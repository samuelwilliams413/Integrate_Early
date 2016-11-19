function[] = able_motor(id)
    calllib('dynamixel','dxl_write_byte', id, 24, 1);
end
    