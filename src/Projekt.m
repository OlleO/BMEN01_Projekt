%% Setup (load data and such)
clc
clear all
close all
addpath('../Data')

temp_rr = cell(1,4);
temp_targetsRR = cell(1,4);

load afdb_1
temp_rr{1} = rr;
temp_targetsRR{1} = targetsRR;

load afdb_2
temp_rr{2} = rr;
temp_targetsRR{2} = targetsRR;

load afdb_3
temp_rr{3} = rr;
temp_targetsRR{3} = targetsRR;

load afdb_4
temp_rr{4} = rr;
temp_targetsRR{4} = targetsRR;

rr = temp_rr;
targetsRR = temp_targetsRR;

clear afBounds Fs qrs recordName temp_rr temp_targetsRR targetsQRS

RR = [rr{1}, rr{2}, rr{3}, rr{4}];
TargetsRR = [targetsRR{1}, targetsRR{2}, targetsRR{3}, targetsRR{4}];


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
Features = zeros(2,length(RR));

% P_cv
Features(1,:) = pcv(RR);

% deltaHistogram
Features(2,:) = deltaHistogram(RR);

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

%% Train k-Nearest Neighbours classifier (k = 4)
classifier = trainClassifier(Features, TargetsRR);










%% *** Classification part ***

%% Feature extraction
features = cell(1,4);

for i = 1:4
    features{i} = zeros(2, length(rr{i}));
    
    % P_cv
    features{i}(1,:) = pcv(rr{i});
    
    % deltaHistogram
    features{i}(2,:) = deltaHistogram(rr{i});
end

%% AF-detection
detectRR = cell(1,4);

for i = 1:4
    detectRR{i} = myClassifier(features{i}, classifier);
end

%% Interval smoothing with threshold

for i = 1:4
    detectRR{i} = noiseEraser(detectRR{i});
end
    
%% Benchmark performance and print
sensitivity = [0 0 0 0];
specificity = [0 0 0 0];

for i = 1:4
    [sensitivity(i), specificity(i)] = benchmark(targetsRR{i}, detectRR{i});
    
    fprintf('Subject %d: \n Sensitivity %f \n Specificity %f \n\n', ...
    i, sensitivity(i), specificity(i));
    fprintf('_____________________________________________\n');
end

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



