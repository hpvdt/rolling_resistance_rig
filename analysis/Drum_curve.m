
Idrum = 6.7575;
drum_radius = 4.709/(2*pi);

%Plots drum power curves

aeroFileL1 = ['Michelin 4575r16 - Separate - Left - 60psi.csv'];
aeroFileR1 = ['Michelin 4575r16 - Separate - Right - 60psi.csv'];

aeroFileL2 = ['Michelin 44-406 - Separate - Left - 80psi.csv'];
aeroFileR2 = ['Michelin 44-406 - Separate - Right - 80psi.csv'];

aeroFileL3 = ['Green - Scorcher - Separate - Left - 80 psi.csv'];
aeroFileR3 = ['Green - Scorcher - Separate - Left - 80 psi.csv'];

% aeroFileL3 = [name_wheel ' - Separate - Left - 50psi.csv'];
% aeroFileR3 = [name_wheel ' - Separate - Right - 50psi.csv'];

drum_L = [{aeroFileL1}, {aeroFileL2}, {aeroFileL3}];
drum_R = [{aeroFileR1}, {aeroFileR2}, {aeroFileR3}];

power_drum_left = [];
speed_low = 0;
speed_high = 23;


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

        %Compute the tire power by removing aero effects of drum
        %and wheel

        power_left = P_drum_left(drum_ind_left);
        power_right = P_drum_right(drum_ind_right);
        
        totalPower = [totalPower,(power_left + power_right)/2];
        
        

    end
    
    if i == 1
        figure()
    end
    plot(speed_tire,totalPower);
    hold on

    xlabel('Velocity (m/s)', 'fontsize', 12)
    ylabel('Power (W)', 'fontsize', 12)
    legend('November 2nd','December 5th','February 19th')

    hold on
    
    
end




