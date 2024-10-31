clear all;
close all;
clc

%Preliminary definitions
cMap = [0 0.4470 0.7410;
0.8500 0.3250 0.0980;
0.9290 0.6940 0.1250;
0.4940 0.1840 0.5560];
shells = importdata("Data/shells.m","-mat");
k = size(shells,1);
m = size(shells,2);
n = size(shells,3);
H = helm(k);

%Align the shells by GPA to find a mean shape
[alignedShells, meanShell] = GPA(shells,0.0001);
%subplot(2,2,1);
plotShapes(alignedShells, cMap(1,:), "x",true,true,0.5);
hold on;
plotShapes(meanShell, cMap(2,:), "x",true,true,2);

axis square;
box on;
print(gcf,'shellsa.png','-dpng','-r500');

%Compute the Helmeterized pre-shapes
shellPreshapes = getPreshapes(alignedShells,"helmert");
polePreshape = getPreshapes(meanShell,"helmert");

%Compute the tangent coords of the preshapes
[shellsTangentCoords, shellsPoleCoords] = preshapeToTangent(shellPreshapes, polePreshape, "proc");

shellsTangentShapes = zeros(k,m,n);
shellsTangentShapes(:,1,:) = (H')*(shellsTangentCoords(1:2,:)+polePreshape(:,1));
shellsTangentShapes(:,2,:) = (H')*(shellsTangentCoords(3:4,:)+polePreshape(:,2));
 


%Perform PCA on the shell data
[V,D, meanTangentCoords] = shapePCA(shellsTangentCoords);
disp(D)
sig = (sum(sum(D)));
disp(100*(D(1)/sig));
disp(100*(D(2)/sig));

componentLoadings = zeros(2,n);
for i=1:n
    componentLoadings(1,i) = sqrt(D(1))*dot(shellsTangentCoords(:,i),V(:,1));
    componentLoadings(2,i) = sqrt(D(2))*dot(shellsTangentCoords(:,i),V(:,2));
end


%subplot(2,2,4);
figure;
%Visualising PCA
weights = linspace(-3,3,100);
for j=1:2
    PCAshapes = zeros(3,2,length(weights));
    for i=1:length(weights)
        v = meanTangentCoords + weights(i)*sqrt(D(j))*V(:,j);
        vPreshape = tangentToPreshape(v, shellsPoleCoords);
        PCAshapes(:,:,i) = (H')*vPreshape;
    end
    
    [a,b,vKendallCoords] = getTriangleCoords(PCAshapes);
    p=plot3(vKendallCoords(1,:),vKendallCoords(2,:),vKendallCoords(3,:));
    p.LineWidth=2;
    p.Color = cMap(4,:);
    hold on;
end



[a,b,kendallCoords] = getTriangleCoords(shells);
for i=1:n
    scatter3(kendallCoords(1,i),kendallCoords(2,i),kendallCoords(3,i), 'filled','MarkerFaceColor',cMap(1,:));
    hold on;
end

N = 15;
thetavec = linspace(0,pi,N);
phivec = linspace(0,2*pi,2*N);
[th, ph] = meshgrid(thetavec,phivec);
R = ones(size(th)); % should be your R(theta,phi) surface in general

x = 0.5*R.*sin(th).*cos(ph);
y = 0.5*R.*sin(th).*sin(ph);
z = 0.5*R.*cos(th);
axis equal;

colormap gray;
surf(x,y,z,'EdgeAlpha',0.7,'FaceAlpha',1);
view(2);
axis vis3d;

box on;
print(gcf,'shellsd.png','-dpng','-r500');

weight = 3;
linethick =1.4

%subplot(2,2,2);
figure;
pcShapes = zeros(3,2,3);
pcShapes(:,:,1) = (H')*tangentToPreshape(meanTangentCoords -weight*sqrt(D(1))*V(:,1),shellsPoleCoords);
pcShapes(:,:,2) = (H')*tangentToPreshape(meanTangentCoords,shellsPoleCoords);
pcShapes(:,:,3) = (H')*tangentToPreshape(meanTangentCoords +weight*sqrt(D(1))*V(:,1),shellsPoleCoords);
plotShapes(pcShapes(:,:,2), cMap(2,:), "x",true,true,linethick);
hold on;
plotShapes(pcShapes(:,:,[1,3]), cMap(4,:), "x",true,true,linethick);
axis square;
box on;
print(gcf,'shellsb.png','-dpng','-r500');

%subplot(2,2,3);
figure
pcShapes = zeros(3,2,3);
pcShapes(:,:,1) = (H')*tangentToPreshape(meanTangentCoords -weight*sqrt(D(2))*V(:,2),shellsPoleCoords);
pcShapes(:,:,2) = (H')*tangentToPreshape(meanTangentCoords,shellsPoleCoords);
pcShapes(:,:,3) = (H')*tangentToPreshape(meanTangentCoords +weight*sqrt(D(2))*V(:,2),shellsPoleCoords);
plotShapes(pcShapes(:,:,2), cMap(2,:), "x",true,true,linethick);
hold on;
plotShapes(pcShapes(:,:,[1,3]), cMap(4,:), "x",true,true,linethick);
axis square;
box on;
print(gcf,'shellsc.png','-dpng','-r500');

figure;
i=8;
shell1 = alignedShells(:,:,i);
plotShapes(shell1,"blue","x" ,true,true,1);


shell2 = tangentToPreshape(shellsTangentCoords(:,i), shellsPoleCoords);
shell2 = (H')*shell2;
plotShapes(shell2,"red","o" ,true,true,1);