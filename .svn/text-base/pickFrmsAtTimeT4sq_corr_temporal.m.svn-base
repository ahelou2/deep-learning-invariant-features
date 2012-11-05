function mask = pickFrmsAtTimeT4sq_corr_temporal(num_blks, timeSteps, T)

% generates mask for time step T such that X(mask,:) returns on frames that
% belong to time T.

smallMask = zeros(timeSteps, 1) ;
smallMask(T,1) = 1 ;
mask = rpcSwitch('@(x,y) makeSlaveRef(repmat(x, [y, 1]))', 'rpc', smallMask, num_blks) ;