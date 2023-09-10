function [ Iwheel ] = inertiaCalc( m_coin, m_wheel, R_coin, theta_1, theta_2, name_wheel,d_coin)
%Calculates the moment of intertia of the wheel or the drum
I_coin = m_coin*(d_coin^2);     %kg-m^2
M = m_coin + m_wheel;       %kg
R = (d_coin)*m_coin/(m_coin + m_wheel); %m

%Open all inertia files

numSets = 0;
dataDirectory = ['data' filesep 'inertia' filesep];

while exist([dataDirectory name_wheel '_I' int2str(i+1) '.xlsx'], 'file')
    numSets = numSets + 1;
end

for i=1:numSets

    inertiaFile = readmatrix([dataDirectory name_wheel '_I' int2str(i) '.xlsx']);
    triggerTime = inertiaFile(:,1);

    %Remove last point if dataset contrain even amount of points
    if mod(length(triggerTime),2) == 0
        triggerTime = triggerTime(1:end-1);
    end
    triggerTime = triggerTime(1:2:end);
    
    %shift the amplitude over 1/4 period since trigger happens at theta = 0
%     shift = (theta_1 - theta_2)/(2*length(triggerTime));
%     theta_1 = theta_1-shift;
%     theta_2 = theta_2-shift;
% 
%     triggerTime = triggerTime/1000000;
%     Tavg = (triggerTime(end-1) -triggerTime(1)/((length(triggerTime)-1)/2.0));
    
    times = diff(triggerTime)/1000000; %s 
    Tavg = mean(times);
    beta = -log(theta_2/theta_1)/(triggerTime(end-1) - triggerTime(1));

    %Calculate average period and damping
    %Iwheel = 9.807*M*R*(Tavg)^2/(4*pi^2) * (1/AGmean(1,cos(theta_1/2)))^2 - m_coin*(d_coin^2) - I_coin;
    Iwheel = 9.807*M*R*(Tavg)^2/(4*pi^2) * (1/AGmean(1,cos(theta_1/2)))^2 - I_coin; %kg-m^2
end
end

