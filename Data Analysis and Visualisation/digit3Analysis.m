clear all;
close all;
clc;

%%% Preliminary definitions %%%
digits = importdata("Data/digit3.m","-mat");
k = size(digits,1);
m = size(digits,2);
n = size(digits,3);
cMap = [0 0.4470 0.7410;
0.8500 0.3250 0.0980;
0.9290 0.6940 0.1250;
0.4940 0.1840 0.5560];
H = helm(k);

%%% Plotting and aligning data %%%
[digits, meanDigits] = GPA(digits, 0.00001);
for i=1:n
    digits(:,:,i) = OPA(digits(:,:,i), meanDigits, "partial");
end
plotShapes(digits,cMap(1,:),"o",false,false,1);
hold on;
box on;
%plotShapes(meanDigits,"red","o",true,false,3);
axis square;

%%% Individual point PCA %%%
deviations = 1.5;

for i=1:k
    landmarks = zeros(2,n);
    for j=1:n
        landmarks(:,j) = digits(i,:,j);
    end
    %meanLandmark = (1/n)*sum(landmarks,2);
    Vbar = zeros(2,n);
    for j=1:n
        Vbar(:,j) = meanDigits(i,:);
    end
    CV = (1/n)*(landmarks - Vbar)*(landmarks - Vbar)';
    [V,D] = eig(CV);
    for j=1:2
        line([meanDigits(i,1), meanDigits(i,1)+(deviations*sqrt(D(j,j))*V(1,j))], ...
            [meanDigits(i,2), meanDigits(i,2)+(deviations*sqrt(D(j,j))*V(2,j))], ...
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
    plot(M(1,:) + meanDigits(i,1), M(2,:) + meanDigits(i,2), '-', 'LineWidth', 2,'Color',cMap(4,:),'DisplayName','');
end
print(gcf,'digit3pointPCA.png','-dpng','-r500');

%%% Shape PCA %%%
digitPreshapes = getPreshapes(digits, "helmert");

figure;
plotShapes(digitPreshapes,cMap(1,:),"o",false,false,1);

polePreshape = getPreshapes(meanDigits, "helmert");
[digitTangentCoords, digitPoleCoords] = preshapeToTangent(digitPreshapes, polePreshape, "proc");
[V,D, meanTangentCoords] = shapePCA(digitTangentCoords);

%%% Cumulative variance in PCs %%%
disp(D);
disp(size(D));
e = size(D);
cumulativeVariance = zeros(e);
totalVariance = sum(D);
for i=1:e
    cumulativeVariance(i) = (sum(D(1:i))/totalVariance)*100;
end

figure;
plot(0:24, [0,cumulativeVariance'], '-o','LineWidth',1.5,'MarkerFaceColor', cMap(1,:));
hold on;
xlim([0,24]);
ylim([0,100]);
box on;
xlabel("Principal components");
ylabel("Cumulative variance (percentage)");

ax = gca; 
ax.FontSize = 16; 

print(gcf,'digit3cumvar.png','-dpng','-r500');

%%% Principal deformations %%%
figure;
weights = [-3,0,3];
t = tiledlayout(3, 3, "TileSpacing", "compact");
for i =1:3
    deformations = zeros(k,m,3);
    for j=1:3
        v = meanTangentCoords + weights(j)*sqrt(D(i))*V(:,i);
        vPreshape = tangentToPreshape(v, digitPoleCoords);
        deformations(:,:,j) = (H')*vPreshape;
        nexttile;
        plotShapes(deformations(:,:,j),cMap(1,:),"o",true,false,1.5);
        axis off
        axis equal;
        set(gca,'XTick',[], 'YTick', []);
        if j==2
            title(['PC-',num2str(i)]);
        end
    end
end
set(gcf,'position',[10,10,900,900]);
print(gcf,'digit3deformations.png','-dpng','-r500');

%%% Projections onto PCs %%%
figure;
components = 5;
componentLoadings = zeros(components, n);
for i=1:n
    for j=1:components
        componentLoadings(j,i) = sqrt(D(j))*dot(digitTangentCoords(:,i), V(:,j));
    end
end

scatter(componentLoadings(1,:), componentLoadings(2,:),40,"filled","MarkerFaceColor",cMap(1,:) );
xlabel('PC-1','FontWeight','bold');
ylabel('PC-2','FontWeight','bold');

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
print(gcf,'digit3normalApprox.png','-dpng','-r500');

%%% Evaluating the tangent space approximation %%%
figure;

distances = zeros(2,n*(n-1));
index =0;
for i=1:n
    for j=1:n
        if i ~= j
            index = index +1;
            tangentResidual = digitTangentCoords(:,i) - digitTangentCoords(:,j);
            tangentResidual = tangentResidual.^2;
            tangentDist = sqrt(sum(tangentResidual));
            distances(1,index) = tangentDist;
            distances(2, index) = dist(digits(:,:,i),digits(:,:,j),"riem");
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
print(gcf,'digit3tangentApprox.png','-dpng','-r500');

%%% Plotting an example shape %%%
figure;
plotShapesLabelled(digits(:,:,4), cMap(1,:),"o",true,false,1.5);
box on;
axis equal;
axis square;
axis off;
set(gca,'XTick',[], 'YTick', []);
print(gcf,'digit3sample.png','-dpng','-r500');

