function [xv1 yv1 xv2 yv2] = get_quad(i, trackingin, matches)

x = trackingin(i, 1) + 0.5 * trackingin(i, 3);
y = trackingin(i, 2) + 0.5 * trackingin(i, 4);
m = (matches(i,12) - matches(i,10))/(matches(i,11) - matches(i,9));
m = tand(atand(m) );

off = y - m*x;
hold on
plot(x, y,'r+','LineWidth',2); % points inside
x = 0:1:2000;
y = m*x+off;
% plot(x, y);

p1(1) = trackingin(i, 1);
p5(1) = trackingin(i, 1) + trackingin(i, 3);
p1(2) = m*p1(1) + off;
p5(2) = m*p5(1) + off;


p2(1) = trackingin(i, 1);
p2(2) = trackingin(i, 2);

p3(1) = trackingin(i, 1) + trackingin(i, 3);
p3(2) = trackingin(i, 2);

p8(1) = trackingin(i, 1) + trackingin(i, 3);
p8(2) = trackingin(i, 2) + trackingin(i, 4);

p7(1) = trackingin(i, 1);
p7(2) = trackingin(i, 2) + trackingin(i, 4);

xv1 = [p1(1) p2(1) p3(1) p5(1) p1(1)];
yv1 = [p1(2) p2(2) p3(2) p5(2) p1(2)];

xv2 = [p1(1) p7(1) p8(1) p5(1) p1(1)];
yv2 = [p1(2) p7(2) p8(2) p5(2) p1(2)];


if p1(2) > (trackingin(i, 2) + trackingin(i, 4))
    p1(2) = (trackingin(i, 2) + trackingin(i, 4));
    p1(1) = (p1(2) - off) / m;
    
    p5(2) = (trackingin(i, 2));
    p5(1) = (p5(2) - off) / m;
    
    
    xv1 = [p1(1) p7(1) p2(1) p5(1) p1(1)];
    yv1 = [p1(2) p7(2) p2(2) p5(2) p1(2)];
    
    xv2 = [p1(1) p8(1) p3(1) p5(1) p1(1)];
    yv2 = [p1(2) p8(2) p3(2) p5(2) p1(2)];
    
    
end

if p5(2) > (trackingin(i, 2) + trackingin(i, 4))
    p5(2) = (trackingin(i, 2) + trackingin(i, 4));
    p5(1) = (p5(2) - off) / m;
    
    p1(2) = (trackingin(i, 2));
    p1(1) = (p1(2) - off) / m;
end



plot(p1(1), p1(2),'r+','LineWidth',2); % points inside
plot(p2(1), p2(2),'bo','LineWidth',2); % points inside
plot(p3(1), p3(2),'bo','LineWidth',2); % points inside
plot(p5(1), p5(2),'r*','LineWidth',2); % points inside
plot(p7(1), p7(2),'yo','LineWidth',2); % points inside
plot(p8(1), p8(2),'yo','LineWidth',2); % points inside


end