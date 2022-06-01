% Author: Aloi Davide
% Description: Realignment, reslice and co-registration for: tennis task, joystick pre, and
% joystick baseline.

%% Part 1: Realignand reslice
%% P01
%% W02
% Week 02 day 01 - TENNIS TASK
cd D:\Raindrop_data\p01\p01_w02\day01\fmri_data\TENNIS_TASK_0016\nifti\
P = spm_select('Extlist',pwd, '^TENNIS_TASK_0016_tennis_task_20220503122456_16.nii',1:170)
spm_realign(P);
spm_reslice(P);
% Week 02 day 01 - Joystick Baseline
cd D:\Raindrop_data\p01\p01_w02\day01\fmri_data\JOYSTICK_BASELINE_0015\nifti
P = spm_select('Extlist',pwd, '^JOYSTICK_BASELINE_0015_joystick_baseline_20220503122456_15.nii',1:170)
spm_realign(P);
spm_reslice(P);
% Week 02 day 01 - Joystick Post
cd D:\Raindrop_data\p01\p01_w02\day01\fmri_data\JOYSTICK_POST_0019\nifti
P = spm_select('Extlist',pwd, '^JOYSTICK_POST_0019_joystick_post_20220503122456_19.nii',1:170)
spm_realign(P);
spm_reslice(P);

%% W04

%% W06

%% If you want to plot the RP file created after spm_realign, create a csv
% copy of it. And you can then load it and run:
%figure()
%stackedplot(rp(:,1:3)) % x y z translation 
%figure()
%stackedplot(rp(:,4:6)) % x y z degree

%% Part 2: Coregistration

%%P01
%W02
inputs = {}
inputs{1} = cellstr(spm_select('FPList',fullfile(),'.nii$'));
inputs{2} = cellstr(spm_select('FPList',fullfile(),'.nii$')); % Coregister: Estimate: Source Image - cfg_files
spm('defaults', 'FMRI');
spm_jobman('run', jobs, inputs{:});
