% get_next_D
while  already_sorted(sorted, the_D)
    [the_D, face_count] = get_next_domino(face_count);
    if face_count.index == -1
        sorted = lcear_s(sorted);
        continue
    end
end
[sorted] = add_to_sorted(sorted, the_D);
% convert