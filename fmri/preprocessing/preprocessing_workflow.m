% Author: Aloi Davide
% Description: Realignment, reslice and co-registration for: tennis task, joystick pre, and
% joystick baseline and passive mobilisation.

%% Step 1: Use SPM display to reorient the functional and anatomical scans

%% Step 2: Realign and reslice all functional files
% use job file realign_all_functional_scans_job.m
% I've always used as a reference the first joystick scan (so all fMRI tasks are in the
% same space basically). (How to do it: make a copy of the realigned scan from a joystick
% task session and use it as first image in the realignment job
% (ps: for the first image there's no need to load all the volumes, just the first one)

%% Part 2: Coregistration
% use preprocessing\preprocessing_2_coreg_job.m from the batch editor to run
% the coregistration between the anatomical and the functional scans (of each
% fmri task).

%% Part 3: Smoothing
% use preprocessing\preprocessing_3_smooth_job to smooth the realigned
% functional file. 

%% Part 4: movement regressor 
max_mm = 2
max_rad = 0.035

%% W02
% w02 day01 tennis task
cd D:\Raindrop_data\p01\p01_w02\day01\fmri_data\TENNIS_TASK_0016\nifti\
disp(pwd)
rp = dir('rp*.txt');
mov_regr = stick_regressor(rp.name, max_mm, max_rad)';
disp({'Volumes excluded: '} + string(sum(mov_regr(7,:) == 0)) + ' out of ' + string(numel(mov_regr(1,:))))
writetable(table(mov_regr'), 'regr.txt')
% w02 day01 Joystick baseline
cd D:\Raindrop_data\p01\p01_w02\day01\fmri_data\JOYSTICK_BASELINE_0015\nifti
disp(pwd)
rp = dir('rp*.txt');
mov_regr = stick_regressor(rp.name, max_mm, max_rad)';
disp({'Volumes excluded: '} + string(sum(mov_regr(7,:) == 0)) + ' out of ' + string(numel(mov_regr(1,:))))
writetable(table(mov_regr'), 'regr.txt')
% w02 day01 Joystick post
cd D:\Raindrop_data\p01\p01_w02\day01\fmri_data\JOYSTICK_POST_0019\nifti
disp(pwd)
rp = dir('rp*.txt');
mov_regr = stick_regressor(rp.name, max_mm, max_rad)';
disp({'Volumes excluded: '} + string(sum(mov_regr(7,:) == 0)) + ' out of ' + string(numel(mov_regr(1,:))))
writetable(table(mov_regr'), 'regr.txt')
% w02 day05 tennis task
cd D:\Raindrop_data\p01\p01_w02\day05\fmri_data\TENNIS_TASK_0006\nifti\
disp(pwd)
rp = dir('rp*.txt');
mov_regr = stick_regressor(rp.name, max_mm, max_rad)';
disp({'Volumes excluded: '} + string(sum(mov_regr(7,:) == 0)) + ' out of ' + string(numel(mov_regr(1,:))))
writetable(table(mov_regr'), 'regr.txt')
% w02 day05 Joystick baseline
cd D:\Raindrop_data\p01\p01_w02\day05\fmri_data\JOYSTICK_BASELINE_0005\nifti
disp(pwd)
rp = dir('rp*.txt');
mov_regr = stick_regressor(rp.name, max_mm, max_rad)';
disp({'Volumes excluded: '} + string(sum(mov_regr(7,:) == 0)) + ' out of ' + string(numel(mov_regr(1,:))))
writetable(table(mov_regr'), 'regr.txt')
% w02 day05 Joystick post
cd D:\Raindrop_data\p01\p01_w02\day05\fmri_data\JOYSTICK_POST_0010\nifti
disp(pwd)
rp = dir('rp*.txt');
mov_regr = stick_regressor(rp.name, max_mm, max_rad)';
disp({'Volumes excluded: '} + string(sum(mov_regr(7,:) == 0)) + ' out of ' + string(numel(mov_regr(1,:))))
writetable(table(mov_regr'), 'regr.txt')

%% W04
% w04 day01 tennis task
cd D:\Raindrop_data\p01\p01_w04\day01\fmri_data\TENNIS_TASK_0006\nifti
disp(pwd)
rp = dir('rp*.txt');
mov_regr = stick_regressor(rp.name, max_mm, max_rad)';
disp({'Volumes excluded: '} + string(sum(mov_regr(7,:) == 0)) + ' out of ' + string(numel(mov_regr(1,:))))
writetable(table(mov_regr'), 'regr.txt')
% w04 day01 Joystick baseline
cd D:\Raindrop_data\p01\p01_w04\day01\fmri_data\JOYSTICK_BASELINE_0005\nifti
disp(pwd)
rp = dir('rp*.txt');
mov_regr = stick_regressor(rp.name, max_mm, max_rad)';
disp({'Volumes excluded: '} + string(sum(mov_regr(7,:) == 0)) + ' out of ' + string(numel(mov_regr(1,:))))
writetable(table(mov_regr'), 'regr.txt')
% w04 day01 Joystick post
cd D:\Raindrop_data\p01\p01_w04\day01\fmri_data\JOYSTICK_POST_0009\nifti
disp(pwd)
rp = dir('rp*.txt');
mov_regr = stick_regressor(rp.name, max_mm, max_rad)';
disp({'Volumes excluded: '} + string(sum(mov_regr(7,:) == 0)) + ' out of ' + string(numel(mov_regr(1,:))))
writetable(table(mov_regr'), 'regr.txt')
% w04 day05 tennis task
cd D:\Raindrop_data\p01\p01_w04\day05\fmri_data\TENNIS_TASK_0006\nifti
disp(pwd)
rp = dir('rp*.txt');
mov_regr = stick_regressor(rp.name, max_mm, max_rad)';
disp({'Volumes excluded: '} + string(sum(mov_regr(7,:) == 0)) + ' out of ' + string(numel(mov_regr(1,:))))
writetable(table(mov_regr'), 'regr.txt')
% w04 day05 Joystick baseline
cd D:\Raindrop_data\p01\p01_w04\day05\fmri_data\JOYSTICK_BASELINE_0005\nifti
disp(pwd)
rp = dir('rp*.txt');
mov_regr = stick_regressor(rp.name, max_mm, max_rad)';
disp({'Volumes excluded: '} + string(sum(mov_regr(7,:) == 0)) + ' out of ' + string(numel(mov_regr(1,:))))
writetable(table(mov_regr'), 'regr.txt')
% w04 day05 Joystick post
cd D:\Raindrop_data\p01\p01_w04\day05\fmri_data\JOYSTICK_POST_0009\nifti
disp(pwd)
rp = dir('rp*.txt');
mov_regr = stick_regressor(rp.name, max_mm, max_rad)';
disp({'Volumes excluded: '} + string(sum(mov_regr(7,:) == 0)) + ' out of ' + string(numel(mov_regr(1,:))))
writetable(table(mov_regr'), 'regr.txt')

% w06 day01 tennis task
cd D:\Raindrop_data\p01\p01_w06\day01\fmri_data\TENNIS_TASK_0006\nifti
disp(pwd)
rp = dir('rp*.txt');
mov_regr = stick_regressor(rp.name, max_mm, max_rad)';
disp({'Volumes excluded: '} + string(sum(mov_regr(7,:) == 0)) + ' out of ' + string(numel(mov_regr(1,:))))
writetable(table(mov_regr'), 'regr.txt')
% w06 day01 Joystick baseline
cd D:\Raindrop_data\p01\p01_w06\day01\fmri_data\JOYSTICK_BASELINE_0005\nifti
disp(pwd)
rp = dir('rp*.txt');
mov_regr = stick_regressor(rp.name, max_mm, max_rad)';
disp({'Volumes excluded: '} + string(sum(mov_regr(7,:) == 0)) + ' out of ' + string(numel(mov_regr(1,:))))
writetable(table(mov_regr'), 'regr.txt')
% w06 day01 Joystick post
cd D:\Raindrop_data\p01\p01_w06\day01\fmri_data\JOYSTICK_POST_0009\nifti
disp(pwd)
rp = dir('rp*.txt');
mov_regr = stick_regressor(rp.name, max_mm, max_rad)';
disp({'Volumes excluded: '} + string(sum(mov_regr(7,:) == 0)) + ' out of ' + string(numel(mov_regr(1,:))))
writetable(table(mov_regr'), 'regr.txt')

% w06 day05 tennis task
cd D:\Raindrop_data\p01\p01_w06\day05\fmri_data\TENNIS_TASK_0006\nifti
disp(pwd)
rp = dir('rp*.txt');
mov_regr = stick_regressor(rp.name, max_mm, max_rad)';
disp({'Volumes excluded: '} + string(sum(mov_regr(7,:) == 0)) + ' out of ' + string(numel(mov_regr(1,:))))
writetable(table(mov_regr'), 'regr.txt')
% w06 day05 Joystick baseline
cd D:\Raindrop_data\p01\p01_w06\day05\fmri_data\JOYSTICK_BASELINE_0005\nifti
disp(pwd)
rp = dir('rp*.txt');
mov_regr = stick_regressor(rp.name, max_mm, max_rad)';
disp({'Volumes excluded: '} + string(sum(mov_regr(7,:) == 0)) + ' out of ' + string(numel(mov_regr(1,:))))
writetable(table(mov_regr'), 'regr.txt')

% w06 day05 Joystick Post
cd D:\Raindrop_data\p01\p01_w06\day05\fmri_data\JOYSTICK_POST_0009\nifti
disp(pwd)
rp = dir('rp*.txt');
mov_regr = stick_regressor(rp.name, max_mm, max_rad)';
disp({'Volumes excluded: '} + string(sum(mov_regr(7,:) == 0)) + ' out of ' + string(numel(mov_regr(1,:))))
writetable(table(mov_regr'), 'regr.txt')

% Passive mobilisation 
%% Part 4: movement regressor 
max_mm = 2
max_rad = 0.035

% w02 day 1
cd D:\Raindrop_data\p01\p01_w02\day01\fmri_data\PASSIVE_MOV_DURING_TDCS_0018\nifti
disp(pwd)
rp = dir('rp*.txt');
mov_regr = stick_regressor(rp.name, max_mm, max_rad)';
disp({'Volumes excluded: '} + string(sum(mov_regr(7,:) == 0)) + ' out of ' + string(numel(mov_regr(1,:))))
writetable(table(mov_regr'), 'regr.txt')

% w02 day 5
cd D:\Raindrop_data\p01\p01_w02\day05\fmri_data\PASSIVE_MOV_DURING_TDCS_0009\nifti
disp(pwd)
rp = dir('rp*.txt');
mov_regr = stick_regressor(rp.name, max_mm, max_rad)';
disp({'Volumes excluded: '} + string(sum(mov_regr(7,:) == 0)) + ' out of ' + string(numel(mov_regr(1,:))))
writetable(table(mov_regr'), 'regr.txt')

% w04 day 1
cd D:\Raindrop_data\p01\p01_w04\day01\fmri_data\PASSIVE_MOV_DURING_TDCS_0008\nifti
disp(pwd)
rp = dir('rp*.txt');
mov_regr = stick_regressor(rp.name, max_mm, max_rad)';
disp({'Volumes excluded: '} + string(sum(mov_regr(7,:) == 0)) + ' out of ' + string(numel(mov_regr(1,:))))
writetable(table(mov_regr'), 'regr.txt')

% w04 day 5
cd D:\Raindrop_data\p01\p01_w04\day05\fmri_data\PASSIVE_MOV_DURING_TDCS_0008\nifti
disp(pwd)
rp = dir('rp*.txt');
mov_regr = stick_regressor(rp.name, max_mm, max_rad)';
disp({'Volumes excluded: '} + string(sum(mov_regr(7,:) == 0)) + ' out of ' + string(numel(mov_regr(1,:))))
writetable(table(mov_regr'), 'regr.txt')

% w06 day 1
cd D:\Raindrop_data\p01\p01_w06\day01\fmri_data\PASSIVE_MOV_DURING_TDCS_0008\nifti
disp(pwd)
rp = dir('rp*.txt');
mov_regr = stick_regressor(rp.name, max_mm, max_rad)';
disp({'Volumes excluded: '} + string(sum(mov_regr(7,:) == 0)) + ' out of ' + string(numel(mov_regr(1,:))))
writetable(table(mov_regr'), 'regr.txt')

% w06 day 5
cd D:\Raindrop_data\p01\p01_w06\day05\fmri_data\PASSIVE_MOV_DURING_TDCS_0008\nifti
disp(pwd)
rp = dir('rp*.txt');
mov_regr = stick_regressor(rp.name, max_mm, max_rad)';
disp({'Volumes excluded: '} + string(sum(mov_regr(7,:) == 0)) + ' out of ' + string(numel(mov_regr(1,:))))
writetable(table(mov_regr'), 'regr.txt')
