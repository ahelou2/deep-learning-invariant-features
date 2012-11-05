%function fakeOut = saveData(savesDir, var2save, varName, machineIdx, saveFlag)

function saveData(savesDir, var2save, varName, machineIdx, saveFlag, fileName)

% OUTPUT:
%   - fakeOut is needed to prevent rpcSwitch from erroring with a too many
%   output arguments error due to the use of varargout.

%global ID ;

if nargin < 6
  fileName = varName ;
end

if saveFlag
  x = genvarname(varName) ;
  eval([x ' = var2save ;']) ;
  
  savesDir = [savesDir '/' fileName '_ID' num2str(machineIdx) '.mat'] ;
  
  mkdir(savesDir) ;
  save(savesDir, varName, '-v7.3') ;
end

%fakeOut = 1 ;