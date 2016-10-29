function [bag] = count_polygons(centers, trackingin, matches);

for index = 1:length(centers)
    xq(index) = centers(index, 1);
    yq(index) = centers(index, 2);
end

[m,n] = size(matches);
for index = 1:m
    [xv1, yv1, xv2, yv2] = get_polygon(index, trackingin, matches);
    
    [in,on] = inpolygon(xq,yq,xv1,yv1);
    lFace = numel(xq(in)) + numel(xq(on));
    
    [in,on] = inpolygon(xq,yq,xv2,yv2);
    rFace = numel(xq(in)) + numel(xq(on));
    %         if (rFace == 0) && (lFace == 0)
    %             fprintf('There is a 0|0 OR blank domino\n');
    %         else
    %             fprintf('There is a %d|%d domino\n', lFace, rFace);
    %         end
    bag(index, 1) = lFace;
    bag(index, 2) = rFace;
    
    
    
    bag(index, 3) = trackingin(index, 1) + 0.5 * trackingin(index, 3);
    bag(index, 4) = trackingin(index, 2) + 0.5 * trackingin(index, 4);
    %         plot(bag(i, 3), bag(i, 4),'g+','LineWidth',2);
    
    if index == 3 || index == 2
        plot(xv1,yv1,'LineWidth',2,'Color','y') % polygon
        axis equal;
        hold on;
                 plot(xv2,yv2,'LineWidth',2,'Color','b'); % polygon
                 axis equal;
                 hold on;
    end
    
end
end