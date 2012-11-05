function [rf_matrix best_corr_score rf_matrix4disp avg_corr_scores] = RFCluster(sq_corr_matrix, T, ...
  mode, R_n, corr_thresh, limitRFSize, slow)

% function for constructing recepetive fields.
% R_n := number of receptive fields
% T := we place each feature x_i in the top T receptive fields with
% largest sq_corr values
% Mode := paper | avg | max
% slow := whether the sq_corr_matrix represents the slowness objective
% function.

%mode = 'avg' ;

if nargin < 6
  limitRFSize = inf ;
  slow = 0 ;
end
if nargin < 7
  slow = 0 ;
end

if ~slow
  assert(min(min(sq_corr_matrix)) >= -1 && max(max(sq_corr_matrix)) <= 1, ...
    'All entries in sq_corr_matrix must be between -1 and 1.') ;
else
  % Because I want to minimize
  sq_corr_matrix = -1*sq_corr_matrix ;
end
%corr_thresh = -10^5 ;

assert(R_n <= size(sq_corr_matrix,1)) ;
num_feat = size(sq_corr_matrix,1) ;
rf_matrix = zeros(R_n, num_feat) ;
best_rf_matrix = rf_matrix ;
best_corr_score = -inf ;
winner = 0 ;


if R_n == size(sq_corr_matrix)
  rf_matrix = eye(R_n, num_feat) ;
  initial_rf_elts = 1:1:num_feat ;
else
  initial_rf_elts = randperm(num_feat) ;
  for i=1:1:R_n
    rf_matrix(i, initial_rf_elts(i)) = 1 ;
  end
end

RFsCounter = zeros(R_n,1) ;
RFsCounter(initial_rf_elts(1:R_n),1) = 1 ;

corr_score = zeros(num_feat*T,1) ;
totalNumEltsInRFs = 0 ;
%UNCOMMENT START
for i=1:1:num_feat
  if strcmp(mode,'paper')
    [C I] = sort(sq_corr_matrix(i,initial_rf_elts), 'descend') ;
  elseif strcmp(mode, 'avg')
    sq_corr_matrix_vec = sq_corr_matrix(i,:) ;
    sq_corr_matrix_rep = sq_corr_matrix_vec(ones(R_n,1),:) ;
    avg = sum(sq_corr_matrix_rep.*(rf_matrix==1),2)./sum(rf_matrix==1,2) ;
    avg = avg' ;

    [C I] = sort(avg, 'descend') ;
  elseif strcmp(mode, 'max')
    sq_corr_matrix_vec = sq_corr_matrix(i,:) ;
    sq_corr_matrix_rep = sq_corr_matrix_vec(ones(R_n,1),:) ;
    sq_corr_matrix_rep(rf_matrix==0) = -10^5 ;
    maxCorr = max(sq_corr_matrix_rep, [],2) ;
    maxCorr = maxCorr' ;
    [C I] = sort(maxCorr, 'descend') ;
  elseif strcmp(mode, 'maxSuppressSelf')
    sq_corr_matrix_vec = sq_corr_matrix(i,:) ;
    sq_corr_matrix_vec(i,i) = -inf ;
    sq_corr_matrix_rep = sq_corr_matrix_vec(ones(R_n,1),:) ;
    sq_corr_matrix_rep(rf_matrix==0) = -inf ;
    maxCorr = max(sq_corr_matrix_rep, [],2) ;
    maxCorr = maxCorr' ;
    [C I] = sort(maxCorr, 'descend') ;
  end
  
  % construction start
%   modT = sum(C(1:1:T)> corr_thresh) ;
%   totalNumEltsInRFs = totalNumEltsInRFs + modT ;
%   rf_matrix(I(1:1:modT),i) = 1 ;
%   corr_score((i-1)*modT+1:i*modT) = C(1:modT) ;
  % construction end
  
  % new construction start
%   modT = min(sum(C(1:1:T)>= corr_thresh), limitRFSize-RFsCounter(i,1)) ;
%   totalNumEltsInRFs = totalNumEltsInRFs + modT ;
%   rf_matrix(I(1:1:modT),i) = 1 ;
%   RFsCounter(I(1:1:modT),1) = RFsCounter(I(1:1:modT),1) + 1 ;
%   corr_score((i-1)*modT+1:i*modT) = C(1:modT) ;
  % new construction end
  
  % new^2 construction start
  potentials = (RFsCounter(I) + 1) <= limitRFSize ;
  I((potentials==0)' | (C < corr_thresh) | (rf_matrix(I,i) == 1)') = [] ;
  t = min(T, length(I)) ;
  rf_matrix(I(1:1:t),i) = 1 ;
  RFsCounter(I(1:1:t),1) = RFsCounter(I(1:1:t),1) + 1 ;
  
  % new^2 construction end
end
% UNCOMMEND END
%corr_score = mean(corr_score) ;
corr_score = sum(corr_score)/totalNumEltsInRFs ;
if corr_score > best_corr_score
  best_corr_score = corr_score 
  best_rf_matrix = rf_matrix ;
  winner = 1 ;
end

if winner
  rf_matrix = best_rf_matrix ;
end
rf_matrix4disp = [] ;

% avg corr score per RF
avg_corr_scores = zeros(R_n,1) ;
for i=1:1:R_n
  avg_corr_scores(i,1) = mean(mean(triu(sq_corr_matrix(rf_matrix(i,:)==1,rf_matrix(i,:)==1)))) ;
end