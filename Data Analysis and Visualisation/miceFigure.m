clear all;
close all;
clc

Cmap1 = parula(2); 

digit3 = importdata("Data/digit3.m","-mat");
sooty = importdata("Data/sooty.m","-mat");
mice = importdata("Data/mice.m","-mat");
gorf = importdata("Data/gorf.m","-mat");
panf = importdata("Data/panf.m","-mat");

figure;
pbaspect([1 1 1]);
subplot(2,2,1)
axis equal;
plotShapes(panf(:,:,1:2),"black","o",true,true);
box on;
ha = gca;

ss = scaleShapes(translateShapes(panf));
subplot(2,2,2)
axis equal;
box on;
ha = gca;
plotShapes(ss(:,:,1:2),"black","o",true,true);

newShape = OPA(ss(:,:,6),ss(:,:,7),"partial");
subplot(2,2,3)
axis equal;
box on;
ha = gca;
plotShapes(newShape,"black","o",true,true);
plotShapes(ss(:,:,7),"black","o",true,true);

newShape2 = OPA(ss(:,:,6), ss(:,:,7), "full");
subplot(2,2,4)
axis equal;
box on;
ha = gca;
plotShapes(newShape2,"black","o",true,true);
plotShapes(newShape, "red","o",true,true);
%plotShapes(ss(:,:,7),"black","o",true,true);

% newDigit3 = scaleShapes(translateShapes(digit3));
% plotShapes(newDigit3(:,:,6),"blue","x",true,false);

% subplot(2,2,1)
% tangentShape = newDigit3(:,:,6)+tangentCoords(newDigit3(:,:,5),newDigit3(:,:,6));
% plotShapes(tangentShape,"blue","x", true);
% 
% plotShapes(rotateShape(newDigit3(:,:,5),newDigit3(:,:,6)),"red","x",true);
% 
% disp(norm(tangentShape,'fro'));
% disp(dist(digit3(:,:,1),digit3(:,:,1),"riem"));
%plot(tangentCoords(digit3(:,:,1),digit3(:,:,1)));


% smallMice = mice(:,:,76-22:76);
% smallMicePreshapes = scaleShapes(translateShapes(smallMice));
% 
% subplot(2,2,1)
% plotShapes(smallMicePreshapes,"red","x",false);