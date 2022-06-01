# Analyses of the fMRI and EEG data collected at the Wellington Hospital

## List of Scripts and functions

### fMRI

#### Preprocessing
 
1) Anonymise DICOM [file names](https://github.com/Davi93/raindrop_analyses_fmri_eeg/blob/main/fmri/preprocessing/anonymise_data_fnames.ipynb) / [headers](https://github.com/Davi93/raindrop_analyses_fmri_eeg/blob/main/fmri/preprocessing/anonymise_data_headers.ipynb). 
Description: The first script removes patient names from the name of the DICOM files. The second script removes the name from the header of each DICOM file.
2) Conversion of DICOM to nifti is done using MRIcron.
3) 
