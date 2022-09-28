function weights = MVDRBeamformer(theta,SNR,M)
%MVDRBEAMFORMER Calculates the weights of a MVDR beamformer given the
% angles of arrival of the incoming signals (theta) and the SNR (dB).
% We consider that the power of the incoming signal is 1W, the number 
% of array elements is equal to M and βd=pi.
    
    % Convert the angles to rad
    theta = theta * pi/180;
    % Number of incoming signals
    N = length(theta);
    % Steering matrix
    A = exp(1i .* ((0:(M-1))*pi)' .* cos(repmat(theta,M,1)));
    % Steering vector of the desired signal
    a_d = A(:,1);
    % Correlation matrix of incoming signals Rgg
    Rgg = eye(N);
    % Correlation matrix of noise Rnn
    SNR = 10^(SNR/10);
    Rnn = (1/SNR) * eye(M);
    % Correlation matrix Rxx = ARggA' + Rnn
    Rxx = A * Rgg * A' + Rnn;

    % Calculate the weights of the MVDR beamformer
    weights = inv(Rxx) * a_d;
end