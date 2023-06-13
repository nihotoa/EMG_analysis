function setconfig(mfile,name,value)
% setconfig(mfile,name,value)
% 
% setconfig(mfilename,'lastdir',y)

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
    
    
    if(exist(workpath,'dir'))
        if(exist(configfile,'file'))
            S   = load(configfile);
            S.(mfile).(name)    = value;
            save(configfile,'-struct','S')
        else
            S   = [];
            S.(mfile).(name)    = value;
            save(configfile,'-struct','S')
        end
    else
        mkdir(workpath);
        S   = [];
        S.(mfile).(name)    = value;
        save(configfile,'-struct','S')
    end
catch
    error('config is not saved.')
    
end

end