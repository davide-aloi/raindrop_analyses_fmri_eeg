function out = regressor_fmri(regressor_num,total)

% 1st argument is regressor, 2nd argument is total scans

x = zeros(1,total);
x(regressor_num) = 1;
out = x;
x = num2str(x);
fname = ['regresor' num2str(regressor_num) '.txt'];
fid = fopen(fname,'w');
fprintf(fid,'%s',x);
fclose(fid);

fprintf('%s \n',x);

fprintf('Regressor %d of %d saved in %s. \n',regressor_num,total,fname);

end