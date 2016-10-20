i = 10; %inital videoframe
j = 100; %final videoframe

%close all the other images
close all
%get the first image of the video 
videoFrame = (uint8(x(:,:,:,i))); 
%[x,y,width,height]
bbox=[165,235,90,36];

%shows the location of interest probably remove this line later
videoFrame = insertShape(videoFrame, 'Rectangle', bbox);
%display the image with the rectangle3
figure; imshow(videoFrame); title('Initial domino');

% Convert the first box into a list of 4 points
% This is needed to be able to visualize the rotation of the object.
bboxPoints = bbox2points(bbox(1, :))

% Detect feature points in the face region.
points = detectMinEigenFeatures(rgb2gray(videoFrame), 'ROI', bbox);

% Display the detected points.
figure, imshow(videoFrame), hold on, title('Detected features');
plot(points);

% Create a point tracker and enable the bidirectional error constraint to
% make it more robust in the presence of noise and clutter.
pointTracker = vision.PointTracker('MaxBidirectionalError', 2);

% Initialize the tracker with the initial point locations and the initial
% video frame.
points = points.Location;
initialize(pointTracker, points, videoFrame);

videoPlayer  = vision.VideoPlayer('Position',...
    [100 100 [size(videoFrame, 2), size(videoFrame, 1)]+30]);

% Make a copy of the points to be used for computing the geometric
% transformation between the points in the previous and the current frames
oldPoints = points;


while i < j
    % get the next frame
    i=i+1;
    videoFrame = (uint8(x(:,:,:,i))); 
    
     % Track the points. Note that some points may be lost.
    [points, isFound] = step(pointTracker, videoFrame);
    visiblePoints = points(isFound, :);
    oldInliers = oldPoints(isFound, :);
    
     if size(visiblePoints, 1) >= 2 % need at least 2 points

        % Estimate the geometric transformation between the old points
        % and the new points and eliminate outliers
        [xform, oldInliers, visiblePoints] = estimateGeometricTransform(...
            oldInliers, visiblePoints, 'similarity', 'MaxDistance', 4);
        
         % Apply the transformation to the bounding box points
        bboxPoints = transformPointsForward(xform, bboxPoints);
        
         % Insert a bounding box around the object being tracked
        bboxPolygon = reshape(bboxPoints', 1, []);
        videoFrame = insertShape(videoFrame, 'Polygon', bboxPolygon, ...
            'LineWidth', 2);
        
         % Display tracked points
        videoFrame = insertMarker(videoFrame, visiblePoints, '+', ...
            'Color', 'white');
        
        % Reset the points
        oldPoints = visiblePoints;
        setPoints(pointTracker, oldPoints);
        
     end
     step(videoPlayer, videoFrame);
     
        
        

    


end




