function [face_count] = get_face_count(image, trackingin, matches);
% Calibration Params
Rmin = 8;
Rmax =12;

% Get Circles
[centers, radii, metric] = imfindcircles(image,[Rmin Rmax],'Sensitivity',0.92);

% Plot Circles
viscircles((centers*0.5), (radii*0.5),'EdgeColor','b');
hold on;

%% Count circles with polygons
[face_count] = count_polygons(centers, trackingin, matches);

end