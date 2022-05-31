# Author: Davide Aloi, PhD student, University of Birmingham.
# Description: visualise 4d data for quality inspection
# usage: specify folder with nifti, use the slider to change slice (z) and the buttons
# to change the volumes (8 volumes are displayed)

import matplotlib.pyplot as plt
import os, glob
from nilearn import image, plotting
import numpy as np
from matplotlib.widgets import Button, Slider
%matplotlib auto

# path of nifti scan that you want to visualise
path = "D:\\Raindrop_data\\p01\\p01_w02\\day01\\fmri_data\\JOYSTICK_POST_0019\\nifti\\"
file = glob.glob(path + '*.nii')

# load data
img = image.load_img(file).get_fdata()

nslice = 35 # which z to display
steps = 8 # jump between volumes

# Interactive plot
fig, axes = plt.subplots(ncols=4, nrows=2, figsize=(20, 10))
plt.subplots_adjust(bottom=0.2)
for t, ax in enumerate(axes.flatten()):

    ax.imshow(img[:, :, nslice, 0].T, cmap='gray', origin='lower') 
    ax.axis('off')
    ax.set_title('z = ' + str(nslice) + ' v = 0', fontsize=10)


# Make a horizontal slider to control the slice.
axslice = plt.axes([0.15, 0.1, 0.45, 0.03])
freq_slider = Slider(
    ax = axslice,
    label = 'Slice (z)',
    valmin = 0,
    valmax = img.shape[2],
    valinit = nslice,
    valstep = np.arange(0,img.shape[2],1),
)

class Index:
    ind = 0

    def next(self, event):
        self.ind += steps
        for t, ax in enumerate(axes.flatten()):    
            ax.imshow(img[:, :, nslice, t + self.ind].T, cmap='gray', origin='lower')
            ax.set_title('z = ' + str(nslice) +' v = ' + str(self.ind + t), fontsize=10)
        plt.draw()

    def prev(self, event):
        self.ind -= steps
        for t, ax in enumerate(axes.flatten()):    
            ax.imshow(img[:, :, nslice, t + self.ind].T, cmap='gray', origin='lower')
            ax.set_title('z = ' + str(nslice) + ' v = ' + str(self.ind + t), fontsize=10)
        plt.draw()

    def update_slice(self, val):
        nslice = freq_slider.val
        for t, ax in enumerate(axes.flatten()):    
            ax.imshow(img[:, :, nslice, t + self.ind].T, cmap='gray', origin='lower')
            ax.set_title('z = ' + str(nslice) + ' v = ' + str(self.ind + t), fontsize=10)
        plt.draw()

callback = Index()
axprev = plt.axes([0.7, 0.05, 0.1, 0.075])
axnext = plt.axes([0.81, 0.05, 0.1, 0.075])
bnext = Button(axnext, 'Next')
bnext.on_clicked(callback.next)
bprev = Button(axprev, 'Previous')
bprev.on_clicked(callback.prev)
freq_slider.on_changed(callback.update_slice)
plt.show()