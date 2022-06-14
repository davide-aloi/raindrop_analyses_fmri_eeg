% List of open inputs
% Change Directory: Directory - cfg_files
% fMRI model specification: Directory - cfg_files
% fMRI model specification: Scans - cfg_files
% fMRI model specification: Onsets - cfg_entry
% fMRI model specification: Multiple regressors - cfg_files
nrun = X; % enter the number of runs here
jobfile = {'C:\Users\davide\Documents\GitHub\raindrop_analyses_fmri_eeg\fmri\glm\first_level_glm_joystick_job_final_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(5, nrun);
for crun = 1:nrun
    inputs{1, crun} = MATLAB_CODE_TO_FILL_INPUT; % Change Directory: Directory - cfg_files
    inputs{2, crun} = MATLAB_CODE_TO_FILL_INPUT; % fMRI model specification: Directory - cfg_files
    inputs{3, crun} = MATLAB_CODE_TO_FILL_INPUT; % fMRI model specification: Scans - cfg_files
    inputs{4, crun} = MATLAB_CODE_TO_FILL_INPUT; % fMRI model specification: Onsets - cfg_entry
    inputs{5, crun} = MATLAB_CODE_TO_FILL_INPUT; % fMRI model specification: Multiple regressors - cfg_files
end
spm('defaults', 'FMRI');
spm_jobman('run', jobs, inputs{:});
