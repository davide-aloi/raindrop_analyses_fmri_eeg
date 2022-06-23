% Davide Aloi - UOB
% GLM 1st level for passive mobilisation or active task
% just change the path to scans and onsets
% p01 only

clear all
jobfile = {'C:\Users\davide\Documents\GitHub\raindrop_analyses_fmri_eeg\fmri\glm\first_level_glm_joystick_job.m'}; %directory of the .m file to run

% path to folder with functional files, regr.txt file etc
paths = {'D:\Raindrop_data\p01\p01_w06\day05\fmri_data\PASSIVE_MOV_DURING_TDCS_0008\nifti'};

%onsets "move" for each scan
onsets = {[20.0025790144919,60.0120913623177,100.020758260869,140.030068405797,180.039398492752,220.048429449274,260.058399072463,300.065960811593,340.074130550724,380.083367420290,420.091604869565,460.100716057970,500.110689391304,540.118688927536,580.127433275362,620.135611826087,660.143200927536,700.151580753623,740.159270028986,780.166731594203,820.176934956522,860.184730434781,900.191994898551,940.200330666667,980.208153043477,1020.21792742029,1060.22598400000,1100.23384672464,1140.24248023188,1180.24961252174]
          };

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