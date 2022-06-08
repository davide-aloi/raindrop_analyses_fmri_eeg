
function [ ] = maxmov_rel(file,dist,ang,lenght)

%Davinia 8 July 2012
% file is rp_.txt file, dist is the mm, ang in radians, lenght is the
% number of volumes in the series

amatrix=load(file);

x=amatrix(:,1);
y=[];

for i=2:(lenght)(x) 
y(i)=x(i)-x(i-1);
end

transx=find(abs(y)>dist);

clear y;
clear i;
clear x;


x=amatrix(:,2);
y=[];

for i=2:(lenght)(x) 
y(i)=x(i)-x(i-1);
end

transy=find(abs(y)>dist);

clear y;
clear i;
clear x;


x=amatrix(:,3);
y=[];

for i=2:(lenght)(x) 
y(i)=x(i)-x(i-1);
end

transz=find(abs(y)>dist);

clear y;
clear i;
clear x;


x=amatrix(:,4);
y=[];

for i=2:(lenght)(x) 
y(i)=x(i)-x(i-1);
end

rot_p=find(abs(y)>ang);


clear y;
clear i;
clear x;


x=amatrix(:,5);
y=[];

for i=2:(lenght)(x) 
y(i)=x(i)-x(i-1);
end

rot_r=find(abs(y)>ang);


clear y;
clear i;
clear x;


x=amatrix(:,6);
y=[];

for i=2:(lenght)(x) 
y(i)=x(i)-x(i-1);
end

rot_y=find (abs(y)>ang);

clear y;
clear i;
clear x;


display('Exceden x relativo al anterior');


if (size(transx)>0) transx
end

  
display ('Exceden y relativo al anterior');
if (size(transy)>0) transy
end

display ('Exceden z relativo al anterior');
if (size(transz)>0) transz
end

display ('Exceden pitch relativo al anterior');
if (size(rot_p)>0) rot_p
end

display ('Exceden roll relativo al anterior');
if (size(rot_r)>0) rot_r
end

display ('Exceden yaw relativo al anterior');
if (size(rot_y)>0) rot_y
end

end







