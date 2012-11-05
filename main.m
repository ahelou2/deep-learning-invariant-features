function [filters RFMatC corrMatrix responses] = main(varargin)

% NOTES:
%   - All function arguments must start with specifying rpcCall varialbe in
%   rpcSwitch function. 
%   - data structure standardization. The data structure will have the
%   following fields:
%       - data := numDataPts X dataPtDim
%       - numBlks
%       - timeSteps
%       - whitened
%       - dims := 1D vector specifying size of each dimension. length(dims)
%           = number of dimensions.
%   - filters := struct with the following fields. 
%     - filters := numFilters X filterDim
%     - dims := [dim1 dim2]

%addpath('/afs/cs.stanford.edu/u/ahelou2/projects/learnInvFeat/util') ;

global server ;
global options ;
global ID ;
options = varargin{1} ;
ID = 0 ; % Server gets ID 0. This will be used for saving data purposes.

%Process options
%if args are just passed through in calls they become cells
if (isstruct(varargin)) 
    args= prepareArgs(varargin{1});
else
    args= prepareArgs(varargin);
end
[   server         ...
    slaveCount     ...
    loadDataF      ...
    loadDataFvars  ...
    preProcF       ...
    preProcFvars   ...
    corrF          ...
    corrFvars      ...
    RFClusterF     ...
    RFClusterFvars ...
    learnWF        ...
    learnWFvars    ...
    compRespF      ...
    compRespFvars  ...
    poolF          ...
    poolFvars      ...
    stagesExe      ...
    savesDir       ...
    responses      ...
] = process_options(args           , ...
'server'         ,  ''             , ...
'slaveCount'     ,  ''             , ...
'loadDataF'      ,  ''             , ...
'loadDataFvars'  ,  {}             , ...
'preProcF'       ,  ''             , ...
'preProcFvars'   ,  {}             , ...
'corrF'          ,  ''             , ...
'corrFvars'      ,  {}             , ...
'RFClusterF'     ,  ''             , ...
'RFClusterFvars' ,  {}             , ...
'learnWF'        ,  ''             , ...
'learnWFvars'    ,  {}             , ...
'compRespF'      ,  ''             , ...
'compRespFvars'  ,  {}             , ...
'poolF'          ,  ''             , ...
'poolFvars'      ,  {}             , ...
'stagesExe'      ,  [1 2 3 4 5]    , ...
'savesDir'       , 'cannotBeEmpty' , ...
'responses'      ,  {}                   ) ;

if strcmp(server, '')
    options.slavecount = slaveCount ;
    server = Server(options) ;
    server.rpc('rehash') ;
end

% Set independent random streams for each slave. This is done mainly to
% prevent the gaborGenerate.m function from generating the same gabors.
% RS = RandStream.create('mrg32k3a','NumStreams',3, 'CellOutput', slaveCount) ;
% rpcSwitch('@(x) RandStream.setGlobalStream(x)', 'rpc', RS) ;
%rpcSwitch('@(x) RandStream.setGlobalStream(RandStream(''mrg32k3a'', ''Seed'', 2^x))', 'rpc', num2cell(1:slaveCount)) ;
server.rpc('slaveRandSeed');

save = 0 ;
if ~strcmp(savesDir, 'cannotBeEmpty')
  save = 1 ;
end
if save
   assert(exist(savesDir)==7, 'Save directory op.savesDir does not exist') ;
end

% 0- Preprocessd data
%   0.1- choose location of data
if isempty(loadDataF)
    error('main:loadDataF', 'You must specify a function for loading data') ;
end
fprintf('Loading Data... ') ;
data = rpcSwitch(loadDataF, loadDataFvars{1}, loadDataFvars{2:end}) ;
fprintf('DONE\n') ;
%   0.2- choose function for preprocessing data 
if ~isempty(preProcF)
    fprintf('Proprocessing Data... ') ;
    data = rpcSwitch(preProcF, preProcFvars{1}, data, preProcFvars{2:end}) ;
    fprintf('DONE\n') ;
end
% At this point, data.data must have the form numDataPts X dataPtsDim

% 1- Learn simple RF
if sum(stagesExe == 1) > 0
  fprintf('Computing Correlation Matrix for Simple RF... ') ;
  corrMatrix = rpcSwitch(corrF, corrFvars{1}, data, corrFvars{2:end}) ;
  fprintf('DONE\n') ;
  fprintf('Forming Simple Receptive Fields... ') ;
  RFMatS = rpcSwitch(RFClusterF, RFClusterFvars{1}, corrMatrix, RFClusterFvars{2:end}) ;
  fprintf('DONE\n') ;
  rpcSwitch('saveData', 'noRPC', savesDir, RFMatS, 'RFMatS', 0, save) ;
  %save([savesDir '/' 'RFMatS' '_ID' ID '.mat'], 'RFMatS') ;
end
% 2- Extract filters
if sum(stagesExe == 2) > 0
  fprintf('Extracting filters... ') ;
  filters = rpcSwitch(learnWF, learnWFvars{1}, data, learnWFvars{2:end}) ;
  % HACK
  % This is needed because rpcvertcat currently concatenates all the fields
  % of a structure. But some fields such as dims should not be concatenated
  % because they contain the same information across all slaves.
  filters.dims = filters.dims(1,:) ;
  % HACK DONE
  fprintf('DONE\n') ;
  rpcSwitch('saveData', 'noRPC', savesDir, filters, 'filters', 0, save) ;
  %save([savesDir '/' 'filters' '_ID' num2str(ID) '.mat'], 'filters') ;
end
% 3- Extract simple responses
if sum(stagesExe == 3) > 0
  fprintf('Computing simple responses... ') ;
  responses = ...
    rpcSwitch(compRespF, compRespFvars{1}, data, filters, compRespFvars{2:end}) ;
  fprintf('DONE\n') ;
  rpcSwitch('saveData', 'rpc', savesDir, responses, 'data', num2cell(1:slaveCount), save, 'responses') ;
  %server.rpc('@(x,y) save([x "/" "responses" "_ID" num2str(y) ".mat"], "responses")', savesDir, num2cell(1:slaveCount)) ;
end
% 4- Learn complex RF
if sum(stagesExe == 4) > 0
  fprintf('Computing Correlation Matrix for Complex RF... ') ;
  corrMatrix = rpcSwitch(corrF, corrFvars{1}, responses, corrFvars{2:end}) ;
  fprintf('DONE\n') ;
  fprintf('Forming Complex Receptive Fields... ') ;
  RFMatC = rpcSwitch(RFClusterF, RFClusterFvars{1}, corrMatrix, RFClusterFvars{2:end}) ;
  fprintf('DONE\n') ;
  %rpcSwitch('saveData', 'noRPC', savesDir, RFMatC, 'RFMatC', 0, save) ;
  %save([savesDir '/' 'RFMatC' '_ID' ID '.mat'], 'RFMatC') ;
end
% 4.1- Load complex RF. Skip stage 4 since RF matrix has already been
% computed in a previous run.
if sum(stagesExe == 4.1) > 0
  RFMatC = rpcSwitch(RFClusterF, RFClusterFvars{1}, RFClusterFvars{2:end}) ;
end

% 5- Extract complex responses
if sum(stagesExe == 5) > 0
  fprintf('Pooling... ') ;
%   pooledData = ...
%     rpcSwitch(poolF, poolFvars{1}, data, RFMatC, poolFvars{2:end}) ;
  pooledData = ...
    rpcSwitch(poolF, poolFvars{1}, responses, RFMatC, poolFvars{2:end}) ;
  fprintf('DONE\n') ;
  %rpcSwitch('saveData', 'rpc', savesDir, pooledData, 'pooledData', num2cell(1:slaveCount), save, 'pooledData') ;
  rpcSwitch('saveData', 'rpc', savesDir, pooledData, 'data', num2cell(1:slaveCount), save, 'pooledData') ;
  %server.rpc('@(x,y,z) save([x "/" "pooledData" "_ID" y ".mat"], "pooledData")', savesDir, num2cell([1:slaveCount])) ;
end
