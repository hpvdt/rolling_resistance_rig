function [ U,P ] = Power_tire( dataFile, Iwheel_avg, drum_radius, drumFlag )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%   Calculates the speed, power of a dataset

ptAvg = 21;

%Import from the file

cd('CoastDown data/Aero Tests')

testFile = xlsread(string(dataFile));
rawTime = testFile(:,1);

if drumFlag == 1    
    rawSpeed = testFile(:,2); %km/h
    dataPoints = testFile(:,3);
    
else
    rawSpeed = testFile(:,4); %km/h
    dataPoints = testFile(:,5);
end

cd('..');
cd('..');

% Remove timepoints triggered by other wheel
time1 = 1;
time2 = 2;

speed = [];
triggerTime = [];


for i = 1:size(dataPoints)-1
    if dataPoints(i+1) ~= dataPoints(i)
        speed = [speed, rawSpeed(i)];
        triggerTime = [triggerTime, rawTime(i)];
    end
%     if dataPoints(time2) ~= dataPoints(time1)
%         speed = [speed,rawSpeed(time2)];
%         triggerTime = [triggerTime, rawTime(time2)];
%     end
%     time1 = time1 + 1;
%     time2 = time2 + 1;
    
end

% Truncate the data to only keep the coastdown section

[max_speed,ind] = max(speed);
speed = speed(ind:end);
triggerTime = triggerTime(ind:end);

%Filter t and compute filtered U

t_raw = sgolayfilt(triggerTime./1000000, 1, ptAvg); %seconds
%t_raw = triggerTime./1000000;
%speed_raw = sgolayfilt(speed./3.6, 1, ptAvg);

omega_raw = 2*pi./diff(t_raw); %radians/second      rotation speed
 
omega = [];
t = [];

%median_filter_points = 5;

for i=(2:(length(omega_raw)-2))
    omega = [omega, mean(omega_raw((i-1):(i+2)))]; %radians/second
    t = [t, mean(t_raw((i-1):(i+2)))]; %seconds
end

tau = Iwheel_avg*(diff(omega))./diff(t); %Nm 
% t = mean([t(1:end-1);t(2:end)],1);
% omega = mean([omega(1:end-1);omega(2:end)],1);
omega = omega(2:end);
P = -tau.*omega; % Watts
U = omega.*drum_radius; %m/s

P = sgolayfilt(P, 1, ptAvg); 

end

