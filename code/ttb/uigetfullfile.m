function fullfilename   = uigetfullfile(varargin)

CurrDir = pwd;

lastdir     = getconfig(mfilename,'pathname');
lastfile    = getconfig(mfilename,'filename');

try
    if(~exist(lastdir,'dir'))
        lastdir = CurrDir;
    end
catch
    lastdir = CurrDir;
end
if(isempty(lastfile))
    lastfile = '*.*';
end


[filename, pathname]  = uigetfile(varargin{:},fullfile(lastdir,lastfile));
if isequal(filename,0) || isequal(pathname,0)
    disp('User pressed cancel')
    fullfilename    = [];
    cd(CurrDir)
    return;
end
fullfilename    = fullfile(pathname,filename);
    
cd(CurrDir)

setconfig(mfilename,'pathname',pathname)
setconfig(mfilename,'filename',filename)