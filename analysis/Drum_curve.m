% This is a script that was prepared to compare what appears to be the
% wheel's perfomance across different trials to see if the drum's behaviour
% is consistent between different trials.

Idrum = 6.7575;
drum_radius = 4.709/(2*pi);

%Plots drum power curves

aeroDataDirectory = ['data' filesep 'aero' filesep];
drum_L(1) = {[aeroDataDirectory 'Michelin 4575r16 - Separate - Left - 60 psi.csv']};
drum_R(1) = {[aeroDataDirectory 'Michelin 4575r16 - Separate - Right - 60 psi.csv']};

drum_L(2) = {[aeroDataDirectory 'Michelin 44-406 - Separate - Left - 80 psi.csv']};
drum_R(2) = {[aeroDataDirectory 'Michelin 44-406 - Separate - Right - 80 psi.csv']};

drum_L(3) = {[aeroDataDirectory 'Greenspeed Scorcher - Separate - Left - 80 psi.csv']};
drum_R(3) = {[aeroDataDirectory 'Greenspeed Scorcher - Separate - Left - 80 psi.csv']};

% drum_L(3) = [aeroDataDirectory name_wheel ' - Separate - Left - 50 psi.csv'];
% drum_R(3) = [aeroDataDirectory name_wheel ' - Separate - Right - 50 psi.csv'];

power_drum_left = [];
speed_low = 0;
speed_high = 23;

figure(); % Start a new figure for data

for i = 1:3
    speed_tire = [];
    totalPower = [];
    %get drum curve
    [U_drum_left, P_drum_left] = Power_tire(drum_L(i), Idrum, drum_radius,1);
    [U_drum_right, P_drum_right] = Power_tire(drum_R(i), Idrum, drum_radius,1);
    
    for n=floor(speed_low)*10:floor(speed_high)*10
        u = n/10;
        speed_tire = [speed_tire, u];

        %Find the corrosponding power values for the given velocity

        [~,drum_ind_left] = min(abs(U_drum_left-u));

        [~,drum_ind_right] = min(abs(U_drum_right-u));

        %Compute the tire power by removing aero effects of drum and wheel

        power_left = P_drum_left(drum_ind_left);
        power_right = P_drum_right(drum_ind_right);
        
        totalPower = [totalPower,(power_left + power_right)/2];
    end

    plot(speed_tire,totalPower);
    hold on
    
end

% Dress up the figure at the end
xlabel('Velocity (m/s)', 'fontsize', 12)
xlim([0,inf])
ylabel('Power (W)', 'fontsize', 12)
ylim([0,inf])
legend('November 2nd','December 5th','February 19th', 'Location','northwest')
