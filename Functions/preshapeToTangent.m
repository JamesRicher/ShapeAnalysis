function [coords, poleCoords] = preshapeToTangent(preShapes,pole)
% preshapeToTangent calculates the Procrustes tangent coordinates for preShapes in Helmertized form with respect to a pole preshape
    
    disp(size(preShapes(:,:,1)));
    k=size(preShapes,1);
    m=size(preShapes,2);
    n=size(preShapes,3);
    
    coords = zeros(m*k,n);
    poleCoords = reshape(pole,[m*k,1]);
    
    for i=1:n
        R = optRotation(preShapes(:,:,i), pole);
        shape = preShapes(:,:,i)*R;
        shape = reshape(shape,[m*k,1]);
        coords(:,i) = (eye(m*k) - poleCoords*(poleCoords'))*shape;
    end
end

