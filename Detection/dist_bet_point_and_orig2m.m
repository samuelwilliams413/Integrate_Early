function [dist_mm_x, dist_mm_y] = dist_bet_point_and_orig(x, y, indexC, centers)
%[origin_to_dom_mm] = dist_bet_point_and_orig1(centers_x,centers_y, longest_sides)

% create empty matrix of coordinates
origin_to_dom_mm = [];

xScale = 4*262/1920; % mm/p
yScale = 4*262/1080; % mm/p

dist_pix_x = x-(centers(indexC,1));
dist_mm_x = dist_pix_x*xScale;

dist_pix_y = y-(centers(indexC,2));
dist_mm_y = dist_pix_y*yScale;

% determine the z coordinate for each dom from origin
% distance_z = 0.9652*longest-196.4; 
% if distance_z < 0
%     dist_mm_z = 0
% else
%     dist_mm_z = distance_z
%end

%dist_mm_tot = dist_pix_tot*scale;
end