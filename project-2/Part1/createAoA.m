function theta = createAoA(delta,lAngleLimit,uAngleLimit)
%CREATEAOA Creates the angles of arrival of the incoming signals.
% We consider that one desired signal by angle θ0 arrives at the beamformer
% while we have five interference signals at θ1-θ5.
% The function generates all possible sets of θ0, θ1, θ2, θ3, θ4 and θ5, 
% uniformly distributed in the interval [lAngleLimit, uAngleLimit], with a 
% distance between any two adjacent angles exactly equal to delta.
    
    % Number of possible set so as to θi <= uAngleLimit
    n = uAngleLimit-5*delta-lAngleLimit+1;
    theta = zeros(6,6,n);
    for i = 1:n
        tmp = (lAngleLimit+i-1):delta:(lAngleLimit+i-1+5*delta);
        theta(:,:,i) = repmat(tmp,6,1);
        for j = 2:6
            theta(j:6,[1 j],i) = theta(j:6,[j 1],i);
        end
    end
end