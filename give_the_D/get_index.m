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

LR = [L R];

if L > 6 || R > 6 || L < 0 || R < 0
    INVALID_DOM = [face(1) face(2)];
    index(1) = -1;
    
    return
end

switch (R)
    case 0
        index(1) = 1;
    case 1
        index(1) = 3 - L;
    case 2
        index(1) = 6 - L;
    case 3
        index(1) = 10 - L;
    case 4
        index(1) = 15 - L;
    case 5
        index(1) = 21 - L;
    case 6
        index(1) = 28 - L;
end
end