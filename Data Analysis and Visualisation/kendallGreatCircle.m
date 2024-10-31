clear all;
close all;
clc;

cMap = [0 0.4470 0.7410;
0.8500 0.3250 0.0980;
0.9290 0.6940 0.1250;
0.4940 0.1840 0.5560];
t = tiledlayout(1,3);
t.Padding = 'compact';
nexttile;

equilateral = [0 0;
    1 0;
    0.5 sqrt(3/4)];

n=100;
thetaVec = linspace(pi/2,2*pi + pi/2,n);
R = ones(size(thetaVec));

points = zeros(3,n);

points(2,:) = 0.5*R.*cos(thetaVec);
points(3,:) = 0.5*R.*sin(thetaVec);

equator = zeros(3,n);

equator(1,:) = 0.5*R.*cos(thetaVec);
equator(2,:) = 0.5*R.*sin(thetaVec);

N = 300;
thetavec = linspace(0,pi,N);
phivec = linspace(0,2*pi,2*N);
[th, ph] = meshgrid(thetavec,phivec);
R = ones(size(th)); % should be your R(theta,phi) surface in general

x = 0.5*R.*sin(th).*cos(ph);
y = 0.5*R.*sin(th).*sin(ph);
z = 0.5*R.*cos(th);

colormap gray;
surf(x,y,z,'EdgeAlpha',0,'FaceAlpha',0.75);
axis vis3d
hold on;

plot3(points(1,:),points(2,:),points(3,:),'LineWidth',4);
plot3(equator(1,:),equator(2,:),equator(3,:),"--k",'LineWidth',1);

[a,b,kendallCoords] = getTriangleCoords(equilateral);
scatter3(kendallCoords(1),kendallCoords(2),kendallCoords(3),60,'filled','MarkerFaceColor',cMap(2,:));

nexttile;
colormap gray;
surf(x,y,z,'EdgeAlpha',0,'FaceAlpha',0.75);
axis vis3d
hold on;

plot3(points(2,:),points(1,:),points(3,:),'LineWidth',4);
plot3(equator(1,:),equator(2,:),equator(3,:),"--k",'LineWidth',1);
scatter3(kendallCoords(1),kendallCoords(2),kendallCoords(3),60,'filled','MarkerFaceColor',cMap(2,:));

nexttile;
colormap gray;
surf(x,y,z,'EdgeAlpha',0,'FaceAlpha',0.75);
axis vis3d
hold on;



ang = 45;
points = zeros(3,n);
thetaVec = linspace(pi/2,2*pi + pi/2,n);
R = ones(size(thetaVec));

points(1,:) = 0.5*R.*cos(thetaVec);
points(3,:) = 0.5*R.*sin(thetaVec);

R = [1, 0, 0;
    0, cosd(ang), -sind(ang);
    0, sind(ang), cosd(ang)];

for i=1:n
    points(:,i) = R*points(:,i);
end

plot3(points(1,:),points(2,:),points(3,:),'LineWidth',4);
plot3(equator(1,:),equator(2,:),equator(3,:),"--k",'LineWidth',1);
scatter3(kendallCoords(1),kendallCoords(2),kendallCoords(3),60,'filled','MarkerFaceColor',cMap(2,:));

set(gcf,'position',[0,0,900,900]);
print(gcf,'kendallGreatCircles.png','-dpng','-r500');