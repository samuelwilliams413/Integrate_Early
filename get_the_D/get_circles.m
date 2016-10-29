function [centers, radii, metric] = get_circles(image)
    Rmin = 5;
    Rmax = 15;
    [centers, radii, metric] = imfindcircles(image,[Rmin Rmax],'Sensitivity',0.73);
    viscircles(centers, radii,'EdgeColor','b');
    hold on;
end