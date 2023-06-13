function varargout  = tgetfile(dlgtitle)
if nargin < 1
    dlgtitle    = 'Pick a file';
end

CurrDir = pwd;

configfile  = [fullfile(matlabroot,'work'),'\myconfig.mat'];
if(exist(configfile))
    load(configfile,'myconfig');
    if(isfield(myconfig,'topen'))
        lastdir = myconfig.topen.pathname;
        if(~exist(lastdir))
            lastdir = CurrDir;
        end
        lastfile  = myconfig.topen.filename;
    else
        lastdir = CurrDir;
        lastfile    = '*.*'
    end
else
    lastdir = CurrDir;
    lastfile    = '*.*'
end

cd(lastdir)

FilterSpec  = {'*.m;*.fig;*.mat;*.mdl','MATLAB Files (*.m,*.fig,*.mat,*.mdl)';...
    '*.m',  'M-files (*.m)'; ...
    '*.fig','Figures (*.fig)'; ...
    '*.mat','MAT-files (*.mat)'; ...
    '*.mdl','Models (*.mdl)'; ...
    '*.*',  'All Files (*.*)'};
    

[filename, pathname, filterindex] = uigetfile( ...
    FilterSpec,...
    dlgtitle, ...
    ['*',extension(lastfile)],...
    'MultiSelect', 'on');

if(filterindex  == 0)
    S   =[];
%     return;  
elseif(class(filename) == 'cell')
    for ii=1:length(filename)
        S{ii}   = open([pathname,'\',filename{ii}]);
    end
    myconfig.topen.pathname = pathname;
    myconfig.topen.filename = filename{1};
    save(configfile,'myconfig');

else
    S   = open([pathname,'\',filename]);
    myconfig.topen.pathname = pathname;
    myconfig.topen.filename = filename;
    save(configfile,'myconfig');

end

cd(CurrDir)

if(nargout < 1)
    varargout   = [];
elseif(nargout == 1)
    varargout{1}    = S;
elseif(nargout == 2)
    varargout{1}    = S;
    if(class(filename) == 'cell');
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