clear all;
close all;
clc

cMap = [0 0.4470 0.7410;
    0.8500 0.3250 0.0980];
dotSize = 15;
lineWidth = 2;

digit3 = importdata("Data/digit3.m","-mat");

k=size(digit3,1);
m=size(digit3,2);
n=size(digit3,3);
disp(n);

t = tiledlayout(2, 2, "TileSpacing", "compact");

nexttile;
axis equal;
box on;
plotShapes2(digit3,cMap(1,:),false,false,lineWidth,dotSize);

newDigit3 = translateShapes(digit3);
nexttile;
axis equal;
box on;
plotShapes2(newDigit3,cMap(1,:),false,false,lineWidth,dotSize);

estMean = (1/n)*sum(newDigit3,3);
nexttile;
axis equal;
box on;
plotShapes2(newDigit3,cMap(1,:),false,false,lineWidth,dotSize);
plotShapes2(estMean,cMap(2,:),true,false,lineWidth,dotSize);

nexttile;
axis equal;
box on;

[alignedShapes, meanShape] = GPA(digit3,0.000001);
plotShapes2(alignedShapes,cMap(1,:),false,false,1,dotSize);
plotShapes2(meanShape,cMap(2,:),true,false,lineWidth,dotSize);

disp(calculateCentroidSizes(alignedShapes));
%print(gcf,'GPAfig.png','-dpng','-r300');

t = tiledlayout(2, 2, "TileSpacing", "compact");
nexttile
axis equal;
box on;
[alignedShapes2, meanShape2] = pGPA(digit3,0.000001);
plotShapes2(meanShape,cMap(2,:),true,false,lineWidth,dotSize);
plotShapes2(meanShape2,cMap(1,:),true,false,lineWidth,dotSize);

disp(dist(meanShape2, meanShape, "riem"));
