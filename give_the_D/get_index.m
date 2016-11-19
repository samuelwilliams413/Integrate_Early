function [index] = get_index(face);
L = face(1);
R = face(2);
X = face(3);
Y = face(4);
T = face(5);
index(2) = L;  %lower face
index(3) = R;
index(4) = X;
index(5) = Y;
index(6) = T;

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