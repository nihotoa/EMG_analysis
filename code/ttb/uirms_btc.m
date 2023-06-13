function uinoise_btc(outputfile)


ParentDir   = uigetdir(matpath,'親フォルダを選択してください。');
InputDirs   = dirdir(ParentDir);
InputDirs   = uiselect(InputDirs,1,'対象となるExperimentを選択してください。');

InputDir    = InputDirs{1};
files    = dirmat(fullfile(ParentDir,InputDir));
files    = uiselect(files,1,'対象とするファイル(EMGなど)を選択してください。');


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