% Author: Davide Aloi, 
% Description: given an rp file, max mm and max radiants accepted, it
% creates a regressor to exclude volumes exceeding max_mm and max_rad.

function stick_regressor = regr_movements(rp_path, max_mm, max_rad)
    fileID = fopen(rp_path,'r');
    % Read rp.txt file
    rp = fscanf(fileID, '   %f   %f   %f   %f   %f   %f', [6 Inf])';
    % number of volumes
    vols = size(rp, 1);
    % regressor containing 0 / 1 
    stick_regressor = repmat(1,1,vols);
    stick_regressor(1,1) = 1;

    % If a translation / rotation exceeds max_mm or max_rad respectively,
    % exclude the volume.
    for x = 2:size(rp,1)
        
        eucl = ((rp(x,1) - rp(x-1,1))^2 + (rp(x,2) - rp(x-1,2))^2 + (rp(x,3) - rp(x-1,3))^2);
        eucl = sqrt(eucl);
        
        eucl_rad = ((rp(x,4) - rp(x-1,4))^2 + (rp(x,5) - rp(x-1,5))^2 + (rp(x,6) - rp(x-1,6))^2);
        eucl_rad = sqrt(eucl_rad);
        
        if (eucl > max_mm) || (eucl_rad > max_rad)
            stick_regressor(1,x) = 0;
        end
        
    end
    stick_regressor = [rp stick_regressor'];
end