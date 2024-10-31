clear all;
close all;
clc;

%%% Preliminaries %%%
gorm = importdata("Data/gorm.m","-mat");
gorf = importdata("Data/gorf.m","-mat");
k = size(gorm,1);
m = size(gorm,2);
n1 = size(gorm,3);
n2 = size(gorf,3);
n = n1 + n2;
H = helm(k);
cMap = [0 0.4470 0.7410;
0.8500 0.3250 0.0980;
0.9290 0.6940 0.1250;
0.4940 0.1840 0.5560];

%%% Combining the two samples %%%
gorCombined = zeros(k,m,n);
gorCombined(:,:,1:n1) = gorm;
gorCombined(:,:,(n1+1):n) = gorf;

gorCombinedNew = zeros(k,m,n);
%%% Permuting the landmarks %%%
for i=1:n
    gorCombinedNew(1,:,i) = gorCombined(1,:,i);
    gorCombinedNew(2,:,i) = gorCombined(6,:,i);
    gorCombinedNew(3,:,i) = gorCombined(7,:,i);
    gorCombinedNew(4,:,i) = gorCombined(8,:,i);
    gorCombinedNew(5,:,i) = gorCombined(2,:,i);
    gorCombinedNew(6,:,i) = gorCombined(3,:,i);
    gorCombinedNew(7,:,i) = gorCombined(4,:,i);
    gorCombinedNew(8,:,i) = gorCombined(5,:,i);
end

gorCombined = gorCombinedNew;


% plotShapes(gorm,"blue","o",false,false,1);
% hold on;
% plotShapes(gorf, "red","o",false,false,1);
% axis equal;

%%% Plotting labelled sample shape %%%
plotShapesLabelled(gorCombined(:,:,1),cMap(1,:),"o",true,true,2);
box on;
axis equal;
axis off;
set(gca,'XTick',[], 'YTick', []);
ax = gca; 
ax.FontSize = 16;
print(gcf,'gorsample.png','-dpng','-r500');

%%% Visualising the male and female mean shapes %%%
figure;
[a,maleMean] = GPA(gorCombinedNew(:,:,1:n1),1e-6);
[a,femaleMean] = GPA(gorCombinedNew(:,:,(n1+1):n),1e-6);
maleMean = OPA(maleMean,femaleMean,"partial");
plotShapes(maleMean, cMap(1,:),"o",true,true,1.5);
hold on;
plotShapes(femaleMean, cMap(2,:),"o",true,true,1.5);
axis equal;
box on;
print(gcf,'gormeanshaoes.png','-dpng','-r500');
disp("mean shape distance");
disp(dist(maleMean, femaleMean,"riem"));


%%% Aligning the shapes %%%
figure;
[gorAligned, meanGor] = GPA(gorCombined, 0.000001);
plotShapes(gorAligned, cMap(1,:),"x",false,false,0.5);
hold on;
plotShapes(meanGor, cMap(2,:),"x",true,true,2);
axis equal;
box on;


%%% Individual point PCA %%%
figure;
deviations = 3;

plotShapes(gorAligned, cMap(1,:),"x",false,false,1);
axis equal;
hold on;
plotShapes(meanGor, cMap(2,:),"x",true,true,2);

for i=1:k
    landmarks = zeros(2,n);
    for j=1:n
        landmarks(:,j) = gorAligned(i,:,j);
    end
    meanLandmark = (1/n)*sum(landmarks,2);
    Vbar = zeros(2,n);
    for j=1:n
        Vbar(:,j) = meanLandmark(:);
    end
    CV = (1/n)*(landmarks - Vbar)*(landmarks - Vbar)';
    [V,D] = eig(CV);
    for j=1:2
        line([meanLandmark(1), meanLandmark(1)+(deviations*sqrt(D(j,j))*V(1,j))], ...
            [meanLandmark(2), meanLandmark(2)+(deviations*sqrt(D(j,j))*V(2,j))], ...
            'Color',cMap(3,:), 'LineWidth',2, 'DisplayName','PC1');
    end
    
    SD1 = sqrt(D(1,1));
    SD2 = sqrt(D(2,2));
    axis1 = deviations*SD1;
    axis2 = deviations*SD2;
    t = linspace(0, 360,2000);
    x = axis1 * sind(t);
    y = axis2 * cosd(t);
    M = [x;y];
    M = V*M;
    hold on;
    plot(M(1,:) + meanLandmark(1), M(2,:) + meanLandmark(2), '-', 'LineWidth', 2,'Color',cMap(4,:),'DisplayName','');
end

box on;
set(gcf,'position',[10,10,700,700]);
print(gcf,'gorpointPCA.png','-dpng','-r500');

%%% Shape PCA %%%
figure;
gorPreshapes = getPreshapes(gorAligned, "helmert");
polePreshape = getPreshapes(meanGor, "helmert");
[gorTangentCoords, gorPoleCoords] = preshapeToTangent(gorPreshapes, polePreshape, "proc");
[V,D, meanTangentCoords] = shapePCA(gorTangentCoords);
disp(D);

%%% Cumulative variance in PCs %%%
disp(D);
disp(size(D));
e = size(D);
cumulativeVariance = zeros(e);
totalVariance = sum(D);
for i=1:e
    cumulativeVariance(i) = (sum(D(1:i))/totalVariance)*100;
end

plot(0:e, [0,cumulativeVariance'], '-o','LineWidth',1.5,'MarkerFaceColor', cMap(1,:));
hold on;
xlim([0,e(1)]);
ylim([0,100]);
box on;
xlabel("Principal components");
ylabel("Cumulative variance (percentage)");
ax = gca; 
ax.FontSize = 16; 
print(gcf,'gorcumvar.png','-dpng','-r500');

%%% Principal deformations %%%
figure;
weights = [-5,0,5];
t = tiledlayout(3, 3, "TileSpacing", "compact")
for i =1:3
    deformations = zeros(k,m,3);
    for j=1:3
        v = meanTangentCoords + weights(j)*sqrt(D(i))*V(:,i);
        vPreshape = tangentToPreshape(v, gorPoleCoords);
        deformations(:,:,j) = (H')*vPreshape;
        nexttile;
        plotShapes(deformations(:,:,j),cMap(1,:),"o",true,true,1);
        axis off
        axis equal;
        set(gca,'XTick',[], 'YTick', []);
        if j==2
            title(['PC-',num2str(i)]);
        end
    end
end
set(gcf,'position',[10,10,900,900]);
ax = gca; 
ax.FontSize = 16;
print(gcf,'gordeformations.png','-dpng','-r500');

%%% Projections onto PCs %%%
figure;
components = 5;
componentLoadings = zeros(components, n);
for i=1:n
    for j=1:components
        componentLoadings(j,i) = sqrt(D(j))*dot(gorTangentCoords(:,i), V(:,j));
    end
end

scatter(componentLoadings(1,1:n1), componentLoadings(2,1:n1),80,"filled","MarkerFaceColor",cMap(1,:) );
hold on;
scatter(componentLoadings(1,(n1+1):n), componentLoadings(2,(n1+1):n),80,"filled","MarkerFaceColor",cMap(2,:) );
xlabel('PC-1','FontWeight','bold');
ylabel('PC-2','FontWeight','bold');

legend('male','female','FontSize',14);
ax = gca; 
ax.FontSize = 14;
print(gcf,'gorgenderPCA.png','-dpng','-r500');

figure;
t = tiledlayout(components, components, "TileSpacing", "compact");
for i=1:components
    for j=1:components
        nexttile;
        if i==j
            histogram(componentLoadings(i,:),7);
        else
            scatter(componentLoadings(i,:), componentLoadings(j,:),'filled');
        end
        axis square;
        box on;
    end
end
set(gcf,'position',[10,10,900,900]);
print(gcf,'gornormalApprox.png','-dpng','-r500');

%%% Hypothesis test %%%
maleSample = gorTangentCoords(:,1:n1);
femaleSample = gorTangentCoords(:,(n1+1):n);
maleMean = (1/n1)*sum(maleSample,2);
femaleMean = (1/n2)*sum(femaleSample,2);
maleCovariance = (1/n1)*(maleSample - maleMean)*(maleSample - maleMean)';
femaleCovariance = (1/n2)*(femaleSample - femaleMean)*(femaleSample - femaleMean)';

pooledCovariance = (n1*maleCovariance + n2*femaleCovariance)/(n1+n2-2);
Cinv = mpInverse(pooledCovariance);
Tsqr = (maleMean - femaleMean)'*Cinv*(maleMean - femaleMean);
k = 8;
n = 2;
q = k*n - n -1 -((n-1)*n)/2;
F = (n1*n2*(n1+n2-q-1)*Tsqr)/((n1+n2)*(n1+n2-2)*q);
disp(F);
disp(n1+n2-q-1);
p = fcdf(F,q,n1+n2-q-1);
disp(p);
disp(1-p);

%%% Evaluating the tangent space approximation %%%
figure;

n = size(gorCombined,3);
distances = zeros(2,n*(n-1));
index =0;
for i=1:n
    for j=1:n
        if i ~= j
            index = index +1;
            tangentResidual = gorTangentCoords(:,i) - gorTangentCoords(:,j);
            tangentResidual = tangentResidual.^2;
            tangentDist = sqrt(sum(tangentResidual));
            distances(1,index) = tangentDist;
            distances(2, index) = dist(gorCombined(:,:,i),gorCombined(:,:,j),"riem");
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
print(gcf,'gortangentApprox.png','-dpng','-r500');

