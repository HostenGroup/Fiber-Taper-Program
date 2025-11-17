function [lw_mm] = lw_verification(desired_lw_mm, FTM_limits)
    if desired_lw_mm < FTM_limits.Nozzle_size
        %disp('')
        error('The desired fiber profile requires that the Heating length size at waist should be lower than the allowed nozzle size')
        % agregar condicion de que si queremos podemos calcular para lw=nozzle size
    else
        lw_mm = desired_lw_mm;
    end
end 