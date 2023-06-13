function saveconfig(mfile_name,xxx)
warning('off','MATLAB:load:variableNotFound')
try
configfile  = [fullfile(matlabroot,'work'),'\myconfig.mat'];
if(exist(configfile))
    load(configfile);
end
eval(['myconfig.',mfile_name,'=xxx;'])
clear('xxx','mfile_name')
save(configfile,'myconfig')
catch
end