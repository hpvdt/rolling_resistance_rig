%Import stuff

%Define intial variables

Tire_name_list = {'Michelin 4575r16','Michelin 44-406','Greenspeed','Vittoria Corsa Open','Drum','Samplewheel 29','Grandprix'};
g = 9.80665002864; %in newtons

bad_speed_zone_start = 0;
bad_speed_zone_end = 0;


test_mass = ((90+35)/2.2)*g; %Newtons

name_wheel = [];
full_name = [];
m_wheel = [];
m_coin = [];
R_coin = [];
r_coin = [];
theta_1 = [];
theta_2 = [];
inertia_file = [];
R_roll = [];
Figure_name_wheel = [];

wheelFile = readcell('wheelInfo.csv');

%Read in parameters from all tires for the inertia calculation
for i=2:size(wheelFile,1)
    name_wheel = [name_wheel,wheelFile(i,1)];
    full_name = [full_name, wheelFile(i,2)];
    m_wheel = [m_wheel, cell2mat(wheelFile(i,3))];
    m_coin = [m_coin, cell2mat(wheelFile(i,4))];
    R_coin = [R_coin, cell2mat(wheelFile(i,5))];
    r_coin = [r_coin, cell2mat(wheelFile(i,6))];
    R_roll = [R_roll, cell2mat(wheelFile(i,7))];
    theta_1 = [theta_1, pi/180*cell2mat(wheelFile(i,8))];
    theta_2 = [theta_2, pi/180*cell2mat(wheelFile(i,9))];
end

%Read in pressure and tire info from each test to analyze
test_file = readcell('Test_info.csv');
test_tires = string(test_file(:,1));
test_pressures = cell2mat(test_file(:,2:end));

I_wheels = [];

%For each tire and pressure specified in the test file, calculate and plot
%the coefficient of rolling resistance as a function of speed
for i = 1:length(test_tires)

%     if i == 1
%         test_pressures = [100 140];
%     else
%         test_pressures = 100;
%     end
 
    tire_ind = 0;
    
    %Find the index of the test tire in the tire parameter data
    for ind = 1:length(Tire_name_list)
        if Tire_name_list(ind) == test_tires(i)
            tire_ind = ind;
        end
    end
    
    
    %Calculate the mass-moment of inertia of the test tire
    I_wheel = inertiaCalc(m_coin(tire_ind),m_wheel(tire_ind), R_coin(tire_ind), theta_1(tire_ind),theta_2(tire_ind),char(name_wheel(tire_ind)),r_coin(tire_ind));
    I_drum = inertiaCalc(m_coin(5), m_wheel(5), R_coin(5), theta_1(5),theta_2(5),char(name_wheel(5)),r_coin(5)); %Drum data is the 5th entry in 
    %I_wheel = 0.05; 
    I_wheels = [I_wheels, I_wheel];
    
    %Testing approximate values of moment of int
    %I_wheel = 1.2*0.235^2; %m*r^2
    I_drum = 10; %0.5*m*r^2
    
    

    %find indexes of each tire in tirelist
    
    %For each test with a given tire, compute the coefficient of rolling
    %resistance vs. speed
    
    crrL = [];
    crrR = [];
    totalPower = [];
    CRR_fulltire = [];
    len = size(test_pressures);
    for c = 1:len(2)
        
        [U_wheel_left, U_wheel_right, P_wheel_left, P_wheel_right, U_drum_left, U_drum_right, P_drum_left, P_drum_right] = PowerCurve_wheel(name_wheel{tire_ind}, I_wheel, I_drum, R_roll(tire_ind),0.76, test_pressures(c));
        
        legend_drum = [];
        legend_wheel = [];
        legend_run = [];
        tire_coeffs = [];

        %test_mass = [156.1,557.4,1114.8];
        test_mass = [557.4];
        
        
        %Find Inertia of entire system 
        wheelCirc = 1.497; %m
        drumCirc = 4.709; %m
        I_system = I_drum*(wheelCirc/drumCirc)^2 + I_wheel;
        
        % Compute power of full coastdown

        dataFileL = [Tire_name_list{tire_ind} ' - Contact - Left - ' int2str(test_pressures(c)) 'psi.csv'];
        dataFileR = [Tire_name_list{tire_ind} ' - Contact - Right - ' int2str(test_pressures(c)) 'psi.csv']; 
        
        %Assuming I have the power, speed for both directions of wheel and drum
        %find index for closest velocity in the drum, wheel, and both tire runs

        if c == 3
            hello = 7;
        end
        
        [speed_run_left, power_run_left] = Power_tire(dataFileL, I_system, R_roll(i),0);
        [speed_run_right, power_run_right] = Power_tire(dataFileR, I_system, R_roll(i),0);
        
        %Will contain speeds in 0.1m/s increments throughtout entire range of interest
        %Used as x-axis data in final graphs
        speed_tire = [];
        
        %speed range of interest
        speed_low = 5;
        speed_high = 22;

%         force_tire_run_left = [];
%         coeficient_tire_run_left = [];
%         Power_tire_run_right = [];
%         speed_tire_run_right = [];
%         force_tire_run_right = [];
% 
%         force_tire = [];
        
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
%               
%                 total_power_left = power_run_left(run_ind_left);
%                 total_power_right = power_run_right(run_ind_right);

%                 
%                 total_power_left = P_wheel_left(wheel_ind_left);
%                 total_power_right = P_wheel_right(wheel_ind_right);
%              
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

%         hold on
        if (c == 1 && i == 1)
            figure()
        end
        
        plot(speed_tire,coefficient_tire);
        
%         plot(speed_tire,crrL);
%         hold on
%         plot(speed_tire,crrR);
%         plot(speed_tire,totalPower);
        hold on
        
        axis([(speed_low-1) (18) 0 5E-3]);
        %axis([(speed_low-1) (speed_high+1)]);
        
        xlabel('Velocity (m/s)', 'fontsize', 12)
        ylabel('Coefficient of Rolling Resistance', 'fontsize', 12)
        legend('Grand Prix 4000 SII - 100 psi','Grand Prix 4000 SII - 140 psi','Vittoria Corsa Open - 100 psi')
        %legend('Grand Prix 4000 SII - 100 psi','Grand Prix 4000 SII - 140 psi')
        
        %legend('Vittoria Corsa Open - 100 psi')
        
        %legend('100 psi','120 psi','140 psi')
        %legend([num2str(test_mass(1)) ' N'],[num2str(test_mass(2)) ' N'],[num2str(test_mass(3)) ' N'])
        
        hold on

%         speed_tire = 3.6*speed_tire;
% %         plot(speed_tire,CRR);
   
%         
%         tire_coeffs = [tire_coeffs, coefficient_tire];
    end
end


