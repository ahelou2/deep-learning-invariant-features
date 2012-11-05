function varargout = loadVars(varsPath, listOfVars2Load)

% - DESCRIPTION:
%   - This loads variables from a mat file without storing them in structures.
% - INPUT:
%   - listOfVars2Load := cell array of strings specifying variables to load

if nargin < 2
  listOfVars2Load = [] ;
end

if isempty(listOfVars2Load)
  varsStruct = load(varsPath) ;
else
  varsStruct = load(varsPath, listOfVars2Load{:}) ;
end
names = fieldnames(varsStruct) ;
for i=1:length(names)
  varargout{i} = varsStruct.(names{i}) ;
end