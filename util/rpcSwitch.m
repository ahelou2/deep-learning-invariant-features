function varargout = rpcSwitch(funcName, rpcCall, varargin)
%function argsout = rpcSwitch(funcName, rpcCall, varargin)

% Force using conventional function call by using rpcCall = 'noRPC'
% NOTES:

global server ;
global NORPC ;

if NORPC
  rpcCall = 'noRPC' ;
end

varargout = cell(1, nargout) ;
if strcmp(rpcCall, 'rpc')
    [varargout{:}] = server.rpc(funcName, varargin{:}) ;
elseif strcmp(rpcCall, 'rpcsum')
    [varargout{:}] = server.rpcsum(funcName, varargin{:}) ;
elseif strcmp(rpcCall, 'rpcvertcat')
    %argsout = cell(1, nargout(funcName));
    %[argsout{:}]  = server.rpcvertcat(funcName, varargin{:}) ;
    [varargout{:}] = server.rpcvertcat(funcName, varargin{:}) ;
elseif strcmp(rpcCall, 'noRPC')
    % WARNING: Sometime the funcName will have a makeSlaveRef() call. I
    % need to take out the makeSlaveRef() call before extracting the
    % function handle.
    k = strfind(funcName, 'makeSlaveRef') ;
    if ~isempty(k) && (length(k) > 1 || k(1,1) == 1)
        error('rpcSwitch:takingOutMakeSlaveRef', 'funcName has more than one makeSlaveRef') ;
    end
    if ~isempty(k)
        funcName = [funcName(1:k-1) funcName(k+12:end)] ;
    end
    f = str2func(funcName) ;
    [varargout{:}] = f(varargin{:}) ;
else
    error('rpcSwitch:illegalRpcCallName', 'Use valid rpcCall names') ;
end