function [] = motor_mover(id, final_pos)

%global ERRBIT_VOLTAGE
%ERRBIT_VOLTAGE     = 1;
%global ERRBIT_ANGLE 
%ERRBIT_ANGLE       = 2;
%global ERRBIT_OVERHEAT
%ERRBIT_OVERHEAT    = 4;
%global ERRBIT_RANGE
%ERRBIT_RANGE       = 8;
%global ERRBIT_CHECKSUM
%ERRBIT_CHECKSUM    = 16;
%global ERRBIT_OVERLOAD
%ERRBIT_OVERLOAD    = 32;
%global ERRBIT_INSTRUCTION
%ERRBIT_INSTRUCTION = 64;

%global COMM_TXSUCCESS
%COMM_TXSUCCESS     = 0;
%global COMM_RXSUCCESS
%COMM_RXSUCCESS     = 1;
%global COMM_TXFAIL
%COMM_TXFAIL        = 2;
%global COMM_RXFAIL
%COMM_RXFAIL        = 3;
%global COMM_TXERROR
%COMM_TXERROR       = 4;
%global COMM_RXWAITING
%COMM_RXWAITING     = 5;
%global COMM_RXTIMEOUT
%COMM_RXTIMEOUT     = 6;
%global COMM_RXCORRUPT
%COMM_RXCORRUPT     = 7;

%loadlibrary('dynamixel','dynamixel.h');
%libfunctions('dynamixel');

%Default Setting
P_GOAL_POSITION = 30;
%P_PRESENT_POSITION = 150;
DEFAULT_PORTNUM = 17; % com3
DEFAULT_BAUDNUM = 1; % 1mbps

%int32 GoalPos;
GoalPos = final_pos;
%int32 index;
%int32 PresentPos;
%int32 Moving;
%int32 CommStatus;

%open device
%a=1
%res = calllib('dynamixel','dxl_initialize',DEFAULT_PORTNUM,DEFAULT_BAUDNUM);
%a=res
%if res == 1
%   disp('Succeed to open USB2Dynamixel!');
  %  calllib('dynamixel','dxl_write_word', id, 32, 50);
    calllib('dynamixel','dxl_write_word', id ,P_GOAL_POSITION,GoalPos);     
%else
%    disp('Failed to open USB2Dynamixel!');
%end

%Close Device
%calllib('dynamixel','dxl_terminate');  
%unloadlibrary('dynamixel');

end

     

