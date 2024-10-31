clear all;
close all;
clc

cMap = [0 0.4470 0.7410;
0.8500 0.3250 0.0980];
n=800;

%Define the triangles
equilateral = [0 0;
    1 0;
    0.5 sqrt(3/4)];

equilateral2 = [1 0;
    0 0;
    0.5 sqrt(3/4)];

tris = getRandomTriangles(n);

%Transform triangles to pre-shapes
tris = scaleShapes(translateShapes(tris));
equilateral = scaleShapes(translateShapes(equilateral));

%Align the triangles to the reference (equilateral)
for i=1:n
    tris(:,:,i) = OPA(tris(:,:,i), equilateral, "full");
end

%Put the data in the correct form for PCA
trisNew = zeros(6,n+1);
trisNew(:,1:n) = reshapeToCol(tris);
trisNew(:,n+1)=reshapeToCol(equilateral);

[coeff, score, latent] = pca(trisNew);
coords = coeff(:,1:3);

t = tiledlayout(1, 3);
nexttile;

for i=1:n
    scatter3(coords(i,3)*sqrt(latent(3)),coords(i,2)*sqrt(latent(2)),coords(i,1)*sqrt(latent(1)),'filled', 'MarkerFaceColor',cMap(1,:));
    hold on;
end
scatter3(coords(n+1,3)*sqrt(latent(3)),coords(n+1,2)*sqrt(latent(2)),coords(n+1,1)*sqrt(latent(1)),50,'filled', 'MarkerFaceColor',cMap(2,:));
axis square;
daspect([1 1 1]);

xlabel('PC-3','FontWeight','bold');
ylabel('PC-2','FontWeight','bold');
zlabel('PC-1','FontWeight','bold');

nexttile;
axis equal;

for i=1:n
    scatter(coords(i,3)*sqrt(latent(3)),coords(i,2)*sqrt(latent(2)),'filled', 'MarkerFaceColor',cMap(1,:));
    hold on;
end
scatter(coords(n+1,3)*sqrt(latent(3)),coords(n+1,2)*sqrt(latent(2)),50,'filled', 'MarkerFaceColor',cMap(2,:));
daspect([1 1 1]);
xlim([-0.25,0.25]);
ylim([-0.25,0.25]);

xlabel('PC-3','FontWeight','bold');
ylabel('PC-2','FontWeight','bold');

nexttile;
for i=1:n
    scatter(coords(i,3)*sqrt(latent(3)),coords(i,1)*sqrt(latent(1)),'filled', 'MarkerFaceColor',cMap(1,:));
    hold on;
end
scatter(coords(n+1,3)*sqrt(latent(3)),coords(n+1,1)*sqrt(latent(1)),50,'filled', 'MarkerFaceColor',cMap(2,:));
daspect([1 1 1]);
xlabel('PC-3','FontWeight','bold');
ylabel('PC-1','FontWeight','bold');
xlim([-0.25,0.25]);
ylim([-0.01,0.49]);


set(gcf,'position',[10,10,1000,1000])
print(gcf,'triPCA.png','-dpng','-r500');


function tris = reshapeToCol(triangles)
    n = size(triangles,3);
    tris = zeros(6,n);
    
    for i=1:n
        tris(1,i)=triangles(1,1,i);
        tris(2,i)=triangles(2,1,i);
        tris(3,i)=triangles(3,1,i);
        tris(4,i)=triangles(1,2,i);
        tris(5,i)=triangles(2,2,i);
        tris(6,i)=triangles(3,2,i);
    end
end

function tris = reshapeToConfig(triangles)
    n = size(triangles,2);
    tris = zeros(3,2,n);
    
    for i=1:n
        tris(1,1,i)=triangles(1,i);
        tris(2,1,i)=triangles(2,i);
        tris(3,1,i)=triangles(3,i);
        tris(1,2,i)=triangles(4,i);
        tris(2,2,i)=triangles(5,i);
        tris(3,2,i)=triangles(6,i);
    end
end