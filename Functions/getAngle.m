function ang = getAngle(vec)
%Returns the vector in radians between zero and 2pi to rotate vec to the
%positive x-axis anti-clockwise
    x = vec(1);
    y = vec(2);
    ratio = (abs(y))/(abs(x));
    
    if (x>=0) && (y>=0)
        ang = 2*pi - atan(ratio);
    elseif (x<=0) && (y>=0)
        ang = pi + atan(ratio);
    elseif (x<=0) && (y<=0)
        ang = pi - atan(ratio);
    elseif (x>=0) && (y<=0)
        ang = atan(ratio);
    end
end