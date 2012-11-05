% SERVER.VERTCAT invokes an RPC, then stacks the results on top of each
% other (i.e., along the first dimension).
function varargout = rpcvertcat(server, reqHook, varargin)
  
  %argsout = cell(1, nargout);
  argsout = cell(1, nargout(reqHook));
  [argsout{:}] = server.rpc(reqHook, varargin{:});

  for i=1:length(argsout)
    % concatenate vertically
    % Handle case where we are concatenating structures.
    if isstruct(argsout{i}{1})
      names = fieldnames(argsout{i}{1}) ;
      for j=1:1:length(names)
        out{i}.(names{j}) = [] ;
        for k=1:1:length(argsout{i})
          out{i}.(names{j}) = [out{i}.(names{j}); argsout{i}{k}.(names{j})] ;
        end
      end
    else
      out{i} = vertcat(argsout{i}{:});
    end
  end
  varargout = out;
