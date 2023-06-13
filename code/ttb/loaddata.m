function Y  = loaddata(fullfilename,varargin)
% Y  = loaddata(fullfilename,varargin)
% TrialsToUse‚à‚İ‚Åload‚·‚éê‡‚Í“ü—Í‚É'-full'‚Æ“ü‚ê‚é
% 
% written by tomohiko takei 20101223

TrialsToUse_flag   = false;

if(nargin<1)
    % getfile
    pathname    = getconfig(mfilename,'pathname');
    if(isempty(pathname) || ~ischar(pathname))
        pathname    = pwd;
    end
    if(~exist(pathname,'dir'))
        pathname    = pwd;
    end
    [filename,pathname] = uigetfile(fullfile(pathname,'*.*'));
    fullfilename    = fullfile(pathname,filename);
    setconfig(mfilename,'pathname',pathname);
    
    Y   = load(fullfilename);
elseif(nargin<2)
    if(strcmp(fullfilename,'-full'))
        TrialsToUse_flag    = true;
        
        % getfile
        pathname    = getconfig(mfilename,'pathname');
        if(isempty(pathname) || ~ischar(pathname))
            pathname    = pwd;
        end
        if(~exist(pathname,'dir'))
            pathname    = pwd;
        end
        [filename,pathname] = uigetfile(fullfile(pathname,'*.*'));
        fullfilename    = fullfile(pathname,filename);
        setconfig(mfilename,'pathname',pathname);
        
        
        Y   = load(fullfilename);
    else
        Y   = load(fullfilename);
    end
else
    nvarargin   = length(varargin);
    for ivarargin=nvarargin:-1:1
        if(ischar(varargin{ivarargin}))
            if(strcmp(varargin{ivarargin},'-full'))
                TrialsToUse_flag    = true;
                varargin(ivarargin) = [];
            end
        end
    end
    
    if(length(varargin)<1)
        Y   = load(fullfilename);
    else
        Y   = load(fullfilename,varargin{:});
    end
end

if(isfield(Y,'Class'))
    if(strcmp(Y.Class,'virtual channel'))
        [pathname,filename] = fileparts(fullfilename);
        
        Name    = Y.Name;
        
        eval(Y.Process);
        
        Y.Name  = Name;
    end
end

if(~TrialsToUse_flag)
    Y   = applyTrialsToUse(Y);
end
