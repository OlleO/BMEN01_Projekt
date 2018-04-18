%% El projecto de signales medicós
clc
clear all
close all

load afdb_4.mat

figure(1)
subplot(2,1,1)
plot(rr)

subplot(2,1,2)
plot(targetsRR)
ylim([-1 2])