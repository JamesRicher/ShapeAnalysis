function tangentShape = tangentCoords(shape,pole,type)
%TANGENTCOORDS Projects a given shape into tangent space with respect to a
%pole pre-shape
    k=size(shape,1);
    m=size(shape,2);
    
    shapes = zeros(k,m,2);
    shapes(:,:,1) = shape;
    shapes(:,:,2) = pole;
    
    preShapes = scaleShapes(translateShapes(shapes));
    R = optRotation(preShapes(:,:,1), preShapes(:,:,2));
    rotatedShape = preShapes(:,:,1)*R;
    
    d = dist(preShapes(:,:,1),preShapes(:,:,2),"riem");
    procTangentShape = rotatedShape - cos(d)*preShapes(:,:,2);
    
    switch type
        case "proc"
            tangentShape = procTangentShape;
        case "exp"
            tangentShape = (d/sin(d))*procTangentShape;
    end
end

