% This .m contains the main experimental limitation of our Fiber Tapering Machine (FTM)
% This features are essential to establish the real conditions and limits
% to fabricate fibers in our machine

function [FTM_limits] = FTM_features()
    FTM_limits.Nozzle_size = 1.75;             %[mm]
    FTM_limits.Max_heating_velocity = 200;    %[mm/min]
    FTM_limits.Max_heating_length = 200;       %[mm/min]
    FTM_limits.Initial_fixture_distance = 10; %[mm]
    FTM_limits.Max_fixture_distance = 216.5;  %[mm]
    FTM_limits.Available_fixture_distance = FTM_limits.Max_fixture_distance - FTM_limits.Initial_fixture_distance; %[mm]
    FTM_limits.Max_fixture_velocity = 300;    %[mm/min]
    FTM_limits.Delay_time = 1000;             %[s]
    FTM_limits.Taper_Length = 500;            %[mm]
end 

