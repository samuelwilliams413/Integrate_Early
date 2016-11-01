function [lost] = get_next_domino_list(face_count);
%% Note to self: you need to return the orienation of the domino
%% face_count = [lowest_value_face highest_value_face middle_x middle_y]

for i = 1:length(face_count)
    index(i,:) = get_index(face_count(i,:));
end
lost = zeros(length(index),3);
for i = 1:length(index)
    minVal = min(index(:,1));
    toMove = find(index==minVal,1);
    lost(i,:) = index(toMove,:);
    index(toMove,1) = intmax;
end

end