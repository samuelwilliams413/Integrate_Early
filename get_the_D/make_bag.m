function [bag] = make_bag(trackingin, matches, filename)
    close all
    %% Preprocess Image
    I = imread(filename);
    IG= rgb2gray(I);
    BW = edge(IG,'canny', 0.1);
    image = BW;
    figure, imshow(I), hold on;

    %% Get Circles
    [centers, radii, metric] = get_circles(image);
    
    %% Get Bag
    [bag] = get_bag(centers, trackingin, matches);
    
end