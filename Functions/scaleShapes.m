function scaledShapes = scaleShapes(shapes)
%scaleShapes scales the given shapes to have unit centroid size

    k=size(shapes,1);
    m=size(shapes,2);
    n=size(shapes,3);
    
    scaledShapes=zeros(k,m,n);
    
    centroidSizes = calculateCentroidSizes(shapes);
    centroids = calculateCentroids(shapes);
    translatedShapes = translateShapes(shapes);
    for i=1:n
        scaledShapes(:,:,i) = (1/centroidSizes(i))*translatedShapes(:,:,i);
        scaledShapes(:,:,i) = scaledShapes(:,:,i) + centroids(i,:);
    end
end

