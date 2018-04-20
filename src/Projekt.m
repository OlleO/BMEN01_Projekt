%% El projecto de signales medicós
clc
clear all
close all
addpath('../Data')

%%
load afdb_3

figure(1)
subplot(2,1,1)
plot(rr)

subplot(2,1,2)
plot(targetsRR)
ylim([-1 2])

features = zeros(1,length(rr));

%% Test av P_cv

P_cv = pcv(rr);
features(1,:) = P_cv;

figure(2)
subplot(2,1,1)
hold on
plot(rr)
plot(targetsRR*2, 'g')
hold off
subplot(212)
hold on
plot(P_cv(6:end-5))
plot(targetsRR(6:end-5)*0.5, 'g')
hold off

%% Test av trainClassifier
classifier = trainClassifier(features, targetsRR);

%% Test av myClassifier
Y = myClassifier(features, classifier);

figure
hold on
plot(rr)
plot(Y)



