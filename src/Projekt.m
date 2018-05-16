%% Setup (load data and such)
clc
clear all
close all
addpath('../Data')
%%
temp_rr = cell(1,7);
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

load afdb_5
temp_rr{5} = rr;

load afdb_6
temp_rr{6} = rr;

load afdb_7
temp_rr{7} = rr;

rr = temp_rr;
targetsRR = temp_targetsRR;

clear afBounds Fs qrs recordName temp_rr temp_targetsRR targetsQRS

RR = [rr{1}, rr{2}, rr{3}, rr{4}];
TargetsRR = [targetsRR{1}, targetsRR{2}, targetsRR{3}, rr{4}];


%% Plot data and target values (ground truth)

% figure(1)
% subplot(2,1,1)
% plot(RR)
% title('Signal')
% subplot(2,1,2)
% plot(TargetsRR)
% ylim([-1 2])
% title('Ground truth')





%% *** Training part ***

%% Feature extraction
Features = zeros(1,length(RR));

% P_cv
Features(1,:) = pcv(RR);

% deltaHistogram
%Features(2,:) = deltaHistogram(RR);

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
features = cell(1,7);

for i = 1:7
    features{i} = zeros(1, length(rr{i}));
    
    % P_cv
    features{i}(1,:) = pcv(rr{i});
    
    % deltaHistogram
    %features{i}(2,:) = deltaHistogram(rr{i});
end

%% AF-detection
detectRR = cell(1,7);

for i = 1:7
    detectRR{i} = myClassifier(features{i}, classifier);
end

%% Interval smoothing with threshold

for i = 1:7
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

%% Plot the results for subjects
figure(1)

for i = 1:4
subplot(4,1,i)
    
    classifiedVector = benchmarkColors(targetsRR{i}, detectRR{i}, rr{i});
    
    hold on
    for j = 1:4
        plot(classifiedVector{3,j}, classifiedVector{2,j})
    end
    ylabel(['AFDB\_' num2str(i)])
    hold off
end

bme = suptitle('Classified signals');
set(bme, 'FontSize',30)
legend({'True negative', 'True positive', 'False negative', 'False positive'},'FontSize',14)

%% Save the evaluation detections
detectRR_5 = detectRR{5};
detectRR_6 = detectRR{6};
detectRR_7 = detectRR{7};

save('PAFresults', 'detectRR_5', 'detectRR_6', 'detectRR_7')


