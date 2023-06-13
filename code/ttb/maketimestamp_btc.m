warning off

ParentDir   = 'L:\tkitom\MDAdata\mat';
InputDirs   = dir(ParentDir);
InputDirs   = uiselect({InputDirs.name});
% Filefilt    = '-rect.mat';
% Filefilt    = {'smoothed','Torque(N)'};
% Reffile     = 'Spike3.mat';
ch1file     = 'smoothed Index Torque(N).mat';
ch2file     = 'smoothed Thumb Torque(N).mat';
ch3file     = 'Grip Onset (success valid).mat';
keyboard
for jj=1:length(InputDirs)
    try
        InputDir    = InputDirs{jj};
%         Tarfiles    = what(fullfile(ParentDir,InputDir));
%         Tarfiles    = strfilt(Tarfiles.mat,Filefilt);
%         Ref         = load(fullfile(ParentDir,InputDir,Reffile));
        ch1         = load(fullfile(ParentDir,InputDir,ch1file));
        ch2         = load(fullfile(ParentDir,InputDir,ch2file));
        ch3         = load(fullfile(ParentDir,InputDir,ch3file));
        OutputDir   = fullfile('L:\tkitom\MDAdata\mat',InputDir);
        mkdir(OutputDir)
        disp([num2str(jj),'/',num2str(length(InputDirs)),':  ',OutputDir])

%         for ii=1:length(Tarfiles)
%             Tar     = load(fullfile(ParentDir,InputDir,Tarfiles{ii}));
%             STADATA = sta(Tar,Ref,TimeWindow,1);
            [Y1,Y2,Y3]  = maketimestamp(ch1,ch2,ch3);
            save(fullfile(OutputDir,Y1.Name),'-struct','Y1');
            save(fullfile(OutputDir,Y2.Name),'-struct','Y2');
            save(fullfile(OutputDir,Y3.Name),'-struct','Y3');
%             
%             Name            = STADATA.Name;
%             OutputFile  = fullfile(OutputDir,Name);
%             save(OutputFile,'-struct','STADATA')
            
            
            pack
%             disp([' L-- ',num2str(ii),'/',num2str(length(Tarfiles)),':  ',OutputFile])
%         end
        indicator(jj,length(InputDirs))

    catch
%         indicator(0,0)
        disp(['****** Error occured in ',InputDirs{jj}])
    end

end

warning on