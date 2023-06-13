function saveconfig(mfile_name,S)
configfile  = [fullfile(matlabroot,'work'),'\myconfig.mat'];
if(exist(configfile))
    load(configfile,'myconfig');
    if(isfield(myconfig,mfile_name))
        S   = getfiled(myconfig,mfile_name);
    else
        S   =[];
    end
else
    S   =[];
end