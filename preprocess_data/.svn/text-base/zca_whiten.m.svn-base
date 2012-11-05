function [features M P] = zca_whiten(features)

% Input:
%   - features = num_data_pts X num_features matrix

fprintf('Whitening with ZCA \n') ;
tic
C = cov(features);
M = mean(features);
[V,D] = eig(C);
P = V * diag(sqrt(1./(diag(D) + 0.01))) * V';
features = bsxfun(@minus, features, M) * P;
toc
fprintf('Done whitening with ZCA \n') ;