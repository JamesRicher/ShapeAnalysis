clear all;
close all;
clc

mice = importdata("Data/mice.m","-mat");
mice = mice(:,:,31:76);
k=size(mice,1);
m=size(mice,2);
n=size(mice,3);
cMap = [0 0.4470 0.7410;
0.8500 0.3250 0.0980];

newMice = zeros(k,m,n);
for i=1:n
    newMice(1,:,i) = mice(1,:,i);
    newMice(2,:,i) = mice(6,:,i);
    newMice(3,:,i) = mice(2,:,i);
    newMice(4,:,i) = mice(3,:,i);
    newMice(5,:,i) = mice(4,:,i);
    newMice(6,:,i) = mice(5,:,i);
end


[alignedMice, meanMouse] = GPA(newMice,0.00001);

% plotShapes(alignedMice,"blue","x",true,false,0.5);
% hold on;
% plotShapes(meanMouse, "black","x",true,true,1);

miceTris = zeros(3,m,n);
for i=1:n
    miceTris(1,:,i) = newMice(1,:,i);
    miceTris(2,:,i) = newMice(3,:,i);
    miceTris(3,:,i) = newMice(5,:,i);
end

[miceTris, meanTri] = GPA(miceTris, 0.00001);
miceTrisPreshapes = getPreshapes(miceTris,"helmert");
polePreshape = getPreshapes(meanTri,"helmert");
[miceTangentCoords, micePoleCoords] = preshapeToTangent(miceTrisPreshapes, polePreshape, "proc");
[V,D, meanTangentCoords] = shapePCA(miceTangentCoords);

disp(D);
disp(V);

sig = sum(D);
disp(100*(D(1)/sig));
disp(100*(D(2)/sig));

componentLoadings = zeros(2,n);
for i=1:n
    componentLoadings(1,i) = sqrt(D(1))*dot(miceTangentCoords(:,i),V(:,1));
    componentLoadings(2,i) = sqrt(D(2))*dot(miceTangentCoords(:,i),V(:,2));
end

scatter(componentLoadings(1,1:23), componentLoadings(2,1:23),40,"filled","MarkerFaceColor",cMap(1,:) );
hold on;
scatter(componentLoadings(1,24:46), componentLoadings(2,24:46),40,"filled","MarkerFaceColor",cMap(2,:) );
axis square;
xlabel('PC-1','FontWeight','bold');
ylabel('PC-2','FontWeight','bold');
print(gcf,'mousePCA.png','-dpng','-r500');

%%%%% Carrying out Hypothesis test %%%%%
smallSample = miceTangentCoords(:,1:23);
largeSample = miceTangentCoords(:,24:46);
m1 = size(smallSample,2);
m2 = size(largeSample,2);
smallMean = (1/m1)*sum(smallSample,2);
largeMean = (1/m2)*sum(largeSample,2);

smallCovariance = (1/m1)*(smallSample - smallMean)*(smallSample - smallMean)';
largeCovariance = (1/m2)*(largeSample - largeMean)*(largeSample - largeMean)';
pooledCovariance = (m1*smallCovariance + m2*largeCovariance)/(m1+m2-2);

Cinv = pinv(pooledCovariance);

Tsqr = ((smallMean - largeMean)')*Cinv*(smallMean - largeMean);
k=3;
n=2;
q = k*n - n -1 -((n-1)*n)/2;
F = (m1*m2*(m1+m2-q-1)*Tsqr)/((m1+m2)*(m1+m2-2)*q);
disp(F);

p = fcdf(F,q,m1+m2-q-1);
disp(p);
disp(1-p);

largeMice = miceTris(:,:,1:23);
smallMice = miceTris(:,:,24:46);

[a, largeMean] = GPA(largeMice, 0.00001);
[a, smallMean] = GPA(smallMice, 0.00001);

largeMean = OPA(largeMean, smallMean, "partial");

% plotShapes(largeMean,"red","x",true,true,0.5);
% plotShapes(smallMean,"blue","x",true,true,0.5);

[a,b,smallKendallCoords] = getTriangleCoords(largeMean);
[a,b,largeKendallCoords] = getTriangleCoords(smallMean);


% for i=1:size(smallMice,3)
%     scatter3(smallKendallCoords(1,i),smallKendallCoords(2,i),smallKendallCoords(3,i), 'filled','MarkerFaceColor',cMap(1,:));
%     hold on;
% end
% 
% for i=1:size(largeMice,3)
%     scatter3(largeKendallCoords(1,i),largeKendallCoords(2,i),largeKendallCoords(3,i), 'filled','MarkerFaceColor',cMap(2,:));
% end
% scatter3(smallKendallCoords(1),smallKendallCoords(2),smallKendallCoords(3), 50,'filled','MarkerFaceColor',cMap(1,:));
% hold on;
% scatter3(largeKendallCoords(1),largeKendallCoords(2),largeKendallCoords(3), 50,'filled','MarkerFaceColor',cMap(2,:));
% 
% N = 15;
% thetavec = linspace(0,pi,N);
% phivec = linspace(0,2*pi,2*N);
% [th, ph] = meshgrid(thetavec,phivec);
% R = ones(size(th)); % should be your R(theta,phi) surface in general
% 
% x = 0.5*R.*sin(th).*cos(ph);
% y = 0.5*R.*sin(th).*sin(ph);
% z = 0.5*R.*cos(th);
% axis equal;
% 
% colormap gray;
% surf(x,y,z,'EdgeAlpha',0.7,'FaceAlpha',1);
% view(2);
% axis vis3d;
% 
% print(gcf,'mouseMeans.png','-dpng','-r500');