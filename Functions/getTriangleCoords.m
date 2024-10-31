function [shapeCoords, sphericalCoords, kendallCoords] = getTriangleCoords(triangles)
%getTriangleCoords given a list of triangles, returns 3 sets of coordinates
%shapeCoords = [r, phi]
%sphericalCoords = [X, Y, Z] - points on the sphere
%kendallCoords = [X, Y, X] - sphericalCoords projected radially to the sphere of radius 0.5 centred at the origin

    n = size(triangles, 3);
    shapeCoords = zeros(2,n);
    sphericalCoords = zeros(3,n);
    kendallCoords = zeros(3,n);
    
    for i=1:n
        triangle = triangles(:,:,i)';
            
        %Get shape coordinates r and phi
        [r, phi] = getTriangleShapeCoords(triangle);
        shapeCoords(1,i) = r;
        shapeCoords(2,i) = phi;

        %Get hemisphere coordinates X, Y and Z
        [X, Y, Z] = getTriangleSphericalCoords(r, phi);
        sphericalCoords(1,i) = X;
        sphericalCoords(2,i) = Y;
        sphericalCoords(3,i) = Z;

        %Get Kendall coordinates
        d = lineSphereIntersect([0,0,0], [X, Y, Z], [0,0,0],0.5);
        kendallCoords(:,i) = d(1) * sphericalCoords(:,i);
    end
end

