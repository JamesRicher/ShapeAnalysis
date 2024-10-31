clear all;
close all;
clc;

cMap = [0 0.4470 0.7410;
0.8500 0.3250 0.0980;
0.9290 0.6940 0.1250;
0.4940 0.1840 0.5560];
shells = importdata("Data/shells.m","-mat");
k = size(shells,1);
m = size(shells,2);
n = size(shells,3);
H = helm(k);

index = 1;
[shells, meanShell] = GPA(shells, 0.000001);

shellPreshape = getPreshapes(shells(:,:,index), "helmert");
meanPreshape = getPreshapes(meanShell, "helmert");

plotShapes(shells(:,:,1), cMap(1,:),"x",true,true,1.7);
shellTangent = preshapeToTangent(shellPreshape(:,:,index), meanPreshape);

shellTangentShape = zeros(k,m);
shellTangentShape(:,1) = (H')*shellTangent(1:2) + meanShell(:,1);
shellTangentShape(:,2) = (H')*shellTangent(3:4) + meanShell(:,2);
hold on;
box on;
plotShapes(shellTangentShape,cMap(2,:),"x",true,true,1.7);

print(gcf,'tangentTriangle.png','-dpng','-r500');