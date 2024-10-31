function centroidSizes = calculateCentroidSizes(shapes)
%CALCULATECENTROIDSIZES
%   Returns the centroid sizes of the given shapes as an array
    k=size(shapes,1);
    m=size(shapes,2);
    n=size(shapes,3);
    
    translatedShapes = translateShapes(shapes);
    centroidSizes = zeros(n,1);
    for i=1:n
        centroidSizes(i) = sqrt(sum(translatedShapes(:,1,i).^2 + translatedShapes(:,2,i).^2));
    end
end

