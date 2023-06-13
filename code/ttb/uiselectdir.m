function s  = uiselectdir(startpath,titlestr)

if nargin<1
    parentpath  = tgetdir('Select parent directory');
elseif nargin<2
    if(exist(startpath)==7)
        parentpath  = uigetdir;
    else
        parentpath  = tgetdir(startpath);
    end
else
    parentpath  = uigetdir(startpath,titlestr);
end


children    = dir(parentpath);
s   = uiselect({children([children.isdir]).name},1,parentpath);

for ii=1:length(s)
    s{ii}   = fullfile(parentpath,s{ii});
end

