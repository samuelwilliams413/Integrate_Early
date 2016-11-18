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

if L > 6 || R > 6 || L < 0 || R < 0
    INVALID_DOM = [face(1) face(2)]
    index(1) = -1;
    
    return
end

switch (R)
    case 0
        index(1) = 1;
    case 1
        index(1) = L + 2;
    case 2
        index(1) = L + 4;
    case 3
        index(1) = L + 7;
    case 4
        index(1) = L + 11;
    case 5
        index(1) = L + 16;
    case 6
        index(1) = L + 22;
end
end