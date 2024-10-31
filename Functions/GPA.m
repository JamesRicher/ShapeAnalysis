function [alignedShapes,meanShape] = GPA(shapes, tol)
%GPA performs (full) GPA on shapes with restpect to the tolerance 
%parameter tol

    k=size(shapes,1);
    m=size(shapes,2);
    n=size(shapes,3);
    
    % Variable to hold the shapes aligned to estimated mean shape
    shapesBuffer = zeros(k,m,n);
    it = 0;
    converged = false;
    
    % Centre the shapes and estimate the value of the mean shape
    shapes = translateShapes(shapes);
    estMean = scaleShapes((1/n)*sum(shapes,3));
    
    while (~converged)
        it = it + 1;
        
        % Align each shape to the estimated mean by OPA
        for i=1:n
            shapesBuffer(:,:,i) = OPA(shapes(:,:,i), estMean, "full");
        end
        
        % Estimate a new mean shape 
        newEstMean = scaleShapes((1/n)*sum(shapesBuffer,3));
        meanDiff = norm(newEstMean - estMean);
        disp(meanDiff);
        estMean = newEstMean;
        
        % Check if the convergence is sufficient
        converged = (meanDiff < tol/2);
    end
    
    fprintf("GPA complete in %d iterations",it);
    alignedShapes = shapesBuffer;
    meanShape = estMean;
end

