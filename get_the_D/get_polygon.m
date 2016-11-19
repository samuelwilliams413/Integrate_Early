function [xv1, yv1, xv2, yv2, theta] = get_polygon(index, trackingin, matches);
%% Set up domino orientation gradients
x = trackingin(index, 1) + 0.5 * trackingin(index, 3);
y = trackingin(index, 2) + 0.5 * trackingin(index, 4);

m = (matches(index,12) - matches(index,10))/(matches(index,11) - matches(index,9));
if isnan(m)
    m = 0.0001;
end

m = tand(atand(m));
theta = atand(m);

if m == 0
    m = 0.0001;
end



if (theta < 0)
    theta = 360 +theta;
end

off = y - m*x;

%% plot centerline to check orientation
%  hold on
%  x = 0:1:2000;
%  y = m*x+off;
%  plot(x, y)

%% Set up dominocorners and boundaries
BoR(1) = trackingin(index, 1);
ToL(1) = trackingin(index, 1) + trackingin(index, 3);
BoR(2) = m*BoR(1) + off;
ToL(2) = m*ToL(1) + off;

TL(1) = trackingin(index, 1);
TL(2) = trackingin(index, 2);

TR(1) = trackingin(index, 1) + trackingin(index, 3);
TR(2) = trackingin(index, 2);

BR(1) = trackingin(index, 1) + trackingin(index, 3);
BR(2) = trackingin(index, 2) + trackingin(index, 4);

BL(1) = trackingin(index, 1);
BL(2) = trackingin(index, 2) + trackingin(index, 4);

m = m
TL2 = TL(2)
BL2 = BL(2)


%% Create Polygon Arrays and Handle Special Cases
if(atand(m) > 45)
    % set max height
    ToL(2) = TL(2);
    BoR(2) = BL(2);
    
    %set center pol
    ToL(1) = (ToL(2) - off)/m;
    BoR(1) = (BoR(2) - off)/m;
end

j = 1;
xv1 = [TL(j) ToL(j) BoR(j) BL(j) TL(j)];
j = 2;
yv1 = [TL(j) ToL(j) BoR(j) BL(j) TL(j)];

j = 1;
xv2 = [TR(j) ToL(j) BoR(j) BR(j) TR(j)];
j = 2;
yv2 = [TR(j) ToL(j) BoR(j) BR(j) TR(j)];

if(atand(m) < 45)
    j = 1;
    xv1 = [BL(j) BoR(j) ToL(j) BR(j) BL(j)];
    j = 2;
    yv1 = [BL(j) BoR(j) ToL(j) BR(j) BL(j)];
    
    j = 1;
    xv2 = [TL(j) BoR(j) ToL(j) TR(j) TL(j)];
    j = 2;
    yv2 = [TL(j) BoR(j) ToL(j) TR(j) TL(j)];
end

if(m < 0 && abs(atand(m)) > 45)
    % set max height
    ToL(2) = TL(2);
    BoR(2) = BL(2);
    
    %set center pol
    ToL(1) = (ToL(2) - off)/m;
    BoR(1) = (BoR(2) - off)/m;
    
    j = 1;
    xv1 = [TL(j) ToL(j) BoR(j) BL(j) TL(j)];
    j = 2;
    yv1 = [TL(j) ToL(j) BoR(j) BL(j) TL(j)];
    
    j = 1;
    xv2 = [TR(j) ToL(j) BoR(j) BR(j) TR(j)];
    j = 2;
    yv2 = [TR(j) ToL(j) BoR(j) BR(j) TR(j)];
    
end

%% Plot corner points
    plot(BoR(1)*0.5, BoR(2)*0.5,'r+','LineWidth',2); % B || L
    plot(TL(1)*0.5, TL(2)*0.5,'b*','LineWidth',2); % TL
    plot(TR(1)*0.5, TR(2)*0.5,'ro','LineWidth',2); % TR
    plot(ToL(1)*0.5, ToL(2)*0.5,'r*','LineWidth',2); % T || L
    plot(BL(1)*0.5, BL(2)*0.5,'go','LineWidth',2); % BL
    plot(BR(1)*0.5, BR(2)*0.5,'y*','LineWidth',2); % BR

end