function [TaperParameter] = XML_generator(T, H2_Flow, O2_Flow, Fixtures_speed, output_filename)

  % --- Create XML Structure ---
  TaperParameter = struct(); 

  % These are just references that were in the standars programs from FTM:
  % No are actually needed.
  TaperParameter.xmlns_xsd = "http://www.w3.org/2001/XMLSchema";
  TaperParameter.xmlns_xsi = "http://www.w3.org/2001/XMLSchema-instance";

  % --- Section 1: 'taperType_List'
  TaperParameter.taperType_List.TaperType.waveLengthCount = 4;
  TaperParameter.taperType_List.TaperType.MachineType = "SSC";
  TaperParameter.taperType_List.TaperType.WaveLength1 = 1310;
  TaperParameter.taperType_List.TaperType.WaveLength2 = 1550;
  TaperParameter.taperType_List.TaperType.WaveLength3 = 1590;
  TaperParameter.taperType_List.TaperType.WaveLength4 = 1690;
  TaperParameter.taperType_List.TaperType.PortType = "1x2";

  % --- Section 2: 'taperQuality_List'
  TaperParameter.taperQuality_List.TaperQuality(1).Level = "P";
  TaperParameter.taperQuality_List.TaperQuality(2).Level = "A";
  TaperParameter.taperQuality_List.TaperQuality(3).Level = "C";

  % --- Section 3: Steps 
  % -- Program Template ---
  step_template = struct(...
      'StartCondition', "Last Step End", 'StartAction', "None", ...
      'H2DisCharge', 0, 'O2Discharge', 0, 'HeaterSpeed', 0, 'HeaterLength', 0, ...
      'FixtureLeftSpeed', 0, 'FixtureRightSpeed', 0, 'FixtureLeftAcc', 0, 'FixtureRightAcc', 0, ...
      'StopCondition', "Delay Time Over", 'PreODR', 0, 'DelayTime', 0, 'PreTaperLength', 0, ...
      'HeaterCycle', 0, 'PreCycle', 0, 'PreCycleStartODR', 0, 'PreCycleStopODR', 0, ...
      'StartConditionIndex', 2, 'StartActionIndex', 0, 'StopConditionIndex', 0);

  program_list = [];

  % ----Step 1: Pre-Heating
  % This correspond to the pre-heating needed before tapering starts:
  step_preheat = step_template;
  step_preheat.StartCondition = "Click Pre-Taper Button";
  step_preheat.StartAction = "Heater Move to Taper Pos1";
  step_preheat.H2DisCharge = H2_Flow;
  step_preheat.O2Discharge = O2_Flow;
  step_preheat.DelayTime = 30;
  step_preheat.StartConditionIndex = 0;
  step_preheat.StartActionIndex = 1;
  program_list = [program_list, step_preheat];

  % ----Intermediate Steps: Tapering from the simulation table
  for i = 1:height(T)
      new_step = step_template;
      new_step.H2DisCharge = H2_Flow;
      new_step.O2Discharge = O2_Flow;
      %new_step.HeaterSpeed = Heater_speed;
      new_step.HeaterSpeed = T.Flame_speed(i); 
      new_step.FixtureLeftSpeed = Fixtures_speed;
      new_step.FixtureRightSpeed = Fixtures_speed;
      new_step.StopCondition = "Preset Taper Length Meeted";
      new_step.StopConditionIndex = 1;
      new_step.HeaterLength = T.HeaterLength_mm(i);      
      new_step.PreTaperLength = T.TaperLength_no_acummulated_mm(i);     
      program_list = [program_list, new_step];
  end

  % Once tapering is done, the heater needs to be back to its initial
  % position for later uses

  % ----Final Step: Heater backwards
  step_backwards = step_template;
  step_backwards.H2DisCharge = H2_Flow;
  step_backwards.O2Discharge = O2_Flow;
  step_backwards.HeaterSpeed = 60;
  step_backwards.StartAction = "Heater Move Backward";
  step_backwards.StartActionIndex = 2;
  step_backwards.StartActionIndex = 3;
  step_backwards.DelayTime = 0;
  program_list = [program_list, step_backwards];

  % ----Pre-Final Step: Fixture Home
  step_home = step_template;
  step_home.H2DisCharge = H2_Flow;
  step_home.O2Discharge = O2_Flow;
  step_home.StartCondition = "Click Home Button";
  step_home.StartAction = "Fixture Home";
  step_home.StartConditionIndex = 3;
  step_home.StartActionIndex = 5;
  step_home.DelayTime = 0;
  program_list = [program_list, step_home];


  % --- Section 4: 'machineInfo'
  TaperParameter.machineInfo.FixtureInitSpace = "";
  TaperParameter.machineInfo.TaperLengthName = "Taper Length";
  TaperParameter.machineInfo.TaperLength = "";
  TaperParameter.machineInfo.SkinLengthName = "Fiber Stripping Length";
  TaperParameter.machineInfo.SkinLength = "";
  TaperParameter.machineInfo.FiberNameName = "Fiber Name";
  TaperParameter.machineInfo.FiberName = "";
  TaperParameter.machineInfo.PackageSubstrateSizeName = "Packaged Quartz Substrate Size";
  TaperParameter.machineInfo.PackageSubstrateSize = "";
  TaperParameter.machineInfo.PackageTubeSizeName = "Packaged Quartz Round Tube Size";
  TaperParameter.machineInfo.PackageTubeSize = "";
  TaperParameter.machineInfo.IncomingNoName = "Incoming Materials Batch Number";
  TaperParameter.machineInfo.IncomingNo = "";
  TaperParameter.machineInfo.PackageSizeName = "Package Size";
  TaperParameter.machineInfo.PackageSize = "";


  % --- XML File ---
  TaperParameter.taperProgram_List.TaperProgram = program_list;
  writestruct(TaperParameter, output_filename, "StructNodeName", "TaperParameter", "AttributeSuffix", "_");

  fprintf('XML file generated:%s\n ',output_filename);
  fprintf('Steps: %d.\n', length(program_list));

end 