function data = eachSlaveLoad(dataPath, prefix, filesIdxs, format)

  dirlist = dir([dataPath '/' prefix]);
  numFiles = length(filesIdxs) ;
  if strcmp(format, 'zou')
    data.X = [] ;
  elseif strcmp(format, 'justLoad')
    data.numBlks = 0 ;
    data.dims = [] ;
    data.timeSteps = 0 ;
    data.data = [] ;
    data.whitened = 0 ;
    data.standardized = 0 ;
    data.targets = [] ;
  end
  for i=1:1:numFiles
    i
    filename = dirlist(filesIdxs(i)).name;
    if strcmp(format, 'zou')
      X = load([dataPath '/' filename]) ;
      data.X = [data.X X.X] ;
    elseif strcmp(format, 'justLoad')
      dataPart = loadVars([dataPath '/' filename]) ;
      data.numBlks = data.numBlks + dataPart.numBlks ;
      data.dims = dataPart.dims ;
      data.timeSteps = dataPart.timeSteps ; 
      data.data = [data.data; dataPart.data] ;
      data.whitened = dataPart.whitened ;
      data.standardized = dataPart.standardized ;
      if isfield(dataPart, 'targets')
        data.targets = [data.targets; dataPart.targets] ;
      end
    end
  end
  data = makeSlaveRef(data) ;
end