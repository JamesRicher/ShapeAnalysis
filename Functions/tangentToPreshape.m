function preshape = tangentToPreshape(tangentCoords, poleTangentCoords)
%tangentToPreshape projects an element of the tangent space back onto the preshape sphere

    preshape = (sqrt(1-dot(tangentCoords, tangentCoords))*poleTangentCoords + tangentCoords);
    preshape = reshape(preshape, [],2);
end

