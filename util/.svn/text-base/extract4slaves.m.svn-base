function y = extract4slaves(x, fieldName)

% NOTES:
%   - Would it be legal to do y = makeSlaveRef(x.(fieldName))? If yes then
%   I would save on duplicating variables.

if iscell(x)
  y = cell(1, length(x)) ;

  for i=1:1:length(x)
    y{i} = x{i}.(fieldName) ;
  end
else
  y = x.(fieldName) ;
  y = makeSlaveRef(y) ;
end

