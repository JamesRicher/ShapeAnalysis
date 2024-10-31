clear all;
close all;
clc;

cMap = [0 0.4470 0.7410;
    0.8500 0.3250 0.0980];

skulls = importdata("Data/panf.m","-mat");

k = size(skulls,1);
m = size(skulls,2);
n = size(skulls,3);

skulls = scaleShapes(translateShapes(skulls));
[alignedSkulls, meanSkull] = GPA(skulls,0.000001);
meanSkull = scaleShapes(translateShapes(meanSkull));
tangentSkulls = zeros(k,m,n);

for i=1:n
    tangentSkulls(:,:,i) = tangentCoords(skulls(:,:,i),meanSkull,"exp") + meanSkull;
end

t = tiledlayout(1,2);
nexttile;
plotShapes2(tangentSkulls,cMap(1,:),true,true,0.6,10);
hold on
plotShapes2(meanSkull,cMap(2,:),true,true,2.2,20);
axis square;
ylim([-0.55,0.55]);
xlim([-0.55,0.55]);
box on;

distances = zeros(2,n,n);

for i=1:n
    for j=1:n
        residual = tangentSkulls(:,:,i) - tangentSkulls(:,:,j);
        residual = residual.^2;
        disp(sum(sum(residual)));
        distances(1,i,j) = sqrt(sum(sum(residual)));
        distances(2,i,j) = dist(skulls(:,:,i), skulls(:,:,j),"riem");
    end
end

distances = reshape(distances,2,n^2);
x = distances(1,:);
y = distances(2,:);

fit = polyfit(x,y,1);
coeff = fit(1);
line = coeff*x;

disp(coeff);

nexttile;
scatter(x,y,'x','black');
hold on;
plot(x,line,'black');
axis square;

xlabel("Euclidean tangent space distance",'FontWeight','bold');
ylabel("Riemannian distance, \rho",'FontWeight','bold');
box on;


set(gcf,'position',[0,0,700,700]);
print(gcf,'tangentApprox.png','-dpng','-r500');
