function [alignedShapes,meanShape] = pGPA(shapes, tol)
%PGPA Summary of this function goes here
    k=size(shapes,1);
    m=size(shapes,2);
    n=size(shapes,3);
    
    % variable to hold the shapes aligned to estimated mean shape
    shapesBuffer = zeros(k,m,n);
    it = 0;
    converged = false;
    
    % centre the shapes and estimate the value of the mean shape
    shapes = scaleShapes(translateShapes(shapes));
    estMean = scaleShapes((1/n)*sum(shapes,3));
    
    % align each shape to the estimated mean by OPA
    while (~converged)
        it = it + 1;
        
        for i=1:n
            shapesBuffer(:,:,i) = OPA(shapes(:,:,i), estMean, "partial");
        end
        
        newEstMean = scaleShapes((1/n)*sum(shapesBuffer,3));
        meanDiff = norm(newEstMean - estMean);
        estMean = newEstMean;
        
        converged = (meanDiff < tol/2);
    end
    
    fprintf("pGPA complete in %d iterations",it);
    alignedShapes = shapesBuffer;
    meanShape = estMean;
end

