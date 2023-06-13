function segmentdepth(Depth_th,Time_th)
% segmentdepth(500,300)


if(nargin<1)
    Depth_th    = 500;
    Time_th     = 300;
elseif(nargin<2)
    Time_th     = 300;
end

ParentDir   = getconfig(mfilename,'ParentDir');
try
    if(~exist(ParentDir,'dir'));
        ParentDir   = pwd;
    end
catch
    ParentDir   = pwd;
end
ParentDir   = uigetdir(ParentDir,'親フォルダを選択してください。');
if(ParentDir==0)
    disp('User pressed cancel.')
    return;
else
    setconfig(mfilename,'ParentDir',ParentDir);
end

InputDirs   = dirdir(ParentDir);
InputDirs   = uiselect(InputDirs,1,'対象となるExperimentを選択してください。');
if(isempty(InputDirs))
    disp('User pressed cancel.')
    return;
end
InputDir    = InputDirs{1};
InputFile    = sortxls(dirmat(fullfile(ParentDir,InputDir)));
InputFile    = uiselect(InputFile,1,'Depthファイルを選択してください（一つ）。');
if(isempty(InputFile))
    disp('User pressed cancel.')
    return;
else
    InputFile   = InputFile{1};
end

OutputFile = getconfig(mfilename,'OutputFile');
OutputFullFile  = fullfile(ParentDir,InputDir,OutputFile);
% try
%     if(~exist(OutputFullFile,'file'))
%         OutputFullFile = fullfile(pwd,'*.mat'); 
%     end
% catch
%     OutputFullFile = fullfile(pwd,'*.mat'); 
% end

[OutputFile,OutputDir]      = uiputfile(OutputFullFile,'出力ファイルを指定してください。');
if(isequal(OutputFile,0))
    disp('User pressed cancel.')
    return;
else
    setconfig(mfilename,'OutputFile',OutputFile);
end

nDir    = length(InputDirs);

for iDir=1:nDir
    try
        InputDir    = InputDirs{iDir};
    InputFullFile   = fullfile(ParentDir,InputDir,InputFile);
    OutputFullFile  = fullfile(ParentDir,InputDir,OutputFile);
    
    D       = load(InputFullFile);
    YData   = D.Data;
    nData   = length(YData);
    XData   = ((1:nData)-1)/D.SampleRate;
    SegData = nan(1,nData);
    
    for iData=1:nData
        if(iData==1)
            StartDepth  = YData(1);
            iSeg        = 1;
            SegData(1)  = iSeg;
        else
            if(abs(YData(iData)-StartDepth) > Depth_th);
                StartDepth  = YData(iData);
                iSeg    = iSeg + 1;
                SegData(iData)  = iSeg;
            else
                SegData(iData)  = iSeg;
            end
        end
    end
    
    
%     S.PlatForm  = D.PlatForm;
%     S.Name    = [deext(OutputFile) num2str(0)];
%     S.Data  = SegData;
%     S.SampleRate    = D.SampleRate;
%     S.Class    = D.Class;
%     S.TimeRange    = D.TimeRange;
%     S.Unit    = '#seg';
%     save(fullfile(ParentDir,InputDir,[S.Name,'.mat']),'-struct','S');
%     disp(fullfile(ParentDir,InputDir,[S.Name,'.mat']));
    
    
    StartTimes  = XData([1,diff(SegData)]==1);
    EndTimes    = XData([diff(SegData),1]==1);
    
    
    Durations   = EndTimes - StartTimes;
    ind         = Durations > 0;
    StartTimes  = StartTimes(ind);
    EndTimes    = EndTimes(ind);
%     
%     S   = [];
%     S.PlatForm  = D.PlatForm;
%     S.TimeRange = D.TimeRange;
%     S.Name      = [deext(OutputFile) num2str(1)];
%     S.TimeUnits = 'seconds';
%     S.Class     = 'interval channel';
%     S.Data      = [StartTimes;EndTimes];
%     save(fullfile(ParentDir,InputDir,[S.Name,'.mat']),'-struct','S');
%     disp(fullfile(ParentDir,InputDir,[S.Name,'.mat']));
    
    
    Durations   = EndTimes - StartTimes;
    ind         = Durations >= Time_th;
    StartTimes  = StartTimes(ind);
    EndTimes    = EndTimes(ind);
    
    S   = [];
    S.PlatForm  = D.PlatForm;
    S.TimeRange = D.TimeRange;
    S.Name      = deext(OutputFile);
    S.TimeUnits = 'seconds';
    S.Class     = 'interval channel';
    S.Data      = [StartTimes;EndTimes];
    
    save(OutputFullFile,'-struct','S');
    disp(OutputFullFile);
    
%     keyboard
    
    catch
        keyboard
        disp(['*** Error occurred in ',fullfile(InputDirs{iDir},InputFile)]);
    end
end
