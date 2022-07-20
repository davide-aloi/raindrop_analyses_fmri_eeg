# Author Davide Aloi
# Scripts for the ERD analyses of the EEG data (active task) collected at the Wellington Hospital 

import numpy as np
import matplotlib.pyplot as plt
from matplotlib.colors import TwoSlopeNorm
import mne
from mne.io import concatenate_raws, read_raw_edf
from mne.time_frequency import tfr_multitaper
import glob


# Settings
epochs_cleaned_folder = 'D:\\Raindrop_eeg_analysis\\p01\\'
sessions_raw = glob.glob(epochs_cleaned_folder + '*-epo.fif')
event_ids = dict(move=1)
freqs = np.arange(7, 31, 1) # mu and beta
freqs_toplot = [(8,13),(13,30)]
freqs_names = ['Mu','Beta']
n_cycles = freqs / 2 
time_bandwidth = 2.0
tmin, tmax = -3.5, 4  #??? do not crop
baseline = [-1, -0.5]  # baseline interval (in s) 
vmin,vmax = -4, 6 # to avoid displaying edge artefact reduce this (I think)
cnorm = TwoSlopeNorm(vmin=vmin, vcenter=0, vmax=vmax)  # min, center & max ERDS
kwargs = dict(n_permutations=100, step_down_p=0.05, seed=1,
            buffer_size=None, out_type='mask')

#sessions_raw = [sessions_raw[0]] # if you want to debug on one session

# Iterate each file in session_raw
for session in sessions_raw:
    print(session)
    name = session.split('\\')[3].split('_')
    name = name[0] + name[1] # name of participant / session used to save file
    epochs = mne.read_epochs(session) # load file

    tfr = tfr_multitaper(epochs, freqs=freqs, n_cycles=n_cycles, use_fft=True,
                        return_itc=False, average=False, decim=2,
                        time_bandwidth = time_bandwidth, n_jobs = -1)

    # cropping and applying baseline
    tfr.crop(tmin, tmax).apply_baseline(baseline, mode="logratio")
    tfr_a = tfr.average() # averaging epochs

    # iterating each frequency range
    for wf, fr in enumerate(freqs_toplot):
        title = session.split('\\')[3].split('cleaned')[0].replace('_',' ')
        # creating plot with 2 subpltos (montage, tfr)
        fig, axes = plt.subplots(1, 2, figsize = (15,10), gridspec_kw={'width_ratios': [1, 2]})
        axes[0].set_box_aspect(1)
        axes[1].set_box_aspect(1/2)
        axes[0].set_title('Montage')
        axes[1].set_title('Session: ' + title + '\nBand: ' + freqs_names[wf] )

        # defining band range
        fmin, fmax = fr
        fmin, fmax = fmin - freqs[0], fmax - freqs[0] # just because freq starts from 7
        
        # creating color map for lines and montage
        n_chs = len(tfr_a.info['ch_names']) # number of channels
        colors = plt.cm.Spectral_r(np.linspace(0, 1, n_chs))

        x = np.arange(0, tfr_a.data.shape[2], 1)
        # adding lines        
        for i in range(n_chs):
            # plotting the average across the frequencies selected, for each elect
            data = np.mean(tfr_a.data[i,fmin:fmax,:], axis = 0)
            axes[1].plot(x, data, color = colors[i], linewidth = 0.6, alpha = 0.8)

        # plotting montage
        cap = mne.channels.make_standard_montage('GSN-HydroCel-128')
        for elidx, elect in enumerate(tfr.ch_names[:-1]):
            pos = cap.get_positions()['ch_pos'][elect]
            axes[0].plot(pos[0],pos[1], marker = '.', markersize = 5, color = colors[elidx])

        # some final adjustments
        axes[0].set_xticks([])
        axes[0].set_yticks([])
        # plotting onset line and setting xticks 
        axes[1].axvline(x = 500*(-tmin), color = 'black', linewidth = 0.4, label = 'onset')
        axes[1].set_xticks(ticks = [0,500,1000,1500,2000,2500,3000,3500], labels = np.arange(tmin,4.5,1))
        axes[0].set_xlim(xmin = -0.1, xmax= 0.1)
        fig.tight_layout()
        plt.savefig(title.replace(' ','') + '_band_' + freqs_names[wf] +'.png', dpi = 300)
        plt.close()



