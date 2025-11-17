%% --- Find x(z): Total elongation as a function of taper profile z
% Ref: Birks and Li, "The Shape of Fiber Tapers", Eq. (27)
% Distance law: x(z) = 2z + L(z) - Lo


function [x_values, x_total] = Elongation_length_solver(z_values,L_values,L0,FTM_limits)

    x_values = 2 * z_values + L_values - L0;
    % Total elongation (xo)
    x_total = x_values(end);

    if x_total>FTM_limits.Available_fixture_distance
        error('The total elongation required for this fiber exceeds the fixture limits of the machine')
    end

end