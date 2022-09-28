function [dtheta,SINR,SLL] = calculateAoAdev_SINR_SLL(w,theta,SNR,N,M)
%CALCULATEAOADEV_SINR_SLL Calculates the signal-to-interference-and-noise 
% ratio, the deviation of the main lobe and the nulls from the desired 
% angles and the side lobe level and displays the radiation pattern.
% We consider that the power of the incoming signal is 1W, the number 
% of array elements is equal to M and βd=pi.

    % Convert the angles to rad
    theta_rad = theta * pi/180;

    %% Calculate SINR
    % Steering matrix
    A = exp(1i .* ((0:(M-1))*pi)' .* cos(repmat(theta_rad,M,1)));
    % Steering vector of the desired signal
    a_d = A(:,1);
    % Steering matrix of the undesired (real) signals
    a_i = A(:,2:N);
    % Correlation matrix of noise Rnn
    SNR = 10^(SNR/10);
    Rnn = (1/SNR) * eye(M);
    % Correlation matrix of the desired signal
    Rdd = a_d*a_d';
    % Correlation matrix of the undesired signals
    Ruu = a_i * eye(N-1) * a_i' + Rnn;
    % SINR (dB)
    SINR = 10*log10((w'*Rdd*w)/(w'*Ruu* w));

    %% Create the radiation pattern
    thetaRange = 0:pi/1800:pi;
    a_theta = exp(1i .* ((0:(M-1))*pi)' .* cos(thetaRange));
    AF = abs(w' * a_theta);
    AF = AF/max(AF);
    
    %{
    % Display the radiation pattern
    figure();
    plot(thetaRange*180/pi,AF);
    title('Radiation Pattern');
    xlabel(['θ' char(176)]);
    ylabel('Normalized |AF(θ)|');
    %}

    %% Find Angle of Arrival deviation
    dtheta = zeros(1,N);
    % Main lobe
    mainLobe = find(AF == max(AF));
    if(length(mainLobe)==1)
        dtheta(1) = abs((mainLobe-1)/10-theta(1));
    else
        dtheta(1) = min(abs((mainLobe-1)/10-theta(1)));
    end
    % Nulls
    [~,radiationPatternNulls] = findpeaks(max(AF)-AF);
    radiationPatternNulls = (radiationPatternNulls-1)/10;
    dev = repmat(radiationPatternNulls,N-1,1) - theta(2:N)';
    dtheta(2:N) = min(abs(dev'));

    %% Find Side Lobe Level
    pks = findpeaks(AF);
    pks = sort(pks);
    SLL = 10*log10(pks(end-1));
end