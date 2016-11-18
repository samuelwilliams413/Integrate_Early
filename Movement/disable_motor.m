function disable_motor(id)
    calllib('dynamixel','dxl_write_byte', id, 24, 0);
end