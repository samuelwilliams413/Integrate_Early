function [img] = get_img(cam, params)
hold on


img = snapshot(cam);
img = undistortImage(img,params);
img = imcrop(img,[20,20,1880,1040]);
img = imresize(img,0.67);


end