% Array = [-15, 10; -15, 20; -10 20; -10, 25; 0 20; 10 20]
function [prez_x, prez_y] = mapping_parts(prez_x, prez_y, Array)

for i = 1:length(Array)-1
    x1 = Array(i,1)
    y1 = Array(i,2)
    
    x2 = Array(i+1,1)
    y2 = Array(i+1,2)
    
    jimmy_testing(prez_x, prez_y, x1, y1, x2, y2);
    
       
    prez_x = x2;
    prez_y = y2;
    
    %disp('one completion')
    
end
    
    
    