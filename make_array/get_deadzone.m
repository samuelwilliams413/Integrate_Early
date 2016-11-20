function [deadzone] = get_deadzone()
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
                deadzone(index,:) = [i,j];
                index = index + 1;
            end
        end
end
    
deadzone = [deadzone;[1,1]];
deadzone = [deadzone;[1,2]];
deadzone = [deadzone;[1,3]];
deadzone = [deadzone;[1,4]];
deadzone = [deadzone;[1,5]];
deadzone = [deadzone;[1,16]];
deadzone = [deadzone;[1,15]];
deadzone = [deadzone;[1,14]];
deadzone = [deadzone;[1,13]];
deadzone = [deadzone;[1,12]];
end