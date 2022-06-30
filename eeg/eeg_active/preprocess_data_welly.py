# Author Davide Aloi
# Scripts for the analyses of the EEG data (active task) collected at the Wellington Hospital - Aloi Davide PhD UoB

import numpy as np
import mne
import os
import glob 
import matplotlib.pyplot as plt
from preprocessing.preprocess import preprocess 

mne.set_log_level("WARNING")
mne.cuda.init_cuda(verbose=True)
mne.utils.set_config('MNE_USE_CUDA', 'true')  

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

raw = mne.io.read_raw_egi(sessions_raw[0], preload=True)

cleaned_epochs = preprocess('p01_w01','D:\\Raindrop_eeg_analysis\\p01\\', raw, 'GSN-HydroCel-128', 'STI 014',
            events_id = dict(move=1,relax=2), save = True)