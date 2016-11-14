function [] = init_lib(DEFAULT_PORTNUM,DEFAULT_BAUDNUM)
loadlibrary('dynamixel','dynamixel.h');
libfunctions('dynamixel');
calllib('dynamixel','dxl_initialize',DEFAULT_PORTNUM,DEFAULT_BAUDNUM);
end