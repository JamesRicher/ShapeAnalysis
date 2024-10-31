clear all;
close all;
clc

cMap = [0 0.4470 0.7410;
0.8500 0.3250 0.0980];
dotSize = 15;
lineWidth = 2;

digit3 = importdata("Data/digit3.m","-mat");

newDigit3 = scaleShapes(translateShapes(digit3));
k=size(digit3,1);
m=size(digit3,2);
n=size(digit3,3);

axis equal;
box on;
[alignedShapes, meanShape] = pGPA(newDigit3, 0.000001);
plotShapes2(alignedShapes,cMap(1,:),false,false,lineWidth,dotSize);
plotShapes2(meanShape,cMap(2,:),true,false,lineWidth,dotSize);

print(gcf,'pGPAfig.png','-dpng','-r300');

[alignedShapes2, meanShape2] = GPA(newDigit3, 0.000001);
disp(dist(meanShape, meanShape2,"riem"));
disp(dist(meanShape2, meanShape,"riem"));