function responses = extractResponses(data, filters, varargin)

% INPUT:
%   - data := follows convention set in main. Only works for 2D data.
%   - filters := struct with the following fields. Only works for 2D
%   filters.
%     - filters := numFilters X filterDim
%     - dims := [dim1 dim2]
% OUTPUT:
%   - responses := numDataPts X (numFilters x mapDims)
% NOTES:
%   - This function only works with 2D data and filters.

%Process options
%if args are just passed through in calls they become cells
if (isstruct(varargin)) 
    args= prepareArgs(varargin{1});
else
    args= prepareArgs(varargin);
end
[   normalize      ...
] = process_options(args    , ...
'normalize'      ,  1            );

numDataPts = size(data.data,1) ;
dataDim = size(data.data,2) ;
numFilters = size(filters.filters,1) ;
filtersDim = size(filters.filters,2) ;
responsesDims = data.dims - filters.dims + 1 ;

% Normalize filters and data to have unit norm
if normalize
  normFac = sqrt(var(filters.filters)) ;
  normFacNonZero = normFac(normFac > 0) ;
  modifier = min(normFacNonZero)/10 ;
  filters.filters = ...
    bsxfun(@rdivide, bsxfun(@minus, filters.filters, mean(filters.filters)), normFac+modifier) ;
  normFac = sqrt(var(data.data)) ;
  normFacNonZero = normFac(normFac > 0) ;
  modifier = min(normFacNonZero)/10 ;
  data.data = ...
    bsxfun(@rdivide, bsxfun(@minus, data.data, mean(data.data)), normFac+modifier) ;
end

% There are 2 main cases to consider:
%   - case 1: data and filters have different dimensions -> use convolution
%   - case 2: data and filters have same dimensions -> use matrix multiplication

% case 1:
if filtersDim ~= dataDim
  responses = zeros([numDataPts, numFilters, responsesDims]) ;
  data.data = permute(data.data, [2 1]) ;
  data.data = squeeze(reshape(data.data, [data.dims numDataPts])) ;
  %dataOrigForm = reshape(data.data, [numDataPts data.dims]) ;
  filters.filters = permute(filters.filters, [2 1]) ;
  filters.filters = reshape(filters.filters, [filters.dims numFilters]) ;
  %filtersOrigForm = reshape(filters.filters, [numFilters filters.dims]) ;
  for i=1:1:numFilters
    for j=1:1:numDataPts
      %responses(j,i) = conv2(dataOrigForm(j), filtersOrigForm(i), 'valid') ;
      responses(j,i,:,:) = conv2(data.data(:,:,j), filters.filters(:,:,i), 'valid') ;
    end
  end
  responses = reshape(responses, [numDataPts numFilters*prod(responsesDims)]) ;
end

% case 2:
if filtersDim == dataDim
  responses = data.data*transpose(filters.filters) ; 
end

responses.data = responses ;
%responses.dims = [numDataPts numFilters responsesDims] ;
if sum(responsesDims)/length(responsesDims) ~=1
  responses.dims = [numFilters responsesDims] ;
else
  responses.dims = numFilters ;
end
responses.timeSteps = data.timeSteps ;
responses.numBlks = data.numBlks ;
responses.whitened = 0 ;
responses.standardized = 0 ;
if isfield(data, 'targets')
  responses.targets = data.targets ;
end

responses = makeSlaveRef(responses) ;