# Integrate_Early
## Synopsis

A repository for team: 'Integrate Early, Upgrade Later' solution to the METR4202 2016 Practical 3: Domino sorting challenge. Contained is the various files, functions and scripts used. Detection used matlab toolboxes and the pdollar image detection libraries. Movement was accomplised via the use of dynamixes and their supporting sortware. Lifecam drivers were used in practice for image capture and a retrofitted A* algorithm was used for path planning.


## Contents
Main
Main logic loop handles all system logic and plays game

Detection
The central file is detection.m which searches a given image for dominoes. Metadata is produced which used by the face detection code to identify the dominoes to be sorted and those to be treated as obstacles. Object detection is accomplished by hough lines, and the use of size constraints and orthogonality as selection criteria. The detected lines were overlayed on the detection image as a separate figure.

Face_Detection
Face detection used hough circles and detection metadata to form polygons of the domino faces and count the number of hough circles within them. These values were then used to construct arrays detailing the dominoes in the system and their pertinent values (position, value and orientation).

Get_Next
Get_Next takes the results of Face_Detection returns the next domino to be sorted based on its index and resemblence to desired conditions.

Movement
The central file is mapping_parts.m which takes the array created by Path_Planning and uses it to determine what coordinates need to be sent to jimmy_testing.m and jimmy_testing_diag.m, the functions that were in charge of manipulating the robotic arm's motors to achieve wanted positions and movements. 

Path_Planning
A cell decomposition using the dimensions of dominoes as guides was used to create arrays (in tandem with Get_Next) for path planning. A repurposed A* tutorial as used to solve for a valid path. A visual display was created and the path was plotted for a predictive reference.

Runfiles
Miscellaneous runfiles that were accidentally committed

## Contributors
Bradley Spencer  s4321233@student.uq.edu.au

Bryden Page  s4319413@student.uq.edu.au

Samuel Williams  s4321966@student.uq.edu.au

Ryan Ferguson  s4323183@student.uq.edu.au

Brooke Schafer  s4316647@student.uq.edu.au


## License

Dynamixel
Software License Agreement (BSD License)

Copyright (c) 2014, ROBOTIS Inc.
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of ROBOTIS nor the names of its contributors may be
      used to endorse or promote products derived from this software
      without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY ROBOTIS "AS IS" AND ANY EXPRESS OR IMPLIED
WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL ROBOTIS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


A* (A Star) search for path planning tutorial
by Paul Premakumar
02 Jan 2010 (Updated 01 Sep 2016)
The A* search algorithm is a simple and effective technique that can be used to compute the shortest path to a target location. This tutorial presents a detailed description of the algorithm and an interactive demo.
http://au.mathworks.com/matlabcentral/fileexchange/26248-a---a-star--search-for-path-planning-tutorial


Structured Edge Detection
Dr Piotr Dollár
Edge detection was accomplished via the various pdollar libraries

Structured Edge Detection Toolbox
https://github.com/pdollar/edges

Matlab interpreter (tested with versions R2013a-2013b) and requires the Matlab Image Processing Toolbox

Piotr's Matlab Toolbox (version 3.26 or later)
https://pdollar.github.io/toolbox/

