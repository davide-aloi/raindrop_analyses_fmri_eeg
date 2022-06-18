% GLM 1st level with implicit mask set to -inf
% p01 only

clear all
jobfile = {'C:\Users\davide\Documents\GitHub\raindrop_analyses_fmri_eeg\fmri\glm\first_level_glm_joystick_job.m'}; %directory of the .m file to run

% path to folder with functional files, regr.txt file etc
paths = {'D:\Raindrop_data\p01\p01_w06\day05\fmri_data\JOYSTICK_BASELINE_0005\nifti'
         'D:\Raindrop_data\p01\p01_w06\day05\fmri_data\JOYSTICK_POST_0009\nifti\'};

%onsets "move" for each scan
onsets = {[35.7407513043727,115.793368579703,195.830565565208,275.855716173945,355.894188521779]
          [35.6541913043475,115.685126028955,195.704172985512,275.731370666646,355.762838724651]};

nrun = length(paths);
jobs = repmat(jobfile, 1, nrun);

      
      
% inputs for glm first level
inputs = cell(5, nrun);
for crun = 1:nrun
    inputs{1, crun} = cellstr(paths{crun});
    inputs{2, crun} = cellstr(fullfile(paths{crun},'glm_first_level')); % fMRI model specification: Directory - cfg_files
    inputs{3, crun} = cellstr(spm_select('FPList',fullfile(paths{crun}),'sr.*.nii'));
    inputs{4, crun} = onsets{crun}; % fMRI model specification: Onsets - cfg_entry
    inputs{5,crun} = cellstr(spm_select('FPList',fullfile(paths{crun}),'regr.*'));
end

spm('defaults', 'FMRI');
spm_jobman('run', jobs, inputs{:});