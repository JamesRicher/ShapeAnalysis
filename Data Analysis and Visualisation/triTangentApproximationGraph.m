clear all;
close all;
clc;

cMap = [0 0.4470 0.7410;
0.8500 0.3250 0.0980;
0.9290 0.6940 0.1250;
0.4940 0.1840 0.5560];
shells = importdata("Data/shells.m","-mat");
k = size(shells,1);
m = size(shells,2);
n = size(shells,3);
H = helm(k);

[shells, meanShell] = GPA(shells, 0.000001);
shellPreshapes = getPreshapes(shells, "helmert");
polePreshape = getPreshapes(meanShell, "helmert");
[shellsTangentCoords, shellPoleCoords] = preshapeToTangent(shellPreshapes, polePreshape, "proc");

distances = zeros(2,n*(n-1));
index =0;
for i=1:n
    for j=1:n
        if i ~= j
            index = index +1;
            tangentResidual = shellsTangentCoords(:,i) - shellsTangentCoords(:,j);
            tangentResidual = tangentResidual.^2;
            tangentDist = sqrt(sum(tangentResidual));
            distances(1,index) = tangentDist;
            distances(2, index) = dist(shells(:,:,i),shells(:,:,j),"riem");
        end
    end
end

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

xlabel("Euclidean tangent space distance");
ylabel("Riemannian distance, \rho");
box on;
ax = gca; 
ax.FontSize = 16; 
print(gcf,'triTangentApprox.png','-dpng','-r500');