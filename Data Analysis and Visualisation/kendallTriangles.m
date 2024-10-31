clear all;
close all;
clc

cMap = [0 0.4470 0.7410;
0.8500 0.3250 0.0980];

k=3;
m=2;
n=1000;
tris = zeros(m,k,n);

equilateral = [0 0;
    1 0;
    0.5 sqrt(3/4)];


Q = [1/sqrt(3) -1/sqrt(2) -1/sqrt(6);
    1/sqrt(3) 1/sqrt(2) -1/sqrt(6);
    1/sqrt(3) 0 2/sqrt(6)];

%Generate random triangles
for i=1:n
    tris(:,1,i) = [normrnd(0,1) normrnd(0,1)];
    tris(:,2,i) = [normrnd(0,1) normrnd(0,1)];
    tris(:,3,i) = [normrnd(0,1) normrnd(0,1)];
end

%Centre triangles
centroid = zeros(2,1);
for i=1:n
    centroid = centroid + tris(:,1,i);
    centroid = centroid + tris(:,2,i);
    centroid = centroid + tris(:,3,i);
    centroid = centroid/3;
    
    tris(:,1,i) = tris(:,1,i) - centroid;
    tris(:,2,i) = tris(:,2,i) - centroid;
    tris(:,3,i) = tris(:,3,i) - centroid;
end

%Get shape shape coordinates r and phi
coords = zeros(2,n);
ang = 0;
for i=1:n
    tri = tris(:,:,i)';
    ratio = abs(tri(2,2))/abs(tri(2,1));
    if (tri(2,1) >= 0) && (tri(2,2) >= 0)
        ang = 2*pi - atan(ratio);
    elseif (tri(2,1) <= 0) && (tri(2,2) >= 0)
        ang = pi + atan(ratio);
    elseif (tri(2,1) <= 0) && (tri(2,2) <= 0)
        ang = pi - atan(ratio);
    elseif (tri(2,1) >= 0) && (tri(2,2) <= 0)
        ang = atan(ratio);
    end
    
    midpoint = 0.5*(tris(:,1,i) + tris(:,2,i));
    v = tris(:,2,i) - tris(:,1,i);
    rotMat = [cos(ang), -sin(ang);
        sin(ang), cos(ang)];
    vRotated = rotMat*v;
    r = norm(midpoint - tris(:,3,i));
    r = r *(2/sqrt(3));
    coords(:,i) = [r, ang];
end

%Calculate [X Y Z]
positions = zeros(n,3);
for i=1:n
    r = coords(1,i);
    phi = coords(2,i);
    
    X = (1-r^2)/(1+r^2);
    Y = (2*r*cos(phi))/(1+r^2);
    Z = (2*r*sin(phi))/(1+r^2);
    
    positions(i,:) = [X Y Z];
end

t = tiledlayout(1, 2, "TileSpacing", "compact");
nexttile;

axis equal;
for i=1:n
    scatter3(positions(i,1),positions(i,2),positions(i,3),'filled','MarkerFaceColor',cMap(1,:));
    hold on;
end

%Radial projection onto sphere of radius 1/2
%project points onto sphere of radius 1/2
%we can also maybe do this by scaling by cos(rho)?
o = [0 0 0]';
r = 0.5;
c = [0 0 0.5]';
positions = positions';
kendallPositions = zeros(3,n);
for i=1:n
    u = positions(:,i);
    d = lineSphereIntersect(o,u,c,r);
    kendallPositions(:,i) = d(1) * u;
end

nexttile;

axis equal;
for i=1:n
    scatter3(kendallPositions(1,i),kendallPositions(2,i),kendallPositions(3,i),'filled','MarkerFaceColor',cMap(1,:));
    hold on;
end

function d = lineSphereIntersect(o,u,c,r)
%All vectors must be column vectors in three dimensions
    d = zeros(1,2);
    t1 = -dot(u,o-c);
    t2 = sqrt(t1^2 - (norm(u)^2*(norm(o-c)^2-r^2)));
    d(1) = (t1 + t2)/(norm(u)^2);
    d(2) = (t1 - t2)/(norm(u)^2);
end