function cNormalizeWhiten(dataPath, prefix, numSlaves, format, numFilesCap, spSize, tmpSize) 

global server ;
options.slavecount = numSlaves ;
server = Server(options) ;

data = rpcSwitch('slaveLoadData', 'noRPC', dataPath, prefix, numSlaves, ...
  format, numFilesCap) ;
data = rpcSwitch('standardizeZou_Holly', 'rpc', data, spSize, tmpSize) ;
whitened = rpcSwitch('extract4server', 'rpc', data, 'whitened') ;
if iscell(whitened)
  whitened = whitened{1} ;
end
standardized = rpcSwitch('extract4server', 'rpc', data, 'standardized') ;
if iscell(standardized)
  standardized = standardized{1} ;
end
dataMat = rpcSwitch('extract4slaves', 'rpc', data, 'data') ;

% normalize for contrast
dataMean = myMean(dataMat) ;
dataVar = myVar(dataMat) ;
if ~standardized
  normFacNonZero = dataVar(dataVar > 0) ;
  modifier = min(normFacNonZero)/10 ;
  dataMat = ...
      rpcSwitch('@(x,y,z,a) makeSlaveRef(bsxfun(@rdivide, bsxfun(@minus, z, x), sqrt(y+a)))', ...
      'rpc', dataMean, dataVar, dataMat, modifier) ;
end
% whitening
if ~whitened
    dataMat = zcaWhiten(dataMat) ;
end

saveDir = [dataPath '/cNormalizedWhitened/' ] ;
%saveDir = [dataPath '/TESTcNormalizedWhitenet/' ] ;
if ~exist(saveDir, 'dir')
  mkdir(saveDir) ;
end
% fileName = 'blktrain' ;
% savePath = cell(1, numSlaves) ;
% for i=1:1:numSlaves
%   savePath{1,i} = [saveDir '/' fileName '_' num2str(i) '.mat'] ;
% end
% rpcSwitch('rpc', 'save', savePath, 'data', '-v7.3') ; 
%server.rpc('@(x,y) x.whitened = y', data, 1) ;
data = rpcSwitch('assign2struct', 'rpc', data, 'whitened', 1) ;
%server.rpc('@(x,y) x.standardized = y', data, 1) ;
data = rpcSwitch('assign2struct', 'rpc', data, 'standardized', 1) ;
%server.rpc('@(x,y) x.data = y', data, dataMat) ;
data = rpcSwitch('assign2struct', 'rpc', data, 'data', dataMat) ;

rpcSwitch('saveData', 'rpc', saveDir, data, 'data', num2cell(1:numSlaves), 1) ;