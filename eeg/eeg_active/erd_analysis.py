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
event_ids = dict(move=1,relax=2)
freqs = np.arange(7, 31) # beta
tmin, tmax = -0.8, 3  #???
baseline = [-1, 0]  # baseline interval (in s)
vmin,vmax = -1, 1.5
cnorm = TwoSlopeNorm(vmin=vmin, vcenter=0, vmax=vmax)  # min, center & max ERDS
kwargs = dict(n_permutations=100, step_down_p=0.05, seed=1,
            buffer_size=None, out_type='mask')  # for cluster test

# channels to include:
# divide the channels in smaller groups to make better figure
picks_subsets = [['E36','E35','E40', 'E41', 'E42'],['E46', 'E47','E52','E51', 'E45'] ]

# Iterate each file in session_raw
for session in sessions_raw:
    print(session)
    name = session.split('\\')[3].split('_')
    name = name[0] + name[1] # name of participant / session used to save file
    epochs = mne.read_epochs(session) # load file
    
    # iterate each channel group
    for n, picks in enumerate(picks_subsets):
        tfr = tfr_multitaper(epochs, freqs=freqs, n_cycles=freqs, use_fft=True,
                            return_itc=False, average=False, decim=2, picks = picks)
        tfr.crop(tmin, tmax).apply_baseline(baseline, mode="percent")

        # iterate each condition (move / relax)
        for event in event_ids:
            # plot settings
            tfr_ev = tfr[event]
            h_r = ([10]*len(picks)) # column width ratios
            h_r.append(2) # color bar 
            w_r = [5]
            fig, axes = plt.subplots(len(picks)+1, 1, figsize=(8,16),
                                    gridspec_kw={"width_ratios": w_r, "height_ratios": h_r})
            plt.title(f"ERDS ({event})")

            # plot each channel
            for ch, ax in enumerate(axes[:-1]):  
                # positive clusters
                _, c1, p1, _ = pcluster_test(tfr_ev.data[:, ch], tail=1, **kwargs)
                # negative clusters
                _, c2, p2, _ = pcluster_test(tfr_ev.data[:, ch], tail=-1, **kwargs)

                # note that we keep clusters with p <= 0.05 from the combined clusters
                # of two independent tests; in this example, we do not correct for
                # these two comparisons
                c = np.stack(c1 + c2, axis=2)  # combined clusters
                p = np.concatenate((p1, p2))  # combined p-values
                mask = c[..., p <= 0.05].any(axis=-1)

                # plot TFR (ERDS map with masking) 
                # ERD to blue color and ERS to red color (NB I swapped them from the original 
                # tutorial on the mne website)
                tfr_ev.average().plot([ch], cmap="RdBu_r", cnorm=cnorm, axes=ax,
                                    colorbar=False, show=False, mask=mask,
                                    mask_style="mask")

                ax.set_title(picks[ch], fontsize=10)
                ax.axvline(0, linewidth=1, color="black", linestyle=":")  # event

            fig.colorbar(axes[0].images[-1], cax=axes[-1], orientation = 'horizontal').ax.set_yscale("linear")
            
            #fig.suptitle(f"ERDS ({event})")
            fig.tight_layout()
            plt.savefig(epochs_cleaned_folder + name + '_group_elect_' + str(n) + '_cond_' + event + '_ERDs.jpg', dpi = 300, bbox_inches='tight')
            plt.show(block=False)
            plt.close()
        # data to DF
        df = tfr.to_data_frame(time_format=None)
        df.head()
        df = tfr.to_data_frame(time_format=None, long_format=True)
       
        # Map to frequency bands:
        freq_bounds = {'_': 7,
                    'mu': 12,
                    'beta': 31}
                    
        df['band'] = pd.cut(df['freq'], list(freq_bounds.values()),
                            labels=list(freq_bounds)[1:])

        # Filter to retain only relevant frequency bands:
        freq_bands_of_interest = ['mu', 'beta']
        df = df[df.band.isin(freq_bands_of_interest)]
        df['band'] = df['band'].cat.remove_unused_categories()

        g = sns.FacetGrid(df, row='band', col='channel', margin_titles=True)
        g.map(sns.lineplot, 'time', 'value', 'condition', n_boot=10)
        axline_kw = dict(color='black', linestyle='dashed', linewidth=0.5, alpha=0.5)
        g.map(plt.axhline, y=0, **axline_kw)
        g.map(plt.axvline, x=0, **axline_kw)
        g.set(ylim=(None, 1.5), xlim=(tmin,tmax))
        g.set_axis_labels("Time (s)", "ERDS (%)")
        g.set_titles(col_template="{col_name}", row_template="{row_name}")
        g.add_legend(ncol=2, loc='lower center')
        g.fig.subplots_adjust(left=0.1, right=0.9, top=0.9, bottom=0.08)
        plt.savefig(epochs_cleaned_folder + name + '_group_elect_' + str(n) + '_ERDs_cf.jpg', dpi = 300, bbox_inches='tight')
        plt.show(block=False)
        plt.close()

        # violinplot
        df_mean = (df.query('time > 1')
                    .groupby(['condition', 'epoch', 'band', 'channel'])[['value']]
                    .mean()
                    .reset_index())

        g = sns.FacetGrid(df_mean, col='condition', col_order=['move', 'relax'],
                        margin_titles=True)

        g = (g.map(sns.violinplot, 'channel', 'value', 'band', n_boot=10,
                palette='deep', order = picks,
                hue_order=freq_bands_of_interest,
                linewidth=0.5).add_legend(ncol=4, loc='lower center'))

        g.map(plt.axhline, **axline_kw)
        g.set_axis_labels("", "ERDS (%)")
        g.set_titles(col_template="{col_name}", row_template="{row_name}")
        g.fig.subplots_adjust(left=0.1, right=0.9, top=0.9, bottom=0.3) 
        plt.savefig(epochs_cleaned_folder + name + '_group_elect_' + str(n) + '_ERDs_freq_band.jpg', dpi = 300, bbox_inches='tight')
        plt.show(block=False)
        plt.close()