%% El projecto de signales medicós
clc
clear all
close all
addpath('../Data')

 %% TRAIN! Plot signal and ground truth 
load afdb_1

figure(1)
subplot(2,1,1)
plot(rr)
title('Signal')
subplot(2,1,2)
plot(targetsRR)
ylim([-1 2])
title('Ground truth')

features = zeros(1,length(rr));

%% METHODS

%P_cv
P_cv = pcv(rr);
features(1,:) = P_cv;

%% Plot P_cv 
figure(2)
subplot(2,1,1)
hold on
plot(rr)
plot(targetsRR*2, 'g')
legend('Signal', 'Ground truth')
hold off
subplot(212)
hold on
plot(P_cv(6:end-5))
plot(targetsRR(6:end-5)*0.5, 'g')
title('P_cv feature')
legend('P_{cv}', 'Ground truth')
hold off

%% trainClassifier
classifier = trainClassifier(features, targetsRR);




 %% TEST! Plot signal and ground truth 
load afdb_5

figure(1)
subplot(2,1,1)
plot(rr)
title('Signal')

subplot(2,1,2)
plot(targetsRR)
ylim([-1 2])
title('Ground truth')

features = zeros(1,length(rr));

%% METHODs

%P_cv
P_cv = pcv(rr);
features(1,:) = P_cv;

%% Test av myClassifier
detectRR = myClassifier(features, classifier);
%Interval filtering with thresholding (>10 detections )
[sensitivity, specificity]=benchmark(targetsRR, detectRR)

%Plot the results 
figure 
subplot(211)
hold on
plot(rr)
plot(detectRR)
legend('Signal', 'Classification')
hold off
subplot(212)
hold on
plot(targetsRR*2)
plot(detectRR)
legend('Ground truth', 'Classification')
hold off



