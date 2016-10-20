function [bag] = count_polygons(centers, trackingin, matches);

    for i = 1:length(centers)
        xq(i) = centers(i, 1);
        yq(i) = centers(i, 2);
    end

    [m,n] = size(matches);
    for i = 1:m
        [xv1, yv1, xv2, yv2] = get_quad(i, trackingin, matches);
        plot(xv1,yv1,'LineWidth',2,'Color','y') % polygon
        axis equal;
        hold on;
        [in,on] = inpolygon(xq,yq,xv1,yv1);
        lFace = numel(xq(in)) + numel(xq(on));
        plot(xv2,yv2,'LineWidth',2,'Color','b'); % polygon
        axis equal;
        hold on;
        [in,on] = inpolygon(xq,yq,xv2,yv2);
        rFace = numel(xq(in)) + numel(xq(on));
        %         if (rFace == 0) && (lFace == 0)
        %             fprintf('There is a 0|0 OR blank domino\n');
        %         else
        %             fprintf('There is a %d|%d domino\n', lFace, rFace);
        %         end
        bag(i, 1) = lFace;
        bag(i, 2) = rFace;



        bag(i, 3) = trackingin(i, 1) + 0.5 * trackingin(i, 3);
        bag(i, 4) = trackingin(i, 2) + 0.5 * trackingin(i, 4);
        plot(bag(i, 3), bag(i, 4),'g+','LineWidth',2);
    end
end