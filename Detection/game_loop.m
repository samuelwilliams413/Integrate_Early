function [matches, dominos, finalfinallines, trackingin] = game_loop(params)
close all
clear cam


cam = webcam('Microsoft® LifeCam Studio(TM)');
cam.resolution = '1920x1080';
cam.Brightness=80;
preview(cam);
pause(5);

while 1  
    img = get_img(cam, params);
    imshow(img);
    imwrite(img, 'IMAGE.jpg');


    [matches, dominos, finalfinallines, trackingin] = detection(img)
    %face_finder(img, trackingin, matches);
    %tracking3(trackingin,cam,cameraParams)%, centers, indexC);
    break
end

end