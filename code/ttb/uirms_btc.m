function uinoise_btc(outputfile)


ParentDir   = uigetdir(matpath,'�e�t�H���_��I�����Ă��������B');
InputDirs   = dirdir(ParentDir);
InputDirs   = uiselect(InputDirs,1,'�ΏۂƂȂ�Experiment��I�����Ă��������B');

InputDir    = InputDirs{1};
files    = dirmat(fullfile(ParentDir,InputDir));
files    = uiselect(files,1,'�ΏۂƂ���t�@�C��(EMG�Ȃ�)��I�����Ă��������B');


for iDirs=1:length(InputDirs)
    try
        InputDir    = InputDirs{iDirs};

        fulloutputfile  = fullfile(ParentDir,InputDir,[outputfile,'.mat']);
        disp([num2str(iDirs),'/',num2str(length(InputDirs)),':  ',fulloutputfile])

        for ifile=1:length(files)

            file    = files{ifile};
            try
                s       = load(fullfile(ParentDir,InputDir,file));
                XData   =([1:length(s.Data)]-1)./s.SampleRate;
                ind     = (XData>=1 & XData<=15);

                RMS     = uirms(XData(ind),s.Data(ind));

                if(exist(fulloutputfile,'file'))
                    disp('add')
                    S       = load(fulloutputfile);
                    S.(deparenth(deext(file))) = RMS;
                else
                    disp('new')
                    S.(deparenth(deext(file))) = RMS;
                end
                save(fulloutputfile,'-struct','S')

                disp([' L-- ',num2str(ifile),'/',num2str(length(files)),':  ',file])
            catch
                disp([' L-- *** error occured in ',fullfile(ParentDir,InputDir,file)])
            end
        end
    catch
        disp(['****** Error occured in ',InputDirs{iDirs}])
    end

end