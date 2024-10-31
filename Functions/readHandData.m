function shapes = readHandData(handsFilepath)
%READHANDDATA Summary of this function goes here
    handsID = fopen(handsFilepath);
    A = fscanf(handsID, '%f');
    
    for r = (1:40)
        shapes(:,:,r) = [(A(r:40:4480/2))'; (A(4480/2+r:40:4480))';]';
    end
end