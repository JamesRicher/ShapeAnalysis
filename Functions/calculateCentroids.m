function centroids= calculateCentroids(shapes)
%CALCULATECENTROIDS returns the centroid coordinates of the given shapes
    k=size(shapes,1);
    n=size(shapes,3);
    
    centroids = zeros(n,2);
    for i=1:n
        centroids(i,:) = (1/k)*[sum(shapes(:,1,i)),sum(shapes(:,2,i))];
    end
end

