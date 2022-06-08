%-----------------------------------------------------------------------
% Job saved on 08-Jun-2022 14:33:27 by cfg_util (rev $Rev: 7345 $)
% spm SPM - SPM12 (7771)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
matlabbatch{1}.spm.stats.factorial_design.dir = {'C:\Users\davide\Documents\GitHub\raindrop_analyses_fmri_eeg\fmri\glm\baseline_glm_results'};
matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = {
                                                          'D:\Raindrop_data\p01\p01_w02\day01\fmri_data\JOYSTICK_BASELINE_0015\nifti\glm_1st_level\con_0002.nii,1'
                                                          'D:\Raindrop_data\p01\p01_w02\day01\fmri_data\JOYSTICK_POST_0019\nifti\glm_1st_level\con_0002.nii,1'
                                                          'D:\Raindrop_data\p01\p01_w02\day05\fmri_data\JOYSTICK_BASELINE_0005\nifti\glm_1st_level\con_0002.nii,1'
                                                          'D:\Raindrop_data\p01\p01_w02\day05\fmri_data\JOYSTICK_POST_0010\nifti\glm_1st_level\con_0002.nii,1'
                                                          'D:\Raindrop_data\p01\p01_w04\day01\fmri_data\JOYSTICK_BASELINE_0005\nifti\glm_1st_level\con_0002.nii,1'
                                                          'D:\Raindrop_data\p01\p01_w04\day01\fmri_data\JOYSTICK_POST_0009\nifti\glm_1st_level\con_0002.nii,1'
                                                          'D:\Raindrop_data\p01\p01_w04\day05\fmri_data\JOYSTICK_BASELINE_0005\nifti\glm_1st_level\con_0002.nii,1'
                                                          'D:\Raindrop_data\p01\p01_w04\day05\fmri_data\JOYSTICK_POST_0009\nifti\glm_1st_level\con_0002.nii,1'
                                                          };
matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;
matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('Factorial design specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'Group pattern';
matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = 1;
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{2}.fcon.name = 'Group pattern F';
matlabbatch{3}.spm.stats.con.consess{2}.fcon.weights = 1;
matlabbatch{3}.spm.stats.con.consess{2}.fcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.delete = 0;
