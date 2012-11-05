function whitenedData = zcaWhiten(data)

% INPUT:
%   data := numDataPts X dataDim

C = myCov(data) ;
numDataPts = rpcSwitch('@(x) size(x,1)', 'rpcsum', data) ;
M = rpcSwitch('@(x,y) sum(x,1)/y', 'rpcsum', data, numDataPts) ;
[V,D] = eig(C);
P = V * diag(sqrt(1./(diag(D) + 10^-5))) * V';
whitenedData = ...
    rpcSwitch('@(x,y,z) makeSlaveRef(bsxfun(@minus, x, y)*z)', 'rpc', data, M, P) ;