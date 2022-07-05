def preprocess(session_name, output_folder, raw, montage, reference, stim_channel, picks,
                events_id, tmin = -.5, tmax = 4, filter = (1, 100),
                reject=dict(eeg=300e-6), baseline = (None, 0), ica_labels = True,
                review_ica = True, save = True):
    
    ### UPDATE SUMMARY!!!
    """_summary_
    EEG data preprocessing for ERD analysis. 
    Steps: 
        - definying montage
        - applying low and high pass filters
        - finding events / epoching
        - bad electrodes detection using RANSAC (which are excluded from ICA)
        - bad epochs detection (before ICA)
        - ICA without bad electrodes / bad epochs
        - applying baseline


    Args:
        session_name (_type_): _description_
        output_folder (_type_): _description_
        raw (_type_): _description_
        montage (_type_): _description_
        stim_channel (_type_): _description_
        events_id (_type_, optional): _description_. Defaults to dict().
        tmin (float, optional): _description_. Defaults to -.5.
        tmax (int, optional): _description_. Defaults to 4.
        filter (tuple, optional): _description_. Defaults to (1, 40).
        reject (_type_, optional): _description_. Defaults to dict(eeg=300e-6).
        baseline (_type_, optional): _description_. Defaults to None.
        save (bool, optional): _description_. Defaults to False.

    Returns:
        _type_: epoched data
    """

    # Workflow: autoreject -> ica -> autoreject
    # The workflow is suggested here 
    # https://autoreject.github.io/stable/auto_examples/plot_autoreject_workflow.html#sphx-glr-auto-examples-plot-autoreject-workflow-py

    import os
    import autoreject
    from autoreject import Ransac
    import mne
    import matplotlib.pyplot as plt
    import numpy as np
    from time import time, ctime

    print('Preprocessing session: ' + session_name)
    print('Results and plots will be saved in folder: ' + output_folder)
    
    # Specifying montage
    print(f'Montage: {montage}')
    montage = mne.channels.make_standard_montage(montage)
    
    # Finding events
    events = mne.find_events(raw, stim_channel=stim_channel, verbose=True)

    # Filtering Data
    print(f'Filtering data 0.1 / 100Hz. {ctime()}')
    hi_pass, lo_pass = filter[0] , filter[1]
    raw.filter(0.1, None)
    raw.filter(None, 100) 
    print('Applying notch filter')
    raw.notch_filter([50,100], picks=picks, filter_length='auto',
                 phase='zero')

    print(f'Filtering Done. {ctime()}')

    # Reference on average
    print(f'Setting reference: {reference}')
    raw.set_eeg_reference(ref_channels=reference)
    raw.apply_proj()

    # Epoching data
    print(f'Epoching data: {tmin}s - {tmax}s.')
    epochs = mne.Epochs(raw, events, events_id, tmin, tmax, baseline=None,
                        reject=None, verbose=False, detrend=0, preload=True)

    # Bad channel detection (ransac)
    print(f'Detecting bad channels with Ransac. {ctime()}')
    ransac = Ransac(verbose=True, picks=picks, n_jobs=-1)
    epochs_clean = ransac.fit_transform(epochs)
    bad_chs = ransac.bad_chs_ # list with bad channels according to RANSAC 
    print('Bad channels detected: ' + str(len(bad_chs)))
    print(bad_chs)

    # plot psd without bad channels (?)
    fig1 = raw.plot_psd(exclude = bad_chs, show = False)

    # Bad epochs rejection (autoreject before ICA)
    print(f'Bad epochs detection (autorject). {ctime()}')
    ar = autoreject.AutoReject(n_interpolate=[1, 2, 4, 32], random_state=11,
                            n_jobs=-1, verbose=True, thresh_method = 'bayesian_optimization')
    ar.fit(epochs[:30])  # fit on a few epochs to save time
    epochs_ar, reject_log = ar.transform(epochs, return_log=True)
    fig2 = reject_log.plot('horizontal', show = False)
    plt.savefig(output_folder + session_name + '_autoreject_before_ica.jpg', dpi = 160)
    print(f'Epochs rejected: {(reject_log.bad_epochs == True).sum()}')

    # ICA without bad epochs / bad channels
    epochs.info['bads'] = bad_chs
    print(f'Fitting ICA. {ctime()}')
    ica = mne.preprocessing.ICA(random_state=99, n_components=30, # mne_icalabel needs infomax
                                method='infomax', fit_params=dict(extended=True)) 
    ica.fit(epochs[~reject_log.bad_epochs])
    print(f'Completed. {ctime()}')

    # If ica labels is set to true, usa mne_icalabel to automatically label ICA components
    if ica_labels:
        print(f'Automatic ICA labelling (mne_icalabel).  {ctime()}')
        from mne_icalabel import label_components
        ic_labels = label_components(epochs[~reject_log.bad_epochs], ica, method="iclabel")
        print(ic_labels)
        labels = ic_labels["labels"]
        exclude_idx = [idx for idx, label in enumerate(labels) if label not in ["brain", "other"]]
        print(f"Excluding these ICA components: {exclude_idx}")
        ica.exclude = exclude_idx

    # ICA visual inspection
    if review_ica:
        print('Visually inspect results and select eye-blinks components.')
        ica.plot_components(picks = np.arange(0,30,1))
        print(ica.exclude) # list of components excluded

    # Applying ICA
    print('Applying ICA')
    fig2 = ica.plot_components(ica.exclude, show = False)
    plt.savefig(output_folder + session_name + '_ica_bad_components.jpg', dpi = 160)
    fig3 = ica.plot_overlay(epochs.average(), exclude=ica.exclude, show = False)
    plt.savefig(output_folder + session_name + '_ica_overlay.jpg', dpi = 160)
    ica.apply(epochs, exclude=ica.exclude)
    
    # Autoreject after high pass filter and ICA
    print(f'Applying autoreject after ICA. {ctime()}')
    epochs.info['bads'] = [] # resetting the list of bad channels to []
    ar = autoreject.AutoReject(n_interpolate=[1, 2, 4, 32], random_state=11,
                            n_jobs=-1, verbose=True, thresh_method = 'bayesian_optimization')

    ar.fit(epochs[:30])  # fit on the first 20 epochs to save time
    epochs_ar, reject_log = ar.transform(epochs, return_log=True)
    fig4 = epochs[reject_log.bad_epochs].plot(scalings=dict(eeg=100e-6))
    reject_log.plot('horizontal', show = False)
    print(f'Epochs rejected: {(reject_log.bad_epochs == True).sum()}')

    plt.savefig(output_folder + session_name + '_autoreject_after_ica.jpg', dpi = 160)

    # Applying lo pass and hi pass specified in function
    print('Filtering cleaned data.')
    epochs_ar.filter(hi_pass, None) 
    epochs_ar.filter(None, lo_pass) 

    # Re-Referencing after ICA
    print('Re-refering after ICA.')
    mne.set_eeg_reference(epochs_ar, ref_channels='average', copy = False)

    # Applying baseline correction
    print('Applying baseline correction.')
    epochs_ar.apply_baseline(baseline)

    # Saving cleaned epochs
    if save == True:
        print('Saving epoched data cleaned.')
        epochs_ar.save(output_folder + session_name + '_cleaned-epo.fif' , overwrite=True)
    return epochs_ar
