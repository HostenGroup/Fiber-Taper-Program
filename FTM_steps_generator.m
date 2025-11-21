%% 
% ----- Fiber Tapering Machine Steps Generator -----
% This script is based on the "Reverse Program" from Ref: Birks and Li, "The Shape of Fiber Tapers".
% The idea is to obtain the Heating Length (L) and elongation (x) for the generation of any desired fiber type.
% The output from this program will be the input in XML format for the FTM
% This is the compact script version ("FTM_steps_generator").
% Its matlab function components can be found here:
% G:\ExperimentalData\FiberPullingLogs\Josu\AdiabaticProgram\Full_Reverse_trial\FTM_step_generator
% Any question? Ask Josu!!! :)

% ----- Program Structure------

% ____Inputs____
% 1.1 The desired fiber features for your fiber.
% 1.2 The needed values for your desired taper profile (omega, alpha)
% 1.3 General conditions for your XML program (e.g. gases flow, speeds, times, etc)
% 1.4 Number of desired steps for your program.

% ___ Calculations ____
% 2. Taper Profile r(z): radius as function of z (linear & exponencial tapers)
% 3. Heating Length L(z) and Lo: Initial H. L.
% 4. Elongation x(z) and xo: total elongation

% ___ Steps Generation & XML extraction for FTM ____ 
% ___ Printing & Plotting Results ___




clc; 
clear;
close all;
close hidden;

%% --- Inputs ---

% --- What tater profile do you want to do?? ---
% Linear = 0, Exponencial and variable = 1
Taper = 0;

% --- Initial conditions for simulation ---

d0_um = 125;         % initial diameter of the fiber [um]
r0_um = d0_um/2;     % initial radius of the fiber [um]
% Desirable fiber conditions:
dw_um = 1;         % Desired waist diameter of the fiber [um]
rw_um = dw_um/2;     % Desired waist radio of the fiber [um]
desired_lw_mm = 80;         % Desired tapered length at waist [mm]

% Conditions for taper profiles:
% Linear Profile
Omega_mrad = 4 ; % 2 mrad 
% Exponential Profile
alpha = 6;       % Alpha should be less than 1

% --- Units conversion ---
r0 = r0_um / 1000.0;
rw = rw_um / 1000.0;
Omega_rad = Omega_mrad/ 1000.0;


% --- Initial conditions for FTM ---
output_filename = 'T3_exponencial_Profile_alpha0.xml'; % Write the name for your output file
num_steps = 25; % Desired number of steps for the program

H2_Flow = 80;            % Hydrogen flow [sccm]
O2_Flow = 40;             % Oxygen flow [sccm]
Heater_speed = 75;        % Heater velocity [mm/min]
Fixtures_speed = 5;     % Fixture velocity (per side) [mm/min]

%% --- Verification of Taper feasibility ---
% --- Experimental Limitations
     FTM_limits = FTM_features();
     [lw_mm] = lw_verification(desired_lw_mm, FTM_limits);

%% --- Calculations & Steps Generation ---

        if Taper == 0
            % ____ Linear Taper Profile r(z)____
            [z0,z_values,r_values,integral_values] = Linear_Taper_Profile_generator(r0,rw,Omega_rad);
        
            % ____ Heating Length L(z)____
            [L_values,L0] = Heater_length_equation_solver(z_values,integral_values,rw,r_values,lw_mm);
        
            % ____ Elongation x(z)____ 
            [x_values,x_total] = Elongation_length_solver(z_values,L_values,L0,FTM_limits);
                
        elseif Taper == 1
            % ____ Exponential/Variable Taper profile with constant/variable L____
            [z0,x_total,L0,z_values,r_values,x_values,L_values] = Exponential_Lalpha_Taper_Profile_generator(r0,rw,alpha,lw_mm,FTM_limits);        
        else 
            disp('The introduced Taper profile is not valid')
        end


        % ___Write Steps___
        [T] = Write_steps(num_steps,x_total,x_values,L_values,z_values,r_values,L0,Taper,alpha,Fixtures_speed,FTM_limits);


%% --- Extract Fiber inputs ---
        % XML Format
        % Verify the values for gasses flow, heater and fixtures speeds, and delay time 
        [TaperParameter] = XML_generator(T, H2_Flow, O2_Flow, Heater_speed, Fixtures_speed, output_filename);

        % Excel Format
        writetable(T, output_filename+".xlsx", 'Sheet', 1, 'Range', 'A1');


%% --- Printing & Plotting ---

fprintf('Key parameters in the model:\n');
fprintf(' - Transition Length (z₀): %.2f mm\n', z0);
fprintf(' - Initial Heating Length (L₀): %.2f mm\n', L0);
fprintf(' - Total taper elongation (x₀): %.2f mm\n\n', x_total);
fprintf('Adiabatic Program (25 Steps):\n');
disp(T);


% ---- Hot zone vs Elongation ----
f1 = figure(1); hold on
plot(T.TaperLength_acummulated_mm, T.HeaterLength_mm, 'o-', 'LineWidth', 1.8);
xlabel('x: Elongation (mm)','FontWeight','bold', 'FontSize',20);
ylabel('Hot-zone size (mm)','FontWeight','bold', 'FontSize',20);
title('Hot zone vs Elongation','FontWeight','bold', 'FontSize',20);
%legend('Location','best');
ax = gca; 
ax.FontSize = 14; 
% lgd = legend; 
% lgd.FontSize = 12; 

% ---- Elongation vs Fiber Diameter ----
f2 = figure(2);
plot(T.TaperLength_acummulated_mm, T.Estimated_Diameter_um, 'o-', 'LineWidth', 1.8);
xlabel('x: Elongation (mm)','FontWeight','bold', 'FontSize',20);
ylabel('Fiber diameter (um)','FontWeight','bold', 'FontSize',20);
title('Elongation vs Fiber Diameter','FontWeight','bold', 'FontSize',20);
%legend('Location','best');
ax = gca; 
ax.FontSize = 14; 
% lgd = legend; 
% lgd.FontSize = 12;  


% ---- Geometric Profile ----
% Full taper with raw values 
f3 = figure(3); hold on;
plot(z_values, r_values*2000, '-', 'LineWidth', 1.8, 'Color','r'); % 1. First half
plot([z0, z0 + lw_mm], [rw_um*2, rw_um*2], '-', 'LineWidth', 1.8,'Color','r'); % 2. Waist
plot((z0 + lw_mm)+z_values, fliplr(r_values*2000), '-', 'LineWidth', 1.8,'Color','r'); % 3. Second half
% Mirror
% plot(z_values, -r_values*2000, '-', 'LineWidth', 1.8, 'Color','r'); % 1. First half
% plot([z0, z0 + lw_mm], -[rw_um*2, rw_um*2], '-', 'LineWidth', 1.8,'Color','r'); % 2. Waist
% plot((z0 + lw_mm)+z_values, -fliplr(r_values*2000), '-', 'LineWidth', 1.8,'Color','r'); % 3. Second half
% k=(z0 + lw_mm)+z_values;
% xlim([-0.1, max(k)*1.1]);
% max_diam = max(r_values*2000); 
% ylim([-max_diam*1.1, max_diam*1.1]);
grid off;
title('Geometric Taper Profile','FontWeight','bold', 'FontSize',20);
xlabel('Position along z (mm)','FontWeight','bold', 'FontSize',20);
ylabel('Diameter (um)','FontWeight','bold', 'FontSize',20);
%legend('Location','best');
ax = gca; 
ax.FontSize = 14; 
% lgd = legend; 
% lgd.FontSize = 12; 
%hold off;



% Flame features
[Flame_speed, P_turning_points] = Heating_speed(Taper, alpha, Fixtures_speed, num_steps,x_total,T.HeaterLength_mm,FTM_limits);   
trip_number = (1:num_steps);
P_axis = (0:num_steps);

f4 = figure(4);
% Left plane: Position
yyaxis left; 
plot(P_axis,P_turning_points, '-', 'LineWidth', 1.8, 'Color','b');
ylabel('Flame Position (mm)','FontWeight','bold', 'FontSize',20);
title('Flame features','FontWeight','bold', 'FontSize',20);
% Right plane: Velocity
yyaxis right; 
% in mm/minutes (as in the FTM)
plot(trip_number, Flame_speed, 'ko', 'MarkerFaceColor', 'k'); hold on;
% in mm/seconds
%plot(trip_number, Flame_speed/(60), 'ko', 'MarkerFaceColor', 'k'); hold on;
plot(0, 0, 'ko', 'MarkerFaceColor', 'k');
ylabel('Flame Velocity (mm/min)','FontWeight','bold', 'FontSize',20);
ax = gca; 
ax.FontSize = 14; 
% Trip number / steps
xlabel('Flame trip number (i)');
legend('Turning Points', 'Flame velocity');
grid on;

    


% Uploading trial from Matlab to Github 