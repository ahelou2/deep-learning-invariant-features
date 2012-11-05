function dataMean = myMean(data)

% TESTED: Works for sure.

numDataPts = rpcSwitch('@(x) size(x,1)', 'rpcsum', data) ;
dataMean = rpcSwitch('@(x,y) sum(x,1)/y', 'rpcsum', data, numDataPts) ;