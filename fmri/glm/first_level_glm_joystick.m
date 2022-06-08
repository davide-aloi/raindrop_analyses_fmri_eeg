% GLM 1st level with implicit mask set to -inf
% p01 only

clear all
jobfile = {'C:\Users\davide\Documents\GitHub\raindrop_analyses_fmri_eeg\fmri\glm\first_level_glm_joystick_job.m'}; %directory of the .m file to run
nrun = 8;
jobs = repmat(jobfile, 1, nrun);

% path to folder with functional files, regr.txt file etc
paths = {'D:\Raindrop_data\p01\p01_w02\day01\fmri_data\JOYSTICK_BASELINE_0015\nifti\'
         'D:\Raindrop_data\p01\p01_w02\day01\fmri_data\JOYSTICK_POST_0019\nifti\'
         'D:\Raindrop_data\p01\p01_w02\day05\fmri_data\JOYSTICK_BASELINE_0005\nifti\'
         'D:\Raindrop_data\p01\p01_w02\day05\fmri_data\JOYSTICK_POST_0010\nifti\'
         'D:\Raindrop_data\p01\p01_w04\day01\fmri_data\JOYSTICK_BASELINE_0005\nifti\'
         'D:\Raindrop_data\p01\p01_w04\day01\fmri_data\JOYSTICK_POST_0009\nifti\'
         'D:\Raindrop_data\p01\p01_w04\day05\fmri_data\JOYSTICK_BASELINE_0005\nifti'
         'D:\Raindrop_data\p01\p01_w04\day05\fmri_data\JOYSTICK_POST_0009\nifti\'};

%onsets "move" for each scan
onsets = {[35.7384640000000,115.780885797101,195.808676173914,275.834737159421,355.865966376812]
          [35.6564999420298,115.687170782610,195.737452521740,275.757985855073,355.787099362320]
          [35.7171849275474,115.766911536222,195.800229565240,275.832089507254,355.866164869571]
          [35.6568366377032,115.685782724642,195.720287072472,275.753681623202,355.784363594197]
          [35.7539773857716,115.821068306919,195.852716262889,275.890881543121,355.930668154426]
          [35.6618768762273,115.705036468353,195.740153405000,275.778704076001,355.825341460382]
          [35.7471446996788,115.799233206897,195.836833154608,275.899728371413,355.969106129953]
          [35.6592004741542,115.699453635549,195.728802232421,275.765875340265,355.800463581982]};

% inputs for glm first level
inputs = cell(5, nrun);
for crun = 1:nrun
    inputs{1, crun} = cellstr(paths{crun});
    inputs{2, crun} = cellstr(fullfile(paths{crun},'glm_1st_level_2nd_attempt')); % fMRI model specification: Directory - cfg_files
    inputs{3, crun} = cellstr(spm_select('FPList',fullfile(paths{crun}),'sr.*.nii'));
    inputs{4, crun} = onsets{crun}; % fMRI model specification: Onsets - cfg_entry
    inputs{5,crun} = cellstr(spm_select('FPList',fullfile(paths{crun}),'regr.*'));
end

spm('defaults', 'FMRI');
spm_jobman('run', jobs, inputs{:});