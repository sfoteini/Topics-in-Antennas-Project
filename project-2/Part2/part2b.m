%% Part 2.B: Minimum angular distance of the arrival directions
%
% Foteini Savvidou, AEM: 9657

clc;
clear;
close all;

%% Global parameters
M = 24;     % number of array elements
N = 13;     % number of incoming signals
SNR = 10;
threshold = -50;

%% Spatial Spectrum
for delta = 0:0.01:15
    theta = 90 + (-6:6) * delta;
    P = spatialspectrumMUSIC(theta,M,SNR,'nodisp');
    P = 10*log10(P/max(P));
    peaks = findpeaks(P);
    % Keep the peaks greater that -50dB (threshold)
    peaks = peaks(peaks >= threshold);
    % Check if the number of peaks is equal to N
    if(length(peaks) == N)
        break;
    end
end
minDiff = delta;
fprintf('Minimum angular distance of the arrival directions: %.2f\n',minDiff);

%% Plot the spatial spectrum
P = spatialspectrumMUSIC(theta,M,SNR);
P = 10*log10(P/max(P));
[peaks,locs] = findpeaks(P);
index = find(peaks >= threshold);
peaks = peaks(index);
locs = locs(index);
hold on;
plot((locs-1)/100,peaks,'o');
legend('Spatial Spectrum','Local maxima');
