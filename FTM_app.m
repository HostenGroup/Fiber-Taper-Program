
% % 1. create a buttom for the fixture distance input.
% 
% % 2. Create a message for displaying the necesity of verifying the fixture
% % distance to check the available space for elongation
% 
% % 3. Delete de input of the velocity of the heating length
% 
% % 4. Include the Manual section in a second tab
% 
% % 5. Include the Q&A section in a third tab
% 
% % Check the callback function/buttom to avoid the interface freezing after
% % an error message appears
% 
% % Try the programs with no pre-heating, with new velocity change for
% % alpha=variable, and normal minimal nozzle size (analize that or how to
% % check it)?
% 


function FTM_app()
% =========================================================================
% User Interface 
% =========================================================================

% --- Creates the Main UI Figure ---
    fig = uifigure('Name', 'FTM Step Generator', 'Position', [0 0 1200 760]);
    % position [Left, Bottom, Width, Height]

    % --- Center the screen ---
    movegui(fig, 'center');

    % Tabs
        tabGroup = uitabgroup(fig, 'Position', [0 0 1200 760]);

        % 1. Main Tab (Input/output)
            mainTab = uitab(tabGroup, 'Title', 'Steps Generator');
    
        % 2. Manual Tab
            manualTab = uitab(tabGroup, 'Title', 'Manual');
            uilabel(manualTab, 'Text', 'Manual will be here', 'Position', [500 375 200 20]);
        
        % 3. Q&A tab
            faTab = uitab(tabGroup, 'Title', 'Q&A');
            uilabel(faTab, 'Text', 'Q&A will be here', 'Position', [500 375 200 20]);

    % =========================================================================
    % Tab 1 Interface: Step Generator ('mainTab')
    % =========================================================================

    % --- Control Panel (Left) ---
        controlPanel = uipanel(mainTab, 'Title', 'Simulation & FTM Parameters', ...
                           'Position', [20 20 300 710], 'FontSize', 14); 
    %% --- Environemnt --- 

    % --- 1. Simulation Setup: Ask for inputs ---
            uilabel(controlPanel, 'Text', 'Fiber features', ...
                    'Position', [15 665 270 14], 'FontSize', 13, 'FontWeight', 'bold');
            
            % Choose the desired profile
            uilabel(controlPanel, 'Text', 'Taper Profile:', 'Position', [15 636 140 18]); 
            FTM_app.TaperType = uidropdown(controlPanel, 'Items', {'Exponential (alpha)', 'Linear (Omega)'}, ...
                                           'Value', 'Exponential (alpha)', ...
                                           'Position', [160 636 120 18], ... 
                                           'ValueChangedFcn', @(src, event) parametersChanged(src, event, @toggleParams)); 
           
            % Input the Untapered Fiber diameter (Initial Taper)                           
            uilabel(controlPanel, 'Text', 'Initial Diameter (d₀) [μm]:', 'Position', [15 606 140 18]); % Width 140
            FTM_app.d0_um = uieditfield(controlPanel, 'numeric', 'Value', 125, 'Position', [160 606 120 18], ... % Left 160, Width 120
                                    'ValueChangedFcn', @parametersChanged);
            
            % Input the desired waist diameter    
            uilabel(controlPanel, 'Text', 'Waist Diameter (dᵥ) [μm]:', 'Position', [15 576 140 18]); % Width 140
            FTM_app.dw_um = uieditfield(controlPanel, 'numeric', 'Value', 1, 'Position', [160 576 120 18], ... % Left 160, Width 120
                                    'ValueChangedFcn', @parametersChanged);
            
           % Input the desired waist length    
            uilabel(controlPanel, 'Text', 'Waist Length (lᵥ) [mm]:', 'Position', [15 546 140 18]); % Width 140
            FTM_app.desired_lw_mm = uieditfield(controlPanel, 'numeric', 'Value', 5, 'Position', [160 546 120 18], ... % Left 160, Width 120
                                                'ValueChangedFcn', @parametersChanged);
            
            % Input the desired Taper Angle Omega
            FTM_app.LinearLabel = uilabel(controlPanel, 'Text', 'Taper Angle (Ω) [mrad]:', 'Position', [15 514 140 18], 'Visible', 'off'); % Width 140
            FTM_app.Omega_mrad = uieditfield(controlPanel, 'numeric', 'Value', 5, 'Position', [160 514 120 18], 'Visible', 'off', ... % Left 160, Width 120
                                                'ValueChangedFcn', @parametersChanged);
            
            % Input the alha parameter
            FTM_app.ExpLabel = uilabel(controlPanel, 'Text', 'Alpha Parameter (α):', 'Position', [15 514 140 18], 'Visible', 'on'); % Width 140
            FTM_app.alpha = uieditfield(controlPanel, 'numeric', 'Value', 0, 'Position', [160 514 120 18], 'Visible', 'on', ... % Left 160, Width 120
                                    'ValueChangedFcn', @parametersChanged);
            
    % --- 2. FTM Parameters ---
            % FTM 
            uilabel(controlPanel, 'Text', 'FTM Parameters', ...
                    'Position', [15 480 270 18], 'FontSize', 13, 'FontWeight', 'bold');
            
            % Input the desired number of steps
            uilabel(controlPanel, 'Text', 'Number of Steps:', 'Position', [15 450 140 18]); % Ancho 140
            FTM_app.num_steps = uieditfield(controlPanel, 'numeric', 'Value', 25, 'Position', [160 450 120 18], ... % Left 160, Width 120
                                            'ValueChangedFcn', @parametersChanged);
            
            % Input the Heater Speed (I may be able to change it at some point for a more general way
            uilabel(controlPanel, 'Text', 'Heater Speed [mm/min]:', 'Position', [15 420 140 18]); % Width 140
            FTM_app.Heater_speed = uieditfield(controlPanel, 'numeric', 'Value', 75, 'Position', [160 420 120 18], ... % Left 160, Width 120
                                                 'ValueChangedFcn', @parametersChanged);
           
            % Input a desired Fixture Speed
            uilabel(controlPanel, 'Text', 'Fixtures Speed [mm/min]:', 'Position', [15 390 140 18]); % Ancho 140
            FTM_app.Fixtures_speed = uieditfield(controlPanel, 'numeric', 'Value', 5, 'Position', [160 390 120 18], ... % Left 160, Width 120
                                                     'ValueChangedFcn', @parametersChanged);
            
            % Input the H2 Flow
            uilabel(controlPanel, 'Text', 'H₂ Flow [sccm]:', 'Position', [15 360 140 18]); % Ancho 140
            FTM_app.H2_Flow = uieditfield(controlPanel, 'numeric', 'Value', 80, 'Position', [160 360 120 18], ... % Left 160, Width 120
                                      'ValueChangedFcn', @parametersChanged);
            
            % Input the O2 flow 
            uilabel(controlPanel, 'Text', 'O₂ Flow [sccm]:', 'Position', [15 330 140 18]); % Ancho 140
            FTM_app.O2_Flow = uieditfield(controlPanel, 'numeric', 'Value', 40, 'Position', [160 330 120 18], ... % Left 160, Width 120
                                      'ValueChangedFcn', @parametersChanged);

    % --- Button for 'Steps Generation' ---
    FTM_app.runButton = uibutton(controlPanel, 'Text', 'Generate Steps', ...
                             'Position', [15 290 270 30], 'FontSize', 14, 'FontWeight', 'bold', ...
                             'ButtonPushedFcn', @generateButtonPushed);
                             
    %% --- Results & Comments section ---
        uilabel(controlPanel, 'Text', 'Key Results & Comments', ...
                'Position', [15 258 270 22], 'FontSize', 13, 'FontWeight', 'bold');
        FTM_app.resultsArea = uitextarea(controlPanel, 'Value', {'Press "Generate Steps" to see the results.'}, ...
                                     'Position', [15 170 270 80], 'Editable', 'off', 'FontSize', 12);

        % --- Export Panel ---
        % The idea is to export the program in 2 formats XML and Excel to
        % make it available for he program and for the user observation/comments section
    
        exportPanel = uipanel(controlPanel, 'Title', '4. Export Data', ...
                              'Position', [15 10 270 150], 'FontSize', 13, 'FontWeight', 'bold'); 
        
        uilabel(exportPanel, 'Text', 'Path:', 'Position', [5 95 40 22]);
        FTM_app.outputPath = uieditfield(exportPanel, 'text', 'Value', pwd, ... 
                                     'Position', [50 95 160 22], 'Editable', 'off'); 
        FTM_app.browseButton = uibutton(exportPanel, 'Text', 'Browse...', ...
                                    'Position', [215 95 50 22], ... 
                                    'ButtonPushedFcn', @browseButtonPushed);
        
        % Input for the desired name for the file
        uilabel(exportPanel, 'Text', 'Filename:', 'Position', [5 60 60 22]); 
        FTM_app.output_filename = uieditfield(exportPanel, 'text', ...
                                              'Value', 'T3_profile', ...
                                              'Position', [70 60 195 22]); 
    
        % XML Export buttom
        FTM_app.exportXMLButton = uibutton(exportPanel, 'Text', 'XML', ...
                                     'Position', [10 15 120 25], 'Enable', 'off', ... 
                                     'ButtonPushedFcn', @exportXMLButtonPushed);
        % Excel Export buttom
        FTM_app.exportExcelButton = uibutton(exportPanel, 'Text', 'Excel', ...
                                         'Position', [140 15 120 25], 'Enable', 'off', ... 
                                         'ButtonPushedFcn', @exportExcelButtonPushed);
                                         
        FTM_app.exportStatus = uilabel(exportPanel, 'Text', '', ... % Hidden
                                   'Position', [10 -10 1 1], 'Visible', 'off');

    %%  --- Results section ---
                
        plotPanel = uipanel(mainTab, 'Title', 'Result Plots', ...
                            'Position', [340 280 840 450], 'FontSize', 14); 
        
        %% We can erase this panel
        % Figure 1: 'Hot zone vs. Elongation'
        FTM_app.ax1 = uiaxes(plotPanel, 'Position', [30 232 380 190]); 
        title(FTM_app.ax1, 'Hot zone vs. Elongation');
        xlabel(FTM_app.ax1, 'x: Elongation (mm)');
        ylabel(FTM_app.ax1, 'Hot-zone size (mm)');
        %%

        % Figure 2: 'Elongation vs. Diameter'       
        FTM_app.ax2 = uiaxes(plotPanel, 'Position', [430 232 380 190]); 
        title(FTM_app.ax2, 'Elongation vs. Diameter');
        xlabel(FTM_app.ax2, 'x: Elongation (mm)');
        ylabel(FTM_app.ax2, 'Diameter (μm)');
        
        % Figure 3: 'Geometric Profile'
        FTM_app.ax3 = uiaxes(plotPanel, 'Position', [30 20 380 190]); 
        title(FTM_app.ax3, 'Geometric Profile');
        xlabel(FTM_app.ax3, 'Position z (mm)');
        ylabel(FTM_app.ax3, 'Diameter (μm)');

        % Figure 4: 'Flame Features'
        FTM_app.ax4 = uiaxes(plotPanel, 'Position', [430 20 380 190]); 
        title(FTM_app.ax4, 'Flame Features');
        xlabel(FTM_app.ax4, 'Flame trip number (i)');
        yyaxis(FTM_app.ax4, 'left');
        ylabel(FTM_app.ax4, 'Flame Position (mm)');
        FTM_app.ax4.YColor = 'b';
        yyaxis(FTM_app.ax4, 'right');
        ylabel(FTM_app.ax4, 'Flame Velocity (mm/min)');
        FTM_app.ax4.YColor = 'k';
    
    % --- Table Panel ---
        tablePanel = uipanel(mainTab, 'Title', 'Input for FTM', ...
                             'Position', [340 20 840 250], 'FontSize', 14); 
                             
        FTM_app.stepsTable = uitable(tablePanel, 'Position', [10 01 820 220]); 
                             
    % --- Store app structure and initial export path ---
        FTM_app.exportParams.Path = pwd; % Store initial path
        fig.UserData = FTM_app;
        
    % Initial call to set visibility
        toggleParams(FTM_app.TaperType, []);

   
end
%% --- Callback functions ---

% --- Disable export buttons if parameters change ---
      
        function parametersChanged(src, event, optionalCallback)
            fig = getFigHandle(src);
            if isempty(fig), return; end 
            app = fig.UserData;
            
            if isfield(app, 'exportXMLButton') && isvalid(app.exportXMLButton)
                app.exportXMLButton.Enable = 'off';
                app.exportExcelButton.Enable = 'off';
                % app.exportStatus.Text = 'Params changed. Re-generate steps.';
            end
            
            if nargin > 2 && ~isempty(optionalCallback)
                optionalCallback(src, event);
            end
        end

        % Que hace esto?
        % --- Callback Function for Dropdown ---
        function toggleParams(src, ~)
            fig = getFigHandle(src);
            if isempty(fig), return; end
            app = fig.UserData;
            if strcmp(app.TaperType.Value, 'Linear (Omega)')
                app.LinearLabel.Visible = 'on';
                app.Omega_mrad.Visible = 'on';
                app.ExpLabel.Visible = 'off';
                app.alpha.Visible = 'off';
            else % Exponential
                app.LinearLabel.Visible = 'off';
                app.Omega_mrad.Visible = 'off';
                app.ExpLabel.Visible = 'on';
                app.alpha.Visible = 'on';
            end
        end


% --- Callback Function for "Generate Steps" Button ---
function generateButtonPushed(src, ~)
    fig = getFigHandle(src);
    app = fig.UserData;
    
    app.runButton.Text = 'Generating...';
    app.runButton.Enable = 'off';
    drawnow;
% =========================================================================
% Calculations
% =========================================================================
    try
        % --- 1. Collect Inputs from UI ---
        if strcmp(app.TaperType.Value, 'Exponential (alpha)')
            Taper = 1;
        else
            Taper = 0;
        end
        
        d0_um = app.d0_um.Value; 
        dw_um = app.dw_um.Value; 
        r0 = d0_um / 2000.0; 
        rw = dw_um / 2000.0; 
        lw_mm = app.desired_lw_mm.Value;
        Omega_rad = app.Omega_mrad.Value / 1000.0;
        alpha = app.alpha.Value;
        num_steps = app.num_steps.Value;
        Fixtures_speed = app.Fixtures_speed.Value;
        H2_Flow = app.H2_Flow.Value; 
        O2_Flow = app.O2_Flow.Value; 
        Heater_speed = app.Heater_speed.Value;
        
        % --- 2. Run Calculations ---
        FTM_limits = FTM_features(); 
        lw_mm = lw_verification(lw_mm, FTM_limits); 

        if Taper == 0
            [z0, z_values, r_values, integral_values] = Linear_Taper_Profile_generator(r0, rw, Omega_rad);
            [L_values, L0] = Heater_length_equation_solver(z_values, integral_values, rw, r_values, lw_mm);
            [x_values, x_total] = Elongation_length_solver(z_values, L_values, L0, FTM_limits);
            
                
        elseif Taper == 1
            [z0, x_total, L0, z_values, r_values, x_values, L_values] = Exponential_Lalpha_Taper_Profile_generator(r0, rw, alpha, lw_mm, FTM_limits);        
        end
        
        [T] = Write_steps(num_steps, x_total, x_values, L_values, z_values, r_values, L0, Taper, alpha, Fixtures_speed, FTM_limits);
        
        [Flame_speed, P_turning_points] = Heating_speed(Taper, alpha, Fixtures_speed, num_steps, x_total, T.HeaterLength_mm, FTM_limits);   
        trip_number = (1:num_steps);
        P_axis = (0:num_steps);
        
        
        % --- 3. Store results in 'app' for export ---
        app.T = T;
        app.exportParams.H2_Flow = H2_Flow;
        app.exportParams.O2_Flow = O2_Flow;
        app.exportParams.Heater_speed = Heater_speed;
        app.exportParams.Fixtures_speed = Fixtures_speed;
        fig.UserData = app; 
        
        % --- 4. Display Results ---
        
        % --- Key Results Text ---
        resultsText = {
            'Results & Comments:';
            sprintf(' - Transition (z₀): %.2f mm', z0);
            sprintf(' - Initial Heating Length (L₀): %.2f mm', L0);
            sprintf(' - Total Elongation (x₀): %.2f mm', x_total)
        };
        app.resultsArea.Value = resultsText;
        
        % --- Steps Table ---
        app.stepsTable.Data = T;
        app.stepsTable.ColumnName = T.Properties.VariableNames;
%         % Format for decimals (still figure it out)
%         num_columns = width(T);
%         col_formats = repmat({'bank'}, 1, num_columns); % Pone todo en 2 decimales
%         col_formats{1} = 'numeric'; % Mantiene la columna 'Step' como entero
%         app.stepsTable.ColumnFormat = col_formats;
%         app.stepsTable.Data = table2cell(T);
        
        % --- Plot 1: Hot zone vs Elongation ---
        plot(app.ax1, cumsum(T.TaperLength_no_acummulated_mm), T.HeaterLength_mm, 'o-');
        title(app.ax1, 'Hot zone vs. Elongation');
        xlabel(app.ax1, 'x: Elongation (mm)');
        ylabel(app.ax1, 'Hot-zone size (mm)');
        grid(app.ax1, 'on');

        % --- Plot 2: Elongation vs Fiber Diameter ---
        plot(app.ax2, cumsum(T.TaperLength_no_acummulated_mm), T.Estimated_Diameter_um, 'o-');
        title(app.ax2, 'Diameter Profile');
        xlabel(app.ax2, 'x: Elongation (mm)');
        ylabel(app.ax2, 'Diameter (μm)');
        grid(app.ax2, 'on');
        
        % --- Plot 3: Geometric Profile ---
        cla(app.ax3); 
        hold(app.ax3, 'on');
        plot(app.ax3, z_values, r_values * 2000, 'r-', 'LineWidth', 1.8); 
        %plot(app.ax3, z_values, -r_values * 2000, 'r-', 'LineWidth', 1.8);
        plot(app.ax3, [z0, z0 + lw_mm], [dw_um, dw_um], 'r-', 'LineWidth', 1.8); 
        %plot(app.ax3, [z0, z0 + lw_mm], [-dw_um, -dw_um], 'r-', 'LineWidth', 1.8);
        plot(app.ax3, (z0 + lw_mm) + z_values, fliplr(r_values * 2000), 'r-', 'LineWidth', 1.8);
        %plot(app.ax3, (z0 + lw_mm) + z_values, -fliplr(r_values * 2000), 'r-', 'LineWidth', 1.8);
        hold(app.ax3, 'off');
        title(app.ax3, 'Geometric Profile');
        xlabel(app.ax3, 'Position z (mm)');
        ylabel(app.ax3, 'Diameter (μm)');
        axis(app.ax3, 'tight');
        
        
        % --- Plot 4: Flame Features ---
        cla(app.ax4);
        yyaxis(app.ax4, 'left');
        plot(app.ax4, P_axis, P_turning_points, 'b-', 'LineWidth', 1.8);
        ylabel(app.ax4, 'Flame Position (mm)');
        app.ax4.YColor = 'b';
        
        yyaxis(app.ax4, 'right');
        plot(app.ax4, trip_number, Flame_speed, 'ko', 'MarkerFaceColor', 'k'); hold(app.ax4, 'on');
        plot(app.ax4, 0, 0, 'ko', 'MarkerFaceColor', 'k'); hold(app.ax4, 'off');
        ylabel(app.ax4, 'Flame Velocity (mm/min)');
        app.ax4.YColor = 'k';
        
        title(app.ax4, 'Flame Features');
        xlabel(app.ax4, 'Flame trip number (i)');
        legend(app.ax4, 'Turning Points', 'Flame velocity', 'Location', 'best');
        grid(app.ax4, 'on');
        
        
        % --- 5. Enable export buttons ---
        app.exportXMLButton.Enable = 'on';
        app.exportExcelButton.Enable = 'on';
        % app.exportStatus.Text = 'Ready to export.';
        
    catch ME
               
        % Mostramos el error en la interfaz
        app.resultsArea.Value = {'ERROR!', ME.message};
        
        % Opcional: Mostrar una alerta visual (pop-up)
        %uialert(fig, ME.message, 'Execution Error');
        
        app.runButton.Text = 'Generate Steps';
        app.runButton.Enable = 'on';
        
        % disp(getReport(ME)); 
    end
    
    % Restore button (for success case)
    if strcmp(app.runButton.Enable, 'off')
        app.runButton.Text = 'Generate Steps';
        app.runButton.Enable = 'on';
    end
end

% --- Callback Function: Browse for Path ---
function browseButtonPushed(src, ~)
    fig = getFigHandle(src);
    app = fig.UserData;
    
    start_path = app.exportParams.Path;
    selected_path = uigetdir(start_path, 'Select Output Directory');
    
    if selected_path ~= 0
        app.outputPath.Value = selected_path;
        app.exportParams.Path = selected_path;
        fig.UserData = app; 
    end
end

% --- Callback Function: Export to XML ---
function exportXMLButtonPushed(src, ~)
    fig = getFigHandle(src);
    app = fig.UserData;
    
    try
        % app.exportStatus.Text = 'Exporting XML...';
        drawnow;
        
        T = app.T;
        params = app.exportParams;
        path = app.exportParams.Path;
        filename_no_ext = app.output_filename.Value;
        xml_filename = [filename_no_ext, '.xml'];
        full_path_xml = fullfile(path, xml_filename);
        
        [TaperParameter] = XML_generator(T, params.H2_Flow, params.O2_Flow, params.Fixtures_speed, full_path_xml);
        
        % app.exportStatus.Text = ['XML saved to: ', full_path_xml];
        uialert(fig, ['XML saved to: ' full_path_xml], 'Export Successful');
        
    catch ME
        % app.exportStatus.Text = 'Error exporting XML!';
        uialert(fig, ME.message, 'XML Export Error');
    end
end

% --- Callback Function: Export to Excel ---
function exportExcelButtonPushed(src, ~)
    fig = getFigHandle(src);
    app = fig.UserData;
    
    try
        % app.exportStatus.Text = 'Exporting Excel...';
        drawnow;
        
        T = app.T;
        params = app.exportParams;
        path = app.exportParams.Path;
        filename_no_ext = app.output_filename.Value;
        excel_filename = [filename_no_ext, '.xlsx'];
        full_path_excel = fullfile(path, excel_filename);
        
        writetable(T, full_path_excel, 'Sheet', 1, 'Range', 'A1');
        
        % app.exportStatus.Text = ['Excel saved to: ', full_path_excel];
        uialert(fig, ['Excel saved to: ' full_path_excel], 'Export Successful');
        
    catch ME
        % app.exportStatus.Text = 'Error exporting Excel!';
        uialert(fig, ME.message, 'Excel Export Error');
    end
end

% --- Helper Function to get main figure handle ---
function fig = getFigHandle(src)
    % Climbs up the UI tree to find the main figure
    parent = src.Parent;
    while ~isempty(parent) && ~isa(parent, 'matlab.ui.Figure')
        parent = parent.Parent;
    end
    fig = parent;
end


