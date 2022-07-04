def preprocess(session_name, output_folder, raw, montage, reference, stim_channel, picks,
                events_id, tmin = -.5, tmax = 4, filter = (1, 40),
                reject=dict(eeg=300e-6), baseline = (None, 0), ica_labels = True, save = False):
    ### UPDATE SUMMARY
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
    print('Results will be saved in folder: ' + output_folder)
    
    # Specifying montage
    print(f'Montage: {montage}')
    montage = mne.channels.make_standard_montage(montage)
    
    # Filtering Data
    print(f'Filtering data ({filter[0]} - {filter[1]}Hz). {ctime()}')
    raw_filtered = raw.copy().filter(filter[0], filter[1])
    print(f'Filtering Done. {ctime()}')

    # Reference on average
    print(f'Setting reference: {reference}')
    raw_filtered.set_eeg_reference(ref_channels=reference)

    # Finding events
    events = mne.find_events(raw, stim_channel=stim_channel, verbose=True)

    # Epoching data
    print(f'Epoching data: {tmin}s - {tmax}s.') 
    epochs = mne.Epochs(raw_filtered, events, events_id, tmin, tmax, baseline=None,
                        reject=None, verbose=False, detrend=0, preload=True)

    # Bad channel detection (ransac)
    print(f'Detecting bad channels with Ransac. {ctime()}')
    ransac = Ransac(verbose=True, picks=picks, n_jobs=-1)
    epochs_clean = ransac.fit_transform(epochs)
    bad_chs = ransac.bad_chs_ # list with bad channels according to RANSAC 
    print('Bad channels detected: ' + str(len(bad_chs)))
    print(bad_chs)

    #This checks electrodes that are outliers (using the unfiltered raw data)
    print(f'Bad channels based on z-point > 3.0, {ctime()}')
    from preprocessing.is_outlier import is_outlier
    data, times = raw[picks, :] #Done on unfiltered data
    outliers = is_outlier(data, 3.0)
    outlier_electrodes = []; #This array will contain bad electrodes (electrodes that differ a lot from all the others)
    for x in range(0, len(outliers)):
        if outliers[x] == 1:
            print ("Electrode %d should be checked." % (x+1))
            outlier_electrodes.append(x+1)
    print(f'Bad channels with z > 3.0: {outliers.sum()}')
    print('Electrodes: ')
    print(outlier_electrodes)
    
    # Bad epochs rejection (autoreject before ICA)
    print(f'Bad epochs detection (autorject). {ctime()}')
    ar = autoreject.AutoReject(n_interpolate=[1, 2, 3, 4], random_state=11,
                            n_jobs=-1, verbose=True)
    ar.fit(epochs[:20])  # fit on a few epochs to save time
    epochs_ar, reject_log = ar.transform(epochs, return_log=True)
    reject_log.plot('horizontal', show = False)
    plt.savefig(output_folder + session_name + '_autoreject_before_ica.jpg', dpi = 160)
    print(f'Plot saved in: {output_folder} {session_name} _autoreject_before_ica.jpg')
    print(f'Epochs rejected: {(reject_log.bad_epochs == True).sum()}')

    # ICA without bad epochs / bad channelss
    epochs.info['bads'] = bad_chs
    print(f'Fitting ICA. {ctime()}')
    ica = mne.preprocessing.ICA(random_state=99)
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
    print('You can now review ICA components and ICA labels outcome.')

    # ICA visual inspection
    print('Visually inspect results and select eye-blinks components...')
    ica.plot_components(picks = np.arange(0,30,1))
    print(ica.exclude) # list of components excluded
    ica.plot_components(ica.exclude, show = False)
    plt.savefig(output_folder + session_name + '_ica_bad_components.jpg', dpi = 160)
    ica.plot_overlay(epochs.average(), exclude=ica.exclude, show = False)
    plt.savefig(output_folder + session_name + '_ica_overlay.jpg', dpi = 160)
    ica.apply(epochs, exclude=ica.exclude)
    
    # Autoreject after high pass filter and ICA
    epochs.info['bads'] = []
    ar = autoreject.AutoReject(n_interpolate=[1, 2, 3, 4], random_state=11,
                            n_jobs=-1, verbose=True)
    ar.fit(epochs[:20])  # fit on the first 20 epochs to save time
    epochs_ar, reject_log = ar.transform(epochs, return_log=True)
    epochs[reject_log.bad_epochs].plot(scalings=dict(eeg=100e-6))
    reject_log.plot('horizontal', show = False)
    plt.savefig(output_folder + session_name + '_autoreject_after_ica.jpg', dpi = 160)


    # We will visualize the cleaned average data and compare it against the bad segments.
    evoked_bad = epochs[reject_log.bad_epochs].average()
    plt.figure()
    plt.plot(evoked_bad.times, evoked_bad.data.T * 1e6, 'r', zorder=-1)
    epochs_ar.average().plot(axes=plt.gca())
    plt.savefig(output_folder + session_name + '_epochs_ar_average_badseg.jpg', dpi = 160)


    # Re-Referencing after ICA
    mne.set_eeg_reference(epochs_ar, ref_channels='average', copy = False)

    # Applying baseline correction
    epochs_ar.apply_baseline(baseline)

    # Saving cleaned epochs
    if save == True:
        epochs_ar.save(output_folder + session_name + '_cleaned_epochs.mff' , overwrite=True)

    return epochs_ar