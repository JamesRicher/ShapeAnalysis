clear all;
close all;
clc

equilateral = [0 0;
    1 0;
    0.5 sqrt(3/4)];

equilateral = scaleShapes(translateShapes(equilateral));
H = helm(3);

n=200;
tris = zeros(3,2,n);
tris = getRandomTriangles(n);
for i=1:n
    tris(:,:,i) = OPA(tris(:,:,i), equilateral, "partial");
end

subplot(1,2,1);
plotShapes(tris,"blue","x",false,false,1);
axis equal;

subplot(1,2,2);
triPreshapes = getPreshapes(tris, "helmert");
meanPreshape = getPreshapes(equilateral, "helmert");
[triTangents, poleTangentCoords] = preshapeToTangent(triPreshapes, meanPreshape,"proc");
triTangentShapes = zeros(3,2,n);
for i=1:n
    triTangentShapes(:,:,i) = (H')*tangentToPreshape(triTangents(:,i), poleTangentCoords);
end

plotShapes(triTangentShapes,"blue","x",false,false,1);
axis equal;
