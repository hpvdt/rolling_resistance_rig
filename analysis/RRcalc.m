%% User configuration
%speed range of interest in m/s
speed_low = 5;
speed_high = 18;

%% Automated Configuration / Constants

% Region of speed values to ignore due to test rig issues (resonance)
bad_speed_zone_start = 0;
bad_speed_zone_end = 0;

aeroDataDirectory = ['data' filesep 'aero' filesep]; % Create path to data directory (`filesep` used to be operating system agnostic)

g = 9.80665002864; %in newtons
test_mass = ((90+35)/2.2)*g; %Newtons (Overwritten later on in loop)

%Read in parameters from all tires for the inertia calculation
wheelFile = readcell('wheelInfo.csv'); % Read in all text (including headers)
name_wheel = wheelFile(2:end,1);
full_name = wheelFile(2:end,2);
m_wheel = cell2mat(wheelFile(2:end,3));
m_coin = cell2mat(wheelFile(2:end,4));
R_coin = cell2mat(wheelFile(2:end,5));
r_coin = cell2mat(wheelFile(2:end,6));
R_roll = cell2mat(wheelFile(2:end,7));
theta_1 = cell2mat(wheelFile(2:end,8));
theta_2 = cell2mat(wheelFile(2:end,9)); %Remove these things

%Read in pressure and tire info from each test to analyze
test_file = readcell('script_config.csv');
test_tires = string(test_file(:,1));
test_pressures = cell2mat(test_file(:,2:end));

% Get the drum moment of inertia
drum_ind = find(name_wheel == "Drum");
if isempty(drum_ind)
    error("Drum information not found in wheel database! (`wheelInfo.csv`)");
end
I_drum = inertiaCalc(m_coin(drum_ind), m_wheel(drum_ind), r_coin(drum_ind), theta_1(drum_ind),char(name_wheel(drum_ind)));

I_wheels = [];

%% CRR Collection 
figure(); % Start figure for data

%For each tire and pressure specified in the test file, calculate and plot
%the coefficient of rolling resistance as a function of speed
for i = 1:length(test_tires)
    
    %Find the index of the test tire in the tire parameter data
    tire_ind = find(name_wheel == test_tires(i));
    if isempty(tire_ind)
        error("Tire '%s' information not found in wheel database! (`wheelInfo.csv`)", test_tires(i));
    end

    %Calculate the mass-moment of inertia of the test tire
    I_wheel = inertiaCalc(m_coin(tire_ind),m_wheel(tire_ind), r_coin(tire_ind), theta_1(tire_ind),char(name_wheel(tire_ind)));
    %I_wheel = 0.05; 
    I_wheels = [I_wheels, I_wheel];
    
    %Testing approximate values of moment of int
    %I_wheel = 1.2*0.235^2; %m*r^2
    I_drum = 10; %0.5*m*r^2
    
    %For each test with a given tire, compute the coefficient of rolling
    %resistance vs. speed
    
    crrL = [];
    crrR = [];
    totalPower = [];
    CRR_fulltire = [];
    len = size(test_pressures);
    for c = 1:len(2)
        % We don't seem to properly sift through the pressures for wheels
        % and assume that we're going to have the same pressures for all
        % wheels being actively compared
        
        [U_wheel_left, U_wheel_right, P_wheel_left, P_wheel_right, U_drum_left, U_drum_right, P_drum_left, P_drum_right] = PowerCurve_wheel(name_wheel{tire_ind}, I_wheel, I_drum, R_roll(tire_ind),0.76, test_pressures(c));

        %test_mass = [156.1,557.4,1114.8];
        test_mass = [557.4];

        %Find Inertia of entire system 
        wheelCirc = 1.497; %m
        drumCirc = 4.709; %m
        I_system = I_drum*(wheelCirc/drumCirc)^2 + I_wheel;
        
        % Compute power of full coastdown

        dataFileL = [aeroDataDirectory char(test_tires(i)) ' - Contact - Left - ' int2str(test_pressures(c)) ' psi.csv'];
        dataFileR = [aeroDataDirectory char(test_tires(i)) ' - Contact - Right - ' int2str(test_pressures(c)) ' psi.csv']; 
        
        %Assuming I have the power, speed for both directions of wheel and drum
        %find index for closest velocity in the drum, wheel, and both tire runs
        
        [speed_run_left, power_run_left] = Power_tire(dataFileL, I_system, R_roll(i),0);
        [speed_run_right, power_run_right] = Power_tire(dataFileR, I_system, R_roll(i),0);
        
        %Will contain speeds in 0.1m/s increments throughtout entire range of interest
        %Used as x-axis data in final graphs
        speed_tire = [];
        coefficient_tire = [];
        
        for n=floor(speed_low)*10:floor(speed_high)*10
            u = n/10;            
            
            if u < bad_speed_zone_start || u > bad_speed_zone_end
                speed_tire = [speed_tire, u];
                %Find the corrosponding power values for each value of velocity
               
                [~,drum_ind_left] = min(abs(U_drum_left-u));
                [~,wheel_ind_left] = min(abs(U_wheel_left-u));
                [~,run_ind_left] = min(abs(speed_run_left-u));
                
                [~,drum_ind_right] = min(abs(U_drum_right-u));
                [~,wheel_ind_right] = min(abs(U_wheel_right-u));
                [~,run_ind_right] = min(abs(speed_run_right-u));
                
                %Compute the tire power by removing aero effects of drum
                %and wheel
                
                total_power_left = power_run_left(run_ind_left) - P_drum_left(drum_ind_left) - P_wheel_left(wheel_ind_left);
                total_power_right = power_run_right(run_ind_right) - P_drum_right(drum_ind_right) - P_wheel_right(wheel_ind_right);
                
%                 total_power_left = P_drum_left(drum_ind_left);
%                 total_power_right = P_drum_right(drum_ind_right);

%                 total_power_left = power_run_left(run_ind_left);
%                 total_power_right = power_run_right(run_ind_right);

%                 total_power_left = P_wheel_left(wheel_ind_left);
%                 total_power_right = P_wheel_right(wheel_ind_right);

                force_left = total_power_left/u; %Newtons
                force_right = total_power_right/u;

                coefficientRR_left = force_left/test_mass(1); 
                coefficientRR_right = force_right/test_mass(1);            
                
                coefficientRR = (coefficientRR_left + coefficientRR_right)/2;
                             
                %Remove outlier points
                if size(coefficient_tire) > 0
                    if abs((coefficientRR - coefficient_tire(end))/coefficientRR) > 0.45 
                        coefficientRR = coefficient_tire(end);
                    end
                end
             end
            
            totalPower = [totalPower, (total_power_left+total_power_right)/2];
            crrL = [crrL, coefficientRR_left];
            crrR = [crrR, coefficientRR_right];
            coefficient_tire = [coefficient_tire,coefficientRR];
        end

        CRR_fulltire = [CRR_fulltire; coefficient_tire];
        %Filter data- Moving median
             
%         median_filter_width = 5;
%         
%         for i = 21:(size(coefficient_tire)-20)
%             width = [coefficient_tire((i-20):(i-1)), coefficient_tire((i+1):(i+20))];
%             coefficient_tire(i) = median(width);
%         end
        
%         dataStart = coefficient_tire(1:174);
%         dataEnd = coefficient_tire(175:end);
%         
%         windowSize = 18;
%         b = (1/windowSize)*ones(1,windowSize);
%         a = 1;
%         
%         y = filter(b,a,dataEnd);
%        
%         CRR = [dataStart,y];

        plot(speed_tire,coefficient_tire, 'DisplayName', [char(test_tires(i)) ' - ' int2str(test_pressures(c)) ' psi']);
        hold on
    end
end

%% Plot Adjustments
axis([floor(speed_low), ceil(speed_high), 0 , inf]);

xlabel('Velocity (m/s)', 'fontsize', 12)
ylabel('Coefficient of Rolling Resistance', 'fontsize', 12)
legend('Location','southeast') % Labels are assumed to be already assigned to plots using 'DisplayName'