%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
[your operation]
1. Go to the directory named monkey name (ex.) if you want to analyze Yachimun's data, please go to 'EMG_analysis/data/Yachimun'
2. Please run this code

[role of this code]
Preform preprocessing on EMG data and save these filtered data (as .mat file).

[Saved data location]
location: Yachimun/new_nmf_result/'~_standard' (ex.) F170516_standard
file name: the file name changes depending on the preprocessing content.
(ex.) BRD-hp50Hz-rect-lp20Hz-ds100Hz.mat

[procedure]
pre:SAVE4NMF.m
post:MakeEMGNMFbtc_Oya.m

[Improvement points(Japanaese)]

%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
%% code section
% get folder path of monkey fold
ParentDir   = getconfig(mfilename,'ParentDir');
try
    if(~exist(ParentDir,'dir'))
        ParentDir   = pwd;
    end
catch
    ParentDir   = pwd;
end
disp('【Please select nmf_result fold (Yachimun/new_nmf_result】)')
ParentDir   = uigetdir(ParentDir,'?e?t?H???_???I???????????????B');
if(ParentDir==0)
    disp('User pressed cancel.')
    return;
else
    setconfig(mfilename,'ParentDir',ParentDir);
end
% get the name of the floder that exists directly under 'Parent dir'
InputDirs   = dirdir(ParentDir);
disp('【Plese select day fold (which contains the data you want to filter】)')
InputDirs   = uiselect(InputDirs,1,'??????????Experiment???I???????????????B');

if(isempty(InputDirs))
    disp('User pressed cancel.')
    return;
end
InputDir    = InputDirs{1};

Tarfiles    = sortxls(dirmat(fullfile(ParentDir,InputDir)));
disp('【Please select all muscle data which you want to filter】')
Tarfiles    = uiselect(Tarfiles,1,'Target?t?@?C?????I???????????????i?????I?????j?B');
if(isempty(Tarfiles))
    disp('User pressed cancel.')
    return;
end

for jj=1:length(InputDirs)  % each day
    try
        InputDir    = InputDirs{jj};
         for kk =1:length(Tarfiles)
             Tar = loaddata(fullfile(ParentDir,InputDir,Tarfiles{kk}));
              OutputDir   = fullfile(ParentDir,InputDir);
             %highpass filtering
             Tar = makeContinuousChannel([Tar.Name,'-hp50Hz'],'butter',Tar,'high',6,50,'both');
             %full wave rectification
             Tar = makeContinuousChannel([Tar.Name,'-rect'],'rectify',Tar);
             %lowpass filtering
             Tar = makeContinuousChannel([Tar.Name,'-lp20Hz'], 'butter', Tar, 'low',6,20,'both');
             %down sampling at 100Hz
             Tar = makeContinuousChannel([Tar.Name,'-ds100Hz'], 'resample', Tar, 100,0);
             % save data
             save(fullfile(OutputDir,[Tar.Name,'.mat']),'-struct','Tar');
             disp(fullfile(OutputDir,Tar.Name));     
         end
     catch
      disp(['****** Error occured in ',InputDirs{jj}]) ; 
    end
end
