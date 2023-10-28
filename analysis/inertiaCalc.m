function [ Iwheel ] = inertiaCalc( m_coin, m_wheel, d_coin, theta_deg, name_wheel)
%inertiaCalc Calculates the moment of intertia of the wheel or the drum
%   NOTE: Likely to be soon depreciated due to a revision to the inertia
%   measuring process
%
% Inputs:
%   m_coin      - Mass of rotation measuring magnet attached to wheel               (kg)
%   m_wheel     - Mass of wheel (without test mass)                 (kg)
%   d_coin      - Radius where magnet test mass was located                (m)
%   theta_deg      - starting angle of the pendulum         (deg)
%   name_wheel  - Name of the wheel being examined
%
% Outputs:
%   Iwheel      - Moment of inertia for the wheel (kg-m^2)

I_coin = m_coin*(d_coin^2);     %kg-m^2
% M = m_coin + m_wheel;       %kg
% R = (d_coin)*m_coin/(m_coin + m_wheel); %m

M = m_coin;       %kg, Period only affected by this test mass thingy
R = d_coin;      %m


theta = deg2rad(theta_deg); % converts degrees to radians

%Open all inertia files for a given wheel, uses times in first column
numSets = 0;
dataDirectory = ['data' filesep 'inertia' filesep];
while exist([dataDirectory name_wheel '_I' int2str(numSets+1) '.csv'], 'file')
    numSets = numSets + 1;
end

for i=1:numSets
    inertiaFile = readmatrix([dataDirectory name_wheel '_I' int2str(i) '.csv']);
    triggerTime = inertiaFile(:,1);%vector 

    times = diff(triggerTime)/1000000.0; %s
    Tavg = mean(times);
    %beta = -log(theta_2/theta_1)/(triggerTime(end-1) - triggerTime(1));
    %beta is unused damping stuff

    %Calculate average period using period of swing

    %Iwheel = 9.807*M*R*(Tavg)^2/(4*pi^2) * (1/AGmean(1,cos(theta_1/2)))^2 - m_coin*(d_coin^2) - I_coin;
    Iwheel = 9.807*M*R*(Tavg)^2/((4*pi^2) *(1/AGmean(1,cos(theta/2)))^2) - I_coin; %kg-m^2

end
end

%Calculations source here: https://utoronto-my.sharepoint.com/:b:/g/personal/georgez_wang_mail_utoronto_ca/Efy5Yl38QMVMuGutcB3ax98BHlE996UcN_6Heu9tfsG-zA?e=8jY2iv
