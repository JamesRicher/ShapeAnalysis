function R = optRotation(shape,targetShape)
%optRotation computes the optimal rotation of shape onto targetShape

    [U,D,V]=svd(targetShape'*shape);
    
    % Check the sign of the covariance matrix
    if (det(targetShape'*shape) <0)
        M = [1, 0;
            0, -1];
        R = ((M*(V'))')*(U');
    else
        R = V*(U');
    end
end

