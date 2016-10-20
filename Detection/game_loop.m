function [matches, dominos, finalfinallines, trackingin] = game_loop(cameraParams)
close all
clear cam


cam = webcam('Microsoft® LifeCam Studio(TM)');
cam.resolution = '1920x1080';
cam.Brightness=80;
preview(cam);
pause(5);

while 1
img = get_img(cam, cameraParams);
imshow(img);
imwrite(img, 'IMAGE.jpg');


[matches, dominos, finalfinallines, trackingin] = new2(img)
%face_finder(img, trackingin, matches);
tracking3(trackingin,cam,cameraParams)%, centers, indexC);
end

end