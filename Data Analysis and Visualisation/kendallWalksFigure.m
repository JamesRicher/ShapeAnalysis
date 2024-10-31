clear all;
close all;
clc;

cMap = [0 0.4470 0.7410;
0.8500 0.3250 0.0980;
0.9290 0.6940 0.1250;
0.4940 0.1840 0.5560];

n=28;
horizontalSpacing = 1.8;
verticalSpacing = 1.8;
thetaVec = linspace(pi/2,2*pi + pi/2,n);
R = ones(size(thetaVec));

%/////////////
%Walk 1
%/////////////
points = zeros(3,n);

points(2,:) = 0.5*R.*cos(thetaVec);
points(3,:) = 0.5*R.*sin(thetaVec);

tris = zeros(3,2,n);
for i=1:n
    tris(:,:,i) = scaleShapes(translateShapes(kendallToTriangle(points(:,i))));
    if (i <= 14)
        for j=1:3
            tris(j,:,i) = tris(j,:,i) + [horizontalSpacing*(i-1),0];
        end
    else
        for j=1:3
            tris(j,:,i) = tris(j,:,i) + [horizontalSpacing*(i-15),-verticalSpacing];
        end
    end
end

myPlotter(tris);
axis equal;
xlim([-1,25]);
ylim([-3,1]);
axis off;

print(gcf,'kendallWalk1.png','-dpng','-r500');
figure
subplot(1,2,1);

%/////////////
%Walk 2
%/////////////
figure

points = zeros(3,n);

points(1,:) = 0.5*R.*cos(thetaVec);
points(3,:) = 0.5*R.*sin(thetaVec);

tris = zeros(3,2,n);
for i=1:n
    tris(:,:,i) = scaleShapes(translateShapes(kendallToTriangle(points(:,i))));
    if (i <= 14)
        for j=1:3
            tris(j,:,i) = tris(j,:,i) + [horizontalSpacing*(i-1),0];
        end
    else
        for j=1:3
            tris(j,:,i) = tris(j,:,i) + [horizontalSpacing*(i-15),-verticalSpacing];
        end
    end
end

myPlotter(tris);
axis equal;
xlim([-1,25]);
ylim([-3,1]);
axis off;

print(gcf,'kendallWalk2.png','-dpng','-r500');

%/////////////
%Walk 3
%/////////////
figure

ang = 45;
points = zeros(3,n);

points(1,:) = 0.5*R.*cos(thetaVec);
points(3,:) = 0.5*R.*sin(thetaVec);

R = [1, 0, 0;
    0, cosd(ang), -sind(ang);
    0, sind(ang), cosd(ang)];

for i=1:n
    points(:,i) = R*points(:,i);
end

tris = zeros(3,2,n);
for i=1:n
    tris(:,:,i) = scaleShapes(translateShapes(kendallToTriangle(points(:,i))));
    if (i <= 14)
        for j=1:3
            tris(j,:,i) = tris(j,:,i) + [horizontalSpacing*(i-1),0];
        end
    else
        for j=1:3
            tris(j,:,i) = tris(j,:,i) + [horizontalSpacing*(i-15),-verticalSpacing];
        end
    end
end

myPlotter(tris);
axis equal;
xlim([-1,25]);
ylim([-3,1]);
axis off;

print(gcf,'kendallWalk3.png','-dpng','-r500');

function myPlotter(triangles)
    n = size(triangles,3);
    cMap = [0 0.4470 0.7410;
    0.8500 0.3250 0.0980;
    0.9290 0.6940 0.1250;
    0.4940 0.1840 0.5560];
    
    hold on;
    for i=1:n
        triangle = triangles(:,:,i)';
        scatter(triangle(1,1), triangle(2,1),30,cMap(1,:), 'o', 'filled');
        scatter(triangle(1,2), triangle(2,2), 30,cMap(3,:),'o',"filled");
        scatter(triangle(1,3), triangle(2,3), 30,cMap(4,:),"o","filled");
        
        line(triangle(1,[1 2]), triangle(2,[1 2]),'Color','black', 'Linewidth',1);
        line(triangle(1,[2 3]), triangle(2,[2 3]),'Color','black', 'Linewidth',1);
        line(triangle(1,[1 end]), triangle(2,[1 end]),'Color','black', 'Linewidth',1);
    end
    
    hold off;
end