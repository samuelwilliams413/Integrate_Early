function [face_count] = make_bag_o_D(trackingin, matches, filename);
%% WARNING
% In count_polygons and get_polygons there is a line 
% "if index ~= 6", this was added to prevent the method from detecting a bad 
% domino, remove this line

%% face_count = [lowest_value_face highest_value_face middle_x middle_y]

% Preprocess Image
close all
I = imread(filename);
IG= rgb2gray(I);
BW = edge(IG,'canny', 0.1);
image = BW;
figure, imshow(I), hold on;

% Get bag
[face_count] = get_face_count(image, trackingin, matches);

% Sort and post process
tmp = 0;
for i = 1:length(face_count)
    if(face_count(i,1) > face_count(i,2))
        tmp = face_count(i,1);
        face_count(i,1) = face_count(i,2);
        face_count(i,2) = tmp;
    end
end
face_count = sortrows(face_count,1);

% for display
for i = 1:length(face_count)
    Faces(i,:) = [face_count(i,1) face_count(i,2)];
end
Faces
end