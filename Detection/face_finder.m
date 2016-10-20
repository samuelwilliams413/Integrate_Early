function [lFace rFace] = face_finder(img, trackingin, matches)
close all;
Rmin = 7;
Rmax = 9;


%I = imread('pls.jpg');
 IG= rgb2gray(img);
 BW = edge(IG,'canny', 0.1);

[centers, radii, metric] = imfindcircles(BW,[Rmin Rmax],'Sensitivity',0.97);

 figure, imshow(img), hold on;
viscircles(centers, radii,'EdgeColor','b'), hold on;

[lFace rFace] = reader(centers, trackingin, matches);
pause(15);
end