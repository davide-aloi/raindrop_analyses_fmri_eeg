function get_metrics

datfiles = dir(['*_mohawk.mat']);

%% loop through them all
for pidx = 1:length(datfiles)
    
    % load file    
    filepath = fullfile(datfiles(pidx).folder,datfiles(pidx).name);
    load(filepath);
    
    %% parameters
    trange = [.9 .1]; % connection densities to study
    trange = (tvals <= trange(1) & tvals >= trange(2));
    
    %% ALPHA
    % Relative Power
    alpha_rel_pwr(pidx,1) = mean(bpower(3,:),2) * 100;
    
    % Median connectivity
    alpha_med_con(pidx,1) = nanmedian(matrix(3,:));
    
    % Modular span
    m = find(strcmpi('modular span',graphdata(:,1)));
    alpha_mod_span(pidx,1) = mean(graphdata{m,2}(3,trange));
    
    % SD of participation coefficient
    m = find(strcmpi('participation coefficient',graphdata(:,1)));
    alpha_sd_part_coeff(pidx,1) = std(mean(squeeze(graphdata{m,2}(3,trange,:)),1)) ;
    
    %% DELTA
    % Relative Power
    delta_rel_pwr(pidx,1) = mean(bpower(1,:),2) * 100;
    
    % Median connectivity
    delta_med_con(pidx,1) = nanmedian(matrix(1,:));
    
    % clustering coefficient
    m = find(strcmpi('clustering',graphdata(:,1)));
    delta_clust_coeff(pidx,1) = mean(mean(squeeze(graphdata{m,2}(1,trange,:)),1));
    
    % modularity
    m = find(strcmpi('modularity',graphdata(:,1)));
    delta_modularity(pidx,1) = mean(graphdata{m,2}(1,trange));
    
end

save 'LPAT_mohawk_metric_output.mat';