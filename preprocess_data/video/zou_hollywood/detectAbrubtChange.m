function ACM = detectAbrubtChange(data, spSize, tempSize, numBatches)

% Cutoff of 5 seems like a fine number.

numBlks = size(data,2) ;
data = reshape(data, [spSize spSize tempSize numBlks]) ;
numDataPtsPerBatch = ceil(numBlks/numBatches) ;

ACM = [] ;

for i=1:1:numBatches
  startIdx = (i-1)*numDataPtsPerBatch + 1 ;
	endIdx = min(i*numDataPtsPerBatch, numBlks) ;
  tdAll = squeeze(sum(sum((data(:,:,2:end,startIdx:endIdx)-data(:,:,1:end-1,startIdx:endIdx)).^2,1),2)) ;
  %ACM = mean(tdAll) ;
  %ACM = [ACM; mean(sqrt(tdAll))'];
  ACM = [ACM; sqrt(tdAll)'];
  %ACM = [ACM; mean(tdAll)'];
end