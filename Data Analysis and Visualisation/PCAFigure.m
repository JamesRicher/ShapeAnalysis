clear all;
close all;
clc

cMap = [0 0.4470 0.7410;
0.8500 0.3250 0.0980;
0.9290 0.6940 0.1250;
0.4940 0.1840 0.5560];
n=10000;
mu = [0 0];
deviations = 3;
Sigma = [0.5 0.2; 0.2 1];

R = mvnrnd(mu,Sigma,n);
R = R';
CR = (1/n)*(R)*(R');
[P, CY] = eigs(CR);
disp(CY);
disp(CY(1,1)/(CY(1,1)+CY(2,2)));
SD1 = sqrt(CY(1,1));
SD2 = sqrt(CY(2,2));
p=scatter(R(1,:), R(2,:),15, cMap(1,:),'DisplayName','');
set(get(get(p,'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); 

axis equal;
set(gca,'XLim',[-4 4],'YLim',[-4 4]);
line([0,deviations*SD1*P(1,1)],[0,deviations*SD1*P(2,1)],'Color',cMap(2,:), 'LineWidth',2, 'DisplayName','PC1');
line([0,deviations*SD2*P(1,2)],[0,deviations*SD2*P(2,2)],'Color',cMap(3,:), 'LineWidth',2, 'DisplayName','PC2');

%plotting the ellipses
axis1 = 2*SD1;
axis2 = 2*SD2;
t = linspace(0, 360,2000);
x = axis1 * sind(t);
y = axis2 * cosd(t);
M = [x;y];
M = P*M;
hold on;
plot(M(1,:), M(2,:), '-', 'LineWidth', 2,'Color',cMap(4,:),'DisplayName','');

axis1 = 3*SD1;
axis2 = 3*SD2;
t = linspace(0, 360,2000);
x = axis1 * sind(t);
y = axis2 * cosd(t);
M = [x;y];
M = P*M;
hold on;
plot(M(1,:), M(2,:), '-', 'LineWidth', 2,'Color',cMap(4,:));

axis1 = 1*SD1;
axis2 = 1*SD2;
t = linspace(0, 360,2000);
x = axis1 * sind(t);
y = axis2 * cosd(t);
M = [x;y];
M = P*M;
hold on;
plot(M(1,:), M(2,:), '-', 'LineWidth', 2,'Color',cMap(4,:));

legend('PC1','PC2');
print(gcf,'PCAFigure.png','-dpng','-r300');