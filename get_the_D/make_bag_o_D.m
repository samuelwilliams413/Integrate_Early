function [face_count] = make_bag_o_D(trackingin, matches, filename);
%% WARNING
% In count_polygons and get_polygons there is a line
% "if index ~= 6", this was added to prevent the method from detecting a bad
% domino, remove this line
%filename = 'redbull2.jpg'
%% face_count = [lowest_value_face highest_value_face middle_x middle_y orientation]

SCALING_FACTOR = 2;

% Preprocess Image
%close all
I = imread(filename);

I = imresize(I,SCALING_FACTOR);

IG= rgb2gray(I);
BW = edge(IG,'canny', 0.1);
image = BW;
%figure, imshow(I), hold on;

% Get bag
trackingin = trackingin*SCALING_FACTOR;
matches =  matches*SCALING_FACTOR;
[face_data] = get_face_count(image, trackingin, matches);

% Sort and post process
tmp = 0;


for i = 1:length(face_data(:,1))
    twist_array =  [face_data(i,1)/2 face_data(i,2)/2 face_data(i,6) face_data(i,5)];
    if(face_data(i,1) == 0 && face_data(i,2) == 0)
        twist_array(4) = mod((twist_array(4)),360);
        continue;
    end
    if(face_data(i,1) > face_data(i,2))
        tmp = face_data(i,1);
        face_data(i,1) = face_data(i,2);
        face_data(i,2) = tmp;
        
        %         before = face_data(i, 5)
        %         if (face_data(i, 5) > 180)
        %             face_data(i, 5) = mod((face_data(i, 5)+180),360);
        %         end
        %         after = face_data(i, 5)
        %         if (twist_array(3) == 0)
        %             twist_array(3) = 1;
        %         else
        %             twist_array(3) = 0;
        %         end
        %
        %         if (twist_array(4) == 0)
        %             twist_array(4) = 1;
        %         else
        %             twist_array(4) = 0;
        %         end
    end
    
    % TL
    if (face_data(i,6) == 4)
        enter_TL = 1;
        while((twist_array(4) > 360) || (twist_array(4) < 270))
            twist_array(4) = mod((twist_array(4) + 90),360);
        end
    end
    
    % TR
    if (face_data(i,6) == 3)
        enter_TR = 1;
        while((twist_array(4) > 270) || (twist_array(4) < 180))
            twist_array(4) = mod((twist_array(4) + 90),360);
        end
    end
    
    % BR
    if (face_data(i,6) == 2)
        enter_BR = 1;
        while((twist_array(4) > 180) || (twist_array(4) < 90))
            twist_array(4) = mod((twist_array(4) + 90),360);
        end
    end
    
    % BL
    if (face_data(i,6) == 1)
        enter_BL = 1;
        while((twist_array(4) > 90) || (twist_array(4) < 0))
            twist_array(4) = mod((twist_array(4) + 90),360);
        end
    end
    
    
    face_data(i, 6) = twist_array(3);
    face_data(i, 5) = twist_array(4);
    printpls = [face_data(i,1) face_data(i,2) face_data(i,5) face_data(i,6)];
end
% the_angle_found = [face_data(:,1)/2 face_data(:,2)/2 face_data(:, 5) face_data(:,6)]
face_data(:, 5) = face_data(:, 5)*SCALING_FACTOR;
face_data = sortrows(face_data,1);

field0 = 'index';
value0 = 1;
field1 = 'face_data';
value1 = face_data(:,:)*(1/SCALING_FACTOR);

face_count = struct(field0, value0, field1, value1);

end