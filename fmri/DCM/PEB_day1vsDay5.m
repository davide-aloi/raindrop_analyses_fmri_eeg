%% This script runs a hierarchical PEB of day1 < day2 differences in each session
% Davinia Fernandez-Espejo 8th July 2020
% Adapted by Davide Aloi (15/07/2022) for p01 raindrop

%% Edit the parameters below
clearvars;
path = 'C:\Users\davide\Documents\GitHub\raindrop_analyses_fmri_eeg\fmri\DCM\dcm_results_p01\'; % path where you have the estimated GCM file
cd(path)
load('PEBppA.mat')

% fields
field = {'A'
         %'B'
         }; 

%% specify settings for PEB day 1 < day 5
Mpp = struct();
Mpp.Q     = 'all';
Mpp.Xnames = {'constant', 'day1<day5'};
Mpp.X(:,1)=[1 1];
Mpp.X(:,2)= [-1 1];
Mpp.maxit = 256; % convergence before max num of iterations is reached

%% conditions for the pebs
polar = {'sham' 
    'anodal'
    'cathodal'};

%% Loop
tot_sess = 6; % n pebs

for fi = 1:length(field)
    PEBdd = cell(tot_sess/2,1);
    GCMdd = cell(tot_sess/2,1);
    BMA = cell(length(polar),1);
    sess = 1;
    
    for sub = 1:tot_sess/2
        PEB_temp = PEBpp(sess:sess+1);
        [PEBdd{sub}, GCMdd{sub}] = spm_dcm_peb(PEB_temp,Mpp,field(fi));
        BMA{sub} = spm_dcm_peb_bmc(PEBpp{sub});
        sess=sess+2;
    end
    
    save(strcat('PEBdd',field{fi}),'GCMdd','PEBdd');
    save(strcat('PEBdd_bma',field{fi}),'BMA');
end
