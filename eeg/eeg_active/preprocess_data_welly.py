# Author Davide Aloi
# Scripts for the analyses of the EEG data (active task) collected at the Wellington Hospital - Aloi Davide PhD UoB

import numpy as np
import mne
import os
import glob 
import matplotlib.pyplot as plt
from preprocessing.preprocess import preprocess 
import autoreject
from autoreject import Ransac
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
#sessions = ['D:\\Raindrop_data\\p01\\p01_w01\\eeg_baseline\\active_task\\']
# Paths to .mff files
sessions_raw = []
for n, session in enumerate(sessions):
    sessions_raw.append(glob.glob(session + '\*.mff')[0])

# cleaning all sessions
for session in sessions_raw:
    print(session)
    session_name = session.split('\\')[3]
    raw = mne.io.read_raw_egi(session, preload=True)
    picks = mne.pick_types(raw.info, meg=False, eeg=True, eog=True, stim=False)
    montage = mne.channels.make_standard_montage('GSN-HydroCel-128')
    events = mne.find_events(raw, stim_channel='STI 014', verbose=True)
    raw.plot_psd()
    raw.filter(1, None)
    raw.filter(None, 100) 
    raw.notch_filter([50,100], picks=picks, filter_length='auto',
                phase='zero')
    raw.set_eeg_reference(ref_channels='average')
    raw.apply_proj()
    raw.plot_psd()
    epochs = mne.Epochs(raw, events, dict(move=1,relax=2), -1, 3, baseline=None,
                    reject=None, verbose=False, detrend=0, preload=True)
    epochs_bck = epochs.copy()                   

    # annotate bad channels, bad epochs
    epochs.plot()