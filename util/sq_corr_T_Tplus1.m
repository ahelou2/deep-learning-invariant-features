function [sq_corr_matrixT sq_corr_matrixTplus1 varT varTplus1] = ...
  sq_corr_T_Tplus1(data, varargin)

% DESCRIPTION:
% - This function computes the sq_corr of features for the set of frames at
% time T and time T+1.

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
timeSteps = rpcSwitch('extract4server', 'rpc', data, 'timeSteps') ;
if iscell(whitened)
  whitened = whitened{1} ;
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
if standardize
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

% sq_corr T
sq_corr_matrixT = zeros(numFeat) ;
numDataPtsT = rpcSwitch('@(x) size(x,1)', 'rpcsum', dataT) ;
sq_corr_matrixT = sq_corr_matrixT + ...
        rpcSwitch('@(x,z,a) transpose(bsxfun(@minus, x, a))*bsxfun(@minus, x, a)/z', 'rpcsum', ...
        dataT, numDataPtsT, meanT) ;
      
% sq_corr T+1
sq_corr_matrixTplus1 = zeros(numFeat) ;
numDataPtsTplus1 = rpcSwitch('@(x) size(x,1)', 'rpcsum', dataTplus1) ;
sq_corr_matrixTplus1 = sq_corr_matrixTplus1 + ...
        rpcSwitch('@(x,z,a) transpose(bsxfun(@minus, x, a))*bsxfun(@minus, x, a)/z', 'rpcsum', ...
        dataTplus1, numDataPtsTplus1, meanTplus1) ;


if xcorr
  normFac = varT'*varT ;
  normFacNonZero = normFac(normFac > 0) ;
  modifier = min(min(normFacNonZero))/10
  sq_corr_matrixT = sq_corr_matrixT./sqrt(normFac + modifier) ;
  
  normFac = varTplus1'*varTplus1 ;
  normFacNonZero = normFac(normFac > 0) ;
  modifier = min(min(normFacNonZero))/10
  sq_corr_matrixTplus1 = sq_corr_matrixTplus1./sqrt(normFac + modifier) ;
  
end