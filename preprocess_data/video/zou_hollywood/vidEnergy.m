function [E xdAll ydAll tdAll] = vidEnergy(data, spSize, tempSize, numBatches)
%function E = vidEnergy(data, spSize, tempSize)

% INPUTS:
%   - data has the same format as the output of the function
%   extract_video_blks.m. (spSize*spSize*tempSize) X (numBlks)
% NOTES:
% - A cutoff of 10-12 seems to be a fine number.

%numBlks = size(data,2) ;

%data = reshape(data, [spSize spSize tempSize numBlks]) ;
%xdAll = squeeze(sum(sum(sum((data(1:end-2,:,:,:) - data(3:end,:,:,:)).^2,1),2),3)) ;
%ydAll = squeeze(sum(sum(sum((data(:,1:end-2,:,:) - data(:,3:end,:,:)).^2,1),2),3)) ;
%tdAll = squeeze(sum(sum(sum((data(:,:,1:end-2,:) - data(:,:,3:end,:)).^2,1),2),3)) ;
%E = sqrt(xdAll+ydAll+tdAll) ;

numBlks = size(data,2) ;
data = reshape(data, [spSize spSize tempSize numBlks]) ;
numDataPtsPerBatch = ceil(numBlks/numBatches) ;

E = [] ;
for i=1:1:numBatches
	startIdx = (i-1)*numDataPtsPerBatch + 1 ;
	endIdx = min(i*numDataPtsPerBatch, numBlks) ;
	xdAll = squeeze(sum(sum(sum((data(1:end-2,:,:,startIdx:endIdx) - data(3:end,:,:,startIdx:endIdx)).^2,1),2),3)) ;
	ydAll = squeeze(sum(sum(sum((data(:,1:end-2,:,startIdx:endIdx) - data(:,3:end,:,startIdx:endIdx)).^2,1),2),3)) ;
	tdAll = squeeze(sum(sum(sum((data(:,:,1:end-2,startIdx:endIdx) - data(:,:,3:end,startIdx:endIdx)).^2,1),2),3)) ;
	%E = [E; sqrt(xdAll+ydAll+tdAll)] ;
  % Normalize
%   xdAll = (xdAll-mean(xdAll))/(var(xdAll)+10^-4) ;
%   ydAll = (ydAll-mean(ydAll))/(var(ydAll)+10^-4) ;
%   tdAll = (tdAll-mean(tdAll))/(var(tdAll)+10^-4) ;
  % Can't take sqrt because it is possible to get imaginary numbers
%   E = [E; xdAll+ydAll+4*tdAll] ;
  E = [E; sqrt(xdAll+ydAll+4*tdAll)] ;
end
