function uicopyfiles

pathname        = uigetdir(matpath, 'Sorceフォルダの親フォルダを選択してください');
dirs            = uiselect(dirdir(pathname),[],'Sorceフォルダを選択してください（複数選択可）');
filenames       = uiselect(dirfile(fullfile(pathname,dirs{1})),[],'コピーするファイルを選択してください');

OutputParent    = uigetdir(matpath, 'コピー先の親フォルダを選択してください');

ndir    = length(dirs);
nfile   = length(filenames);

for idir =1:ndir
    dirname = dirs{idir};
    disp([num2str(idir),'/',num2str(ndir),'',dirname]);
    for ifile=1:nfile
        filename    = filenames{ifile};
        fullfilename    = fullfile(pathname,dirname,filename);
        Outputpath  = fullfile(OutputParent,dirname);
        Outputfile  = fullfile(Outputpath,filename);
        
        if(exist(fullfilename,'file'))
            if(~exist(Outputpath,'dir'))
                mkdir(Outputpath)
            end
            copyfile(fullfilename,Outputfile);
            disp([num2str(ifile),'/',num2str(nfile),' ',Outputfile]);
        end
    end
end