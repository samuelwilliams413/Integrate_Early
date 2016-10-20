function tracking3(arrayOfDom,cam,perams)%, centers, indexC,longest)
[m,n] = size(arrayOfDom);
videoFrame = get_img(cam,perams);
%videoFrame = imread('fred1.jpg');
%videoFrame = imresize(videoFrame,0.5);
close all
for i=1:m
    videoFrame = insertShape(videoFrame, 'Rectangle', arrayOfDom(i,:));
    bbox = arrayOfDom(i,:);
    bboxPoints{i} = bbox2points(bbox(1, :))
    
    currentX{i} = 0;
    currentY{i} = 0;
    %bboxPoints{i} = bbox2points(arrayOfDom(i, :));
    
    points{i} = detectMinEigenFeatures(rgb2gray(videoFrame), 'ROI', arrayOfDom(i,:), 'MinQuality', 0.001);
end
figure; imshow(videoFrame); title('Initial domino');
figure, imshow(videoFrame), hold on, title('Detected features');
videoPlayer  = vision.VideoPlayer('Position',...
    [100 100 [size(videoFrame, 2), size(videoFrame, 1)]+30]);

for i=1:(m)
    plot(points{i});
    pointTracker{i} = vision.PointTracker('MaxBidirectionalError', 2);
    points{i} = points{i}.Location;
    initialize(pointTracker{i}, points{i}, videoFrame);
    oldPoints{i} = points{i};
end


B=0;
%figure, imshow(videoFrame), hold on, title('running loop');
while B==0 %asdf<100
    %         asdf=asdf+1;
    time = toc;
    videoFrame = get_img(cam,perams);
    tic;
    %         %videoFrame = imread('fred2.jpg');
    %         %videoFrame = imresize(videoFrame,0.5);
    for i=1:m
        [points{i}, isFound{i}] = step(pointTracker{i}, videoFrame);
        visiblePoints{i} = points{i}(isFound{i}, :);
        oldInliers{i} = oldPoints{i}(isFound{i}, :);
        
        oldX{i} = currentX{i};
        oldY{i} = currentY{i};
        %
        %
        %
        if size(visiblePoints{i}, 1) >= 2 % need at least 2 points
            [xform{i}, oldInliers{i}, visiblePoints{i}] = estimateGeometricTransform(...
                oldInliers{i}, visiblePoints{i}, 'similarity', 'MaxDistance', 4);
            % %
            bboxPoints{i} = transformPointsForward(xform{i}, bboxPoints{i});
            %
            a = min(bboxPoints{i}(:,1));
            b = max(bboxPoints{i}(:,1));
            c = min(bboxPoints{i}(:,2));
            d = max(bboxPoints{i}(:,2));
            currentX{i} = (a+b)/2;
            currentY{i} = (c+d)/2;a = min(bboxPoints{i}(:,1));
            b = max(bboxPoints{i}(:,1));
            c = min(bboxPoints{i}(:,2));
            d = max(bboxPoints{i}(:,2));
            currentX{i} = (a+b)/2;
            currentY{i} = (c+d)/2;
            format shortEng
            
           % [dx, dy, dz] = dist_bet_point_and_orig(currentX{i}, currentY{i}, longest, indexC, centers);
            
            diffX{i} = abs(currentX{i} - oldX{i});
            diffY{i} = abs(currentY{i} - oldY{i});
            diffT{i} = sqrt(diffX{i}*diffX{i} + diffY{i}*diffY{i});
            velocity{i} = (diffT{i})/time;
            velocity{i} = velocity{i}*4.2;
            round(velocity{i});
           fprintf('Dom %d: pos [] - Speed = %dmm/s\n', i, velocity{i});
            
            bboxPolygon{i} = reshape(bboxPoints{i}', 1, []);
            videoFrame = insertShape(videoFrame, 'Polygon', bboxPolygon{i}, ...
                'LineWidth', 2);
            
            videoFrame = insertMarker(videoFrame, visiblePoints{i}, '+', ...
                'Color', 'magenta');
            
            oldPoints{i} = visiblePoints{i};
            setPoints(pointTracker{i}, oldPoints{i});
            %pos{i} = dist_bet_point_and_orig2m(currentX{i}),currentY{i},indexC,centers)
        else
            B=1;
        end
      %  imshow(videoFrame)
        step(videoPlayer, videoFrame);
    end
end
end

