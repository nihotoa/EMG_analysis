function searchPSE_btc(TimeRange)

ParentDir   = uigetdir(fullfile(datapath,'STA'),'�e�t�H���_��I�����Ă��������B');
InputDirs   = uiselect(dirdir(ParentDir),1,'�ΏۂƂ���Experiments��I�����Ă�������');

InputDir    = InputDirs{1};
Tarfiles    = dirmat(fullfile(ParentDir,InputDir));
Tarfiles    = strfilt(Tarfiles,'~._');
Tarfiles    = uiselect(Tarfiles,1,'�ΏۂƂ���file��I�����Ă�������');


for jj=1:length(InputDirs)
    try
        InputDir    = InputDirs{jj};
       
            disp([num2str(jj),'/',num2str(length(InputDirs)),':  ',InputDir])

            for ii=1:length(Tarfiles)
                try
                    Tarfile = Tarfiles{ii};
                    Tar_hdr = load(fullfile(ParentDir,InputDir,Tarfile));
                    Tar_hdr = searchPSE(Tar_hdr,TimeRange);
                    OutputFile_hdr  = fullfile(ParentDir,InputDir,Tarfile);
                    save(OutputFile_hdr,'-struct','Tar_hdr')

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