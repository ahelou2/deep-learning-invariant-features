function varargout = rpc_switch(funcName, varargin)

global RPC ;
if isempty(RPC)
    RPC = 1 ;
end

if RPC
    varargout = server.rpc(funcName, varargin{:}) ;
else
    f = str2func(funcName) ;
    varargout = f(varargin{:}) ;
end