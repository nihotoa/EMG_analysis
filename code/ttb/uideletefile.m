function uideletefile

pathname = uigetdir(matpath, 'Destinationフォルダの親フォルダを選択してください');
dirs     = uiselect(dirdir(pathname),[],'Destinationフォルダを選択してください（複数選択可）');
filenames   = uiselect(dirfile(fullfile(pathname,dirs{1})),[],'削除するファイルを選択してください');

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