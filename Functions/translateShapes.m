function translatedShapes = translateShapes(shapes)
%translateShapes translates shapes to have their centroids at the origin
    k=size(shapes,1);
    m=size(shapes,2);
    n=size(shapes,3);
    translatedShapes = zeros(k,m,n);
    
    centroids = calculateCentroids(shapes);
    for i=1:n
        for j=1:k
            translatedShapes(j,:,i) = shapes(j,:,i)-centroids(i,:);
        end
    end
end