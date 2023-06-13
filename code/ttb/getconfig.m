function Y  = getconfig(mfile,name)
% Y  = getconfig(mfile,name)
%
% lastdir = getconfig(mfilename,'lastdir');

try
    workpath    = userpath;
    if(isempty(workpath))
        workpath  = fullfile(matlabroot,'work');
    end
    if(strcmp(workpath(end),';') || strcmp(workpath(end),':'))
        workpath(end)=[];
    end
    
    [temp,hostname] = system('hostname');
    configfile  = fullfile(workpath,lower(strcat('ttbconfig_',hostname,'.mat')));
    
    Y   = load(configfile);
    if(nargin==1)
        Y   = Y.(mfile);
    elseif(nargin==2)
        Y   = Y.(mfile).(name);
    end
catch
    Y   = [];
end
end