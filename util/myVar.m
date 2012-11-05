function dataVar = myVar(data)

% TESTED: works for sure.

dataMean = myMean(data) ;
numDataPts = rpcSwitch('@(x) size(x,1)', 'rpcsum', data) ;
zeroMeanData = rpcSwitch('@(x,y) makeSlaveRef(bsxfun(@minus, x, y))', 'rpc', data, dataMean) ;
dataSq = rpcSwitch('@(x) makeSlaveRef(x.^2)', 'rpc', zeroMeanData) ;
dataVar = rpcSwitch('@(x,y) sum(x,1)/y', 'rpcsum', dataSq, numDataPts) ;