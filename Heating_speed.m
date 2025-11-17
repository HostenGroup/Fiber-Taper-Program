    
function [Flame_speed, P_turning_points] = Heating_speed(Taper, alpha, Fixtures_speed, num_steps,x_total,HeaterLength_mm,FTM_limits)
    if Taper == 1 && alpha == 0  % Exponential
        constant_speed = Fixtures_speed * 15;
        Flame_speed = ones(num_steps, 1) * constant_speed;
        [P_turning_points] = Flame_trips(Fixtures_speed, num_steps, x_total,HeaterLength_mm);

    else 
        [P_turning_points, Flame_speed] = Flame_trips(Fixtures_speed, num_steps, x_total,HeaterLength_mm);
    end

   % Verification
    for i = 1:length(Flame_speed)
        if Flame_speed(i) > FTM_limits.Max_heating_velocity % 200 mm/min experimental limitation from the machine
            error(['This profile cannot be fabricated due to exceeds the maximun heating velocity', ...
                    'Please, reduce either the number of steps or the fixture speed']);
        end
    end
    
end