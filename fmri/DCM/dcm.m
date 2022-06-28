% DCM patient 1
main_path = 'D:\Raindrop_data\p01\';

% Path definition
glm_path = {};
nruns = 12;

paths = {'D:\Raindrop_data\p01\p01_w02\day01\fmri_data\JOYSTICK_BASELINE_0015\nifti\'
    'D:\Raindrop_data\p01\p01_w02\day01\fmri_data\JOYSTICK_POST_0019\nifti\'
    'D:\Raindrop_data\p01\p01_w02\day05\fmri_data\JOYSTICK_BASELINE_0005\nifti\'
    'D:\Raindrop_data\p01\p01_w02\day05\fmri_data\JOYSTICK_POST_0010\nifti\'
    'D:\Raindrop_data\p01\p01_w04\day01\fmri_data\JOYSTICK_BASELINE_0005\nifti\'
    'D:\Raindrop_data\p01\p01_w04\day01\fmri_data\JOYSTICK_POST_0009\nifti\'
    'D:\Raindrop_data\p01\p01_w04\day05\fmri_data\JOYSTICK_BASELINE_0005\nifti\'
    'D:\Raindrop_data\p01\p01_w04\day05\fmri_data\JOYSTICK_POST_0009\nifti\'
    'D:\Raindrop_data\p01\p01_w06\day01\fmri_data\JOYSTICK_BASELINE_0005\nifti\'
    'D:\Raindrop_data\p01\p01_w06\day01\fmri_data\JOYSTICK_POST_0009\nifti\'
    'D:\Raindrop_data\p01\p01_w06\day05\fmri_data\JOYSTICK_BASELINE_0005\nifti\'
    'D:\Raindrop_data\p01\p01_w06\day05\fmri_data\JOYSTICK_POST_0009\nifti\'
}

%% Settings
% MRI scanner settings
TR = 1.77;   % Repetition time (secs)
TE = 2;  % Echo time (secs)

% Experiment settings
nregions    = 3;
nconditions = 1;
nruns = 12;

% Index of each condition in tha DCM. If you had more than one condition,
% your first one would be 'task'
MOVE=1;

% Index of each region in the DCM
lM1=1; lTh=2; lSMA=3;

%% Specify DCMs (one per subject). Matrices are informed by the analysis of the baseline

% A-matrix (on / off) % Note that the connections are in the opposite order
% so lM1, lSMA is from SMA to lM1
a = ones(nregions,nregions);

% B-matrix
b = eye(nregions,nregions);

%% EDIT THIS
% C-matrix
c = ones(nregions,nconditions);

% D-matrix (disabled)
d = zeros(nregions,nregions,0);

for crun = 1:nruns %

    % Load SPM
    thisrunpath = paths{crun};
    glm_dir = fullfile(thisrunpath,'glm_first_level');
    SPM     = load(fullfile(glm_dir,'SPM.mat'));
    SPM     = SPM.SPM;

    % Load ROIs
    M1name = dir(fullfile(glm_dir,'VOI_m1_1.mat'));
    Thname = dir(fullfile(glm_dir,'VOI_th_1.mat'));
    SMAname = dir(fullfile(glm_dir,'VOI_sma_1.mat'));

    f = {fullfile(glm_dir, M1name.name);
        fullfile(glm_dir, Thname.name);
        fullfile(glm_dir, SMAname.name);
        };


    for r = 1:length(f)
        XY = load(f{r});
        xY(r) = XY.xY;
    end

    % Move to output directory
    cd(glm_dir);

    % Select whether to include each condition from the design matrix
    % e.g., if you had 3 conditions (Task, Pictures, Words) include = [1 1 1]';
    include = 1; % as I only have 1

    % Specify. Corresponds to the series of questions in the GUI.
    s = struct();
    s.name       = 'fullABC';
    s.u          = include;                 % Conditions
    s.delays     = repmat(TR/2,1,nregions);   % Slice timing for each region: I've chosen half of the TR as my data is interleaved. The original was just the TR
    s.TE         = TE;
    s.nonlinear  = false; % i.e., bilinear
    s.two_state  = false; % i.e., one state per region
    s.stochastic = false;
    s.centre     = true;
    s.induced    = 0;
    s.a          = a;
    s.b          = b;
    s.c          = c;
    s.d          = d;
    DCM = spm_dcm_specify(SPM,xY,s);

    % Return to script directory
    cd C:\Users\davide\Documents\GitHub\raindrop_analyses_fmri_eeg\fmri\DCM;
end

%% Collate into a GCM file and estimate

% Find all DCM files
alldcmdirs = fullfile(paths,'glm_first_level');
dcms = spm_select('FPListRec',alldcmdirs,'DCM_fullABC.mat');

% Prepare output directory
out_dir = 'C:\Users\davide\Documents\GitHub\raindrop_analyses_fmri_eeg\fmri\DCM\dcm_results\';
if ~exist(out_dir,'file')
    mkdir(out_dir);
end

%% full sample

% Check if it exists
if exist(fullfile(out_dir,'GCM_fullABC.mat'),'file')
    opts.Default = 'No';
    opts.Interpreter = 'none';
    f = questdlg('Overwrite existing GCM?','Overwrite?','Yes','No',opts);
    tf = strcmp(f,'Yes');
else
    tf = true;
end

% Collate & estimate
if tf
    % Character array -> cell array
    GCM = cellstr(dcms);

    % Save non-estimated DCM

    save(fullfile(out_dir,'GCM_all_not_estimated.mat'),'GCM');

    % Filenames -> DCM structures
    GCM = spm_dcm_load(GCM);

    % Estimate DCMs (this won't effect original DCM files)
    GCM = spm_dcm_fit(GCM);

    % Save estimated GCM
    save(fullfile(out_dir,'GCM_fullABC.mat'),'GCM');
end


%% Run diagnostics
load(fullfile(out_dir,'GCM_fullABC.mat'));
spm_dcm_fmri_check(GCM);
