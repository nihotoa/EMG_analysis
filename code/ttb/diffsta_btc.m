function diffSTA_btc(ws, ndiff)

if(nargin<1)
    ws      = 0.1;
    ndiff   = 2;
elseif(nargin<2)
    ndiff   = 2;
end

warning('off');


ParentDir   = uigetdir(fullfile(datapath,'STA'),'親フォルダを選択してください。');
% InputDirs   = dir(ParentDir);
InputDirs   = uiselect(dirdir(ParentDir),1,'対象とするExperimentsを選択してください');

InputDir    = InputDirs{1};
Tarfiles    = dirmat(fullfile(ParentDir,InputDir));
Tarfiles    = sortxls(strfilt(Tarfiles,'~._'));
Tarfiles    = uiselect(Tarfiles,1,'対象とするfileを選択してください');


for jj=1:length(InputDirs)
    try
        InputDir    = InputDirs{jj};
       
            disp([num2str(jj),'/',num2str(length(InputDirs)),':  ',InputDir])

            for ii=1:length(Tarfiles)
                try
                    Tarfile         = Tarfiles{ii};
                    InputFile_hdr   = fullfile(ParentDir,InputDir,Tarfile);
                    InputFile_dat   = fullfile(ParentDir,InputDir,['._',Tarfile]);
                    
                    
                    Tar_hdr = load(InputFile_hdr);
                    Tar_dat = load(InputFile_dat);
                    [Tar_hdr,Tar_dat]   = diffSTA(Tar_hdr,Tar_dat,ws,ndiff);
                    
                    OutputFile_hdr  = fullfile(ParentDir,InputDir,[Tar_hdr.Name,'.mat']);
                    OutputFile_dat  = fullfile(ParentDir,InputDir,[Tar_dat.Name,'.mat']);
                    
                    save(OutputFile_hdr,'-struct','Tar_hdr')
                    save(OutputFile_dat,'-struct','Tar_dat')
                    
                    clear('Tar_*')

                    disp([' L-- ',num2str(ii),'/',num2str(length(Tarfiles)),':  ',OutputFile_hdr])
                catch
                    errormsg    = [' L-- *** error occured in ',fullfile(ParentDir,InputDir,Tarfiles{ii})];
                    disp(errormsg)
                    errorlog(errormsg);
                end
%                 indicator(ii,length(Tarfiles))
            end
    catch
        errormsg    = ['****** Error occured in ',InputDirs{jj}];
        disp(errormsg)
        errorlog(errormsg);
    end
%     indicator(0,0)
    
end

warning('on');