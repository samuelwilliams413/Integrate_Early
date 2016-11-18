function [face_count] = get_face_count(image, trackingin, matches);
% Calibration Params
Rmin = 5;
Rmax =7;

% Get Circles
[centers, radii, metric] = imfindcircles(image,[Rmin Rmax],'Sensitivity',0.9621);

% Plot Circles
viscircles(centers, radii,'EdgeColor','b');
hold on;

%% Count circles with polygons
[face_count] = count_polygons(centers, trackingin, matches);

end