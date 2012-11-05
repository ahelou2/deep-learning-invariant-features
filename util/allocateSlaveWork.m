function [workIdxs disregardSlaves] = allocateSlaveWork(workAlocDimSize, numSlaves)

% Distributes the chunks of data which need to be processed on each slave.
% INPUT:
% - workVar: The variable which will be distributed among the slaves.
% - workAlocDim: The dimension along which workVar should be partitioned.
% OUTPUT:
% - cell array of size numSlaves specifying the portion of workVar which
%   will be processed by each slave. {workVarSlave1, workVarSlave2, ...}

disregardSlaves = [] ;
%workAlocDimSize = size(workVar, workAlocDim) ;
if workAlocDimSize <= numSlaves
  workPortionPerSlave = ceil(workAlocDimSize/numSlaves) ;
else
  workPortionPerSlave = floor(workAlocDimSize/numSlaves) ;
  leftOverWork =  workAlocDimSize-mod(workAlocDimSize,numSlaves)+1:1:workAlocDimSize ;
end
workIdxs = 1:1:numSlaves*workPortionPerSlave ;
if workAlocDimSize < numSlaves
  numDisregardSlaves = sum(workIdxs > workAlocDimSize) ;
else
  numDisregardSlaves = 0 ;
end

workIdxs(workIdxs > workAlocDimSize) = -workAlocDimSize ;

workIdxs = reshape(workIdxs, [workPortionPerSlave numSlaves]) ;
workIdxs = num2cell(workIdxs, 1) ;


for i=1:numSlaves
      %TF = isnan(workIdxs{i}) ;
%       TF = workIdxsP2{i} < 0 ;
%       delete = sum(TF) ;
      workIdxs{i}(workIdxs{i} < 0) = workAlocDimSize ;
end

disregardSlaves = 1:1:numSlaves ;
disregardSlaves(1:1:end-numDisregardSlaves) = [] ;

if workAlocDimSize > numSlaves && ~isempty(leftOverWork)
  
  workAlocDimSize = length(leftOverWork) ;
  workPortionPerSlave = ceil(workAlocDimSize/numSlaves) ;
  
  workIdxsP2 = leftOverWork(1):1:leftOverWork(1)-1+numSlaves*workPortionPerSlave ;
  
  workIdxsP2(workIdxsP2 > leftOverWork(end)) = -leftOverWork(end);
  
  workIdxsP2 = reshape(workIdxsP2, [workPortionPerSlave numSlaves]) ;
  workIdxsP2 = num2cell(workIdxsP2, 1) ;
    for i=1:numSlaves
      %TF = isnan(workIdxs{i}) ;
%       TF = workIdxsP2{i} < 0 ;
%       delete = sum(TF) ;
      workIdxsP2{i}(workIdxsP2{i} < 0) = [] ;
    end
    
    for i=1:1:length(workIdxs)
      workIdxs{i} = [workIdxs{i}; workIdxsP2{i}]; 
    end
end
