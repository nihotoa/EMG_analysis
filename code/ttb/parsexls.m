function varargout  = parsexls(varargin)

for iData   =1:nargin
    if(iscell(varargin{iData}))
        if(numel(varargin{iData})==1)
            varargout{iData}    = cell2mat(varargin{iData});
        else
            if(any(cellfun('isclass',varargin{iData},'char')))
                varargout{iData}    = varargin{iData};
            else
                varargout{iData}    = cell2mat(varargin{iData});
            end
        end
    end
end