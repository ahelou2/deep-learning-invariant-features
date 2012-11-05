function image = show_centroids(centroids, H, W)

centroids = reshape(centroids, [size(centroids,1) size(centroids,2)*size(centroids,3)*size(centroids,4)]) ;

%colormap(gray(256));
centroids=centroids./(ones(size(centroids,1),1)*max(abs(centroids))); 
% centroids = centroids./repmat(sqrt(sum(centroids.^2,1)), [size(centroids,1) 1]) ;
% centroids = centroids*255 ;
centroids = bsxfun(@rdivide, bsxfun(@minus, centroids, mean(centroids,2)), sqrt(var(centroids,[],2)+1));
% C = cov(centroids);
% M = mean(centroids);
% [V,D] = eig(C);
% P = V * diag(sqrt(1./(diag(D) + 0.1))) * V';
% centroids = bsxfun(@minus, centroids, M) * P;

  if (nargin < 3)
    W = H;
  end
  N=size(centroids,2)/(H*W);
  assert(N == 3 || N == 1);  % color and gray images
  
  K=size(centroids,1);
  COLS=round(sqrt(K));
  ROWS=ceil(K / COLS);
  COUNT=COLS * ROWS;

  %clf; hold on;
  image=ones(ROWS*(H+1), COLS*(W+1), N)*100;
  for i=1:size(centroids,1)
    r= floor((i-1) / COLS);
    c= mod(i-1, COLS);
    image((r*(H+1)+1):((r+1)*(H+1))-1,(c*(W+1)+1):((c+1)*(W+1))-1,:) = reshape(centroids(i,1:W*H*N),H,W,N);
  end

%   mn=-1.5;
%   mx=+1.5;
  mn=-1;
  mx=1;
  image = (image - mn) / (mx - mn);
%     imshow(image);
imagesc(image, [0 1]); colormap(gray);
axis equal
axis off