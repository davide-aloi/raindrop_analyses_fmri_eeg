# Author Davide Aloi
# Scripts for the preprocessing of the EEG data (active task) collected at the Wellington Hospital - Aloi Davide PhD UoB

import numpy as np
import mne
import os
import glob 
from preprocessing.preprocess import preprocess 
import autoreject
from autoreject import Ransac
import matplotlib.pyplot as plt
from time import time, ctime

mne.set_log_level("WARNING")

# Folders to the EEG active task data
output_folder = 'D:\\Raindrop_eeg_analysis\\p01\\'
sessions = ['D:\\Raindrop_data\\p01\\p01_w01\\eeg_baseline\\active_task\\', # baseline w 1
            'D:\\Raindrop_data\\p01\\p01_w02\\day04_eeg\\active_task\\', # post w 2
            'D:\\Raindrop_data\\p01\\p01_w03\\eeg_baseline\\active_task\\', # baseline w 3
            'D:\\Raindrop_data\\p01\\p01_w04\\day04_eeg\\active_task\\', # post w 4
            'D:\\Raindrop_data\\p01\\p01_w05\\eeg_baseline\\active_task\\', # baseline w5
            'D:\\Raindrop_data\\p01\\p01_w06\\day04_eeg\\active_task\\'] # post w6
            
# Paths to .mff files
sessions_raw = []
for n, session in enumerate(sessions):
    sessions_raw.append(glob.glob(session + '\*.mff')[0])

# Run the code below for each session (changing session_raw[n])
session = sessions_raw[5]
print(session)
session_name = session.split('\\')[3]
results_path = output_folder + session_name
raw = mne.io.read_raw_egi(session, preload=True)
picks = mne.pick_types(raw.info, meg=False, eeg=True, eog=True, stim=False)
montage = mne.channels.make_standard_montage('GSN-HydroCel-128')
events = mne.find_events(raw, stim_channel='STI 014', verbose=True)

## Printing some information about the events
gaps_btw_onsets = []
for i, event in enumerate(events[:,0]/1000):
    gap = events[i,0]/1000 - events[i-1,0]/1000
    gaps_btw_onsets.append(gap)
gaps_btw_onsets = np.delete(np.asarray(gaps_btw_onsets),[0])
print('Time between onsets:')
print(f'Mean: {np.mean(gaps_btw_onsets):.2f}s' )
print(f'Std: {np.std(gaps_btw_onsets):.2f}s' )
print(f'Max: {np.max(gaps_btw_onsets):.2f}s' )
print(f'Min: {np.min(gaps_btw_onsets):.2f}s' )

# Filtering
raw.filter(1, None)
raw.filter(None, 100)
raw.notch_filter([50,100,150], picks=picks, filter_length='auto',
            phase='zero')

# Raw psd plot
raw.plot_psd(show=False)
plt.savefig(results_path + '_raw_psd.jpg', dpi = 300)
plt.close()

# Epoching only around MOVE (-4, 6)
epochs = mne.Epochs(raw, events, dict(move=1), -4, 6, baseline=None,
                reject=None, verbose=False, detrend=0, preload=True)
epochs_cleaned = epochs.copy() # creating a copy of epochs

# Ransac to identify bad channels
from autoreject import get_rejection_threshold  # noqa
ransac = Ransac(verbose=True, picks=picks, n_jobs=-1)
epochs_clean = ransac.fit_transform(epochs)
epochs.info['bads'] = ransac.bad_chs_ # list with bad channels according to RANSAC 
print('Electrodes marked as bad by RANSAC')
print(epochs.info['bads'])

# Annotate other bad channels and annotate bad epochs
epochs.plot(n_channels = len(raw.ch_names))
bad_chs = epochs.info['bads'] # list of bad channels
epochs.drop_bad() 
good_epochs = epochs.selection # list of good epochs

# Re reference to average
mne.set_eeg_reference(epochs, ref_channels='average', copy = False)

# ICA to remove eye blinks
ica = mne.preprocessing.ICA(random_state=99, n_components=25, # mne_icalabel needs infomax
                            method='infomax', fit_params=dict(extended=True))
# fitting ICA         
ica.fit(epochs)
ica

# Automatic Labelling (check results with ICA plot sources)
from mne_icalabel import label_components
ic_labels = label_components(epochs, ica, method="iclabel")
print(ic_labels)
labels = ic_labels["labels"]
exclude_idx = [idx for idx, label in enumerate(labels) if label not in ["brain", "other"]]
print(f"Excluding these ICA components: {exclude_idx}")
ica.exclude = exclude_idx

ica.plot_sources(epochs, show_scrollbars=False)
# Automatically save above plot
ica.plot_sources(epochs, show_scrollbars=False, show = False)
plt.savefig(results_path + '_ica_sources.jpg', dpi = 300)
plt.close()

# Visual inspection, check ICA components
ica.plot_components(picks = np.arange(0,20,1))

ica.plot_components(picks = np.arange(0,20,1), show = False)
plt.savefig(results_path + '_ica_components.jpg', dpi = 300)
plt.close()

ica.apply(epochs_cleaned, exclude=ica.exclude)

# Removing bad epochs and bad channels from epochs_cleaned
epochs_to_drop = [0] # I always remove the first event as there is no relax baseline

# I'm sure there's a nicer way of doing this
for i in np.arange(2,72,2):
    if not np.isin(i, good_epochs):
        # I divide the index by 2 because I had removed the "relax" epochs so now epochs have
        # a new index
        epochs_to_drop.append(int(i/2))

# Dropping from epochs_cleaned the epochs that were previously marked as bad 
epochs_cleaned.drop(epochs_to_drop)

# Interpolating the channels that were marked as bad
epochs_cleaned.info['bads'] = epochs.info['bads']
epochs_cleaned.interpolate_bads()

# Applying low pass filter
epochs_cleaned.filter(None, 40)

# Re referencing data
mne.set_eeg_reference(epochs_cleaned, ref_channels='average', copy = False)

# Plotting cleaned data and erp around MOVE
epochs_cleaned.plot(n_channels = len(raw.ch_names))
evoked_move_clean = epochs_cleaned['move'].average()
evoked_move_clean.plot(picks='eeg', spatial_colors=True, gfp=True, show = False)
plt.savefig(results_path + '_evoked_move.jpg', dpi = 300, bbox_inches='tight')

# Saving results
epochs_cleaned.save(results_path + '_cleaned-epo.fif' , overwrite=True)