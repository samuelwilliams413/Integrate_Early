function [face_count] = count_polygons(centers, trackingin, matches);
% Create an array of centers for counting
for index = 1:length(centers(:,1))
    xq(index) = centers(index, 1);
    yq(index) = centers(index, 2);
end

% Run for each detected domino (length of matches)
[m,n] = size(matches);
for index = 1:m
    % Get polygons
    [xv1, yv1, xv2, yv2,theta] = get_polygon(index, trackingin, matches);
    
    x1mean = mean(xv1);
    y1mean = mean(yv1);
    x2mean = mean(xv2);
    y2mean = mean(yv2);
    
    orientation = [0 0];
    
    if (x1mean < x2mean)
        orientation(1) = 1;
    end
        
    if (y1mean < y2mean)
        orientation(2) = 1;
    end
    
    % Left hand sided count
    [in,on] = inpolygon(xq,yq,xv1,yv1);
    lFace = numel(xq(in)) + numel(xq(on));
    face_count(index, 1) = lFace*2;
    
    % Right hand sided count
    [in,on] = inpolygon(xq,yq,xv2,yv2);
    rFace = numel(xq(in)) + numel(xq(on));
    face_count(index, 2) = rFace*2;
    
    % Store centers
    face_count(index, 3) = trackingin(index, 1) + 0.5 * trackingin(index, 3);
    face_count(index, 4) = trackingin(index, 2) + 0.5 * trackingin(index, 4);
    face_count(index, 5) = theta;
    face_count(index, 6) = orientation(1);
    face_count(index, 7) = orientation(2);
    LRT = [lFace rFace theta]

    %plotting
        plot(face_count(index, 3)*0.5, face_count(index, 4)*0.5,'g+','LineWidth',2);
        plot(xv1*0.5,yv1*0.5,'LineWidth',2,'Color','y');
        axis equal;
        hold on;
        plot(xv2*0.5,yv2*0.5,'LineWidth',2,'Color','b');
        axis equal;
        hold on;
end
end