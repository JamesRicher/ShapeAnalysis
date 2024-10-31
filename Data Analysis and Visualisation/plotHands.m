clear all;
close all;
clc

col = [0 0.4470 0.7410];
hands = readHandData("Data/shapes.txt");
normHands = scaleShapes(translateShapes(hands));

plotShapes(normHands(:,:,1),col,"o",true,false);
axis equal;
h = gca;
h.XAxis.Visible = 'off';
h.YAxis.Visible = 'off';

print(gcf,'hands.png','-dpng','-r300');