clear all;
close all;
clc;

n = 3;

cMap = [0 0.4470 0.7410;
    0.8500 0.3250 0.0980];

tris = getRandomTriangles(n);
equilateral = [0 0;
    1 0;
    0.5 sqrt(3/4)];

%plotShapes2(equilateral,"black",true,true,1,20);

equilateral = scaleShapes(translateShapes(equilateral));

t = tiledlayout(1, 2);
nexttile;
plotShapes2(tris,cMap(1,:),true,true,1,20);
axis square;
box on;

tris = scaleShapes(translateShapes(tris));

for i=1:n
    tris(:,:,i) = OPA(tris(:,:,i), equilateral, "partial");
end

nexttile;
plotShapes2(tris,cMap(1,:),true,true,1,20);
plotShapes2(equilateral,cMap(2,:),true,true,2,20);
box on;
axis equal;
xlim([-0.8,0.8]);
ylim([-0.8,0.8]);

print(gcf,'randomtris.png','-dpng','-r300');