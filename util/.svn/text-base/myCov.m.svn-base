function covMat = myCov(data)

% INPUT:
%   data := numDataPts X dataDim

% Take out the mean
dataMean = myMean(data) ;
zeroMeanData = rpcSwitch('@(x,y) makeSlaveRef(bsxfun(@minus, x, y))', 'rpc', data, dataMean) ;
% Compute covariance
numDataPts = rpcSwitch('@(x) size(x,1)', 'rpcsum', data) ;
covMat = rpcSwitch('@(x,y) transpose(x)*x/y', 'rpcsum', zeroMeanData, numDataPts) ; 