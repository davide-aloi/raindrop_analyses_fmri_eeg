#This script is just to check data collected on 07/02/2020 at the Wellington Hospital
#Davide Aloi - UoB
## Imports
import mne, os
import numpy as np
import pylab as plt
from operator import mod

""" PREPROCESSING

STEPS:
	1) Loading the data + defining global variables
	2) Filtering
	3) Visual inspection and rejection of bad chunks (?) + bad channels
	4) Finding events + Epoching
	5) Vsual inspection to detect bad channels and bad epochs + Excluding these from the data prior to ICA
		5.1) You plot epochs and remove bad channels and bad epochs.
		5.2) Run ICA


"""

# 1) Loading the data + global variables
data_path = "C:/Users/davide/Desktop/eeg/"
scripts_folder = "C:/Users/davide/Documents/GitHub/EEG_Analysis_MNE_Welly";
os.chdir(scripts_folder) #cd to the scripts folder (This is necessary if you want to load your own modules)
raw_fname = data_path + "alice2_20200207_130636.mff"
print (raw_fname)
low_pass = 50; #Low pass filter
high_pass = 0.1; #High pass filter
tmin = -0.2; #Baseline
tmax = 0.5; #End of epoch 1/1.2s for erp
baseline = (None, 0)  # means from the first instant to t = 0
mne.set_log_level("WARNING")

raw = mne.io.read_raw_egi(raw_fname, preload=True)
raw_orig = raw.copy() #Backup of the original data.
print(raw.info) #Info about our EEG recording
print(raw.ch_names) #Channels
#Is this the right montage? IDK
#montage.plot() #If you want to visualise the montage.


# 2) Filtering
raw.filter(high_pass, low_pass, method='iir') #Filtering. Should the low pass filter be applied after ICA?
#plt.plot(raw._data[-1])
#plt.show() #This command should not be needed but it is.

## 3) Visual inspection and rejection of bad chunks (?)
raw.plot() #At this point you can do a first visual inspection and even mark bad electrodes/segments.


## 4) EVENTS AND EPOCHS
#!!! Events had all the same id. Given that they were always a 'move' followed by a 'relax', I will reassign ids (1:move,2:relax)
events = mne.find_events(raw, stim_channel='STI 014', verbose=True) #or STIM
check_id = lambda x: 1 if mod(x,2) == 0 else 2 #Ignore this, it's just to reassign an id of 1 and 2 to the events.
for i in range(0,len(events)):
    events[i,2] = check_id(i);

event_id = dict(move=1,relax=2)

#If you want to plot the events
fig = mne.viz.plot_events(events, raw.info['sfreq'], event_id=event_id);
#exclude bads
picks = mne.pick_types(raw.info, meg=False,emg=False, eeg=True, stim=False, exclude = 'bads');
epochs = mne.Epochs(raw, events, event_id, tmin, tmax, proj=True,
                    picks=picks, baseline=baseline, reject_by_annotation = True)


## 5) ARTEFACT CORRECTION
#5.1)
epochs.plot() #remove bad electrodes and bad epochs
epochs.drop_bad()

# 5.2) ICA
from mne.preprocessing import ICA, create_ecg_epochs
ica = mne.preprocessing.ICA(method="fastica", random_state=1)
ica.fit(epochs)
ica.plot_components(inst=epochs)
ica.plot_sources(inst=raw_tmp)

#apply ica

raw.set_eeg_reference("average") #setting a reference. Should this be done after artefact rejection?

#interpolation
