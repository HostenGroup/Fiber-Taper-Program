% Experimental limitation for the Brush technique: Nozzle size
% If the nozzle size is bigger than the L(i) value, we turn into a
% stationary technique. This may produce the fiber get tapered into
% an undesired shape (e.g. smoother)

function [L_steps_mm_verf] = Nozzle_limit(L_values, FTM_limits)

    % Nozzle limit for the Brush technique
    for j = 1:length(L_values)
        if L_values(j) < FTM_limits.Nozzle_size
           L_values(j) = FTM_limits.Nozzle_size;
        end 
    end
    L_steps_mm_verf = L_values;

       % L_values = max(L_values_raw, FTM_limits.Nozzle_size);

% 
%     % Heating length limit in FTM
%     if L_values(1) <= 30 && L_values(end) < FTM_limits.Max_heating_length
%         if L_values(1)>22 && L_values(1) < 30
%             disp('The current fixture distance has to be increased in the FTM to make this fiber')
%         end
%     else
%         error(['The required Heating Length for this fiber exceeds the fixture limits ', ...
%                'of the machine (first=%.3g, last=%.3g, max=%.3g, initial heating length=22).'], ...
%                L_values(1), L_values(end), FTM_limits.Max_heating_length);
%     end

    
end