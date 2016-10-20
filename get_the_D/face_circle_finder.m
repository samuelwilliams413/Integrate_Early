function [bag] = face_circle_finder(image, trackingin, matches);
    Rmin = 5;
    Rmax = 15;



    [centers, radii, metric] = imfindcircles(image,[Rmin Rmax],'Sensitivity',0.73);


    
    viscircles(centers, radii,'EdgeColor','b');
    hold on;
    [bag] = count_polygons(centers, trackingin, matches);
    
end