function [L_values, L0] = Heater_length_equation_solver(z_values,integral_values,rw,r_values,lw_mm)
    % Ref: Birks and Li, "The Shape of Fiber Tapers", Eq. (26)
    % L(z0) = ((rw^2)/(r(z)^2))*lw_mm + (2 / (r(z)^2))*integral(z-z0) (r(z)^2)dz

    L_values = zeros(size(z_values));
    for i = 1:length(integral_values)
        L_values(i) = ((rw^2) / (r_values(i)^2)) * lw_mm + (2 / (r_values(i)^2)) * integral_values(i);
    end

    % L(z=o)=Lo
    L0 = L_values(1);

end