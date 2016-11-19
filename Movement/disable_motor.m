function disable_motor(id)
    DEFAULT_PORTNUM = 17;
    DEFAULT_BAUDNUM = 1;
    res = calllib('dynamixel','dxl_initialize',DEFAULT_PORTNUM,DEFAULT_BAUDNUM)
    calllib('dynamixel','dxl_write_byte', id, 24, 0);
end