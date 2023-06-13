function shiftMSD_btc(NewName)


ParentDir   = uigetdir(matpath,'親フォルダを選択してください。');
InputDirs   = dirdir(ParentDir);
InputDirs   = uiselect(InputDirs,1,'対象となるExperimentを選択してください。');

InputDir    = InputDirs{1};
MSDfiles    = dirmat(fullfile(ParentDir,InputDir));
Unitfile    = uiselect(MSDfiles,1,'Unitファイル(continuous)をひとつ選択してください。');
Unitfile    = Unitfile{1};
MSDfiles    = uiselect(MSDfiles,1,'MSDファイルを選択してください。');

% Unitfile    = 'Unit 1.mat';
% MSDfiles    = {'MSD.mat'};

for iDirs=1:length(InputDirs)
    try
        InputDir    = InputDirs{iDirs};

        Unit         = load(fullfile(ParentDir,InputDir,Unitfile));

        OutputDir   = fullfile(ParentDir,InputDir);
        disp([num2str(iDirs),'/',num2str(length(InputDirs)),':  ',OutputDir])

        for iMSD=1:length(MSDfiles)
            try
                MSDfile = MSDfiles{iMSD};
                MSD     = load(fullfile(ParentDir,InputDir,MSDfile));
                S       = shiftMSD(Unit,MSD);
                S.Name  = NewName;
                OutputFile  = fullfile(OutputDir,NewName);
                save(OutputFile,'-struct','S')

                disp([' L-- ',num2str(iMSD),'/',num2str(length(MSDfiles)),':  ',OutputFile])
            catch
                disp([' L-- *** error occured in ',fullfile(ParentDir,InputDir,MSDfiles{iMSD})])
            end
        end
    catch
        disp(['****** Error occured in ',InputDirs{iDirs}])
    end

end