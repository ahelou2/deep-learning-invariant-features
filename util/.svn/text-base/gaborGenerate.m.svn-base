function filters = gaborGenerate(data, count, sz)

% INPUTS:
%   - := RandStream object used for generating random numbers. I
%   needed because I am generating gabors on each slave independently and
%   they all share the same global RandStream object, thus generating
%   exactly the same gabors.

% NOTES:
%   - This functions does not need the input variable data. It is there
%   however to stay true to the interface specified in main.

  
theta = [0:15:359] .* (pi/180.0);
asp = [0.5 1 1.5 2];%[ 1 2 2 3 3 3 4 4 4 ];
sig = sz ./ [ 12 12 8 8 6];
phi = [ 0:22.5:359 ] .* (pi/180.0);
lambda = sz ./ [ 1.5 2 3 5 ];

px = (2:sz-1) - sz/2;
py = (2:sz-1) - sz/2;

filters = zeros(count, sz*sz);

t = theta(ceil(length(theta).*rand(count,1)));
a = asp(ceil(length(asp).*rand(count,1)));
s = sig(ceil(length(sig).*rand(count,1)));
p = phi(ceil(length(phi).*rand(count,1)));
l = lambda(ceil(length(lambda).*rand(count,1)));

x = px(ceil(length(px).*rand(count,1)));
y = py(ceil(length(py).*rand(count,1)));

for i=1:count
  g = compute_gabor(l(i),p(i),t(i),a(i),s(i), sz, x(i), y(i));
  filters(i,:) = reshape(g,1,numel(g));
end
filters=bsxfun(@rdivide, filters, sqrt(sum(filters.^2,2)));

quadPairs = filters;
for i=1:count
  g = compute_gabor(l(i),p(i)+pi/2,t(i),a(i),s(i), sz, x(i), y(i));
  quadPairs(i,:) = reshape(g,1,numel(g));
end
quadPairs=bsxfun(@rdivide, quadPairs, sqrt(sum(quadPairs.^2,2)));


%filters.filters = [filters; quadPairs] ;
% filters.filters = [quadPair1; quadPair1; quadPair2; quadPair2 ....]
filters.filters = interweaveMat(filters, quadPairs) ;
filters.dims = [sz sz] ;
