function [ U_wheel_left, U_wheel_right, P_wheel_left, P_wheel_right, U_drum_left, U_drum_right, P_drum_left, P_drum_right ] = PowerCurve_wheel( name_wheel, Iwheel, Idrum, wheel_radius, drum_radius, pressure )
%PowerCurve_wheel Returns the speed and power of the wheel and drum for the 
%aero tests (in each direction)
%   Goes through and collects the data for wheels as desired to provide
%   consistent data for all wheels
%
% Inputs:
%   name_wheel    - Test wheel name
%   Iwheel        - Moment of inertia for the wheel (kg-m^2)
%   Idrum         - Moment of inertia for the drum  (kg-m^2)
%   wheel_radius  - Radius of the wheel             (m)
%   drum_radius   - Radius of the drum              (m)
%   pressure      - Wheel pressure                  (psi)
%
% Outputs:
%   U_wheel_left  - Speed of the wheel going left   (m/s)
%   U_wheel_right - Speed of the wheel going right  (m/s)
%   P_wheel_left  - Power of the wheel going left   (W)
%   P_wheel_right - Power of the wheel going right  (W)
%   U_drum_left   - Speed of the drum going left    (m/s)
%   U_drum_right  - Speed of the drum going right   (m/s)
%   P_drum_left   - Power of the drum going left    (W)
%   P_drum_right  - Power of the drum going right   (W)

dataFile_L = [];
dataFile_R = [];

%Add in aero test files (with same test parameters)
dataDirectory = ['data' filesep 'aero' filesep];
aeroFileL = [dataDirectory name_wheel ' - Separate - Left - ' int2str(pressure) ' psi.csv'];
aeroFileR = [dataDirectory name_wheel ' - Separate - Right - ' int2str(pressure) ' psi.csv'];
if(exist(aeroFileL, 'file'))
    dataFile_L = [dataFile_L, aeroFileL];
    dataFile_R = [dataFile_R, aeroFileR];
end

U_run_left = [];
U_run_right = [];
P_run_left = [];
P_run_right = [];

%Calculate P,U,and t for the wheel
[U_wheel_left, P_wheel_left] = Power_tire(dataFile_L, Iwheel, wheel_radius,0);
[U_wheel_right, P_wheel_right] = Power_tire(dataFile_R, Iwheel, wheel_radius,0);

%Calculates P,U,and t for the drum
[U_drum_left, P_drum_left] = Power_tire(dataFile_L, Idrum, drum_radius,1);
[U_drum_right, P_drum_right] = Power_tire(dataFile_R, Idrum, drum_radius,1);

%     %Makes the drum and wheel datasets the same length
%     %left direction
%     x = size(U_wheel_left_temp,2);
%     y = size(U_drum_left_temp,2); 
%     if size(U_wheel_left_temp,2) > size(U_drum_left_temp,2)
%         U_wheel_left_temp = U_wheel_left_temp(end-y+1:end);
%         P_wheel_left_temp = P_wheel_left_temp(end-y+1:end);
%     else
%         U_drum_left_temp = U_drum_left_temp(end+1-x:end);
%         P_drum_left_temp = P_drum_left_temp(end-x+1:end);
%     end
%     %right direction
%  
%     x = size(U_wheel_right_temp,2);
%     y = size(U_drum_right_temp,2);
%     if size(U_wheel_right_temp,2) > size(U_drum_right_temp,2)
%         U_wheel_right_temp = U_wheel_right_temp(end-y+1:end);
%         P_wheel_right_temp = P_wheel_right_temp(end-y+1:end);
%     else
%         U_drum_right_temp = U_drum_right_temp(end+1-x:end);
%         P_drum_right_temp = P_drum_right_temp(end-x+1:end);
%     end
    
%     U_run_left = [U_run_left; U_wheel_left_temp; U_drum_left_temp];
%     U_run_right = [U_run_right; U_wheel_right_temp; U_drum_right_temp];
%     P_run_left = [P_run_left; P_wheel_left_temp; P_drum_left_temp];
%     P_run_right = [P_run_right; P_wheel_right_temp; P_drum_right_temp];
%     
% end



% %Find the min and max speeds across all the tests
% speed_Low = 1000;
% speed_High = 0;
% for i=1:2*numSets
% 
%     if min(U_run_left(i,:)) < speed_Low
%         speed_Low = min(U_run_left(i,:));
%     end
%     if min(U_run_right(i,:)) < speed_Low
%         speed_Low = min(U_run_right(i,:));
%     end
%     if max(U_run_left(i,:)) > speed_High
%         speed_High = max(U_run_left(i,:));
%     end
%     if max(U_run_right(i,:)) > speed_High
%         speed_High = max(U_run_right(i,:));
%     end
% end

% power_wheel_left = [];
% speed_wheel_left = [];
% power_wheel_right = [];
% speed_wheel_right = [];
    
% %If there is more than one data set for a given test:
% %Find the wheel power at each speed in the range of the min and max speeds
% %Creates sorted array consisting of power values for both drum and wheel
% index = 0;
% for i = floor((speed_Low+0.1)*10):floor((speed_High-0.1)*10)
%     index = index + 1;
%     
%     power_local_left = [];
%     power_local_right = [];
%     speed = i/10;
%     
%     for j=1:2
%         %find closest index for each velocity
%         [M,i_speed_left] = min(abs(U_run_left));
%         [M,i_speed_right] = min(abs(U_run_right));  
%         
%         power_local_left = [power_local_left,P_run_left(i_speed_left)];
%         power_local_right = [power_local_left,P_run_right(i_speed_right)];
%     end
%     
%     power_wheel_left = [power_wheel_left, mean(power_local_left)];
%     speed_wheel_left = [speed_wheel_left, speed];
%     
%     power_wheel_right = [power_wheel_right, mean(power_local_right)];
%     speed_wheel_right = [speed_wheel_right, speed];
% end
end

