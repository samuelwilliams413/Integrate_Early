    % get_next_D
    [the_D, face_count] = get_next_domino(face_count);
    if face_count.index == -1
        continue
    end
    [world] = start_and_endpoints_world(the_D);
    % there is no do-while in matlab this is stupid, matlab is stupid, why would you remove perfectly good functionality, I mean its written in c++, they chose not to include do-while.
    while  not_already_good(world, the_D(4))
        [the_D, face_count] = get_next_domino(face_count);
        if face_count.index == -1
            continue
        end
        [world] = start_and_endpoints_world(the_D);
    end
    % convert