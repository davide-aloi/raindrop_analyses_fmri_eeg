# Author Davide Aloi
# Scripts for the analyses of the EEG data (active task) collected at the Wellington Hospital - Aloi Davide PhD UoB

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
            
sessions = ['D:\\Raindrop_data\\p01\\p01_w01\\eeg_baseline\\active_task\\']
# Paths to .mff files
sessions_raw = []
for n, session in enumerate(sessions):
    sessions_raw.append(glob.glob(session + '\*.mff')[0])


# run this for each session
session = sessions_raw[0]
print(session)
session_name = session.split('\\')[3]
results_path = output_folder + session_name
raw = mne.io.read_raw_egi(session, preload=True)
picks = mne.pick_types(raw.info, meg=False, eeg=True, eog=True, stim=False)
montage = mne.channels.make_standard_montage('GSN-HydroCel-128')
events = mne.find_events(raw, stim_channel='STI 014', verbose=True)

# filtering
raw.filter(1, None)
raw.filter(None, 100) 
raw.notch_filter([50,100,150], picks=picks, filter_length='auto',
            phase='zero')

raw.set_eeg_reference(ref_channels='average')
#raw.apply_proj()
raw.plot_psd(show=False)
plt.savefig(results_path + '_raw_psd.jpg', dpi = 300)
plt.close()

# epoching
epochs = mne.Epochs(raw, events, dict(move=1,relax=2), -1, 3, baseline=None,
                reject=None, verbose=False, detrend=0, preload=True)
epochs_cleaned = epochs.copy()

# Ransac to identify bad channels
ransac = Ransac(verbose=True, picks=picks, n_jobs=-1)
epochs_clean = ransac.fit_transform(epochs)
epochs.info['bads'] = ransac.bad_chs_ # list with bad channels according to RANSAC 
print('Electrodes marked as bad by RANSAC')
print(epochs.info['bads'])
# annotate other bad channels, bad epochs
epochs.plot()

bad_chs = epochs.info['bads']
epochs.drop_bad()

# ICA
ica = mne.preprocessing.ICA(random_state=99, n_components=25, # mne_icalabel needs infomax
                            method='infomax', fit_params=dict(extended=True))
# fitting ICA         
ica.fit(epochs)
ica

# Automatic Labelling
from mne_icalabel import label_components
ic_labels = label_components(epochs, ica, method="iclabel")
print(ic_labels)
labels = ic_labels["labels"]
exclude_idx = [idx for idx, label in enumerate(labels) if label not in ["brain", "other"]]
print(f"Excluding these ICA components: {exclude_idx}")
ica.exclude = exclude_idx

ica.plot_sources(epochs, show_scrollbars=False)

ica.plot_sources(epochs, show_scrollbars=False, show = False)
plt.savefig(results_path + '_ica_sources.jpg', dpi = 300)
plt.close()

# visual inspection
ica.plot_components(picks = np.arange(0,20,1), show = False)
plt.savefig(results_path + '_ica_components.jpg', dpi = 300)
plt.close()

ica.apply(epochs_cleaned, exclude=ica.exclude)
epochs_cleaned.info['bads'] = epochs.info['bads']
epochs_cleaned.interpolate_bads()
epochs_cleaned.filter(1, None) 
epochs_cleaned.filter(None, 40)
mne.set_eeg_reference(epochs_cleaned, ref_channels='average', copy = False)
epochs_cleaned.apply_baseline(baseline = (-0.8,-0.2))
epochs_cleaned.plot()
epochs_cleaned.drop_bad()

evoked_move_clean = epochs_cleaned['move'].average()
evoked_move_clean.plot(picks='eeg', spatial_colors=True, gfp=True, show = False)
plt.savefig(results_path + '_evoked_move.jpg', dpi = 300, bbox_inches='tight')

evoked_relax_clean = epochs_cleaned['relax'].average()
evoked_relax_clean.plot(picks='eeg', spatial_colors=True, gfp=True, show = False)
plt.savefig(results_path + '_evoked_relax.jpg', dpi = 300, bbox_inches='tight')

epochs_cleaned.save(results_path + '_cleaned-epo.fif' , overwrite=True)

