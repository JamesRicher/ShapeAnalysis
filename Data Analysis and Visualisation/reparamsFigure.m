clear all;
close all;
clc;

cMap = [0 0.4470 0.7410;
0.8500 0.3250 0.0980;
0.9290 0.6940 0.1250;
0.4940 0.1840 0.5560];

t = tiledlayout(2,2);
nexttile;
range = [0,2*pi];
nPoints = 200;
index = 10;
dots = nPoints/index;

tVals = linspace(range(1), range(2), nPoints);

xVals = zeros(1, nPoints);
yVals = zeros(1,nPoints);
for i=1:nPoints
    xVals(i) = f(tVals(i));
    yVals(i) = g(tVals(i));
end

plot(xVals,yVals, 'LineWidth',2);
hold on;
axis square;

for i=1:dots
    scatter(xVals(1 + (i-1)*index),yVals(1 + (i-1)*index),60,cMap(1,:),'filled');
end

xline(0, 'LineWidth',1,'Color','black');
yline(0,'LineWidth',1,'Color','black');

t=title('\boldmath$\alpha(t)$','interpreter','latex');
t.FontSize = 19;

nexttile;
plot(tVals,tVals, 'LineWidth',1.5);
x=xlabel('\boldmath$t$','interpreter','latex');
x.FontSize=19;
y=ylabel('\boldmath$t$','interpreter','latex');
y.FontSize=19;


nexttile;
tValsNew = zeros(1, nPoints);
for i=1:nPoints
    tValsNew(i) = h(tVals(i));
    xVals(i) = f(tValsNew(i));
    yVals(i) = g(tValsNew(i));
end

plot(xVals,yVals, 'LineWidth',2, 'Color',cMap(2,:));
hold on;
axis square;

for i=1:dots
    scatter(xVals(1 + (i-1)*index),yVals(1 + (i-1)*index),60,cMap(2,:),'filled');
end

xline(0, 'LineWidth',1,'Color','black');
yline(0,'LineWidth',1,'Color','black');

t=title('\boldmath$\alpha(h(t))$','interpreter','latex');
t.FontSize = 19;

nexttile;
plot(tVals, tValsNew,'LineWidth',1.5, 'Color',cMap(2,:));
x=xlabel('\boldmath$t$','interpreter','latex');
x.FontSize=19;
y=ylabel('\boldmath$h(t)$','interpreter','latex');
y.FontSize=19;

set(gcf,'position',[0,0,900,900]);
print(gcf,'reparam.png','-dpng','-r500');

function y=f(x)
    y = sin(2*x)/(x^2+4);
end

function y=g(x)
    y = cos(2*x)/(x^2+4);
end

function y=h(x)
    y = (x^2)/(2*pi);
end