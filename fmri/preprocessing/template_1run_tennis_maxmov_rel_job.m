%-----------------------------------------------------------------------
% Job configuration created by cfg_util (rev $Rev: 4252 $)
%-----------------------------------------------------------------------
matlabbatch{1}.cfg_basicio.cfg_cd.dir = '<UNDEFINED>';
matlabbatch{2}.spm.stats.fmri_spec.dir = '<UNDEFINED>';
matlabbatch{2}.spm.stats.fmri_spec.timing.units = 'secs';
matlabbatch{2}.spm.stats.fmri_spec.timing.RT = 2;
matlabbatch{2}.spm.stats.fmri_spec.timing.fmri_t = 16;
matlabbatch{2}.spm.stats.fmri_spec.timing.fmri_t0 = 1;
matlabbatch{2}.spm.stats.fmri_spec.sess.scans = '<UNDEFINED>';
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(1).name = 'tennis'; % change this accordingly
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(1).onset = [30
                                                         90
                                                         150
                                                         210
                                                         270];
                                                    
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(1).duration = 30;
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(1).tmod = 0;
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(2).name = 'relax';
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(2).onset = [0
                                                         60
                                                         90
                                                         120
                                                         180
                                                         240];
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(2).duration = 30;
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(2).tmod = 0;
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{2}.spm.stats.fmri_spec.sess.multi = {''};
matlabbatch{2}.spm.stats.fmri_spec.sess.regress(1).name = '30'; %% enter the name of the regressor here and the values below. If it's just one regressor just get rid of the (1)
matlabbatch{2}.spm.stats.fmri_spec.sess.regress(1).val = regressor_fmri(30,143);
matlabbatch{2}.spm.stats.fmri_spec.sess.regress(2).name = '31'; %% enter the name of the regressor here and the values below. If it's just one regressor just get rid of the (1)
matlabbatch{2}.spm.stats.fmri_spec.sess.regress(2).val = regressor_fmri(31,143);
matlabbatch{2}.spm.stats.fmri_spec.sess.regress(3).name = '32'; %% enter the name of the regressor here and the values below. If it's just one regressor just get rid of the (1)
matlabbatch{2}.spm.stats.fmri_spec.sess.regress(3).val = regressor_fmri(32,143);
matlabbatch{2}.spm.stats.fmri_spec.sess.regress(4).name = '38'; %% enter the name of the regressor here and the values below. If it's just one regressor just get rid of the (1)
matlabbatch{2}.spm.stats.fmri_spec.sess.regress(4).val = regressor_fmri(38,143);
matlabbatch{2}.spm.stats.fmri_spec.sess.regress(5).name = '15'; %% enter the name of the regressor here and the values below. If it's just one regressor just get rid of the (1)
matlabbatch{2}.spm.stats.fmri_spec.sess.regress(5).val = regressor_fmri(15,143);
matlabbatch{2}.spm.stats.fmri_spec.sess.regress(6).name = '73'; %% enter the name of the regressor here and the values below. If it's just one regressor just get rid of the (1)
matlabbatch{2}.spm.stats.fmri_spec.sess.regress(6).val = regressor_fmri(73,143);
matlabbatch{2}.spm.stats.fmri_spec.sess.regress(7).name = '74'; %% enter the name of the regressor here and the values below. If it's just one regressor just get rid of the (1)
matlabbatch{2}.spm.stats.fmri_spec.sess.regress(7).val = regressor_fmri(74,143);
matlabbatch{2}.spm.stats.fmri_spec.sess.regress(8).name = '92'; %% enter the name of the regressor here and the values below. If it's just one regressor just get rid of the (1)
matlabbatch{2}.spm.stats.fmri_spec.sess.regress(8).val = regressor_fmri(92,143);
matlabbatch{2}.spm.stats.fmri_spec.sess.regress(9).name = '93'; %% enter the name of the regressor here and the values below. If it's just one regressor just get rid of the (1)
matlabbatch{2}.spm.stats.fmri_spec.sess.regress(9).val = regressor_fmri(93,143);
matlabbatch{2}.spm.stats.fmri_spec.sess.regress(1).name = '94'; %% enter the name of the regressor here and the values below. If it's just one regressor just get rid of the (1)
matlabbatch{2}.spm.stats.fmri_spec.sess.regress(1).val = regressor_fmri(94,143);
matlabbatch{2}.spm.stats.fmri_spec.sess.regress(1).name = '30'; %% enter the name of the regressor here and the values below. If it's just one regressor just get rid of the (1)
matlabbatch{2}.spm.stats.fmri_spec.sess.regress(1).val = regressor_fmri(30,143);
matlabbatch{2}.spm.stats.fmri_spec.sess.regress(1).name = '138'; %% enter the name of the regressor here and the values below. If it's just one regressor just get rid of the (1)
matlabbatch{2}.spm.stats.fmri_spec.sess.regress(1).val = regressor_fmri(138,143);
matlabbatch{2}.spm.stats.fmri_spec.sess.multi_reg = '<UNDEFINED>';
matlabbatch{2}.spm.stats.fmri_spec.sess.hpf = 128;
matlabbatch{2}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{2}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
matlabbatch{2}.spm.stats.fmri_spec.volt = 1;
matlabbatch{2}.spm.stats.fmri_spec.global = 'None';
matlabbatch{2}.spm.stats.fmri_spec.mask = {''};
matlabbatch{2}.spm.stats.fmri_spec.cvi = 'AR(1)';
matlabbatch{3}.spm.stats.fmri_est.spmmat(1) = cfg_dep;
matlabbatch{3}.spm.stats.fmri_est.spmmat(1).tname = 'Select SPM.mat';
matlabbatch{3}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(1).name = 'filter';
matlabbatch{3}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(1).value = 'mat';
matlabbatch{3}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{3}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(2).value = 'e';
matlabbatch{3}.spm.stats.fmri_est.spmmat(1).sname = 'fMRI model specification: SPM.mat File';
matlabbatch{3}.spm.stats.fmri_est.spmmat(1).src_exbranch = substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{3}.spm.stats.fmri_est.spmmat(1).src_output = substruct('.','spmmat');
matlabbatch{3}.spm.stats.fmri_est.method.Classical = 1;
matlabbatch{4}.spm.stats.con.spmmat(1) = cfg_dep;
matlabbatch{4}.spm.stats.con.spmmat(1).tname = 'Select SPM.mat';
matlabbatch{4}.spm.stats.con.spmmat(1).tgt_spec{1}(1).name = 'filter';
matlabbatch{4}.spm.stats.con.spmmat(1).tgt_spec{1}(1).value = 'mat';
matlabbatch{4}.spm.stats.con.spmmat(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{4}.spm.stats.con.spmmat(1).tgt_spec{1}(2).value = 'e';
matlabbatch{4}.spm.stats.con.spmmat(1).sname = 'Model estimation: SPM.mat File';
matlabbatch{4}.spm.stats.con.spmmat(1).src_exbranch = substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{4}.spm.stats.con.spmmat(1).src_output = substruct('.','spmmat');
matlabbatch{4}.spm.stats.con.consess{1}.tcon.name = 'tennis > relax'; %% change this accordingly
matlabbatch{4}.spm.stats.con.consess{1}.tcon.convec = [1 -1];
matlabbatch{4}.spm.stats.con.consess{1}.tcon.sessrep = 'both';
matlabbatch{4}.spm.stats.con.delete = 0;
matlabbatch{5}.spm.stats.results.spmmat(1) = cfg_dep;
matlabbatch{5}.spm.stats.results.spmmat(1).tname = 'Select SPM.mat';
matlabbatch{5}.spm.stats.results.spmmat(1).tgt_spec{1}(1).name = 'filter';
matlabbatch{5}.spm.stats.results.spmmat(1).tgt_spec{1}(1).value = 'mat';
matlabbatch{5}.spm.stats.results.spmmat(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{5}.spm.stats.results.spmmat(1).tgt_spec{1}(2).value = 'e';
matlabbatch{5}.spm.stats.results.spmmat(1).sname = 'Contrast Manager: SPM.mat File';
matlabbatch{5}.spm.stats.results.spmmat(1).src_exbranch = substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{5}.spm.stats.results.spmmat(1).src_output = substruct('.','spmmat');
matlabbatch{5}.spm.stats.results.conspec.titlestr = '';
matlabbatch{5}.spm.stats.results.conspec.contrasts = Inf;
matlabbatch{5}.spm.stats.results.conspec.threshdesc = 'none';
matlabbatch{5}.spm.stats.results.conspec.thresh = 0.005;
matlabbatch{5}.spm.stats.results.conspec.extent = 0;
matlabbatch{5}.spm.stats.results.conspec.mask = struct('contrasts', {}, 'thresh', {}, 'mtype', {});
matlabbatch{5}.spm.stats.results.units = 1;
matlabbatch{5}.spm.stats.results.print = true;
