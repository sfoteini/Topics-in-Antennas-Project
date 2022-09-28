function P = spatialspectrumMUSIC(theta,M,SNR,display)
%SPATIALSPECTRUMMUSIC Creates the spatial spectrum of the MUSIC estimator
% given the angles of arrival or the incoming signals (theta), the number
% of array elements (M) and the SNR.
% We consider that the power of the incoming signals is 1W and the distance 
% between array elements is d=lambda/2 (hence βd=pi).

    arguments
        theta (1,:) {mustBeNumeric,mustBeReal}
        M (1,1) {mustBePositive}
        SNR (1,1) {mustBeNumeric,mustBeReal}
        display (1,:) char {mustBeMember(display,{'disp','nodisp'})} = 'disp'
    end

    % Convert the angles to rad
    theta = theta * pi/180;
    % Number of incoming signals
    N = length(theta);
    % Steering matrix
    A = exp(1i .* ((0:(M-1))*pi)' .* cos(repmat(theta,M,1)));
    % Correlation matrix of incoming signals Rgg
    Rgg = eye(N);
    % Correlation matrix of noise Rnn
    SNR = 10^(SNR/10);
    Rnn = (1/SNR) * eye(M);
    % Correlation matrix Rxx = ARggA' + Rnn
    Rxx = A * Rgg * A' + Rnn;
    % Eigenvalues and eigenvectors
    [eigvec,eigval] = eig(Rxx);
    eigval = diag(eigval);
    [eigval,index] = sort(eigval,'descend');
    eigvec = eigvec(:,index);
    % Find the M-N eigenvectors that correspond to the M-N smaller
    % eigenvalues
    U = eigvec(:,N+1:M);
    % Steering vector
    thetaRange = 0:pi/18000:pi;
    a_theta = exp(1i .* ((0:(M-1))*pi)' .* cos(thetaRange));
    n = size(a_theta,2);
    % Spatial spectrum
    P = zeros(n,1);
    for i=1:n
        a = a_theta(:,i);
        P(i) = abs(1/(a'*U*U'*a));
    end
    % Plot the spatial spectrum
    if (strcmp(display,'disp'))
        Pmax = max(P);
        figure();
        plot(thetaRange*180/pi,10*log10(P/Pmax));
        title('Spatial Spectrum of MUSIC Estimator');
        xlabel(['θ' char(176)]);
        ylabel('10log(P/Pmax) (dB)');
    end
end