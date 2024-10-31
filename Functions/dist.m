function dist = dist(shape1,shape2,distType)
%dist returns full Procrustes, partial Procrustes or Riemannian distance between two shapes or pre-shapes

    k=size(shape1,1);
    m=size(shape1,2);
    
    shapes = zeros(k,m,2);
    shapes(:,:,1) = shape1;
    shapes(:,:,2) = shape2;
    
    % obtain centred pre-shapes
    preShapes = scaleShapes(translateShapes(shapes));
    C=preShapes(:,:,1)'*preShapes(:,:,2);
    e = eig(C'*C);
    e = (sqrt(e));
    
    % optimally sign the eigenvalues
    if det(C) <0
        e(1) = -e(1);
    end
    
    % calculate each type of distance using the sum of the optimally signed eigenvalues
    eSum = sum(e);
    switch distType
        case "partial"
            dist = sqrt(2)*sqrt(1-eSum);
        case "full"
            dist = sqrt(1-eSum^2);
        case "riem"
            dist = acos(eSum);
    end
end

