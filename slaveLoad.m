function data = slaveLoad(dataLoc, format, numSlaves, slaveIdx)

% global ID ;
% ID = slaveIdx ;

% INPUT

% NOTES:
% - numSlaves can be extracted from global options.

if format == 'zou'
    data = load(dataLoc) ;
    numBlks = size(data.X,2) ;
    % To simplify things, I want all slaves to have the same number of data
    % pts.
    blksPerBatch = floor(numBlks/numSlaves) ;
    data.X = ...
        data.X(:, (slaveIdx-1)*blksPerBatch+1:slaveIdx*blksPerBatch) ;
end

data = makeSlaveRef(data) ;
