function [the_D] = get_next_domino(face_count, index);
%% Note to self: you need to return the orienation of the domino
%% face_count = [lowest_value_face highest_value_face middle_x middle_y]

if length(face_count) < index
    the_D = [-1,-1,-1];
    return;
end

[lost] = get_next_domino_list(face_count);

the_D = lost(index,:);

end