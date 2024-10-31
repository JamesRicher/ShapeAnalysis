close all;
clear all;
clc

shells = importdata("Data/shells.m","-mat");
k = size(shells,1);
m = size(shells,2);
n = size(shells,3);

shell = shells(:,:,1);

H = helm(k);
shape1 = (H'*H*shell);
shape2 = (translateShapes(shell));

preshapes1 = getPreshapes(shells,"helmert");
preshapes2 = getPreshapes(shells,"centred");

plotShapes(preshapes2(:,:,4),"blue","x",true,true,1);
plotShapes(H'*preshapes1(:,:,4),"red","x",true,true,1);

disp(preshapes2(:,:,4)-H'*preshapes1(:,:,4));