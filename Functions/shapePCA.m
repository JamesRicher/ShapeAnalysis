function [V,D, meanCoords] = shapePCA(tangentCoords)
    k = size(tangentCoords,1);
    n = size(tangentCoords,2);
    
    %Calculate the sample covariance matrix
    meanCoords = (1/n)*sum(tangentCoords,2);
    Vbar = zeros(k,n);
    for i=1:n
        Vbar(:,i) = meanCoords;
    end
    
    CV = (1/n)*(tangentCoords - Vbar)*(tangentCoords - Vbar)';
    [V,D] = eig(CV);
   
    %Ensure that eigenvectors are sorted in descending amount of variance
    if ~issorted(diag(D))
        [V,D] = eig(CV);
        [D,I] = sort(diag(D));
        V = V(:, I);
    end
    
    D = flip(D);
    V = flip(V,2);
end