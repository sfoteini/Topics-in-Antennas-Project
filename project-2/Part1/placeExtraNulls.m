function totalTheta = placeExtraNulls(theta,SNR,M)
%PLACEEXTRANULLS Creates extra radiation pattern nulls for side lobe level
% reduction.

    % Number of incoming signals
    N = length(theta);
    nOfExtraNulls = M-N;
    thetaNulls = zeros(1,nOfExtraNulls);
    peakPrev = 1;
    extraNull = 0;
    for i=1:(nOfExtraNulls+1)
        % Find the MVDR weights using all the theta angles you have found
        % so far
        w = MVDRBeamformer([theta thetaNulls(1:i-1)],SNR,M);
        % Find the radiation pattern
        thetaRange = 0:pi/1800:pi;
        a_theta = exp(1i .* ((0:(M-1))*pi)' .* cos(thetaRange));
        AF = abs(w' * a_theta);
        AF = AF/max(AF);
        % Find max Side Lobe Level and the corresponding angle
        [pks,maxSLLTheta] = findpeaks(AF);
        % Sort the peaks in ascending order
        pks_sorted = sort(pks);
        % If current max SLL is higher than then previous one, stop the
        % loop and discard the last extra null
        if(peakPrev < pks_sorted(end-1))
            extraNull = i - 2;
            break;
        end
        % If current max SLL is lower than then previous one, try to place
        % an extra null. If you have placed all the available extra nulls,
        % break the loop.
        if(i == nOfExtraNulls + 1)
            break;
        end
        peakPrev = pks_sorted(end-1);
        index = find(pks == pks_sorted(end-1));
        if(length(index)==1)
            index = maxSLLTheta(index);
        else
            index = maxSLLTheta(index(1));
        end
        % Find the value of the angle in degrees
        thetaNulls(i) = (index-1)/10;
        extraNull = extraNull + 1;
    end
    totalTheta = [theta thetaNulls(1:extraNull)];
end