function uicopyfiles

pathname        = uigetdir(matpath, 'Sorce�t�H���_�̐e�t�H���_��I�����Ă�������');
dirs            = uiselect(dirdir(pathname),[],'Sorce�t�H���_��I�����Ă��������i�����I���j');
filenames       = uiselect(dirfile(fullfile(pathname,dirs{1})),[],'�R�s�[����t�@�C����I�����Ă�������');

OutputParent    = uigetdir(matpath, '�R�s�[��̐e�t�H���_��I�����Ă�������');

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