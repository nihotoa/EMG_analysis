function varargout  = topen(dlgtitle)
% [S,fullfilename]  = topen(dlgtitle)
% written by TT


if nargin < 1
    dlgtitle    = 'Pick a file';
end

CurrDir = pwd;

lastdir     = getconfig(mfilename,'pathname');

try
    if(~exist(lastdir,'dir'))
        lastdir = CurrDir;
    end
catch

    lastdir = CurrDir;
end


% cd(lastdir)

FilterSpec  = {'*.m;*.fig;*.mat;*.mdl','MATLAB Files (*.m,*.fig,*.mat,*.mdl)';...
    '*.m',  'M-files (*.m)'; ...
    '*.fig','Figures (*.fig)'; ...
    '*.mat','MAT-files (*.mat)'; ...
    '*.mdl','Models (*.mdl)'; ...
    '*.*',  'All Files (*.*)'};


[filename, pathname, filterindex] = uigetfile( ...
    FilterSpec,...
    dlgtitle,...
    fullfile(lastdir,'*.mat') ,...
    'MultiSelect', 'on');

if(filterindex  == 0)
    S   =[];

elseif(iscell(filename))
    nfiles  = length(filename);
    S       = cell(1,nfiles);
    for ii=1:nfiles
        S{ii}   = open(fullfile(pathname,filename{ii}));
    end
    setconfig(mfilename,'pathname',pathname);

else
    S   = open(fullfile(pathname,filename));
    setconfig(mfilename,'pathname',pathname);
end


if(nargout < 1)
    varargout   = [];
elseif(nargout == 1)
    varargout{1}    = S;
elseif(nargout == 2)
    varargout{1}    = S;
    if(iscell(filename));
        varargout{2}    = cell(1,length(filename));
        for ii=1:length(filename)
            varargout{2}{ii}   = [pathname,filename{ii}];
        end
    else
        varargout{2}    = [pathname,filename];
    end
else
    varargout   = cell(nargout,1);
end