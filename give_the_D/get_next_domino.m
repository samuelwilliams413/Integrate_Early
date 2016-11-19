function [the_D, face_count] = get_next_domino(face_count);
%% Note to self: you need to return the orienation of the domino
%% face_count = [lowest_value_face highest_value_face middle_x middle_y]
%% the_D = [index middle_x middle_y theta]
index = face_count.index;
face_data = face_count.face_data;
if length(face_data) < index
    the_D = [-1,-1,-1,-1];
    face_count.index = -1;
    return;  
end
lengthofthething = length(face_data)
lost = zeros(length(face_data),6);
[lost] = get_next_domino_list(face_data, lost);
lost = lost
for(i = 1:length(lost))
    if(lost(i,1) == -1)
        index = index+1;
    end
end

if length(face_data) < index
    the_D = [-1,-1,-1,-1];
    face_count.index = -1;
    return;
end
the_D(1) = lost(index,(1));
the_D(2) = lost(index,(4));
the_D(3) = lost(index,(5));
the_D(4) = lost(index,(6));
face_count.index = index + 1;


end
