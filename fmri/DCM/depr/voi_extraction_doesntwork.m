clc
clearvars
main_path = 'D:\Raindrop_data\p01'; % Directory of the bids dataset
jobfile = {'C:\Users\davide\Documents\GitHub\raindrop_analyses_fmri_eeg\fmri\DCM\voi_extraction_job.m'};
jobs = repmat(jobfile, 1, 1);


paths = {'D:\Raindrop_data\p01\p01_w02\day01\fmri_data\JOYSTICK_BASELINE_0015\nifti\glm_first_level\'
    'D:\Raindrop_data\p01\p01_w02\day01\fmri_data\JOYSTICK_POST_0019\nifti\glm_first_level\'
    'D:\Raindrop_data\p01\p01_w02\day05\fmri_data\JOYSTICK_BASELINE_0005\nifti\glm_first_level\'
    'D:\Raindrop_data\p01\p01_w02\day05\fmri_data\JOYSTICK_POST_0019\nifti\glm_first_level\'
    'D:\Raindrop_data\p01\p01_w04\day01\fmri_data\JOYSTICK_BASELINE_0015\nifti\glm_first_level\'
    'D:\Raindrop_data\p01\p01_w04\day01\fmri_data\JOYSTICK_POST_0019\nifti\glm_first_level\'
    'D:\Raindrop_data\p01\p01_w04\day05\fmri_data\JOYSTICK_BASELINE_0015\nifti\glm_first_level\'
    'D:\Raindrop_data\p01\p01_w04\day05\fmri_data\JOYSTICK_POST_0019\nifti\glm_first_level\'
    'D:\Raindrop_data\p01\p01_w06\day01\fmri_data\JOYSTICK_BASELINE_0015\nifti\glm_first_level\'
    'D:\Raindrop_data\p01\p01_w06\day01\fmri_data\JOYSTICK_POST_0019\nifti\glm_first_level\'
    'D:\Raindrop_data\p01\p01_w06\day05\fmri_data\JOYSTICK_BASELINE_0015\nifti\glm_first_level\'
    'D:\Raindrop_data\p01\p01_w06\day05\fmri_data\JOYSTICK_POST_0019\nifti\glm_first_level\'
}



%Settings
n_areas = 3;
areas = {'M1','SMA','Th'}; % third input

radius = [13 13 7]; %fifth input 

centres = [-25 -33 37; -6.9 -22.9 48.1; -10 -21.4 -3.8]; %fourth input and sixth input 

incr = 0.05;
nrun = 1;


for p = 1:length(paths)
    inputs{1,1} = {paths{p}}; % Change Directory: Directory - cfg_files
    inputs{2,1} = fullfile(inputs{1,1}, 'SPM.mat'); %SPM mat
    
    for i = 1:3
        area = areas{i};
        rad = radius(i);
        centre = centres(i,:);
        inputs{3,1} = strcat(area,'_');
        inputs{4,1} = centre; %coordinates of the area
        inputs{5,1} = rad;
        spm('defaults', 'FMRI');
        spm_jobman('run', jobs, inputs{:});      
    end
    
    
end
