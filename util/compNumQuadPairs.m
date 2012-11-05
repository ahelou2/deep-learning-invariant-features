function numQuadPairs = compNumQuadPairs(RFMat)

% This function will compute the number of quad pairs in each RF assuming
% that the filters have been ordered in the following manner: [quadPair1
% quadPair1 quadPair2 quadPair2 quadPair3 quadPair3 ...]

% INPUTS:
% - RFMat := numRFs X numFilters. numFilters is even.

numRFs = size(RFMat,1) ;
numFilters = size(RFMat,2) ;
ONES = ones(numRFs, numFilters/2) ;
ZEROS = zeros(numRFs, numFilters/2) ;
odd = interweaveMat(ONES, ZEROS,1) ;
even = interweaveMat(ZEROS,ONES, 1) ;
oddEx = reshape(RFMat(odd==1), [numRFs,numFilters/2]) ;
evenEx = reshape(RFMat(even==1), [numRFs,numFilters/2]) ;
evenEx(evenEx==0)=-1 ;
numQuadPairs = sum(oddEx==evenEx,2) ;