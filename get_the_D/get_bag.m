function [bag] = get_bag(centers, trackingin, matches)
for i = 1:length(centers)
    xq(i) = centers(i, 1);
    yq(i) = centers(i, 2);
end

[m,n] = size(matches);
for i = 1:m
    [xv1, yv1, xv2, yv2] = get_poly(i, trackingin, matches);
    [in,on] = inpolygon(xq,yq,xv1,yv1);
    lFace = numel(xq(in)) + numel(xq(on));
    [in,on] = inpolygon(xq,yq,xv2,yv2);
    rFace = numel(xq(in)) + numel(xq(on));
    bag(i, 1) = lFace;
    bag(i, 2) = rFace;
    bag(i, 3) = trackingin(i, 1) + 0.5 * trackingin(i, 3);
    bag(i, 4) = trackingin(i, 2) + 0.5 * trackingin(i, 4);

%     plot(xv1,yv1,'LineWidth',2,'Color','y') % polygon
%     axis equal;
%     hold on;
%     plot(xv2,yv2,'LineWidth',2,'Color','b'); % polygon
%     axis equal;
%     hold on;
%     plot(bag(i, 3), bag(i, 4),'g+','LineWidth',2);
%     hold on;
end