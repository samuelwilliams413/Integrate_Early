function [index] = get_index(face);
L = face(1);
R = face(2);
index(2) = L;
index(3) = R;

if L > 4 || R > 4 || L < 0 || R < 0
    INVALID_DOM = [face(1) face(2)]
    index(1) = -1;
    
    return
end

switch (R)
    case 0
        index(1) = 14;
    case 1
        index(1) = 14 - (2 - L);
    case 2
        index(1) = 14 - (5 - L);
    case 3
        index(1) = 14 - (9 - L);
    case 4
        index(1) = 14 - (14 - L);
end
end