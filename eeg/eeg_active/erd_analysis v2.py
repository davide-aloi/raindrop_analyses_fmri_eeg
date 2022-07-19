# Author Davide Aloi
# Scripts for the ERD analyses of the EEG data (active task) collected at the Wellington Hospital 

import numpy as np
import matplotlib.pyplot as plt
from matplotlib.colors import TwoSlopeNorm
import pandas as pd
import seaborn as sns
import mne
from mne.datasets import eegbci
from mne.io import concatenate_raws, read_raw_edf
from mne.time_frequency import tfr_multitaper
from mne.stats import permutation_cluster_1samp_test as pcluster_test
import glob


# Settings
epochs_cleaned_folder = 'D:\\Raindrop_eeg_analysis\\p01\\'
sessions_raw = glob.glob(epochs_cleaned_folder + '*-epo.fif')
event_ids = dict(move=1)
freqs = np.arange(7, 31, 1) # mu and beta
n_cycles = freqs / 2 
time_bandwidth = 2.0
tmin, tmax = -3.5, 4  #??? do not crop
baseline = [-1, -0.5]  # baseline interval (in s) 
vmin,vmax = -3.5, 5.5 # to avoid displaying edge artefact

cnorm = TwoSlopeNorm(vmin=vmin, vcenter=0, vmax=vmax)  # min, center & max ERDS
kwargs = dict(n_permutations=100, step_down_p=0.05, seed=1,
            buffer_size=None, out_type='mask')  # for cluster test
sessions_raw = [sessions_raw[0]]
# Iterate each file in session_raw
for session in sessions_raw:
    print(session)
    name = session.split('\\')[3].split('_')
    name = name[0] + name[1] # name of participant / session used to save file
    epochs = mne.read_epochs(session) # load file

    tfr = tfr_multitaper(epochs, freqs=freqs, n_cycles=n_cycles, use_fft=True,
                        return_itc=False, average=False, decim=2,
                        time_bandwidth = time_bandwidth, n_jobs = -1)

    tfr.crop(tmin, tmax).apply_baseline(baseline, mode="percent")
    tfr_a = tfr.average() # averaging epochs

    plt.figure()
    f = 25
    f = f - 7 # nevermind 
    n_chs = len(tfr_a.info['ch_names'])
    colors = plt.cm.Spectral_r(np.linspace(0, 1, n_chs))

    x = np.arange(0, tfr_a.data.shape[2], 1)

    for i in range(n_chs):
        plt.plot(x, tfr_a.data[i, f, :], color = colors[i], linewidth = 0.8)
    
    plt.axvline(x = 500*(-tmin), color = 'black', linewidth = 0.4, label = 'onset')
    plt.show()