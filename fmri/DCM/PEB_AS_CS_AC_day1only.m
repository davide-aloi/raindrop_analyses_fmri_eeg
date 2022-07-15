%% This script runs a hierarchical PEB for AS CS AC (for day1 only though)
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

%% specify settings for PEB day 1
M = struct();
M.Q     = 'all';
M.Xnames = {'constant', 'S<A'};
M.X(:,1)=[1 1];
M.X(:,2)= [-1 1];
M.maxit = 256; % convergence before max num of iterations is reached

%% conditions for the pebs
cond = {'S<A' 
        'S<C'
        'C<A'};

%% Loop
tot_sess = 3; % n pebs
PEBpairwise = {}
BMA = {}
GCMs = {}
for fi = 1:length(field)
       
    % taking the peb pre vs post of day 1 of sham anod and cath:
    % in Pebpp (pre<post) the order is Sham day 1, sham day 5, Anod day 1, anod day 5,
    % cath day 1 cath day 5
    
    AS = [PEBpp(1) PEBpp(3)]'
    CS = [PEBpp(1) PEBpp(5)]'
    AC = [PEBpp(5) PEBpp(3)]'
    
    M.Xnames = {'constant', 'S<A'};
    [PEBpairwise{end+1}, GCMs{end+1}] = spm_dcm_peb(AS,M,field(fi)); %AS
    
    BMA{end+1} = spm_dcm_peb_bmc(PEBpairwise{end});
    M.Xnames = {'constant', 'S<C'};
    [PEBpairwise{end+1}] = spm_dcm_peb(CS,M,field(fi)); %CS
    BMA{end+1} = spm_dcm_peb_bmc(PEBpairwise{end});
    M.Xnames = {'constant', 'C<A'};
    [PEBpairwise{end+1}] = spm_dcm_peb(AC,M,field(fi)); %AC
    BMA{end+1} = spm_dcm_peb_bmc(PEBpairwise{end});
end

PEBpairwise = PEBpairwise'
BMA = BMA'
save(strcat('PEBpairwise_day1',field{fi}),'PEBpairwise');
save(strcat('BMApairwise_day1',field{fi}),'BMA');



