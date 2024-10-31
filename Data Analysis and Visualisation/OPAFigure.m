clear all;
close all;
clc

index1 = 1;
index2 = 2;
panf = importdata("Data/panf.m","-mat");
normalizedPanf = scaleShapes(translateShapes(panf));
cMap = [0 0.4470 0.7410;
    0.8500 0.3250 0.0980];

t = tiledlayout(2, 2, "TileSpacing", "compact")
nexttile;
% subplot(2,2,1);
pbaspect([1 1 1]);
axis equal;
box on;
plotShapes(panf(:,:,index1), cMap(1,:), "x", true, true);
plotShapes(panf(:,:,index2), cMap(2,:), "x", true, true);

% 
% subplot(2,2,2);
nexttile;
pbaspect([1 1 1]);
axis equal;
box on;
plotShapes(normalizedPanf(:,:,index1), cMap(1,:), "x", true, true);
plotShapes(normalizedPanf(:,:,index2), cMap(2,:), "x", true, true);

fAlignedShape = OPA(normalizedPanf(:,:,index1),normalizedPanf(:,:,index2), "partial");
% subplot(2,2,3);
nexttile;
pbaspect([1 1 1]);
axis equal;
box on;
plotShapes(fAlignedShape, cMap(1,:), "x", true, true);
plotShapes(normalizedPanf(:,:,index2), cMap(2,:), "x", true, true);

fAlignedShape = OPA(normalizedPanf(:,:,index1),normalizedPanf(:,:,index2), "full");
% subplot(2,2,4);
nexttile;
pbaspect([1 1 1]);
axis equal;
box on;
plotShapes(fAlignedShape, cMap(1,:), "x", true, true);
plotShapes(normalizedPanf(:,:,index2), cMap(2,:), "x", true, true);

disp(calculateCentroidSizes(fAlignedShape));
%print(gcf,'foo.png','-dpng','-r300');