function [xv1, yv1, xv2, yv2] = get_poly(i, trackingin, matches)

%% Get center lines
x = trackingin(i, 1) + 0.5 * trackingin(i, 3);
y = trackingin(i, 2) + 0.5 * trackingin(i, 4);
m = (matches(i,12) - matches(i,10))/(matches(i,11) - matches(i,9));

m = tand(atand(m) );
off = y - m*x;

%% plot center line
x = 0:1:2000;

hold on
plot(x, y)

%% Get corners
BoR(1) = trackingin(i, 1);
ToL(1) = trackingin(i, 1) + trackingin(i, 3);
BoR(2) = m*BoR(1) + off;
ToL(2) = m*ToL(1) + off;


TL(1) = trackingin(i, 1);
TL(2) = trackingin(i, 2);

TR(1) = trackingin(i, 1) + trackingin(i, 3);
TR(2) = trackingin(i, 2);

BR(1) = trackingin(i, 1) + trackingin(i, 3);
BR(2) = trackingin(i, 2) + trackingin(i, 4);

BL(1) = trackingin(i, 1);
BL(2) = trackingin(i, 2) + trackingin(i, 4);

%% Circumstantial modifiers

%% Get polygon

i = 1;
xv1 = [TL(i) TR(i) BR(i) BL(i) TL(i)];
i = 2;
yv1 = [TL(i) TR(i) BR(i) BL(i) TL(i)];

i = 1;
xv2 = [TL(i) TR(i) BR(i) BL(i) TL(i)];
i = 2;
yv2 =  [TL(i) TR(i) BR(i) BL(i) TL(i)];

%% plot corners
plot(BoR(1), BoR(2),'r+','LineWidth',2); % B || L
plot(TL(1), TL(2),'b*','LineWidth',2); % TL
plot(TR(1), TR(2),'ro','LineWidth',2); % TR
plot(ToL(1), ToL(2),'r*','LineWidth',2); % T || L
plot(BL(1), BL(2),'go','LineWidth',2); % BL
plot(BR(1), BR(2),'y*','LineWidth',2); % BR

end