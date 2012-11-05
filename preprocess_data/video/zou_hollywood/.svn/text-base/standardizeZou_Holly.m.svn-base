function data = standardizeZou_Holly(data, spatial_size, temp_size)
% FUNCTION:
% Standardize hollywood video blks produced by Zou's extract_video_blks
% function.
% INPUT:
% data := (spatial_size^2*temp_size) X num_blks
% temp_size := number of video frames in a blk
% OUTPUT:
% data with fields:
% data := (num_blks*temporal_size) X spatial_size^2
% other obvious fields

if isstruct(data)
    data = data.X ;
end

numBlocks = size(data,2) ;
data = reshape(data, [spatial_size^2 temp_size numBlocks]) ;
data = reshape(data, [spatial_size^2 temp_size*numBlocks]) ;
data = permute(data, [2 1]) ;
data.data = data ;
% data.height = spatial_size ;
% data.width = spatial_size ;
data.dims = [spatial_size spatial_size] ;
data.timeSteps = temp_size ;
data.numBlks = numBlocks ;
data.whitened = 0 ;
data.standardized = 0 ;

data = makeSlaveRef(data) ;
