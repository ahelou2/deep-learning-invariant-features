function sq_corr_matrix = sq_corr_temporal(data, varargin)

%fprintf('new') ;

% INPUT:
%   - data.data = num_data_pts X num_features matrix
%   - data.numBlks = number of video blocks in data.data

% NOTES:
%   - timeSteps, mapH, mapW, slaveCount can be captured from global
%   options.

% WARNINGS:
%   - I still remain suspicious that I'm computing the sq_corr matrix
%   correctly. One source of my suspicion, is that the correlation matrix
%   (after normalizing xcov) is never negative!
%   - I run out of java heap space whenever the sq corr matrix is 10000 X
%   10000. The only solution I can think of is to save the corr matrices
%   into file and have the server load them and sum them up.

%Process options
%if args are just passed through in calls they become cells
if (isstruct(varargin)) 
    args= prepareArgs(varargin{1});
else
    args= prepareArgs(varargin);
end
[   standardize               ...
    xcorr                     ...
] = process_options(args    , ...
'standardize'      ,  1     , ...
 'xcorr'           ,  1          );

features = rpcSwitch('extract4slaves', 'rpc', data, 'data') ;
num_blks = rpcSwitch('extract4slaves', 'rpc', data, 'numBlks') ;
whitened = rpcSwitch('extract4server', 'rpc', data, 'whitened') ;
standardized = rpcSwitch('extract4server', 'rpc', data, 'standardized') ;
timeSteps = rpcSwitch('extract4server', 'rpc', data, 'timeSteps') ;
if iscell(whitened)
  whitened = whitened{1} ;
end
if iscell(standardized)
  standardized = standardized{1} ;
end
if iscell(timeSteps)
  timeSteps = timeSteps{1} ;
end
numFeat = rpcSwitch('@(x) size(x,2)', 'rpc', features) ;
if iscell(numFeat)
    numFeat = numFeat{1} ;
end
%num_blks = rpcSwitch('@(x) x', 'rpcsum', num_blks) ;

% normalize for contrast
featMean = myMean(features) ;
featVar = myVar(features) ;
if standardize && ~standardized
  normFacNonZero = featVar(featVar > 0) ;
  modifier = min(normFacNonZero)/10
  features = ...
      rpcSwitch('@(x,y,z,a) makeSlaveRef(bsxfun(@rdivide, bsxfun(@minus, z, x), sqrt(y+a)))', ...
      'rpc', featMean, featVar, features, modifier) ;
end
% whitening
if ~whitened
    features = zcaWhiten(features) ;
end
features = rpcSwitch('@(x) makeSlaveRef(x.^2)', 'rpc', features) ;

% mean computation for X_T distribution and X_Tplus1 distribution
maskT = pickFrmsAtTimeT4sq_corr_temporal(num_blks, timeSteps, timeSteps) ;
dataT = ...
  rpcSwitch('@(x,y,z) makeSlaveRef(x(y==z,:))', 'rpc', features, maskT, 0) ;
meanT = myMean(dataT) ;

maskTplus1 = pickFrmsAtTimeT4sq_corr_temporal(num_blks, timeSteps, 1) ;
dataTplus1 = ...
  rpcSwitch('@(x,y,z) makeSlaveRef(x(y==z,:))', 'rpc', features, maskTplus1, 0) ;
meanTplus1 = myMean(dataTplus1) ;

% variance computation for X_T distribution and X_Tplus1 distribution
varT = myVar(dataT) ;
varTplus1 = myVar(dataTplus1) ;
  
time_features = cell(1, timeSteps) ;
for i=1:1:timeSteps
	mask = pickFrmsAtTimeT4sq_corr_temporal(num_blks, timeSteps, i) ;
    time_features{1,i} = ...
        rpcSwitch('@(x,y,z) makeSlaveRef(x(y==z,:))', 'rpc', features, mask, 1) ;
end

sq_corr_matrix = zeros(numFeat) ;
%numDataPtsT = rpcSwitch('@(x) size(x,1)', 'rpcsum', time_features{1,1}) ;
numDataPtsT = rpcSwitch('@(x) size(x,1)', 'rpcsum', dataT) ;
for i=1:1:timeSteps-1
sq_corr_matrix = sq_corr_matrix + ...
        rpcSwitch('@(x,y,z,a,b) transpose(bsxfun(@minus, x, a))*bsxfun(@minus, y, b)/z', 'rpcsum', ...
        time_features{1,i}, time_features{1,i+1}, numDataPtsT, meanT, meanTplus1) ;
end

if xcorr
  normFac = varT'*varTplus1 ;
  normFacNonZero = normFac(normFac > 0) ;
  modifier = min(min(normFacNonZero))/10
  sq_corr_matrix = sq_corr_matrix./sqrt(normFac + modifier) ;
  %sq_corr_matrix = sq_corr_matrix./sqrt(varT'*varTplus1+10^-10) ;
end