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
    
    % Left hand sided count
    [in1,on1] = inpolygon(xq,yq,xv1,yv1);
    lFace = numel(xq(in1)) + numel(xq(on1));
    face_count(index, 1) = lFace*2;
    
    % Right hand sided count
    [in2,on2] = inpolygon(xq,yq,xv2,yv2);
    rFace = numel(xq(in2)) + numel(xq(on2));
    face_count(index, 2) = rFace*2;
    
    
    
    
    
    % Store centers
    face_count(index, 3) = trackingin(index, 1) + 0.5 * trackingin(index, 3);
    face_count(index, 4) = trackingin(index, 2) + 0.5 * trackingin(index, 4);
    face_count(index, 5) = theta;
    
    LRT = [lFace rFace theta];
    
    if (rFace*2 > lFace*2) % lFace is the little face
        LR = 1
    else % rFace is the little face
        LR = 0
    end
    
    middle_x_1 = mean(xv1);
    middle_y_1 = mean(yv1);
    middle_x_2 = mean(xv2);
    middle_y_2 = mean(yv2);
    
    if(middle_x_1 == middle_x_2) %vertical
        mx1 = mean(xq(in1));
        mx2 = mean(xq(in2));
        
        if lFace == 0
            mx1 = face_count(index, 3);
        end
        
        if rFace == 0
            mx2 = face_count(index, 3);
        end
        
        VH = 1
        if (mx1 > mx2) %lFace on right hand side
            RT_LB = 1
        end
        
        if (mx1 < mx2) %rFace on right hand side
            RT_LB = 0
        end
        
    end
    
    if(middle_y_1 == middle_y_2) %horizontal
        my1 = mean(yq(in1));
        my2 = mean(yq(in2));
        
        if lFace == 0
            my1 = face_count(index, 4);
        end
        
        if rFace == 0
            my2 = face_count(index, 4);
        end
        
        VH = 0
        if (my1 > my2) %lFace on top
            RT_LB = 1
        end
        
        if (my1 < my2) %rFace on top
            RT_LB = 0
        end
    end
    
    if (lFace == 0 && rFace == 0)
        if(mod(theta,180) > 90)
            LR = 0;
            VH == 1;
            RT_LB == 1;
        else 
            LR == 1;
            VH == 1;
            RT_LB == 0
        end
    end
        
    
    
    if (LR == 1 && VH == 1 && RT_LB == 1)
        orientation = 2;
    end
    
    if (LR == 1 && VH == 1 && RT_LB == 0)
        orientation = 1;
    end
    
    if (LR == 0 && VH == 1 && RT_LB == 0)
        orientation = 3;
    end
    
    if (LR == 0 && VH == 1 && RT_LB == 1)
        orientation = 4;
    end
    
    if (LR == 1 && VH == 0 && RT_LB == 1)
        orientation = 1;
    end
    
    if (LR == 0 && VH == 0 && RT_LB == 0)
        orientation = 2;
    end
    
    if (LR == 0 && VH == 0 && RT_LB == 1)
        orientation = 3;
    end
    
    if (LR == 1 && VH == 0 && RT_LB == 0)
        orientation = 4;
    end
    
    face_count(index, 6) = orientation;
    
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