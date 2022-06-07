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
    
    % If a translation / rotation exceeds max_mm or max_rad respectively,
    % exclude the volume.
    for x = 1:size(rp,1)
        if (abs(rp(x,1)) > max_mm) || (abs(rp(x,2)) > max_mm) || (abs(rp(x,3)) > max_mm)
            stick_regressor(1,x) = 0;
        end
        if (abs(rp(x,4)) > max_rad) || (abs(rp(x,5)) > max_rad) || (abs(rp(x,6)) > max_rad)
            stick_regressor(1,x) = 0;
        end
    end
    stick_regressor = [rp stick_regressor'];
end