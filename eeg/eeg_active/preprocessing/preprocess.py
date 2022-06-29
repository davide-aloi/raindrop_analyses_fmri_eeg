def preprocess(session_name, output_folder, raw, montage, stim_channel, events_id = dict(),
                tmin = -.5, tmax = 4, filter = (1, 40), reject=dict(eeg=300e-6), baseline = None, save = False):
                
    # ADD DESCRIPTION
    # ADD ARGUMENTS / OUTPUT 

    # Workflow: autoreject -> ica -> autoreject
    # The workflow is suggested here 
    # https://autoreject.github.io/stable/auto_examples/plot_autoreject_workflow.html#sphx-glr-auto-examples-plot-autoreject-workflow-py

    print('Preprocessing: ' + session_name)
    print('Output folder: ' + output_folder)
    
    import os
    import autoreject
    import time
    import mne
    import matplotlib.pyplot as plt
    import numpy as np

    #print(raw.info)
    montage = mne.channels.make_standard_montage(montage)
 
    raw_filtered = raw.copy().filter(filter[0], filter[1])
    # Reference on average
    raw_filtered.set_eeg_reference(ref_channels='average')

    picks_eeg = mne.pick_types(raw.info, meg=False, eeg=True, eog=True, stim=False,
                           exclude='bads')

    # Finding events
    events = mne.find_events(raw, stim_channel='STI 014', verbose=True) # or STIM
    
    # Epoching data 
    epochs = mne.Epochs(raw_filtered, events, events_id, tmin, tmax, baseline=None,
                        reject=None, verbose=False, detrend=0, preload=True)

    # Bad channel detection (ransac)
    print('Detecting bad channels with Ransac')
    print(time.strftime("%H:%M:%S", time.localtime()))
    from autoreject import Ransac  # this uses ransac from PREP
    ransac = Ransac(verbose=True, picks=picks_eeg, n_jobs=1)
    epochs_clean = ransac.fit_transform(epochs)
    bad_chs = ransac.bad_chs_ # list with bad channels according to RANSAC 
    print('Bad channels detected: ' + str(len(bad_chs)))
    print(time.strftime("%H:%M:%S", time.localtime()))
    
    # Bad epochs rejection (autoreject before ICA)
    print('Bad epochs detection (autorject)')
    ar = autoreject.AutoReject(n_interpolate=[1, 2, 3, 4], random_state=11,
                            n_jobs=1, verbose=True)
    ar.fit(epochs[:20])  # fit on a few epochs to save time
    print(time.strftime("%H:%M:%S", time.localtime()))
    epochs_ar, reject_log = ar.transform(epochs, return_log=True)
    reject_log.plot('horizontal')
    plt.savefig(output_folder + session_name + '_autoreject_before_ica.jpg', dpi = 240)
    plt.close()
    print(f'Rejected Epochs: {(reject_log.bad_epochs == True).sum()}')
    print(time.strftime("%H:%M:%S", time.localtime()))

    # ICA without bad epochs / bad channels
    epochs.info['bads'] = bad_chs
    print('Fitting ICA')
    print(time.strftime("%H:%M:%S", time.localtime()))
    ica = mne.preprocessing.ICA(random_state=99)
    ica.fit(epochs[~reject_log.bad_epochs])
    print('Completed.')
    print(time.strftime("%H:%M:%S", time.localtime()))

    # ICA visual inspection
    print('Visually inspect results and select eye-blinks components...')
    ica.plot_components(picks = np.arange(0,30,1))
    print(ica.exclude) # list of components excluded
    ica.plot_components(ica.exclude)
    plt.savefig(output_folder + session_name + '_ica_bad_components.jpg', dpi = 240)
    plt.close()
    ica.plot_overlay(epochs.average(), exclude=ica.exclude)
    plt.savefig(output_folder + session_name + '_ica_overlay.jpg', dpi = 240)
    plt.close()
    ica.apply(epochs, exclude=ica.exclude)
    
    # Autoreject after high pass filter and ICA
    epochs.info['bads'] = []
    ar = autoreject.AutoReject(n_interpolate=[1, 2, 3, 4], random_state=11,
                            n_jobs=1, verbose=True)
    ar.fit(epochs[:20])  # fit on the first 20 epochs to save time
    epochs_ar, reject_log = ar.transform(epochs, return_log=True)
    epochs[reject_log.bad_epochs].plot(scalings=dict(eeg=100e-6))
    reject_log.plot('horizontal')
    plt.savefig(output_folder + session_name + '_autoreject_after_ica.jpg', dpi = 240)
    plt.close()

    # We will visualize the cleaned average data and compare it against the bad segments.
    evoked_bad = epochs[reject_log.bad_epochs].average()
    plt.figure()
    plt.plot(evoked_bad.times, evoked_bad.data.T * 1e6, 'r', zorder=-1)
    epochs_ar.average().plot(axes=plt.gca())
    plt.savefig(output_folder + session_name + '_epochs_ar_average_badseg.jpg', dpi = 240)

    # Re-Referencing after ICA
    mne.set_eeg_reference(epochs_ar, ref_channels='average', copy = False)
    epochs_ar.apply_baseline()

    if save == True:
        epochs_ar.save(output_folder + session_name + '_cleaned_epochs.mff' ,overwrite=True)


    return epochs_ar