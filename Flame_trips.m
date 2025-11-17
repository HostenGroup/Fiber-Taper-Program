

function [P_turning_points, Flame_speed] = Flame_trips(Fixtures_speed, num_steps, x_total,HeaterLength_mm)
   
    % Pulling velocity (this is equal to twice our initial speed input)
    Pr = Fixtures_speed*2; 
    
    % Pull interval (how much is being pulled per trip)
    Ip = x_total / num_steps; % This is equal to elongation (1)
    
    % Time per trip
    T_trip = Ip / Pr; % Time per trip
    
    % To find velocity per step
    Flame_speed = HeaterLength_mm/T_trip;
    
    % Position of the flame at turning points
    P_turning_points = zeros(num_steps + 1, 1);
    % Starting point (L/2)
    P_turning_points(1) = -HeaterLength_mm(1) / 2; 
    
    for i = 1:num_steps
        % Direction (+, -, +, -, ...)
        direction = (-1)^(i - 1); % Trip 1 is +1, Trip 2 is -1, etc.
                
        % Position: Previos position + (direction * distance)
        P_turning_points(i + 1) = (P_turning_points(i) + direction * HeaterLength_mm(i));
    end
end
