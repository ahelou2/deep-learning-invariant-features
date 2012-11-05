function divideData(dataPath, prefix, numCuts)

% Loads data with prefix prefix from dataPath, divides each data file into
% numCuts and then save into same folder. Also deletes original data files.
% - NOTE
%     - Functions assumes that data files contain structures named data with
%     fields: data (numDataPts X dataDims), dims, timeSteps, numBlks, whitened,
%     standardized.

dirlist = dir([dataPath '/' prefix]);
totNumFiles = length(dirlist) ;

for i=1:1:totNumFiles
  fileName = dirlist(i).name ; 
  fprintf('Loaded file %s \n', fileName) ;
  load([dataPath '/' fileName]) ;
  dataBak = data ;
  blksPerFile = ceil(dataBak.numBlks/numCuts) ;
  for j=1:1:numCuts 
    data.data = ...
      dataBak.data(data.timeSteps*(j-1)*blksPerFile+1:data.timeSteps*min(j*blksPerFile, dataBak.numBlks),:) ;
    numBlks = min(j*blksPerFile, dataBak.numBlks) - (j-1)*blksPerFile ;
    data.numBlks = numBlks ;
    if isfield(data, 'targets')
      data.targets = ...
        dataBak.targets(data.timeSteps*(j-1)*blksPerFile+1:data.timeSteps*min(j*blksPerFile, dataBak.numBlks),:) ;
    end
    save([dataPath '/' strrep(fileName, '.mat', '') '_P' num2str(j)], 'data') ;
  end
  delete([dataPath '/' fileName]) ;
end
