function tuningInfoAll = tuningCurveVisUtil(filters, rf_matrix, patchSize, freqno, orno, phaseno)

% Input
% - filters := num_filters X filters_dim

if nargin < 6
  freqno=25; %how many frequencies
  orno=40; %how many orientations
  phaseno=25; %how many phases
end

numRF = size(rf_matrix,1) ;
tuningInfoAll.orvalues = [] ;
tuningInfoAll.freqvalues = [] ;
tuningInfoAll.phasevalues = [] ;
tuningInfoAll.orresponses = zeros(numRF, orno) ;
tuningInfoAll.freqresponses = zeros(numRF, freqno) ;
tuningInfoAll.phaseresponses = zeros(numRF, phaseno) ;

fprintf('Computing Tuning Curves... ') ;
for i=1:1:numRF
  i
  tuningInfo = ...
     tuningCurve(filters, rf_matrix(i,:), patchSize, freqno, orno, phaseno) ;
  tuningInfoAll.orvalues = tuningInfo.orvalues ;
  tuningInfoAll.freqvalues = tuningInfo.freqvalues ;
  tuningInfoAll.phasevalues = tuningInfo.phasevalues ;
  tuningInfoAll.orresponses(i,:) = tuningInfo.orresponse ;
  tuningInfoAll.freqresponses(i,:) = tuningInfo.freqresponse ;
  tuningInfoAll.phaseresponses(i,:) = tuningInfo.phaseresponse ;
end
fprintf('Computing Tuning Curves... DONE\n') ;