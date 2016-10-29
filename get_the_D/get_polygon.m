function [xv1, yv1, xv2, yv2] = get_polygon(index, trackingin, matches);

x = trackingin(index, 1) + 0.5 * trackingin(index, 3);
y = trackingin(index, 2) + 0.5 * trackingin(index, 4);
m = (matches(index,12) - matches(index,10))/(matches(index,11) - matches(index,9));
m = tand(atand(m));

off = y - m*x;
hold on
%     ps % points inside
x = 0:1:2000;
y = m*x+off;
%      plot(x, y)

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

if index == 3 || index == 2
    m = (matches(index,12) - matches(index,10))/(matches(index,11) - matches(index,9))
    m = (atand(m))
    yv1
    plot(BoR(1), BoR(2),'r+','LineWidth',2); % B || L
    plot(TL(1), TL(2),'b*','LineWidth',2); % TL
    plot(TR(1), TR(2),'ro','LineWidth',2); % TR
    plot(ToL(1), ToL(2),'r*','LineWidth',2); % T || L
    plot(BL(1), BL(2),'go','LineWidth',2); % BL
    plot(BR(1), BR(2),'y*','LineWidth',2); % BR
end


end