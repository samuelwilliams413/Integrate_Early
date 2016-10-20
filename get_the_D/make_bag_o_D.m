function [bag] = make_bag_o_D(trackingin, matches, filename);
    close all

    I = imread(filename);
    IG= rgb2gray(I);
    BW = edge(IG,'canny', 0.1);
    image = BW;
    figure, imshow(I), hold on;
    
    tmp = 0;
    [bag] = face_circle_finder(image, trackingin, matches);
    for i = 1:length(bag)
        if(bag(i,1) > bag(i,2))
            tmp = bag(i,1);
            bag(i,1) = bag(i,2);
            bag(i,2) = tmp;
        end
    end
end