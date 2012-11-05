function C = interweaveMat(A, B, col)
% Combine two matrices of equal sizes into one by alternating rows (or col) from
% each.

if nargin < 3
  col = 0 ;
end
if col
  A = A' ;
  B = B' ;
end

nA = size(A,1);
nB = size(B,1);
C = zeros(2*size(A,1), size(A,2));
C(1:2:2*nA-1,:) = A;
C(2:2:2*nB,:) = B;

if col
  C = C' ;
end
end
