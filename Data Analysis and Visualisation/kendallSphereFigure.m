clear all;
close all;
clc;

n = 1000;
tris = getRandomTriangles(n);
[shapeCoords, sphericalCoords, kendallCoords] = getTriangleCoords(tris);
cMap = [0 0.4470 0.7410;
0.8500 0.3250 0.0980];
daspect([1,1,1]);

N = 300;
thetavec = linspace(0,pi,N);
phivec = linspace(0,2*pi,2*N);
[th, ph] = meshgrid(thetavec,phivec);
R = ones(size(th)); % should be your R(theta,phi) surface in general

x = 0.5*R.*sin(th).*cos(ph);
y = 0.5*R.*sin(th).*sin(ph);
z = 0.5*R.*cos(th);

t = tiledlayout(1, 2);
nexttile;
colormap gray;
surf(x,y,z,'EdgeAlpha',0,'FaceAlpha',0.85);
axis vis3d
hold on;

for i=1:n
    scatter3(kendallCoords(1,i),kendallCoords(2,i),kendallCoords(3,i),30,'filled','MarkerFaceColor',cMap(1,:));
end

nexttile;
colormap gray;
h(1)=surf(x,y,z,'EdgeAlpha',0,'FaceAlpha',0.7);
axis vis3d
hold on;

shells = importdata("Data/shells.m","-mat");
n = size(shells,3);
[a, meanShell] = GPA(shells, 0.00001);

[a,b,kendallCoords] = getTriangleCoords(shells);

for i=1:n
    h(i+1) = scatter3(kendallCoords(1,i),kendallCoords(2,i),kendallCoords(3,i),40,'filled','MarkerFaceColor',cMap(1,:));
end
[a,b,kendallCoords] = getTriangleCoords(meanShell);
h(n+2)=scatter3(kendallCoords(1),kendallCoords(2),kendallCoords(3),60,'filled','MarkerFaceColor',cMap(2,:));

rotate(h, [1 0 0], 180)


set(gcf,'position',[0,0,1000,700]);
print(gcf,'kendallSphere.png','-dpng','-r300');
