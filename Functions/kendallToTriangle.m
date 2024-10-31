function tri = kendallToTriangle(kendallCoords)
%kendallToTriangle returns the triangle corresponding to a given point on kendalls shape space of triangles. The triangle is placed with landmarks 1 and 2 at (0,0) and (1,0) respectively.

    tol = 10e-14;
    
    X = kendallCoords(1)*2;
    Y = kendallCoords(2)*2;
    Z = kendallCoords(3)*2;
    
    % solve for the shape coordinates r and phi
    r = sqrt((1-X)/(1+X));
    phi = acos(Y*(1+r^2)/(2*r));
    
    if abs(Z- (2*r*sin(phi))/(1+r^2)) >= tol
        phi = 2*pi - phi;
    end
    
    % construct the landmarks of the triangle based on r and phi
    v = [1,0];
    R = [cos(phi), sin(phi);
        -sin(phi), cos(phi)];
    v = v*R;
    v = v*(sqrt(3)/2)*r;
    v = v + [0.5, 0];
    
    % assign the landmarks
    tri = zeros(3,2);
    tri(1,:) = [0,0];
    tri(2,:) = [1,0];
    tri(3,:) = v;
end

