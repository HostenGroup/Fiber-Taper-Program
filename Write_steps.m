% Steps features:
% Heating Length L[mm], elongation x[mm], radious r[um]

function [T] = Write_steps(num_steps,x_total,x_values,L_values,z_values,r_values,L0,Taper,alpha, Fixtures_speed,FTM_limits)

  % --- Calculation of Heating region, Elongation, Radios/Diameter, Transition region ---

    steps = (1:num_steps)';    % Column vector

    % Elongation here is accumulated
        elongation = (steps / num_steps) * x_total;
    % Without elongation acummulation
        no_accumulated_elongation = [elongation(1); diff(elongation)];


    if Taper == 0
        % Linear Taper
          L_steps_mm = interp1(x_values, L_values, elongation);
    else
        % Exponential or variable taper
          L_steps_mm = L0 + (alpha * elongation);
    end

    % Estimated radio per step
        radious_steps_um = interp1(x_values, r_values, elongation) * 1000;
    % Estimated z-position per step
        z_steps_mm = interp1(x_values, z_values, elongation);

    % Velocity required for the flame to complete each step-trip
        [Flame_speed] = Heating_speed(Taper, alpha, Fixtures_speed, num_steps,x_total,L_steps_mm,FTM_limits);

    % Nozzle size verification
    [L_steps_mm_verf] = Nozzle_limit(L_steps_mm, FTM_limits);

    % --- Final table with input for FTM ---
    Program_Step = steps;
    HeaterLength_mm = round(L_steps_mm_verf, 2);
    %TaperLength_acummulated_mm = round(elongation, 2);
    TaperLength_no_acummulated_mm = round(no_accumulated_elongation,2);
    ApproxFormedRadius_um = round(radious_steps_um, 2);
    Estimated_z_mm = round(z_steps_mm,2);
    Flame_speed = round(Flame_speed,2);

    T = table(Program_Step, HeaterLength_mm, TaperLength_no_acummulated_mm, ApproxFormedRadius_um*2, Estimated_z_mm, Flame_speed);
    T.Properties.VariableNames = {'Step', 'HeaterLength_mm', 'TaperLength_no_acummulated_mm','Estimated_Diameter_um','Estimated_z_mm','Flame_speed'};

end 
