function [lost] = get_next_domino_list(face_count, lost);
%% Note to self: you need to return the orienation of the domino
%% face_count = [lowest_value_face highest_value_face middle_x middle_y]
for i = 1:length(face_count)
    index(i,:) = get_index(face_count(i,:));
end
for i = 1:length(index)
    for j = 1:length(lost)
        if(lost(j,:) == index(i,:) )
            index(i,1) = intmax;
        end
    end
end

% k = 1;
% for i = 1:length(lost)
%     if (lost(i, 1) == 0 && lost(i, 2) == 0 && lost(i, 3) == 0)
%         break;
%     end
%     k = k+1;
% end

for(k = 1:length(index))
    minVal = min(index(:,1));
    toMove = find(index==minVal,1);
    if(index(toMove,1) == intmax) 
        return;
    end
    lost(k,:) = index(toMove,:);
    index(toMove,1) = intmax;

end
end