function [] = current_pos(id, DEFAULT_PORTNUM,DEFAULT_BAUDNUM)

loadlibrary('dynamixel','dynamixel.h');
libfunctions('dynamixel');

P_PRESENT_POSITION = 150;
%Read Present position
PresentPos = int32(calllib('dynamixel','dxl_read_word',id,P_PRESENT_POSITION));
CommStatus = int32(calllib('dynamixel','dxl_get_result'));

disp(PresentPos);

calllib('dynamixel','dxl_terminate');  
unloadlibrary('dynamixel');
end