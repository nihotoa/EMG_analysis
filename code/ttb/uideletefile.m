function uideletefile

pathname = uigetdir(matpath, 'Destination�t�H���_�̐e�t�H���_��I�����Ă�������');
dirs     = uiselect(dirdir(pathname),[],'Destination�t�H���_��I�����Ă��������i�����I���j');
filenames   = uiselect(dirfile(fullfile(pathname,dirs{1})),[],'�폜����t�@�C����I�����Ă�������');

ndir    = length(dirs);
nfile   = length(filenames);

for idir =1:ndir
    dirname = dirs{idir};
    disp([num2str(idir),'/',num2str(ndir),'',dirname]);
    for ifile=1:nfile
        filename    = filenames{ifile};
        fullfilename    = fullfile(pathname,dirname,filename);
        if(exist(fullfilename,'file'))
            delete(fullfilename);
            disp([num2str(ifile),'/',num2str(nfile),'deleted: ',fullfilename]);
        end
    end
end