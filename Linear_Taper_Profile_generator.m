% ____Taper Profile r(z)____
% The taper profile depends on your neccesities: linear or  exponential
% Taper has different mathematical expressions, so different functions are
% used for each one.
% Function:
% 1. Find an initial taper condition: 
%    e.g. zo for linear taper; Lo for exponential taper
% 2. Generate the z-coord values
% 3. Generate a taper profile r(z) radios as a function of z.
% 4. Solve the integral of (r(z))^2

function [z0, z_values, r_values,integral_values] = Linear_Taper_Profile_generator(r0,rw,Omega_rad)
% Find the Transition region length [mm]
z0 = (r0 - rw) / Omega_rad; 

% Generate the z-coordinate values
z_values = linspace(0, z0, 500);
% Generate the individual r(z) values 
r_profile = @(z, r0, rw, z0) r0 - (r0 - rw) .* (z_values / z0);
% Full r(z) lineal profile calculation
r_values = r_profile(z_values, r0, rw, z0);

% Find the integral in the equation:
% The integral of r(z)^2 for a lineal taper profile is defined as:
% r(z) = A - Bz, where A=r0, B=(r0-rw)/z0 --> change of variable was applied

A = r0;
B = (r0 - rw)/z0;

integral_r_squared = @(z_upper, z_lower) -((A - B * z_upper).^3) / (3 * B) - (-((A - B * z_lower).^3) / (3 * B));
integral_values = integral_r_squared(z0, z_values);

end 