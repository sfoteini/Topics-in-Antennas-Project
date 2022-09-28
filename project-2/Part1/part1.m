%% Part 1: Minimum Variance Distortionless Response (MVDR) Beamformer
%
% Foteini Savvidou, AEM: 9657

clc;
clear;
close all;

%% Global parameters
N = 6;      % number of incoming signals
M = 24;     % number of array elements

%% Choose SNR and delta parameters
SNR = 0;
delta = 6;

fprintf('Working on SNR=%ddB and delta=%ddeg',SNR,delta);

%% Create the angles of arrival
thetaAoA = createAoA(delta,30,150);
% Convert 3d matrix to 2d
thetaAoA_split = num2cell(thetaAoA,[1 2]);
thetaAoA = vertcat(thetaAoA_split{:});

%% Place extra radiation pattern nulls and calculate SINR, SLL, AoA deviation
n = size(thetaAoA,1);
w = zeros(M,n);
dtheta = zeros(n,N);
SINR = zeros(n,1);
SLL = zeros(n,1);
for i = 1:n
    theta = placeExtraNulls(thetaAoA(i,:),SNR,M);
    w(:,i) = MVDRBeamformer(theta,SNR,M);
    [dtheta(i,:),SINR(i),SLL(i)] = calculateAoAdev_SINR_SLL(w(:,i),theta,SNR,N,M);
end

%% Save the data to a .txt file
formatSpec = repmat('%.3f ',1,14);
formatSpec(end) = [];
formatSpec = [formatSpec '\n'];
fileID = fopen('AoAdev_SINR_SLL.txt','w');
fprintf(fileID,formatSpec,[thetaAoA dtheta SINR SLL]');
fclose(fileID);

%% Load the saved file and calculate statistical parameters
clear;
data = importdata('AoAdev_SINR_SLL.txt');
% Max, min, mean, std for theta0 deviation
fprintf('\n\nMain Lobe Divergence [deg]\n');
minTheta0 = min(data(:,7));
maxTheta0 = max(data(:,7));
meanTheta0 = mean(data(:,7));
stdTheta0 = std(data(:,7));
fprintf('Min: %.3f Max: %.3f Mean: %.3f Std: %.3f\n',minTheta0,...
    maxTheta0,meanTheta0,stdTheta0);
% Min, max, mean, std for theta1-6 deviation
fprintf('\n\nNull Divergence [deg]\n');
minTheta = min(data(:,8:12),[],'all');
maxTheta = max(data(:,8:12),[],'all');
meanTheta = mean(data(:,8:12),'all');
stdTheta = std(data(:,8:12),0,'all');
fprintf('Min: %.3f Max: %.3f Mean: %.3f Std: %.3f\n',minTheta,...
    maxTheta,meanTheta,stdTheta);
% Min, max, mean, std for SINR
fprintf('\n\nSINR [dB]\n');
minSINR = min(data(:,13));
maxSINR = max(data(:,13));
meanSINR = mean(data(:,13));
stdSINR = std(data(:,13));
fprintf('Min: %.3f Max: %.3f Mean: %.3f Std: %.3f\n',minSINR,...
    maxSINR,meanSINR,stdSINR);
% Min, max, mean, std for SLL
fprintf('\n\nSLL [dB]\n');
minSLL = min(data(:,14));
maxSLL = max(data(:,14));
meanSLL = mean(data(:,14));
stdSLL = std(data(:,14));
fprintf('Min: %.3f Max: %.3f Mean: %.3f Std: %.3f\n',minSLL,...
    maxSLL,meanSLL,stdSLL);