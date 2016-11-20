function [DZ] = get_deadzone()
index = 1;
for i = 1:16
    if i < 9
        x = 9 - i;
    end
    if i > 9
        x = i - 8;
    end
        for j = 1:8
            
            y = j+1;
            ss = (x^2 + y^2);
            if (128) < (x^2 + y^2)
                xy = [x y];
                DZ(index,:) = [i,j];
                index = index + 1;
            end
        end
end
    
DZ = [DZ;[1,1]];
DZ = [DZ;[2,1]];
DZ = [DZ;[3,1]];
DZ = [DZ;[4,1]];
DZ = [DZ;[5,1]];
DZ = [DZ;[16,1]];
DZ = [DZ;[15,1]];
DZ = [DZ;[14,1]];
DZ = [DZ;[13,1]];
DZ = [DZ;[12,1]];
end