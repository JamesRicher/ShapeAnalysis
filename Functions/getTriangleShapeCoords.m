function [r, phi] = getTriangleShapeCoords(triangle)
%getTriangleShapeCoords returns the shape coordinates (r, theta) pertaining to a given triangle

    midpoint = 0.5*(triangle(:,1) + triangle(:,2));
    
    midpointVector = triangle(:,3) - midpoint;    
    triangleVector = triangle(:,2) - midpoint;
    
    triangle = triangle - midpoint;
    
    %Calculate theta
    ang = getAngle(triangleVector);
    R = [cos(ang), -sin(ang);
        sin(ang), cos(ang)];
    rotatedMidpointVector = R*midpointVector;
    phi = 2*pi - getAngle(rotatedMidpointVector);
    
    %Calculate r
    r = (2*norm(midpointVector))/(sqrt(3)*norm(triangle(:,2)-triangle(:,1)));
end