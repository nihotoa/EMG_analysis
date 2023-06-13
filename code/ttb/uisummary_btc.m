function uisummary_btc


ParentDir   = uigetdir(matpath,'親フォルダを選択してください。');
InputDirs   = dirdir(ParentDir);
InputDirs   = uiselect(InputDirs,1,'対象となるExperimentを選択してください。');

InputDir    = InputDirs{1};
files       = dirmat(fullfile(ParentDir,InputDir));
files       = sortxls(strfilt(files,'~._'));
EMGfiles    = uiselect(files,1,'対象とするファイル(EMG(uV).mat)を選択してください。');


for iDirs=1:length(InputDirs)
    try
        InputDir    = InputDirs{iDirs};
        
        OutputDir   = fullfile(matpath,'summary_file',InputDir);
        mkdir(OutputDir);
        
        
        disp([num2str(iDirs),'/',num2str(length(InputDirs)),': ',OutputDir])

        for ifile=1:length(EMGfiles)

            FileName    = EMGfiles{ifile};
            EMGName     = parseEMG(FileName);
            fulloutputfile  = fullfile(OutputDir,[EMGName,'(uV).mat']);
            
            if(exist(fulloutputfile,'file'))
                disp('add')
                S       = load(fulloutputfile);
               
            else
                disp('new')
                S       = [];
            end

            try
                s       = load(fullfile(ParentDir,InputDir,FileName));
                if(isfield(s,'AnalysisType'))
                    source  = s.AnalysisType;
                else
                    source  = 'MDAdata';
                end
                
                switch lower(source)
                    case 'mdadata'
                        S.Name1 = FileName;
                        S.RMS   = rms(s.Data);
                        S.MAX   = max(s.Data);
                        S.MEAN  = mean(s.Data);
                        S.STD   = std(s.Data,1);

                        s.Data  = abs(s.Data);
                        S.lMAXl   = max(s.Data);
                        S.lMEANl  = mean(s.Data);
                        S.lSTDl   = std(s.Data,1);
                        S.Unit    = s.Unit;
                    case 'sta'
                        S.Name_sta= FileName; 
                        S.TimeWindow    = [-inf inf];
                        ind   = (s.XData>= S.TimeWindow(1) & s.XData<=S.TimeWindow(2));
                        dt    = s.XData(2) - s.XData(1);
                        S.RMSTW = rms(s.YData(ind));
                        S.MAXTW = max(s.YData(ind));
                        S.MEANTW= mean(s.YData(ind));
                        S.STDTW = std(s.YData(ind),1);
                        S.AreaTW= sum(s.YData(ind)) * dt;
                        S.Unit_sta= s.Unit;
                end

                save(fulloutputfile,'-struct','S')

                disp([' L-- ',num2str(ifile),'/',num2str(length(EMGfiles)),':  ',fulloutputfile])
            catch
                disp([' L-- *** error occured in ',fullfile(OutputDir,FileName)])
            end
        end
    catch
        disp(['****** Error occured in ',InputDirs{iDirs}])
    end

end