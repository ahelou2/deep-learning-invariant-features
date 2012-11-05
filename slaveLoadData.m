function data = slaveLoadData(dataPath, prefix, numSlaves, format, numFilesCap)

  % INPUT:
  % - numFilesCap: Number of files to process.
  % NOTES:
  % - The different between this function and slaveLoad is that this one
  % loads data divided amongst multiple files thus reducing loading time and
  % memory requirements.
  
  if nargin < 5
      numFilesCap = inf ;
  end

  dirlist = dir([dataPath '/' prefix]);
  totNumFiles = min(length(dirlist), numFilesCap) ;
  assert(totNumFiles >= numSlaves) ;
  filesIdxs = allocateSlaveWork(totNumFiles, numSlaves) ;
  data = ...
    rpcSwitch('eachSlaveLoad', 'rpc', dataPath, prefix, filesIdxs, format) ; 
end
