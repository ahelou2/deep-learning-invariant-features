function [phaseInvTest hartiganDipTest localMaximaTest] = ...
  processTuningInfo(tuningInfoAll, filters, RFMat, SAVEDIR, saveIdxMod)

addpath /afs/cs.stanford.edu/u/ahelou2/projects/phaseInvRFPool/misc/hartiganDipStat
addpath /afs/cs.stanford.edu/u/ahelou2/projects/phaseInvRFPool/misc/extrema

if nargin < 5
  saveIdxMod = 0 ;
end

numRF = size(RFMat,1) ;
assert(size(tuningInfoAll.freqresponses,1) == numRF) ;
numTuningCurves = numRF ;
orvalues = tuningInfoAll.orvalues ;
freqvalues = tuningInfoAll.freqvalues ;
phasevalues = tuningInfoAll.phasevalues ;
orresponses = tuningInfoAll.orresponses ;
freqresponses = tuningInfoAll.freqresponses ;
phaseresponses = tuningInfoAll.phaseresponses ;
phaseInvTest = zeros(numRF,1) ;
%hartiganDipTest = zeros(numRF,1) ;
hartiganDipTest = zeros(numRF,2) ;
%localMaximaTest = zeros(numRF,1) ;
localMaximaTest = zeros(numRF,2) ;

for i=1:1:numTuningCurves
  i
  %plot phase tuning curve
  %h = figure(1) ;
  h = figure('visible', 'off') ;
  subplot(2,2,1); plot(phasevalues,phaseresponses(i,:)); title('Phase'); 
  axis([min(phasevalues),max(phasevalues),-1,1]);

  %plot freq tuning curve
  subplot(2,2,2); plot(freqvalues,freqresponses(i,:)); title('Freq'); 

  %plot orientation tuning curve
  subplot(2,2,3); plot(orvalues,orresponses(i,:)); title('Orientation');

  %subplot(2,2,4); imshow(zeros(5,5)); title('zeros') ;

  subplot(2,2,4);
  % Visualize RF
  rf_matrix4disp = filters(RFMat(i,:)==1,:) ;
  show_centroids(rf_matrix4disp, sqrt(size(filters,2))) ;
  numQuadPairs = compNumQuadPairs(RFMat(i,:)) ;
  title(['RF visual. numQuadPairs = ' num2str(numQuadPairs)]);
  print(h, '-djpeg', [SAVEDIR '/' num2str(i+saveIdxMod) '.jpeg']) ;
  
  % compute 3 performance indicators: phaseInvTest, hartiganDipTest and localMaximaTest
%   if min(phaseresponses(i,:) >= 0.6)
%     [dipOr, pOr] = HartigansDipSignifTest(orresponses(i,:), 100); 
%     [dipFreq, pFreq] = HartigansDipSignifTest(freqresponses(i,:), 100);
%     if dipOr < 0.04 && dipFreq < 0.04
%       hartiganDipTest(i,1) = 1 ;
%     end
%     zmaxOr= extrema(orresponses(i,:));
%     zmaxFreq= extrema(freqresponses(i,:));
%     if length(zmaxOr) == 1 && length(zmaxFreq) == 1
%       localMaximaTest(i,1) = 1 ;
%     end
%   end

%   if min(phaseresponses(i,:) >= 0.6)
%     phaseInvTest(i,1) = 1 ;
%   end
%   
%   [dipOr, pOr] = HartigansDipSignifTest(orresponses(i,:), 100); 
%   [dipFreq, pFreq] = HartigansDipSignifTest(freqresponses(i,:), 100);
%   if dipOr < 0.04 && dipFreq < 0.04
%     hartiganDipTest(i,1) = 1 ;
%   end
%     
%   zmaxOr= extrema(orresponses(i,:));
%   zmaxFreq= extrema(freqresponses(i,:));
%   if length(zmaxOr) == 1 && length(zmaxFreq) == 1
%       localMaximaTest(i,1) = 1 ;
%   end

  phaseInvTest(i,1) = min(phaseresponses(i,:)) ;
  
  [dipOr, pOr] = HartigansDipSignifTest(orresponses(i,:), 100); 
  [dipFreq, pFreq] = HartigansDipSignifTest(freqresponses(i,:), 100);
  hartiganDipTest(i,1) = dipOr ;
  hartiganDipTest(i,2) = dipFreq ;
    
  zmaxOr= extrema(orresponses(i,:));
  zmaxFreq= extrema(freqresponses(i,:));
  localMaximaTest(i,1) = length(zmaxOr) ;
  localMaximaTest(i,2) = length(zmaxFreq) ;
  
end