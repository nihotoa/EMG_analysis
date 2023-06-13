function cohsum_mkset;

configfile  = ['C:\Program Files\MATLAB71\work\','myconfig.mat'];
if(exist(configfile))
    load(configfile,'myconfig');
    if(isfield(myconfig,'cohsum'))
        parentdir = myconfig.cohsum.startpath;
        if(~exist(parentdir))
            parentdir = pwd;
        end
    else
        parentdir = pwd;
    end
else
    parentdir = pwd;
end

% parentdir  = uigetdir('C:\data\cohband\');
parentlist = dir(parentdir);
parentlist = {parentlist([parentlist.isdir]==1).name};
parentlist = parentlist(3:length(parentlist));

selected_dir    = uiselect(parentlist,1,'Chose directories');

add_path    =[];
% keyboard
for ii=1:length(selected_dir)
    add_path    = [add_path,parentdir,'\',selected_dir{ii},';'];
end

currdir =pwd;
cd(parentdir)
uisave('add_path','*.mat')
cd(currdir)


