% isa_btc

TimeWindow  = [-0.1 0.1];
Tau         = [-0.1:0.001:0.1];
ParentDir   = 'L:\tkitom\MDAdata\mat';
InputDirs   = dir(ParentDir);
InputDirs   = uiselect({InputDirs.name});
Filefilt    = {'Non-filtered-subsample-5000Hz(uV)'};
Reffile     = 'Spike1.mat';
keyboard
for jj=1:length(InputDirs)
    try
        InputDir    = InputDirs{jj};
        Tarfiles    = what(fullfile(ParentDir,InputDir));
        Tarfiles    = strfilt(Tarfiles.mat,Filefilt);
        Ref         = load(fullfile(ParentDir,InputDir,Reffile));
        OutputDir   = fullfile('L:\tkitom\MDAdata\Analyses\ISA',InputDir);
        mkdir(OutputDir)
        disp([num2str(jj),'/',num2str(length(InputDirs)),':  ',OutputDir])

        for ii=1:length(Tarfiles)
            Tar     = load(fullfile(ParentDir,InputDir,Tarfiles{ii}));
            STADATA = isave(Tar,Ref,TimeWindow,Tau);
            Name            = STADATA.Name;
            OutputFile  = fullfile(OutputDir,Name);
            save(OutputFile,'-struct','STADATA')
            
            clear STADATA
            pack
            disp([' L-- ',num2str(ii),'/',num2str(length(Tarfiles)),':  ',OutputFile])
        end
%         indicator(0,0)

    catch
%         indicator(0,0)
        disp(['****** Error occured in ',InputDirs{jj}])
    end

end