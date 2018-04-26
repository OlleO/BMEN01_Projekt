%% Setup (load data and such)
clc
clear all
close all
addpath('../Data')

load afdb_1
rr1 = rr;
targetsRR1 = targetsRR;

load afdb_2
rr2 = rr;
targetsRR2 = targetsRR;

load afdb_3
rr3 = rr;
targetsRR3 = targetsRR;

load afdb_4
rr4 = rr;
targetsRR4 = targetsRR;



clear afBounds Fs qrs recordName rr targetsRR targetsQRS

rr = [rr1, rr2, rr3, rr4];
targetsRR = [targetsRR1, targetsRR2, targetsRR3, targetsRR4];


%% Plot data and target values (ground truth)

figure(1)
subplot(2,1,1)
plot(rr)
title('Signal')
subplot(2,1,2)
plot(targetsRR)
ylim([-1 2])
title('Ground truth')





%% *** Training part ***

%% Feature extraction
features = zeros(2,length(rr));

% P_cv
features(1,:) = pcv(rr);

% deltaHistogram
features(2,:) = deltaHistogram(rr);

%% Plot P_cv --> corrupted data?? 
% figure(2)
% subplot(2,1,1)
% hold on
% plot(rr)
% plot(targetsRR*2, 'g')
% legend('Signal', 'Ground truth')
% hold off
% subplot(212)
% hold on
% plot(P_cv(6:end-5))
% plot(targetsRR(6:end-5)*0.5, 'g')
% title('P_cv feature')
% legend('P_{cv}', 'Ground truth')
% hold off

%% Train 4-Nearest Neighbours classifier
classifier = trainClassifier(features, targetsRR);










%% *** Classification part ***

%% Feature extraction
features1 = zeros(1, length(rr1));
features2 = zeros(1, length(rr2));
features3 = zeros(1, length(rr3));
features4 = zeros(1, length(rr4));

% P_cv features
features1(1,:) = pcv(rr1);
features2(1,:) = pcv(rr2);
features3(1,:) = pcv(rr3);
features4(1,:) = pcv(rr4);

%% AF-detection
detectRR1 = myClassifier(features1, classifier);
detectRR2 = myClassifier(features2, classifier);
detectRR3 = myClassifier(features3, classifier);
detectRR4 = myClassifier(features4, classifier);

%% Interval filtering with thresholding (>10 detections)
detectRR1 = noiseEraser(detectRR1);
detectRR2 = noiseEraser(detectRR2);
detectRR3 = noiseEraser(detectRR3);
detectRR4 = noiseEraser(detectRR4);

%% Benchmark performance and print
[sensitivity1, specificity1] = benchmark(targetsRR1, detectRR1);
[sensitivity2, specificity2] = benchmark(targetsRR2, detectRR2);
[sensitivity3, specificity3] = benchmark(targetsRR3, detectRR3);
[sensitivity4, specificity4] = benchmark(targetsRR4, detectRR4);

fprintf('Subject 1: \n Sensitivity %f \n Specificity %f \n\n', ...
    sensitivity1, specificity1);
fprintf('_____________________________________________\n');

fprintf('Subject 2: \n Sensitivity %f \n Specificity %f \n\n', ...
    sensitivity2, specificity2);
fprintf('_____________________________________________\n');

fprintf('Subject 3: \n Sensitivity %f \n Specificity %f \n\n', ...
    sensitivity3, specificity3);
fprintf('_____________________________________________\n');

fprintf('Subject 4: \n Sensitivity %f \n Specificity %f \n\n', ...
    sensitivity4, specificity4);
fprintf('_____________________________________________\n');


%% Plot the results for subject1
figure 
subplot(211)
hold on
plot(rr1)
plot(detectRR1)
legend('Signal', 'Classification')
hold off
subplot(212)
hold on
plot(targetsRR1*2)
plot(detectRR1)
legend('Ground truth', 'Classification')
hold off



