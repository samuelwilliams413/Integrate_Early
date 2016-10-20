tic
clear all
% Demo for Structured Edge Detector (please see readme.txt first).

%% set opts for training (see edgesTrain.m)
opts=edgesTrain();                % default options (good settings)
opts.modelDir='models/';          % model will be in models/forest
opts.modelFnm='modelBsds';        % model name
opts.nPos=5e5; opts.nNeg=5e5;     % decrease to speedup training
opts.useParfor=0;                 % parallelize if sufficient memory

%% train edge detector (~20m/8Gb per tree, proportional to nPos/nNeg)
tic, model=edgesTrain(opts); toc; % will load model if already trained

%% set detection parameters (can set after training)
model.opts.multiscale=0;          % for top accuracy set multiscale=1   def = 0
model.opts.sharpen=10;             % for top speed set sharpen=0         def = 3
model.opts.nTreesEval=5;          % for top speed set nTreesEval=1      def = 5
model.opts.nThreads=6;            % max number threads for evaluation   def = 6
model.opts.nms=0;                 % set to true to enable nms           def = 0

%% evaluate edge detector on BSDS500 (see edgesEval.m)
if(0), edgesEval( model, 'show',1, 'name','' ); end


%% detect edge and visualize results

function [matches, dominos, finalfinallines] = detection(I)

    %I = imread('scene2.jpg');
    %I = imread('rightangle2.jpg');
    I = imsharpen(I);
    %I = image(x);
    %I = imadjust(I);

    % Read image from array
    % load('array_for_Bradley.mat');
    % I = uint8(x(:,:,:,12));
    % imshow(I);


    imshow(I);

    tic, E=edgesDetect(I,model); toc
    imshow(E)

    %  Imadj = imadjust(E);
    % imshow(Imadj)

    E = im2bw(E, 0.1);
    %0.06
    %E = bwmorph(E,'thin',1);
    %BW2 = bwperim(E,8);
    %BW2 = medfilt2(E);
    %E = bwmorph(E, 'skel', Inf);
    % BW2 = bwmorph(BW2, 'bridge', 10000);
    % % E = mat2gray(BW2);
    % % E = im2bw(E, 0.00000001);
    %imshowpair(E,BW2,'montage')
    imshow(E)

    %figure
    %imshow(BW2)
    %E = imcomplement(E);
    E = mat2gray(E);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % % Hough Circles - Circle Finder
    % 
    % % Convert image to grayscale
    % I = rgb2gray(I);
    % 
    % % % Show grayscale image for later plotting of circles
    % % imshow(I);
    % 
    % % Define circle radius limits
    % Rmin = 3;
    % Rmax = 50;
    % 
    % % Fine dark circles
    % [centersDark, radiiDark] = imfindcircles(I,[Rmin Rmax],'ObjectPolarity','dark');
    % 
    % % Plot dark circles
    % viscircles(centersDark, radiiDark,'EdgeColor','b');

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %imshow(IG);
    %IG = imgaussfilt(E,2);
    %IG = histeq(E);
    %imshow(IG);

    %BW = edge(E,'Prewitt',0.25);
    %BW = edge(I,'canny',0.1);
    %BW = edge(IG,'sobel',0.01);
    % BW = edge(IG,'canny',0.01);
    %BW = edge(E,'log',0.007);
    %imshow(BW);

    % Apply Hough transform
    [H,theta,rho] = hough(E);

    % Find Hough Peaks
    P = houghpeaks(H,500,'threshold',ceil(0.3*max(H(:))));

    % Find lines in image using Houghlines
    lines = houghlines(E,theta,rho,P,'FillGap',5,'MinLength',70);

    % Initialisation and index parameter setting
    checkedlines = [];
    currentindex = 1;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    dotproductsordered = [];
    distance = 200;

    % Dot product function for detecting perpendicular lines
    for r = 1:length(lines)    
        for dot = 1:length(lines)
            xdotval1 = lines(r).point1(1,1);
            ydotval1 = lines(r).point1(1,2);
            xdotval2 = lines(r).point2(1,1);
            ydotval2 = lines(r).point2(1,2);
            xdotval3 = lines(dot).point1(1,1);
            ydotval3 = lines(dot).point1(1,2);
            xdotval4 = lines(dot).point2(1,1);
            ydotval4 = lines(dot).point2(1,2);
            if (((abs(xdotval1-xdotval3)<distance) || (abs(xdotval1-xdotval4)<distance) || ...
                    (abs(xdotval2-xdotval3)<distance) || (abs(xdotval2-xdotval4)<distance)) && ...
                    ((abs(ydotval1-ydotval3)<distance) || (abs(ydotval1-ydotval4)<distance) || ...
                    (abs(ydotval2-ydotval3)<distance) || (abs(ydotval2-ydotval4)<distance)))
                dotproductsordered(r,dot) = real(acosd(((0 - (xdotval2-xdotval1))*((xdotval3-xdotval1)...
                - (xdotval4-xdotval1))+(0 - (ydotval2-ydotval1))*((ydotval3-ydotval1) - (ydotval4-ydotval1)))...
                /((((abs(xdotval1-xdotval2))^2+(abs(ydotval1-ydotval2))^2)^0.5)*((abs(xdotval3-xdotval4))^2+(abs(ydotval3-ydotval4))^2)^0.5)));
            else
                dotproductsordered(r,dot) = -10;
            end
        end
    end

    % Remove lines that do not have a dot product over the threshold
    finallines = [];
    linkedlines = [];
    indexvalue = 1;
    rightanglethreshold = 80;
    rightanglethresholdmax = 180-rightanglethreshold;


    % For every line
    for ninetydegrees = 1:length(lines)
        xval1 = lines(ninetydegrees).point1(1,1);
        yval1 = lines(ninetydegrees).point1(1,2);
        xval2 = lines(ninetydegrees).point2(1,1);
        yval2 = lines(ninetydegrees).point2(1,2);
        atleast2 = 2;
        for checkfortwo = 1:length(lines)
            if abs(dotproductsordered(ninetydegrees,checkfortwo)) > rightanglethreshold && ...
                    abs(dotproductsordered(ninetydegrees,checkfortwo)) < rightanglethresholdmax
                atleast2 = atleast2 + 1;
            end
        end
        if atleast2 > 2
            % Compare against every line to determine the angles between each
            for ninetyonedegrees = 1:(length(lines))                        
                if abs(dotproductsordered(ninetydegrees,ninetyonedegrees)) > rightanglethreshold && ...
                        abs(dotproductsordered(ninetydegrees,ninetyonedegrees)) < rightanglethresholdmax
                   finallines(indexvalue,1)=ninetydegrees;
                   finallines(indexvalue,2)=xval1;
                   finallines(indexvalue,3)=yval1;
                   finallines(indexvalue,4)=xval2;
                   finallines(indexvalue,5)=yval2;
                   linkedlines(indexvalue,1)=ninetydegrees;
                   linkedlines(indexvalue,2)=ninetyonedegrees;
                   indexvalue = indexvalue + 1;
                end
            end
        end
    end

    % Remove redundant rows
    finalfinallines = unique(finallines, 'rows');

    counter1 = 0;
    counter2 = 2;
    dominos = [];
    variable = 1;
    exceptions = [];
    exceptionsdim = [];
    linkedlinesdim = [];
    resettoken = 1;
    dominorowsize = [1,1];
    firstpass = 1;
    exceptionindex = 1;
    specificposition = 1;

    % Set a variable as the dimensions of the linkedlines array
    linkedlinesdim = size(linkedlines);
    % For every row in the linkedlines matrix
    for checkheight = 1:linkedlinesdim(1,1)
        dominodim = size(dominos);
        indexmatch = 0;
        currentindexvalue = linkedlines(checkheight,1);
        while indexmatch == 0
            % Check all index values for a match
            for checkindex = 1:dominodim(1,1)
                for alldominoindices = 1:dominodim(1,2)
                    if dominos(checkindex,alldominoindices) == currentindexvalue
                        indexmatch = checkindex;
                    end
                end
            end
            break
        end
        zerovalue = 0;
        zerofound = 0;
        indexelsewhere = 0;
        redundantfound = 0;
        entrymatchfalse = 0;
        % If the index matched the current index
        if indexmatch ~= 0
            % Dont run the entry check, as the index check will sort it
            entrymatchfalse = 1;
            % While loop until redundant entries are found, or a blank is found
            % to write to
            while redundantfound == 0 && zerofound ~= 1
                for checkredundant = 1:dominodim(1,2)
                    if dominos(indexmatch,checkredundant) == linkedlines(checkheight,2)
                        redundantfound = checkredundant;
                    end                                  
                    if dominos(indexmatch,checkredundant) == 0
                        zerovalue = checkredundant;
                        zerofound = 1;
                        break
                    end
                end
                break
            end
            % If the index matched, and it was not a redundant entry
            if redundantfound == 0
                % If a zero entry was found
                if zerofound == 1
                    dominos(indexmatch,zerovalue) = linkedlines(checkheight,2);
                % Otherwise, the row takes up all current columns. Add a new
                % column in order to add the entry
                else
                    dominos(indexmatch,dominodim(1,2)+1) = linkedlines(checkheight,2);
                end
            end
        end
        entrymatch = 0;
        while entrymatch == 0 && entrymatchfalse == 0
            % For all rows of the domino matrix
            for checkentry = 1:dominodim(1,1)
                % For all columns of the domino matrix
                for alldominosindices2 = 1:dominodim(1,2)
                    % For all rows of the linkedlines matrix with the current
                    % index value
                    whileindex = currentindexvalue;
                    currentcheckheight = checkheight;
                    while whileindex == currentindexvalue                    
                        if dominos(checkentry,alldominosindices2) == linkedlines(currentcheckheight,2)
                            entrymatch = checkentry;                        
                        end
                        currentcheckheight = currentcheckheight + 1;
                        if currentcheckheight < (1+linkedlinesdim(1,1))
                            whileindex = linkedlines(currentcheckheight,1);
                        else
                            break
                        end                   
                    end
                end
            end
            break
        end
        zerovalue2 = 0;
        zerofound2 = 0;
        redundantfound2 = 0;
        if entrymatch ~= 0  && entrymatchfalse == 0
            while redundantfound2 == 0 && zerofound2 ~= 1
                for checkredundant2 = 1:dominodim(1,2)
                    if dominos(entrymatch,checkredundant2) == linkedlines(checkheight,2)
                        redundantfound2 = checkredundant2;
                    end
                    if dominos(entrymatch,checkredundant2) == 0
                        zerovalue2 = checkredundant2;
                        zerofound2 = 1;                    
                    end
                end
                break
            end
            if redundantfound2 == 0
                if zerofound2 == 1
                    dominos(entrymatch,zerovalue2) = linkedlines(checkheight,1);
                    dominos(entrymatch,zerovalue2+1) = linkedlines(checkheight,2);
                else
                    dominos(entrymatch,dominodim(1,2)+1) = linkedlines(checkheight,1);
                    dominos(entrymatch,dominodim(1,2)+2) = linkedlines(checkheight,2);
                end
            end
        end
        if entrymatch == 0 && entrymatchfalse == 0
            dominos(dominodim(1,1)+1,1) = currentindexvalue;
            dominos(dominodim(1,1)+1,2) = linkedlines(checkheight,2);
        end
    end


    dominodim = size(dominos);
    ffldim = size(finalfinallines);
    bounds = [];

    % For each domino line cluster found previously
    for everydomino = 1:dominodim(1,1)
        setn = -1;
        sete = -1;
        sets = -1;
        setw = -1;
        currentn = 0;
        currente = 0;
        currents = 0;
        currentw = 0;
        % For North
        % For each column entry in the domino line collection
        for dominon = 1:dominodim(1,2)
            % Set the current domino line entry value to compare
            currentlineeval1 = dominos(everydomino,dominon);    
            if currentlineeval1 ~= 0
                % For each row in finalfinallines 
                for findffl1 = 1:ffldim(1,1)
                    % Check the index against the current line value
                    if finalfinallines(findffl1,1) == currentlineeval1
                        % Break the for loop, thus leaving findffl as the
                        % finalfinallines row number for the match
                        break
                    end
                end
                if finalfinallines(findffl1,3) < finalfinallines(findffl1,5)
                    if (setn == -1) || (setn > finalfinallines(findffl1,3))
                        setn = finalfinallines(findffl1,3);
                        currentn = finalfinallines(findffl1,1);
                    end
                else
                    if (setn == -1) || (setn > finalfinallines(findffl1,5))
                        setn = finalfinallines(findffl1,5);
                        currentn = finalfinallines(findffl1,1);
                    end
                end
            end
        end

        % For East
        for dominoe = 1:dominodim(1,2)
            currentlineeval2 = dominos(everydomino,dominoe);  
            if currentlineeval2 ~= 0
                for findffl2 = 1:ffldim(1,1)
                    if finalfinallines(findffl2,1) == currentlineeval2
                        break
                    end
                end
                if finalfinallines(findffl2,2) > finalfinallines(findffl2,4)
                    if (sete == -1) || (sete < finalfinallines(findffl2,2))
                        sete = finalfinallines(findffl2,2);
                        currente = finalfinallines(findffl2,1);
                    end
                else
                    if (sete == -1) || (sete < finalfinallines(findffl2,4))
                        sete = finalfinallines(findffl2,4);
                        currente = finalfinallines(findffl2,1);
                    end
                end
            end
        end

        % For South
        for dominoso = 1:dominodim(1,2)
            currentlineeval3 = dominos(everydomino,dominoso);
            if currentlineeval3 ~= 0
                for findffl3 = 1:ffldim(1,1)
                    if finalfinallines(findffl3,1) == currentlineeval3
                        break
                    end
                end
                if finalfinallines(findffl3,3) > finalfinallines(findffl3,5)
                    if (sets == -1) || (sets < finalfinallines(findffl3,3))
                        sets = finalfinallines(findffl3,3);
                        currents = finalfinallines(findffl3,1);
                    end
                else
                    if (sets == -1) || (sets < finalfinallines(findffl3,5))
                        sets = finalfinallines(findffl3,5);
                        currents = finalfinallines(findffl3,1);
                    end
                end
            end
        end

        % For West
        for dominow = 1:dominodim(1,2)
            currentlineeval4 = dominos(everydomino,dominow); 
            if currentlineeval4 ~= 0
                for findffl4 = 1:ffldim(1,1)
                    if finalfinallines(findffl4,1) == currentlineeval4
                        break
                    end
                end
                if finalfinallines(findffl4,2) < finalfinallines(findffl4,4)
                    if (setw == -1) || (setw > finalfinallines(findffl4,2))
                        setw = finalfinallines(findffl4,2);
                        currentw = finalfinallines(findffl4,1);
                    end
                else
                    if (setw == -1) || (setw > finalfinallines(findffl4,4))
                        setw = finalfinallines(findffl4,4);
                        currentw = finalfinallines(findffl4,1);
                    end
                end
            end
        end
        bounds(everydomino,1) = setn;
        bounds(everydomino,2) = sete;
        bounds(everydomino,3) = sets;
        bounds(everydomino,4) = setw;   
        bounds(everydomino,5) = currentn; 
        bounds(everydomino,6) = currente;
        bounds(everydomino,7) = currents;
        bounds(everydomino,8) = currentw;
    end


    % Display original image with lines superimposed over it
    figure, imshow(I), hold on
    max_len = 0;

    % Replot the Hough circles found previously
    %viscircles(centersDark, radiiDark,'EdgeColor','b');

    % Find the height (effective length) of clu
    heightref = size(finalfinallines);

    % Draw markers between start and end points as cleared
    for k = 1:heightref(1)
       plot([finalfinallines(k,2),finalfinallines(k,4)],[finalfinallines(k,3),finalfinallines(k,5)],'LineWidth',2,'Color','green');  
    end

    mindomsize = 210;
    added = 1;
    longestline = [];

    for each = 1:dominodim(1,1)        
        if (bounds(each,3)-bounds(each,1)) > mindomsize && (bounds(each,2)-bounds(each,4)) > mindomsize
            if (bounds(each,3)-bounds(each,1)) > (bounds(each,2)-bounds(each,4))
                longestline(each,1) = bounds(each,3)-bounds(each,1);
                longestline(each,2) = (bounds(each,3)-bounds(each,1))/(bounds(each,2)-bounds(each,4));
            else
                longestline(each,1) = bounds(each,2)-bounds(each,4);
                longestline(each,2) = (bounds(each,2)-bounds(each,4))/(bounds(each,3)-bounds(each,1));
            end
        end
    end

    filteredonly = [];
    filtered = 1;

    for drawboxes = 1:dominodim(1,1)
        if (bounds(drawboxes,3)-bounds(drawboxes,1)) > mindomsize || (bounds(drawboxes,2)-bounds(drawboxes,4)) > mindomsize
            for check = 1:5    
                filteredonly(filtered,check) = bounds(drawboxes,check);
            end
            filtered = filtered + 1;
            plot([bounds(drawboxes,4),bounds(drawboxes,4)],[bounds(drawboxes,3),bounds(drawboxes,1)],'LineWidth',2,'Color','red');
            plot([bounds(drawboxes,2),bounds(drawboxes,2)],[bounds(drawboxes,3),bounds(drawboxes,1)],'LineWidth',2,'Color','red');
            plot([bounds(drawboxes,2),bounds(drawboxes,4)],[bounds(drawboxes,1),bounds(drawboxes,1)],'LineWidth',2,'Color','red');
            plot([bounds(drawboxes,2),bounds(drawboxes,4)],[bounds(drawboxes,3),bounds(drawboxes,3)],'LineWidth',2,'Color','red');           
        end
    end

    filteredonlydim = size(filteredonly);
    matches = [];

    % For each domino
    for eachdomino = 1:filteredonlydim
        matches(eachdomino,1) = filteredonly(eachdomino,5);
        currentlongest = 0;
        longestlocation = 0;
        xdotval5 = lines(filteredonly(eachdomino,5)).point1(1,1);
        ydotval5 = lines(filteredonly(eachdomino,5)).point1(1,2);
        xdotval6 = lines(filteredonly(eachdomino,5)).point2(1,1);
        ydotval6 = lines(filteredonly(eachdomino,5)).point2(1,2);
        current = ((xdotval6 - xdotval5)^2 + (ydotval6 - ydotval5)^2)^0.5;
        % For each column in the dotproductsordered array
        dotproductsordereddim = size(dotproductsordered);
        for findperp = 1:dotproductsordereddim(1,1)
            if dotproductsordered(filteredonly(eachdomino,5),findperp) > rightanglethreshold
                xdotval7 = lines(findperp).point1(1,1);
                ydotval7 = lines(findperp).point1(1,2);
                xdotval8 = lines(findperp).point2(1,1);
                ydotval8 = lines(findperp).point2(1,2);
                length = ((xdotval8 - xdotval7)^2 + (ydotval8 - ydotval7)^2)^0.5;
                if length > currentlongest
                    currentlongest = length;
                    longestlocation = findperp;
                    matches(eachdomino,5) = xdotval5;
                    matches(eachdomino,6) = ydotval5;
                    matches(eachdomino,7) = xdotval6;
                    matches(eachdomino,8) = ydotval6;
                    matches(eachdomino,9) = xdotval7;
                    matches(eachdomino,10) = ydotval7;
                    matches(eachdomino,11) = xdotval8;
                    matches(eachdomino,12) = ydotval8;
                end
            end
        end
        matches(eachdomino,2) = longestlocation;
        matches(eachdomino,3) = current;    
        matches(eachdomino,4) = currentlongest;   
    end

    % Copy above but for original longest

    for eachdomino2 = 1:filteredonlydim
        currentlongest2 = 0;
        longestlocation2 = 0;
        % For each column in the dotproductsordered array
        for findperp2 = 1:dotproductsordereddim(1,1)
            if dotproductsordered(matches(eachdomino2,2),findperp2) > rightanglethreshold
                xdotval9 = lines(findperp2).point1(1,1);
                ydotval9 = lines(findperp2).point1(1,2);
                xdotval10 = lines(findperp2).point2(1,1);
                ydotval10 = lines(findperp2).point2(1,2);
                length2 = ((xdotval10 - xdotval9)^2 + (ydotval10 - ydotval9)^2)^0.5;
                if length2 > currentlongest2
                    currentlongest2 = length2;
                    longestlocation2 = findperp2;
                    matches(eachdomino2,5) = xdotval9;
                    matches(eachdomino2,6) = ydotval9;
                    matches(eachdomino2,7) = xdotval10;
                    matches(eachdomino2,8) = ydotval10;
                end
            end
        end
        matches(eachdomino2,1) = longestlocation2; 
        matches(eachdomino2,3) = currentlongest2;
    end

    for sort = 1:filteredonlydim
        val1 = matches(sort,1);
        val2 = matches(sort,2);
        val3 = matches(sort,3);
        val4 = matches(sort,4);
        val5 = matches(sort,5);
        val6 = matches(sort,6);
        val7 = matches(sort,7);
        val8 = matches(sort,8);
        val9 = matches(sort,9);
        val10 = matches(sort,10);
        val11 = matches(sort,11);
        val12 = matches(sort,12);
        if val3 < val4
            matches(sort,1) = val2;
            matches(sort,2) = val1;
            matches(sort,3) = val4;
            matches(sort,4) = val3;
            matches(sort,5) = val9;
            matches(sort,6) = val10;
            matches(sort,7) = val11;
            matches(sort,8) = val12;
            matches(sort,9) = val5;
            matches(sort,10) = val6;
            matches(sort,11) = val7;
            matches(sort,12) = val8;
        end
    end

    matchesdim = size(matches);
    for midfinder = 1:matchesdim(1,1)
        notthemiddle = 0;
        firstfirst = 0;
        firstsecond = 0;
        secondfirst = 0;
        if (abs(matches(midfinder,5)-matches(midfinder,9))) < 50            
            if (abs(matches(midfinder,6)-matches(midfinder,10))) < 50         
                notthemiddle = 1;
            end
        end   
        if (abs(matches(midfinder,5)-matches(midfinder,11))) < 50
            if (abs(matches(midfinder,6)-matches(midfinder,12))) < 50
                notthemiddle = 1;
            end
        end
        if (abs(matches(midfinder,7)-matches(midfinder,9))) < 50            
            if (abs(matches(midfinder,8)-matches(midfinder,10))) < 50         
                notthemiddle = 1;
            end
        end   
        if (abs(matches(midfinder,7)-matches(midfinder,11))) < 50
            if (abs(matches(midfinder,8)-matches(midfinder,12))) < 50
                notthemiddle = 1;
            end
        end
        if notthemiddle == 0
            if matches(midfinder,11) > matches(midfinder,9)
                matches(midfinder,13) = round(((matches(midfinder,11)-matches(midfinder,9))/2)+matches(midfinder,9));
            else
                matches(midfinder,13) = round(((matches(midfinder,9)-matches(midfinder,11))/2)+matches(midfinder,11));
            end
            if matches(midfinder,12) > matches(midfinder,10)
                matches(midfinder,14) = round(((matches(midfinder,12)-matches(midfinder,10))/2)+matches(midfinder,10));
            else
                matches(midfinder,14) = round(((matches(midfinder,10)-matches(midfinder,12))/2)+matches(midfinder,12));
            end
        else
            newx = 0;
            newy = 0;
            newx = (matches(midfinder,5)-matches(midfinder,7))/2 + matches(midfinder,7);
            newy = (matches(midfinder,6)-matches(midfinder,8))/2 + matches(midfinder,8);
            if matches(midfinder,5) > matches(midfinder,9) || matches(midfinder,5) > matches(midfinder,11) ...
                    || matches(midfinder,7) > matches(midfinder,9) || matches(midfinder,7) > matches(midfinder,11) ...
                    matches(midfinder,6) > matches(midfinder,10) || matches(midfinder,6) > matches(midfinder,12) ...
                    || matches(midfinder,8) > matches(midfinder,10) || matches(midfinder,8) > matches(midfinder,12)
                matches(midfinder,13) = round(newx - (matches(midfinder,11)-matches(midfinder,9))/2);
                matches(midfinder,14) = round(newy - (matches(midfinder,12)-matches(midfinder,10))/2);
            else
                matches(midfinder,13) = round(newx + (matches(midfinder,11)-matches(midfinder,9))/2);
                matches(midfinder,14) = round(newy + (matches(midfinder,12)-matches(midfinder,10))/2);
            end
        end
    end

    toc
    
end

            