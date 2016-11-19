function [face_count] = make_bag_o_D(trackingin, matches, filename);
%% WARNING
% In count_polygons and get_polygons there is a line 
% "if index ~= 6", this was added to prevent the method from detecting a bad 
% domino, remove this line
%filename = 'redbull2.jpg'
%% face_count = [lowest_value_face highest_value_face middle_x middle_y orientation]

SCALING_FACTOR = 2;

% Preprocess Image
close all
I = imread(filename);

I = imresize(I,SCALING_FACTOR);

IG= rgb2gray(I);
BW = edge(IG,'canny', 0.1);
image = BW;
figure, imshow(I), hold on;

% Get bag
trackingin = trackingin*SCALING_FACTOR;
matches =  matches*SCALING_FACTOR;
[face_data] = get_face_count(image, trackingin, matches);

% Sort and post process
tmp = 0;
for i = 1:length(face_data)
    if(face_data(i,1) > face_data(i,2))
        tmp = face_data(i,1);
        face_data(i,1) = face_data(i,2);
        face_data(i,2) = tmp;
    end
end
face_data = sortrows(face_data,1);

% for display
for i = 1:length(face_data)
    Faces(i,:) = [face_data(i,1) face_data(i,2)];
end
field0 = 'index';
value0 = 1;
field1 = 'face_data';
value1 = face_data(:,:)*(1/SCALING_FACTOR);

face_count = struct(field0, value0, field1, value1);
Faces

end