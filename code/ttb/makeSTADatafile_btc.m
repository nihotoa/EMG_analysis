function makeSTADatafile_btc(rmSmoothing_flag)
% rmSmoothing_flag
%     1: YDataなどをsmYDataに置き換える
%     2: smYDataなどをそのまま削除する
%     0: 何もしない

ParentDir   = uigetdir(fullfile(datapath,'STA'),'親フォルダを選択してください。');
InputDirs   = uiselect(dirdir(ParentDir),1,'対象とするExperimentsを選択してください');
InputDir    = InputDirs{1};
hdrfiles    = dirmat(fullfile(ParentDir,InputDir));
hdrfiles    = strfilt(hdrfiles,'~._');
hdrfiles    = uiselect(hdrfiles,1,'対象とするfileを選択してください');


for jj=1:length(InputDirs)
    try
        InputDir    = InputDirs{jj};
       
            disp([num2str(jj),'/',num2str(length(InputDirs)),':  ',InputDir])

            for ii=1:length(hdrfiles)
                try
                    hdrfile = hdrfiles{ii};
                    datafile = ['._',hdrfile];
                    hdr     = load(fullfile(ParentDir,InputDir,hdrfile));
                    if(exist(fullfile(ParentDir,InputDir,datafile),'file'))
                        data    = load(fullfile(ParentDir,InputDir,datafile));
                    else
                        data    = [];
                    end
                        
                    [hdr,data]  = makeSTADatafile(hdr,data,rmSmoothing_flag);
                    
                    OutputFile_hdr  = fullfile(ParentDir,InputDir,hdrfile);
                    OutputFile_data = fullfile(ParentDir,InputDir,datafile);
                    save(OutputFile_hdr,'-struct','hdr')
                    save(OutputFile_data,'-struct','data')

                    disp([' L-- ',num2str(ii),'/',num2str(length(hdrfiles)),':  ',OutputFile_hdr])
                catch
                    errormsg    = [' L-- *** error occured in ',fullfile(ParentDir,InputDir,hdrfiles{ii})];
                    disp(errormsg)
                    errorlog(errormsg);
                end
            end
    catch
        errormsg    = ['****** Error occured in ',InputDirs{jj}];
        disp(errormsg)
        errorlog(errormsg);
    end
    
end
