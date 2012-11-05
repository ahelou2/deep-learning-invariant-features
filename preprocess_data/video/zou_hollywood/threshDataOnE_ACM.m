function [data numData] = threshDataOnE_ACM(data, spSize, tempSize, numBatches, EThresh, ACMThresh, vis)

if nargin < 7
  vis = 0 ;
end

E = vidEnergy(data, spSize, tempSize, numBatches) ;
ACM = detectAbrubtChange(data, spSize, tempSize, numBatches) ;
ETake = E > EThresh ;
sum(ETake)
ACMTake = sum((ACM < ACMThresh),2) == size(ACM,2) ;
sum(ACMTake)
take = ETake & ACMTake ;
numData = sum(take) ;
data = data(:,take) ;
if vis
  data = standardizeZou_Holly(data, spSize, tempSize) ;
  figure; show_centroids(data.data(1:1000,:), spSize) ;
end