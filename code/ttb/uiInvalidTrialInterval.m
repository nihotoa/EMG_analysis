function uiInvalidTrialInterval



[TrialProp,hLine] = getTrialProp;
Color   = get(hLine(1),'Color');
set(hLine,'Color',[1 0 0])

fig = gcf;
hAx = gca;

UD  = get(fig,'UserData');
ind = UD.h==hAx;
S   = UD.Data{ind};

TimeRange   = S.TimeRange;

iTrials         = [TrialProp.iTrial]';
TriggerTimes    = [TrialProp.TriggerTime]';

TrialProp       = sortrows([iTrials,TriggerTimes],1);
iTrials         = TrialProp(:,1);
TriggerTimes    = TrialProp(:,2);

StartTimes      = TriggerTimes+TimeRange(1);
StopTimes       = TriggerTimes+TimeRange(2);

TimeWindows     = [StartTimes,StopTimes];
nTW             = size(TimeWindows,1);
message         = cell(nTW+1,1);

message{1}      = [num2str(nTW),' trials'];
for iTW=1:nTW
    message{iTW+1}    = [num2str(iTrials(iTW)),': [',num2str(StartTimes(iTW)),',',num2str(StopTimes(iTW)),']'];
end
% message = sort(message);


YN  = questdlg(message, ...
    'TimeWindows',...
    'OK','Cancel','OK');
switch YN
    case 'OK'
        Y  = makeIntervalChannel('Invalid Interval','manual',[],TimeWindows);
        
        
        %% set filename
        [parentpath,InputDir]   = fileparts(UD.parentpath);
        parentpath      = getconfig(mfilename,'parentpath');
        try
        if(isempty(parentpath))
            parentpath  = matpath;
        else
            parentpath  = fileparts(fileparts(parentpath));
        end
        catch
            parentpath  = matpath;
        end
        parentpath      = fullfile(parentpath,InputDir);
        fullfilename    = fullfile(parentpath,[Y.Name,'.mat']);
        [filename, parentpath] = uiputfile(fullfilename);
        setconfig(mfilename,'parentpath',parentpath);
        fullfilename    = fullfile(parentpath,filename);
        %%
        
        if(exist(fullfilename,'file')) % append previous file
            ss  = load(fullfilename);
            Y.Data= union(ss.Data',Y.Data','rows')';
        end
        save(fullfilename,'-struct','Y')
        disp(fullfilename)
        
    otherwise
        set(hLine,'Color',Color)
        disp('User Pressed Cancel')
        return;
end

