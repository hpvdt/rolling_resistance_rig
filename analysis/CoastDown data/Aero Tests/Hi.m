function [ U,P ] = Power_tire( dataFile, Iwheel_avg, drum_radius, drum )
%   Calculates the speed, power of a dataset

ptAvg = 11;

%Import from the file
i = 0;

cd('CoastDown data\Aero Tests')

testFile = xlsread(dataFile);
triggerTime = testFile(:,1);

if drum == 1    
    speed = testFile(:,2);
else
    speed = testFile(:,4);
end
    

cd('..');
cd('..');

% Truncate the data to only keep the coastdown section

[M,ind] = max(speed);
speed = speed(ind:end);
triggerTime = triggerTime(ind:end);

%Filter t and compute filtered U

t_raw = sgolayfilt(triggerTime./1000000, 1, ptAvg);
speed_raw = sgolayfilt(speed./3.6, 1, ptAvg);
%omega_raw = 2*pi/(sgolayfilt(t_raw, 1, ptAvg))
omega_raw = speed_raw./drum_radius;

omega = [];
t = [];

%median_filter_points = 5;

for i=(2:(length(omega_raw)-2))
    omega = [omega, median(omega_raw((i-1):(i+2)))];
    t = [t, median(t_raw((i-1):(i+2)))];
    
end


tau = Iwheel_avg*diff(omega)./diff(t);
t = mean([t(1:end-1);t(2:end)],1);
omega = mean([omega(1:end-1);omega(2:end)],1);

P = -tau.*omega;
U = omega.*drum_radius;
end

