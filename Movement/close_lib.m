function [] = close_lib()

%Close Device
calllib('dynamixel','dxl_terminate');  
unloadlibrary('dynamixel');

end
