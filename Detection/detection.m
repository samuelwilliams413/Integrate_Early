function [matches, dominos, finalfinallines, trackingin] = detection(picturein);

    %% Bryden Page domino detection software, 2016, METR4202, The University
    % of Queensland

    % Pre-word. Coding isnt something that i have had significant
    % experience with. As such, many processes have been performed in a way
    % that may well have been streamlined using exisiting MATLAB functions.
    % I have also been overly optimistic at times, such that arrays that i
    % have considered 'final', have not been...hence the ridiculous
    % variable names at times. Thanks!
    
    %% Structured Edge Detector
    tic

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


    %% Code that is uncommented for the testing of previously stored images
    
    % Read image from a file
%     picturein = imread('IMAGE.jpg');
    
    % Read image from an array
    % load('array_for_Bradley.mat');
    % I = uint8(x(:,:,:,12));
    
    %% Pre-process the image, and run the structured edge detection. 
    % Then apply a black and white filter to enhance the detected edges

    % Pre-sharpen features in original image
    I = imsharpen(picturein);

    % Run the structured edge detection
    tic, E=edgesDetect(I,model); toc

    % Convert to black and white under a filter value of 0.1
    E = im2bw(E, 0.1);
    
    % Convert to gray as required by further processes
    E = mat2gray(E);

    %% Apply the Hough transform and process

    [H,theta,rho] = hough(E);
    
    % Find Hough Peaks
    P = houghpeaks(H,700,'threshold',ceil(0.3*max(H(:))));
    % was 500 for close dominos 

    % Find lines in image using Houghlines
    lines = houghlines(E,theta,rho,P,'FillGap',3,'MinLength',40);
    
    %% Commence sorting of the detected lines

    % Initialisation and index parameter setting
    checkedlines = [];
    currentindex = 1;
    dotproductsordered = [];
    % Variable that controls the distance that lines may be from each other
    % before being considered unrelated
    %distance = 60;
    distance = 7;

    %% Dot product function for detecting perpendicular lines. It iterates
    % through the detected lines with are stored in 'lines'. For each line,
    % it checks its proximity to other lines by comparing the end points of
    % each line. If any two lines are considered to be close enough
    % together, it determines the angle between them using the dot product.
    % The resulting angles are returned to an array where the x and y
    % indices refer to the reference indices of each line. If the lines are
    % too far apart, the angle is set to -10 degrees as it will never make
    % it through further filtering. The output array is called
    % dotproductsordered
    for r = 1:length(lines)    
        for dot = 1:length(lines)
            xdotval1 = lines(r).point1(1,1);
            ydotval1 = lines(r).point1(1,2);
            xdotval2 = lines(r).point2(1,1);
            ydotval2 = lines(r).point2(1,2);
            xdotval1point5 = ((lines(r).point2(1,1) - lines(r).point1(1,1))/2) + lines(r).point1(1,1);
            ydotval1point5 = ((lines(r).point2(1,2) - lines(r).point1(1,2))/2) + lines(r).point1(1,2);
            xdotval3 = lines(dot).point1(1,1);
            ydotval3 = lines(dot).point1(1,2);
            xdotval4 = lines(dot).point2(1,1);
            ydotval4 = lines(dot).point2(1,2);
            xdotval3point5 = ((lines(dot).point2(1,1) - lines(dot).point1(1,1))/2) + lines(dot).point1(1,1);
            ydotval3point5 = ((lines(dot).point2(1,2) - lines(dot).point1(1,2))/2) + lines(dot).point1(1,2);
            if (((abs(xdotval1-xdotval3)<distance) && (abs(ydotval1-ydotval3)<distance)) || ...
                    ((abs(xdotval1-xdotval4)<distance) && (abs(ydotval1-ydotval4)<distance)) || ...
                    ((abs(xdotval1-xdotval3point5)<distance) && (abs(ydotval1-ydotval3point5)<distance)) || ...
                    ((abs(xdotval2-xdotval3)<distance) && (abs(ydotval2-ydotval3)<distance)) || ...
                    ((abs(xdotval2-xdotval4)<distance) && (abs(ydotval2-ydotval4)<distance)) || ...
                    ((abs(xdotval2-xdotval3point5)<distance) && (abs(ydotval2-ydotval3point5)<distance)) || ...
                    ((abs(xdotval1point5-xdotval3)<distance) && (abs(ydotval1point5-ydotval3)<distance)) || ...
                    ((abs(xdotval1point5-xdotval4)<distance) && (abs(ydotval1point5-ydotval4)<distance)))                    
                dotproductsordered(r,dot) = real(acosd(((0 - (xdotval2-xdotval1))*((xdotval3-xdotval1)...
                - (xdotval4-xdotval1))+(0 - (ydotval2-ydotval1))*((ydotval3-ydotval1) - (ydotval4-ydotval1)))...
                /((((abs(xdotval1-xdotval2))^2+(abs(ydotval1-ydotval2))^2)^0.5)*((abs(xdotval3-xdotval4))^2+(abs(ydotval3-ydotval4))^2)^0.5)));
            elseif ((((ydotval2-ydotval1)/(xdotval2-xdotval1)) - ((ydotval4-ydotval3)/(xdotval4-xdotval3))) ~= 0)
                checkendsx = ((ydotval3-xdotval3*((ydotval4-ydotval3)/(xdotval4-xdotval3))-ydotval1+xdotval1*((ydotval2-ydotval1)/(xdotval2-xdotval1)))...
                    /(((ydotval2-ydotval1)/(xdotval2-xdotval1))-((ydotval4-ydotval3)/(xdotval4-xdotval3))));
                if (((((checkendsx < xdotval4) && (checkendsx > xdotval3)) || ((checkendsx > xdotval4) && (checkendsx < xdotval3)))...
                        && (((checkendsx < xdotval2) && (checkendsx > xdotval1)) || ((checkendsx > xdotval2) && (checkendsx < xdotval1)))) ...
                        && (abs(lines(r).theta - lines(dot).theta) < 15))
                    dotproductsordered(r,dot) = -139;
                end
            end
        end
    end

    %% Initialise variables
    finallines = [];
    linkedlines = [];
    indexvalue = 1;
    angleallowance = 20;
    rightanglethreshold = 90 - angleallowance;
    rightanglethresholdmax = 90 + angleallowance;


    % Remove lines that do not have a dot product over the threshold which
    % is set close to 90 degrees. It may be lowered relative to factors
    % such as camera angle to the dominos. An output array called
    % finallines is the remaining lines, while another output array called
    % linked lines, is an array of each linkage between two dominos meeting
    % these crieria
    for ninetydegrees = 1:length(lines)
        xval1 = lines(ninetydegrees).point1(1,1);
        yval1 = lines(ninetydegrees).point1(1,2);
        xval2 = lines(ninetydegrees).point2(1,1);
        yval2 = lines(ninetydegrees).point2(1,2);
        % Compare against every line to determine the angles between each
        for ninetyonedegrees = 1:(length(lines))                        
            if (((abs(dotproductsordered(ninetydegrees,ninetyonedegrees)) > rightanglethreshold) && ...
                    (abs(dotproductsordered(ninetydegrees,ninetyonedegrees)) < rightanglethresholdmax)) || ...
                    ((dotproductsordered(ninetydegrees,ninetyonedegrees)) == (-139)))
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

    %% Remove redundant rows as some rows are repeated. The output array is
    % called finalfinallines
    
    finalfinallines = unique(finallines, 'rows');
    
    %% Goes through the detected lines and linked lines arrays in order to
    % collect a further array where each line contains the indices of all
    % lines that comprise that domino. This output array is called
    % 'dominos'

    % Variable initialisation
    dominos = [];
    linkedlinesdim = [];

    %% The first block checks the first entry of the linkedlines array, to
    % see if it matches any existing entries in the new dominos array.
    
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
        
        %% The next section only runs if the first entry of the current
        % linkedlines match has been detected, in order to determine
        % whether its matching entry has also already been added. If not,
        % it will be added to the same row as it belongs to the same
        % domino.
        
        % The zerovalue variable will store the new cell to be written to
        % for the entry
        zerovalue = 0;
        % The variable zerofound is used to break the loop when an empty
        % zell is found to write to
        zerofound = 0;
        % The redundant found variable is used to advise that 
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
            % If the paired line is not a pre-existing/redundant entry
            if redundantfound == 0
                % If a zero entry was found (a place to write it to)
                if zerofound == 1
                    % Add it to the dominos array at the detected cell
                    dominos(indexmatch,zerovalue) = linkedlines(checkheight,2);
                % Otherwise, the row takes up all current columns. Add a new
                % column in order to add the entry
                else
                    dominos(indexmatch,dominodim(1,2)+1) = linkedlines(checkheight,2);
                end
            end
        end
        
        %% Check the second entry of the linkedlines array in the same
        % manner that we checked the first. The code is mostly the same as
        % the above block.
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
        
        % If the second entry of linkedlines was found to contain a match,
        % add the first entry if it doesnt already exist. This is also very
        % similar to the manner employed for a match of the first variable
        zerovalue2 = 0;
        zerofound2 = 0;
        redundantfound2 = 0;
        if entrymatch ~= 0  && entrymatchfalse == 0
            while redundantfound2 == 0 && zerofound2 ~= 1
                for checkredundant2 = 1:dominodim(1,2)
                    if dominos(entrymatch,checkredundant2) == linkedlines(checkheight,1)
                        redundantfound2 = checkredundant2;
                    end
                    if dominos(entrymatch,checkredundant2) == 0
                        zerovalue2 = checkredundant2;
                        zerofound2 = 1;
                        break
                    end
                end
                break
            end
            if redundantfound2 == 0
                if zerofound2 == 1
                    dominos(entrymatch,zerovalue2) = linkedlines(checkheight,1);
                else
                    dominos(entrymatch,dominodim(1,2)+1) = linkedlines(checkheight,1);
                end
            end
        end
        
        %% If neither the first or second entry were found to already exist 
        % in the dominos array, add them both as a new domino
        if entrymatch == 0 && entrymatchfalse == 0
            dominos(dominodim(1,1)+1,1) = currentindexvalue;
            dominos(dominodim(1,1)+1,2) = linkedlines(checkheight,2);
        end
    end
    
    %% The following finds the largest and smallest x and y value for each
    % domino in order to later use these values when determining a bounding
    % box for showing detection, and passing to tracking. The array
    % 'bounds' contains these values with map like referencing. These
    % references become irritating later when i switch to x and y
    % coordinates, but what else can you do when you later decide that your
    % previous system was confusing and flawed

    dominodim = size(dominos);
    dominorowindex = 1;
    
    % Remove dominos that have no perpendicular sides
    for eachdom = 1:dominodim(1,1)
        checkdom = 0;       
        for eachentry = 1:dominodim(1,2)
            currentline = dominos(eachdom,eachentry);
            for checkrest = 1:dominodim(1,2)
                if (((dominos(eachdom,checkrest)) ~= 0) && (currentline ~= 0))
                    if (dotproductsordered(dominos(eachdom,checkrest),currentline) > rightanglethreshold)...
                            && (dotproductsordered(dominos(eachdom,checkrest),currentline) < rightanglethresholdmax)
                        checkdom = 1;
                        break
                    end
                end
            end
        end
        % Add only dominos with at least one (close to) perpendicular set
        % of sides
        if checkdom == 1
            for adddomino = 1:dominodim(1,2)
                dominoswithduplicates(dominorowindex,adddomino) = dominos(eachdom,adddomino);
            end
            dominorowindex = dominorowindex + 1;
        end
    end
    
    % Previous method creates many duplicate rows. Remove them
    dominosbutoverlap = unique(dominoswithduplicates, 'rows');
    
    % This code will remove occasions where domino lines have become split
    % and subsequently appear to be separate dominos when they arent
    dominosactual = []; 
    dominosbutoverlapdim = size(dominosbutoverlap);
    currentrow = 1;
    % For each domino in the current domino array
    for currentdomino = 1:dominosbutoverlapdim(1,1)
        domsplit = 0;
        rowmatch = 0;
        % For the first row, no duplicates possible so add it straight in
        if currentdomino == 1
            for addfirst = 1:dominosbutoverlapdim(1,2)
                dominosactual(1,addfirst) = dominosbutoverlap(1,addfirst);                
            end
            currentrow = 2;
        % If not the first domino    
        else
            while domsplit == 0
                % For each entry of the current domino
                for others = 1:dominosbutoverlapdim(1,2)
                    % Compare against every previously added domino row to new
                    % array
                    dominosactualdim = size(dominosactual);
                    for checkprevdoms = 1:dominosactualdim(1,1)
                        % Check against every entry in each domino row
                        for checkprevdomvals = 1:dominosactualdim(1,2)
                            % Ensure that we havent reached the zero entries
                            if dominosactual(checkprevdoms,checkprevdomvals) ~= 0
                                % If there is a match anywhere, the domino has
                                % become split and must be rejoined
                                if dominosbutoverlap(currentdomino,others) == dominosactual(checkprevdoms,checkprevdomvals)
                                    rowmatch = checkprevdoms;
                                    domsplit = 1;
                                end
                            end
                        end
                    end
                end
                break
            end
            % If the domino needs to be combined from separate domino rows
            if domsplit == 1
                currentsecond = 1;
                % For all entries of the domino in the old array
                for addall = 1:dominosbutoverlapdim(1,2)
                    % If the current entry is not a zero entry
                    if dominosbutoverlap(currentdomino,addall) ~= 0
                        % Find the next zero free in the domino to which it
                        % is to be added (the matched one)
                        zerofinder = 0;
                        while zerofinder == 0
                            dominosactualdim = size(dominosactual);
                            for findzero = 1:dominosactualdim(1,2)
                                if dominosactual(rowmatch,findzero) == 0
                                    zerofinder = 1;
                                    break
                                end
                            end
                            break
                        end
                        % Check for entries already in the combined domino
                        dominosactualdim = size(dominosactual);
                        dontadd = 0;
                        dominosbutoverlapdim = size(dominosbutoverlap);
                        for checkeach = 1:dominosbutoverlapdim(1,2)
                            if dominosactual(rowmatch,checkeach) == dominosbutoverlap(currentdomino,addall)
                                dontadd = 1;
                            end
                        end
                        % Add entries that are not already in the domino,
                        % that belong there
                        if dontadd == 0
                            if zerofinder == 1
                                dominosactual(rowmatch,findzero) = dominosbutoverlap(currentdomino,addall);
                            else
                                dominosactual(rowmatch,(dominosactualdim(1,2)+1)) = dominosbutoverlap(currentdomino,addall);
                            end
                        end
                    end
                end
                currentrow = currentrow + 1;
            end
            % Add the domino row normally if it was not split
            if domsplit == 0
                for addnonsplit = 1:dominosbutoverlapdim(1,2)
                     if dominosbutoverlap(currentdomino,addnonsplit) ~= 0
                        dominosactual(currentrow,addnonsplit) = dominosbutoverlap(currentdomino,addnonsplit);
                     end
                end
                currentrow = currentrow + 1;
            end
        end
    end
    
    % Remove any redundant rows, and also any zero rows as a result of the
    % row combinations
    dominosactual = unique(dominosactual, 'rows');
    dominosactual = dominosactual(any(dominosactual,2),:);

    ffldim = size(finalfinallines);
    bounds = [];
    
    dominosactualdim = size(dominosactual);

    % For each domino line cluster found previously, find each extreme
    for everydomino = 1:dominosactualdim(1,1)
        setn = -1;
        sete = -1;
        sets = -1;
        setw = -1;
        currentn = 0;
        currente = 0;
        currents = 0;
        currentw = 0;
        % For North (the minimum y value)
        % For each column entry in the domino line collection
        for dominon = 1:dominosactualdim(1,2)
            % Set the current domino line entry value to compare
            currentlineeval1 = dominosactual(everydomino,dominon);    
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

        % For East (the maximum x value)
        for dominoe = 1:dominosactualdim(1,2)
            currentlineeval2 = dominosactual(everydomino,dominoe);  
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

        % For South (the maximim y value)
        for dominoso = 1:dominosactualdim(1,2)
            currentlineeval3 = dominosactual(everydomino,dominoso);
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

        % For West (the minimum x value)
        for dominow = 1:dominosactualdim(1,2)
            currentlineeval4 = dominosactual(everydomino,dominow); 
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


    %% Find the longest line on each domino as it will be the long edge
    % and is later useful for orientation and position

    longestline = [];
    mindomsize = 90;
    maxdomsize = 140;
%     mindomsize = 1;
%     maxdomsize = 500000;


    for each = 1:dominosactualdim(1,1)  
        if abs(bounds(each,3)-bounds(each,1)) < maxdomsize && ...
                abs(bounds(each,3)-bounds(each,1)) > mindomsize && ...
                abs(bounds(each,4)-bounds(each,2)) < maxdomsize && ...
                abs(bounds(each,4)-bounds(each,2)) > mindomsize
            if (bounds(each,3)-bounds(each,1)) > (bounds(each,2)-bounds(each,4))
                longestline(each,1) = bounds(each,3)-bounds(each,1);
                longestline(each,2) = (bounds(each,3)-bounds(each,1))/(bounds(each,2)-bounds(each,4));
            else
                longestline(each,1) = bounds(each,2)-bounds(each,4);
                longestline(each,2) = (bounds(each,2)-bounds(each,4))/(bounds(each,3)-bounds(each,1));
            end
        end
    end
    
    %% Display original image with lines superimposed over it to show
    % the detection
    figure, imshow(I), hold on
    max_len = 0;


    % Find the height (effective length) of finalfinallines
    heightref = size(finalfinallines);

    % Draw markers between start and end points as cleared
    for k = 1:heightref(1)
       plot([finalfinallines(k,2),finalfinallines(k,4)],[finalfinallines(k,3),finalfinallines(k,5)],'LineWidth',2,'Color','green');  
    end
    
    %% Dominos must be between a certain size as known by their dimensions,
    % therefore if a bounding box is too big or too small, the domino is
    % not passed on as it must not be a real domino. These bounds are
    % provided as variables. Dominos that pass this test are passed to an
    % array called trackingin, which is later fed into tracking as initial
    % domino bounding box positions

    filteredonly = [];
    filtered = 1;
    trackingin = [];
    trackingindim = length(trackingin);

    for drawboxes = 1:dominosactualdim(1,1)
        % Uses geometry to find the length across the diagonal of a
        % bounding box as this is longer than any one side may have been.
        currentsize = ((abs(bounds(drawboxes,3)-bounds(drawboxes,1)))^2 + (abs(bounds(drawboxes,2)-bounds(drawboxes,4)))^2)^0.5;
        if (currentsize > mindomsize) && (currentsize < maxdomsize)
            for check = 1:5    
                filteredonly(filtered,check) = bounds(drawboxes,check);
            end
            plot([bounds(drawboxes,4),bounds(drawboxes,4)],[bounds(drawboxes,3),bounds(drawboxes,1)],'LineWidth',2,'Color','red');
            plot([bounds(drawboxes,2),bounds(drawboxes,2)],[bounds(drawboxes,3),bounds(drawboxes,1)],'LineWidth',2,'Color','red');
            plot([bounds(drawboxes,2),bounds(drawboxes,4)],[bounds(drawboxes,1),bounds(drawboxes,1)],'LineWidth',2,'Color','red');
            plot([bounds(drawboxes,2),bounds(drawboxes,4)],[bounds(drawboxes,3),bounds(drawboxes,3)],'LineWidth',2,'Color','red');           
            if filteredonly(filtered,1) < filteredonly(filtered,3)
                if trackingindim == 0 || filteredonly(filtered,1) < trackingin(filtered,1)
                    trackingin(filtered,2) = filteredonly(filtered,1);
                    trackingin(filtered,4) = (filteredonly(filtered,3) - filteredonly(filtered,1));
                end
            else
                if trackingindim == 0 || filteredonly(filtered,3) < trackingin(filtered,1)
                    trackingin(filtered,2) = filteredonly(filtered,3);
                    trackingin(filtered,4) = (filteredonly(filtered,1) - filteredonly(filtered,3));
                end
            end
            if filteredonly(filtered,2) < filteredonly(filtered,4)
                if trackingindim == 0 || filteredonly(filtered,2) < trackingin(filtered,2)
                    trackingin(filtered,1) = filteredonly(filtered,2);
                    trackingin(filtered,3) = (filteredonly(filtered,4) - filteredonly(filtered,2));
                end
            else
                if trackingindim == 0 || filteredonly(filtered,4) < trackingin(filtered,2)
                    trackingin(filtered,1) = filteredonly(filtered,4);
                    trackingin(filtered,3) = (filteredonly(filtered,2) - filteredonly(filtered,4));
                end
            end
            filtered = filtered + 1;
        end
    end

    %% Matches is a useful array containing a selection of information
    % passed into a number of other sections of the demo. It includes the
    % index of the longest line along the long edge of the domino, the
    % index of the longest line along the short edge of the domino, the 
    % length of each, the start and end x and y coordinates of each, the x
    % and y coordinates of the centrepoints of each, and the angle of each
    % domino where the zero angle is specified as the positive x direction,
    % with a rotation into positive y as a positive angle, and a rotation
    % into the negative y as a negative angle. If the angles ever reaches
    % 90 degrees in either direction, the origin of the angle switches to
    % the other end of the line and it is defined from there
    
    filteredonlydim = size(filteredonly);
    matches = [];

    % Takes the initial x and y values of a line determined as being a line
    % from each domino. It then finds the longest line on the same domino
    % that is perpendicular. 
    
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
                lengthj = ((xdotval8 - xdotval7)^2 + (ydotval8 - ydotval7)^2)^0.5;
                if lengthj > currentlongest
                    currentlongest = lengthj;
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

    % The original line may not have been the longest on its side. The
    % process is therefore repeated using the newly discovered lines as a
    % reference
    
    for eachdomino2 = 1:filteredonlydim
        currentlongest2 = 0;
        longestlocation2 = 0;
        % For each column in the dotproductsordered array
        for findperp2 = 1:dotproductsordereddim(1,1)
            if matches(eachdomino2,2) ~= 0
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
        end
        matches(eachdomino2,1) = longestlocation2; 
        matches(eachdomino2,3) = currentlongest2;
    end
    
    % Although the long lines along each have now been determines, it is
    % not clear which is the longer edge and which is the shorter edge. The
    % following takes the current arrangement, and if the second line is
    % longer than the first, it swaps them such that it is consistent and
    % may be referred to later.
    
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

    % This is the block of code that finds the centrepoint of each domino
    % using the long lines that were just found. It uses the principle that
    % if the longest short edge is not close to an end point of the longer
    % line, that it must be the centreline of the domino. This is the ideal
    % case as averaging the x and y values for both ends of this line will
    % yield the centrepoint of the domino, as the line passes through it.
    % If the line is however one of the ends of the domino, the coordinates
    % are effectively translated using the coordinates of the longer edge,
    % so that it is as if the shorter edge line was infact the centreline
    % of the domino. The process then works as before. The resultant
    % centrepoint for the domino is written into 'matches' columns 13 and
    % 14 as mentioned previously
    
    matchesdim = size(matches);
    for midfinder = 1:matchesdim(1,1)
        notthemiddle = 0;
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
                    || matches(midfinder,8) > matches(midfinder,10) || matches(midfinder,8) > matches(midfinder,12);
                matches(midfinder,13) = round(newx - (matches(midfinder,11)-matches(midfinder,9))/2);
                matches(midfinder,14) = round(newy - (matches(midfinder,12)-matches(midfinder,10))/2);
            else
                matches(midfinder,13) = round(newx + (matches(midfinder,11)-matches(midfinder,9))/2);
                matches(midfinder,14) = round(newy + (matches(midfinder,12)-matches(midfinder,10))/2);
            end
        end
        
        % This code determines the angle of the domino. It works by finding
        % which coordinate of x for the longer edge is the greater one, and
        % which is the shorter. The arctan is then taken to determine the
        % angle using basic trigonometry. A special case exists at 90
        % degrees, where a divide-by-zero error presents due to the
        % unchanged x value. This is the purpose of the hard-written value
        % of 90 degrees for this instance
        
        longx1 = 0;
        longx2 = 0;
        longy1 = 0;
        longy2 = 0;
        dividebyzero = 0;
        if matches(midfinder,5) > matches(midfinder,7)
            longx1 = matches(midfinder,7);
            longx2 = matches(midfinder,5);
            longy1 = matches(midfinder,8);
            longy2 = matches(midfinder,6);
        elseif matches(midfinder,5) < matches(midfinder,7)
            longx1 = matches(midfinder,5);
            longx2 = matches(midfinder,7);
            longy1 = matches(midfinder,6);
            longy2 = matches(midfinder,8);
        else
            dividebyzero = 1;
        end
        if dividebyzero == 0
            matches(midfinder,15) = atand((longy1-longy2)/(longx2-longx1));
        else
            matches(midfinder,15) = 90;
        end
            
    end
    
    toc
    
end

            