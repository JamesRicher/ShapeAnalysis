function [X, Y, Z] = getTriangleSphericalCoords(r, phi)
%getTriangleSphericalCoords maps triangles expressed as (r, theta) to the unit sphere

    X = (1-r^2)/(1+r^2);
    Y = (2*r*cos(phi))/(1+r^2);
    Z = (2*r*sin(phi))/(1+r^2);
end

