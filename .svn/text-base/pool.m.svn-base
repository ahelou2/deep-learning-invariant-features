function pooledData = pool(data, RFs, method, standardize, whiten)

% OUTPUT:
%   - pooledData := numDataPts X numRFs

numDataPts = size(data.data, 1) ;
dataDim = size(data.data,2) ;
numRFs = size(RFs, 1) ;
RFDim = size(RFs, 2) ;

% Handle case where RFs matrix was learned on lower dimensional images than
% those in data.data.
if dataDim ~= RFDim
  assert(mod(dataDim, RFDim) == 0) ;
  RFs = repmat(RFs, [1 dataDim/RFDim]) ;
end

pooledData = zeros(numDataPts, numRFs) ;

if nargin < 6
  standardize = 0 ;
  whiten = 0 ;
end
if standardize 
  dataMean = mean(data.data) ;
  dataVar = var(data.data) ;
  normFacNonZero = dataVar(dataVar > 0) ;
  modifier = min(normFacNonZero)/10 ;
  data.data = ...
      makeSlaveRef(bsxfun(@rdivide, bsxfun(@minus, data.data, dataMean), sqrt(dataVar+modifier))) ;
end
if whiten
  if ~data.whitened
    data.data = zcaWhitenOnSlave(data.data) ;
    data.whitened = 1 ;
  end
end

for i=1:1:numRFs
  portion = data.data(:, RFs(i,:)==1) ; 
  if strcmp(method, 'max')
    pooledData(:,i) = max(portion, [], 2)' ;
  elseif strcmp(method, 'mean')
    pooledData(:,i) = mean(portion, 2)' ;
  elseif strcmp(method, 'sqsqrt')
    pooledData(:,i) = sqrt(sum(portion.^2,2))' ;
  end
end

pooledData.data = pooledData ;
pooledData.numBlks = data.numBlks ;
pooledData.timeSteps = data.timeSteps ;
pooledData.whitened = 0 ;
pooledData.standardized = 0 ;
pooledData.dims = numRFs ;
if isfield(data, 'targets')
  pooledData.targets = data.targets ;
end

pooledData = makeSlaveRef(pooledData) ;
%pooledData = pooledData ;
