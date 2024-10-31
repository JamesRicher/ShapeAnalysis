clear all;
close all;
clc

cMap = [0 0.4470 0.7410;
    0.8500 0.3250 0.0980];
dotSize = 15;
lineWidth = 2;

index1=1;
index2=2;
index3=5;
index4=6;


digit3 = importdata("Data/digit3.m","-mat");
newDigit3 = scaleShapes(translateShapes(digit3));


t = tiledlayout(2, 2, "TileSpacing", "compact");

nexttile;
axis equal;
box on;
xlim([-0.5 0.5])
ylim([-0.5 0.5])
plotShapes2(newDigit3(:,:,index1),cMap(1,:),true,false,lineWidth,dotSize);
plotShapes2(newDigit3(:,:,index2),cMap(2,:),true,false,lineWidth,dotSize);

nexttile;
axis equal;
box on;
xlim([-0.5 0.5])
ylim([-0.5 0.5])
plotShapes2(newDigit3(:,:,index3),cMap(1,:),true,false,lineWidth,dotSize);
plotShapes2(newDigit3(:,:,index4),cMap(2,:),true,false,lineWidth,dotSize);

print(gcf,'distancesfig.png','-dpng','-r300');
disp(dist(newDigit3(:,:,index3), newDigit3(:,:,index4),"partial"));
disp(dist(newDigit3(:,:,index3), newDigit3(:,:,index4),"full"));
disp(dist(newDigit3(:,:,index3), newDigit3(:,:,index4),"riem"));