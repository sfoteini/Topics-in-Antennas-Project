%% Part 2.A: Spatial Spectrum of MUSIC Estimator
%
% Foteini Savvidou, AEM: 9657

clc;
clear;
close all;

%% Global parameters
M = 24;     % number of array elements
SNR = 10;
theta = 30:10:150;

%% Spatial Spectrum
spatialspectrumMUSIC(theta,M,SNR);