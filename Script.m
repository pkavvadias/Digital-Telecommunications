clear;
[y,fs] = audioread('speech.wav');
load cameraman.mat;
x = i(:);
x = (x-128)/128;

figure;
plot(y,'-r');
title('Initial sound signal');

[xq_2,centers_2,D_2] = PCM(y,2,min(y),max(y));
[xq_4,centers_4,D_4] = PCM(y,4,min(y),max(y));
[xq_8,centers_8,D_8] = PCM(y,8,min(y),max(y));

[ADM]= ADM(y,0.02,8,16);
fprintf('Source 2 \n');

figure;
plot(x,'-r');
title('Initial image signal');

[xq_2_image,centers_2_image,D_2_image] = PCM(x,2,min(x),max(x));
[xq_4_image,centers_4_image,D_4_image] = PCM(x,4,min(x),max(x));

%Gia therhtiko kai peiramatiko ypologismo emfanishs kathe stathmhs sthn
%eksodo kvantisth gia N=2

% Ypologismos Delta
Del = (max(y)-min(y))/2^2 ;

 
m = -0.04;

d = sqrt(0.11);


% Ypologismos oriwn 
limit1 = max(y) - Del;
limit2 = max(y) - 2*Del;
limit3 = max(y) - 3*Del;
limit4 = inf;

% Pdf function
p4 = normcdf(limit3,m,d) ;
p3 = normcdf(limit2,m,d) - p4;
p2 = normcdf(limit1,m,d) -p3-p4;
p1 = normcdf(limit4,m,d) -p2-p3-p4;

% Anathesi timwn se ena dianusma
theoritical_prop = [p1 p2 p3 p4];

% Ypologismos peiramatikwn timwn
% gia sunarthsh puknotitas pithanotitas
 experimental_prop = hist(xq_2, max(xq_2) - min(xq_2) + 1) / length(xq_2) ;
