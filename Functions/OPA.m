function outShape = OPA(shape,targetShape, type)
%OPA alignes shape to targetShape by full or partial OPA, specified by type

    k=size(shape,1);
    m=size(shape,2);
    outShape = zeros(k,m);

    switch type
        case "full"
            % Calculate the optimal scale and rotation
            R = optRotation(shape,targetShape);
            SF = (calculateCentroidSizes(targetShape))/(calculateCentroidSizes(shape));
            beta = SF*cos(dist(shape,targetShape, "riem"));
            
            outShape = beta*shape*R;
        case "partial"
            % Calculate the optimal rotation
            shape = scaleShapes(translateShapes(shape));
            targetShape = scaleShapes(translateShapes(targetShape));
            R = optRotation(shape,targetShape);
            
            for i=1:k
                outShape(i,:) = shape(i,:)*R;
            end
    end
end

