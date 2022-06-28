% Author: Davide Aloi
% Description: Extract VOIs, subject 01

% NB: I was a bit lazy so I just re run this script 3 times, changing the variables
% roi_name, rad and centre.

% NB: this is a bit different from what we did for wp1a/b and wp2a, in the sense that I did
% not use the spm.mat file to identify a smaller voi within a bigger voi centered on the coordinates
% derived from the activation at baseline for move > rest. Instead, we visually defined the
% coordinates for m1, sma and th with Davinia, and I used those to extract the 4mm vois.
% That's why I changed matlabbatch{1}.spm.util.voi.expression = 'i1 + i3'; to 
% matlabbatch{1}.spm.util.voi.expression = 'i2';  

paths = {'D:\Raindrop_data\p01\p01_w02\day01\fmri_data\JOYSTICK_BASELINE_0015\nifti\glm_first_level\'
    'D:\Raindrop_data\p01\p01_w02\day01\fmri_data\JOYSTICK_POST_0019\nifti\glm_first_level\'
    'D:\Raindrop_data\p01\p01_w02\day05\fmri_data\JOYSTICK_BASELINE_0005\nifti\glm_first_level\'
    'D:\Raindrop_data\p01\p01_w02\day05\fmri_data\JOYSTICK_POST_0010\nifti\glm_first_level\'
    'D:\Raindrop_data\p01\p01_w04\day01\fmri_data\JOYSTICK_BASELINE_0005\nifti\glm_first_level\'
    'D:\Raindrop_data\p01\p01_w04\day01\fmri_data\JOYSTICK_POST_0009\nifti\glm_first_level\'
    'D:\Raindrop_data\p01\p01_w04\day05\fmri_data\JOYSTICK_BASELINE_0005\nifti\glm_first_level\'
    'D:\Raindrop_data\p01\p01_w04\day05\fmri_data\JOYSTICK_POST_0009\nifti\glm_first_level\'
    'D:\Raindrop_data\p01\p01_w06\day01\fmri_data\JOYSTICK_BASELINE_0005\nifti\glm_first_level\'
    'D:\Raindrop_data\p01\p01_w06\day01\fmri_data\JOYSTICK_POST_0009\nifti\glm_first_level\'
    'D:\Raindrop_data\p01\p01_w06\day05\fmri_data\JOYSTICK_BASELINE_0005\nifti\glm_first_level\'
    'D:\Raindrop_data\p01\p01_w06\day05\fmri_data\JOYSTICK_POST_0009\nifti\glm_first_level\'
}

% repeat this for all 3 rois!!!!!!!
areas = {'M1','SMA','Th'}; % third input
radius = [4 4 4]; %fifth input 
centres = [-25 -33 37; -6.9 -22.9 48.1; -10 -21.4 -3.8]; %fourth input and sixth input 

% Change these 3 variables
roi_name = 'th'
rad = 4
centre = [-10 -21.4 -3.8]

for i = 1:length(paths)
    spm_mat_file = fullfile(paths{i},'SPM.mat');

    % Start batch
    clear matlabbatch;
    matlabbatch{1}.spm.util.voi.spmmat  = cellstr(spm_mat_file);
    matlabbatch{1}.spm.util.voi.adjust  = 1;                    % Effects of interest contrast number
    matlabbatch{1}.spm.util.voi.session = 1;                    % Session index
    matlabbatch{1}.spm.util.voi.name    = roi_name;               % VOI name

    % Define thresholded SPM for finding the subject's local peak response
    matlabbatch{1}.spm.util.voi.roi{1}.spm.spmmat      = {''};
    matlabbatch{1}.spm.util.voi.roi{1}.spm.contrast    = 2;     % Index of contrast for choosing voxels
    matlabbatch{1}.spm.util.voi.roi{1}.spm.conjunction = 1;
    matlabbatch{1}.spm.util.voi.roi{1}.spm.threshdesc  = 'none';
    matlabbatch{1}.spm.util.voi.roi{1}.spm.thresh      = 1;
    matlabbatch{1}.spm.util.voi.roi{1}.spm.extent      = 0;
    matlabbatch{1}.spm.util.voi.roi{1}.spm.mask ...
        = struct('contrast', {}, 'thresh', {}, 'mtype', {});

    % Define large fixed outer sphere
    matlabbatch{1}.spm.util.voi.roi{2}.sphere.centre     = centre; % Set coordinates here
    matlabbatch{1}.spm.util.voi.roi{2}.sphere.radius     = rad;           % Radius (mm) (change this based on the roi you're running)
    matlabbatch{1}.spm.util.voi.roi{2}.sphere.move.fixed = 1;

    % Define smaller inner sphere which jumps to the peak of the outer sphere
    %matlabbatch{1}.spm.util.voi.roi{3}.sphere.centre           = [0 0 0]; % Leave this at zero
    %matlabbatch{1}.spm.util.voi.roi{3}.sphere.radius           = 4;       % Set radius here (mm)
    %matlabbatch{1}.spm.util.voi.roi{3}.sphere.move.global.spm  = 1;       % Index of SPM within the batch
    %matlabbatch{1}.spm.util.voi.roi{3}.sphere.move.global.mask = 'i2';    % Index of the outer sphere within the batch

    matlabbatch{1}.spm.util.voi.expression = 'i2'; 

    % Run the batch
    spm_jobman('run',matlabbatch);
end