% ____Taper Profile r(z)____
% The taper profile depends on your neccesities: exponential or variable
% Taper has different mathematical expressions
% Function:
% 1. Find an initial taper condition: zo
% 2. Evaluate z=z0, x(z0) and L(z0) to find the total elongation and intial heating length
% 3. Generate the z-coord values
% 4. Generate a taper profile r(z) radios as a function of z.

function [z0, x_total, L0, z_values, r_values, x_values, L_values] = Exponential_Lalpha_Taper_Profile_generator(r0,rw,alpha,lw_mm, FTM_limits)

    % ---Define the Transition region length zo [mm] ---
        if alpha == 0
            % Exponential Taper Profile
            r_type = 'Exponential';
            z0 = lw_mm*log(r0/rw);
        elseif alpha < 1 && alpha ~= 0 
            % Variable Taper Profile
            r_type = 'Variable';
            z0 = ((1-(rw/r0)^(2*alpha))*(lw_mm-(lw_mm*alpha)))/(2*alpha);
        else 
            error('Alpha value must be less than 1')
        end


     % ---Find initial conditions for xo and Lo:---
       % Total elongation xo:
        x_total = (2*z0)/(1-alpha);
        % Verification
        if x_total>FTM_limits.Available_fixture_distance
        error('The total elongation required for this fiber exceeds the fixture limits of the machine')
        end

       % Initial heating Length Lo (must be positive)
        L0 = lw_mm - (alpha*x_total);
        %if alpha < 0 && x_total > -L0/alpha
        if L0 <= 0 || ~isreal(L0) % && L0 < abs(alpha)*x_total
        error('No possible to fabricate this fiber, check your inputs features (e.g. alpha)');
        end

       % Generate the z-coordinate values for a variable profile
        z_values = linspace(0, z0, 500);
        x_values = (2 * z_values) / (1 - alpha);
        L_values = L0 + (alpha*x_values);

     % --- Radius as function of z-coordinate:---

        if r_type == "Exponential"
            r_values = r0 .* exp(-z_values./ L0);
        elseif r_type == "Variable"
            base = 1 + (2*alpha.*z_values) / ((1-alpha)*L0);
            r_values = r0 .*  base.^ (-1/(2*alpha));
        else
            disp('Error')
        end
end 




    % Find the integral of r(z)^2:
    % Solved defined integral = ((r0)^2)*((-L0/2)+((alpha*z)/(alpha-1))*(1+((2*alpha*z)/(L0-(L0*alpha))))^(-1/alpha))
    %integral_r_squared = @(z_upper, z_lower)...
    %  ((r0)^2).*((-L0/2)+((alpha.*z_upper)/(alpha-1)).*(1+((2*alpha.*z_upper)/(L0-(L0*alpha)))).^(-1/alpha)) - ...
    %((r0)^2).*((-L0/2)+((alpha.*z_lower)/(alpha-1)).*(1+((2*alpha.*z_lower)/(L0-(L0*alpha)))).^(-1/alpha))
    %integral_values = integral_r_squared(z0, z_values);