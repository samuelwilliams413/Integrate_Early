function [deadzone] = get_deadzone()
index = 1;
for i = 1:16
    if i < 9
        x = 9 - i
    end
    if i > 9
        x = i - 8
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
end