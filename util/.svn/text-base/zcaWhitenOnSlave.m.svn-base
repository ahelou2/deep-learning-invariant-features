function [features M P] = zcaWhitenOnSlave(features)

% NOTES:
%   - This function was written because zcaWhiten.m only works properly if
%   called from the server.

% Input:
%   - features = num_data_pts*num_features matrix

fprintf('Whitening with ZCA \n') ;
tic
C = cov(features);
M = mean(features);
[V,D] = eig(C);
P = V * diag(sqrt(1./(diag(D) + 0.1))) * V';
features = bsxfun(@minus, features, M) * P;
toc
fprintf('Done whitening with ZCA \n') ;