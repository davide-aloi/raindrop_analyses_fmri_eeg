## 5.1) Bad electrodes (visual inspection + automatic procedures)

from preprocessing.is_outlier import is_outlier
picks = mne.pick_types(raw.info, meg=False, eeg=True,stim = False) #I take only EEG electrodes
data, times = raw_orig[picks, :] #Done on unfiltered data

#This checks electrodes that are outliers (using the unfiltered raw data)
outliers = is_outlier(data, 3.0);
outlier_electrodes = []; #This array will contain bad electrodes (electrodes that differ a lot from all the others)
for x in range(0, len(outliers)):
	if outliers[x] == 1:
		print ("Electrode %d should be checked." % (x+1))
		outlier_electrodes.append(x+1)

#This does the same but on epochs and mark an electrod as bad if it's bad in more than 10% of the epochs.
epochs = mne.Epochs(raw, events, event_id, tmin, tmax, proj=True,
                    picks=picks, baseline=baseline, reject_by_annotation = True, preload = True)
epochs_outliers_list = np.zeros(len(picks))
threshold = 10; #If an electrode is marked bad > 10% of epochs --> bad electrode.
for ep in epochs[:5]:
	epoch_outliers = is_outlier(ep,3.0)
	for x in range(0, len(epoch_outliers)):
		if epoch_outliers[x] == 1:
			epochs_outliers_list[x]+=1

epochs_outliers_electrodes = [] #List of electrodes marked as bad
for x in range(0,len(epochs_outliers_list)):
	if 100/len(epochs)*epochs_outliers_list[x] > threshold:
		epochs_outliers_electrodes.append(x+1)
		print("Electrode {} should be checked as it's bad in more than {}% of the epochs.".format(x+1, threshold))
#This is just to have an idea of which electrodes should be inspected
#It is based on detection of outliers as compared to all the electrodes.
#I don't think this is the best approach/only one but it gives you an idea.

from autoreject import Ransac
#from autoreject.utils import interpolate_bads  # noqa
ransac = Ransac(verbose='progressbar', picks=picks, n_jobs=1)
epochs_clean = ransac.fit_transform(epochs)
print('\n'.join(ransac.bad_chs_)) #This tells you bad channels using MNE autoreject

#You should anyway inspect the data visually and mark bad electrodes.
#just do epochs.plot() and remove bad epochs/channels
epochs.info['bads']
#May be cool to just implement this https://autoreject.github.io/faq.html
