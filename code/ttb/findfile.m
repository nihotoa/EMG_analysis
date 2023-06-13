function findfile(filename)

CurrDir = pwd;

configfile  = ['C:\Program Files\MATLAB71\work\','myconfig.mat'];
if(exist(configfile))
    load(configfile,'myconfig');
    lastdir = myconfig.findfile.pathname;
else
    lastdir = CurrDir;
end

uigetdir(lastdir)

