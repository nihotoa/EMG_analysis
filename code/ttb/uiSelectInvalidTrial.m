function uiSelectInvalidTrial

UD.fig  = gcf;
UD.hAx  = gca;
UD.hL   = get(UD.hAx,'Children');

S   = get(UD.fig,'UserData');
UD.parentpath   = S.parentpath;

ind = S.h==UD.hAx;
SData   = S.Data{ind};
UD.TimeRange    = SData.TimeRange;
UD.TriggerTimes = SData.TimeStamps / SData.SampleRate;
UD.Name         = SData.Name;
UD.StartTimes   = UD.TriggerTimes+UD.TimeRange(1);
UD.StopTimes    = UD.TriggerTimes+UD.TimeRange(2);
UD.TimeWindows  = [UD.StartTimes',UD.StopTimes'];
UD.oColor       = get(UD.hL,'Color');
UD.oColor       = mode(cat(1,UD.oColor{:}));
UD.InvalidTrial = [];
UD.hInvalidTrial= [];
initialize(UD);

end

function initialize(UD)

h.fig =figure('MenuBar','none',...
    'Name','uiSelectInvalidTrial',...
    'NumberTitle','off',...
    'Position',[769   657   371   271],...
    'Toolbar','none');
centerfig(h.fig)

h.msgbox    = uicontrol(h.fig,'BackgroundColor',get(h.fig,'Color'),...
    'Callback',[],...
    'HorizontalAlignment','center',...
    'Max',100,...
    'Min',0,...
    'String',[],...
    'Style','text',...
    'Units' , 'normalized',...
    'value' , [],...
    'Position' , [0.0754717 0.89 0.762803 0.0738007]);

h.listbox   = uicontrol(h.fig,'BackgroundColor',[1 1 1],...
    'Callback',[],...
    'HorizontalAlignment','left',...
    'Max',100,...
    'Min',0,...
    'String',[],...
    'Style','listbox',...
    'Units' , 'normalized',...
    'value' , [],...
    'Position' , [0.0754717 0.232472 0.762803 0.66]);

h.add  = uicontrol(h.fig,'BackgroundColor',get(h.fig,'Color'),...
    'Callback',{@add,h},...
    'HorizontalAlignment','center',...
    'String','+',...
    'Style','pushbutton',...
    'Units' , 'normalized',...
    'value' , [],...
    'Position' , [0.889488 0.726937 0.0539084 0.0738007]);

h.delete   = uicontrol(h.fig,'BackgroundColor',get(h.fig,'Color'),...
    'Callback',{@delete,h},...
    'HorizontalAlignment','center',...
    'String','-',...
    'Style','pushbutton',...
    'Units' , 'normalized',...
    'value' , [],...
    'Position' , [0.889488 0.626937 0.0539084 0.0738007]);

h.ok  = uicontrol(h.fig,'BackgroundColor',get(h.fig,'Color'),...
    'Callback',{@ok,h},...
    'HorizontalAlignment','center',...
    'String','OK',...
    'Style','pushbutton',...
    'Units' , 'normalized',...
    'value' , [],...
    'Position' , [0.25 0.0774908 0.161725 0.0738007]);

h.cencel   = uicontrol(h.fig,'BackgroundColor',get(h.fig,'Color'),...
    'Callback',{@cancel,h},...
    'HorizontalAlignment','center',...
    'String','Cancel',...
    'Style','pushbutton',...
    'Units' , 'normalized',...
    'value' , [],...
    'Position' , [0.45 0.0774908 0.161725 0.0738007]);


guidata(h.fig,UD);

figure(UD.fig);
set(UD.hAx,'Selected','on');

end


function add(src,evt,h)

UD         = guidata(h.fig);
[TrialProp,hL]  = getTrialProp(UD.hAx,'r');
if(isempty(TrialProp))
    return;
end

iTrials         = [TrialProp.iTrial]';

UD.InvalidTrial = union(UD.InvalidTrial,iTrials);
UD.hInvalidTrial= union(UD.hInvalidTrial,hL);

guidata(h.fig,UD)

refreshlist(h)
refreshLineColor(h)
end

function delete(src,evt,h)

UD         = guidata(h.fig);
[TrialProp,hL]  = getTrialProp(UD.hAx,'g');
if(isempty(TrialProp))
    return;
end

iTrials     = [TrialProp.iTrial]';

UD.InvalidTrial = setdiff(UD.InvalidTrial,iTrials);
UD.hInvalidTrial= setdiff(UD.hInvalidTrial,hL);

guidata(h.fig,UD)

refreshlist(h)
refreshLineColor(h)
end

function ok(src,evt,h)
UD  = guidata(h.fig);

TimeWindows = UD.TimeWindows(UD.InvalidTrial,:);
Y  = makeIntervalChannel(['Invalid Interval (',UD.Name,')'],'manual',[],TimeWindows);


% set filename
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
fullfilename    = fullfile(parentpath,[Y.Name,datestr(now,'yyyymmdd'),'.mat']);
[filename, parentpath] = uiputfile(fullfilename);

if(isequal(filename,0) || isequal(parentpath,0))
    disp('User pressed cancel.')
else
    setconfig(mfilename,'parentpath',parentpath);
    fullfilename    = fullfile(parentpath,filename);
    %

    if(exist(fullfilename,'file')) % append previous file
        ss  = load(fullfilename);
        Y.Data= union(ss.Data',Y.Data','rows')';
    end
    save(fullfilename,'-struct','Y')
    disp(fullfilename)
end
set(UD.hAx,'Selected','off');
close(h.fig);

end

function cancel(src,evt,h)
UD  = guidata(h.fig);
set(UD.hAx,'Selected','off');
close(h.fig);

end

function refreshlist(h)

UD  = guidata(h.fig);
if(~isempty(UD.InvalidTrial))
    nlist   = length(UD.InvalidTrial);
    list    = cell(nlist,1);
    
    for ilist=1:nlist
        list{ilist} = [num2str(UD.InvalidTrial(ilist)),': [',num2str(UD.StartTimes(UD.InvalidTrial(ilist)),'%g'),',',num2str(UD.StopTimes(UD.InvalidTrial(ilist)),'%g'),']'];
    end
    set(h.listbox,'string',list)
else
    nlist   = 0;
    set(h.listbox,'string',[])
end

message = [num2str(nlist),' / ',num2str(length(UD.TriggerTimes)),' trials'];
set(h.msgbox,'string',message)

end



function refreshLineColor(h)

UD  = guidata(h.fig);
set(setdiff(UD.hL,UD.hInvalidTrial),'Color',UD.oColor);
set(UD.hInvalidTrial,'Color',[1 0 0]);


end

% 
% [TrialProp,hLine] = getTrialProp;
% Color   = get(hLine(1),'Color');
% set(hLine,'Color',[1 0 0])
% 
% fig = gcf;
% hAx = gca;
% 
% UD  = get(fig,'UserData');
% ind = UD.h==hAx;
% S   = UD.Data{ind};
% 
% TimeRange   = S.TimeRange;
% 
% iTrials         = [TrialProp.iTrial]';
% TriggerTimes    = [TrialProp.TriggerTime]';
% 
% TrialProp       = sortrows([iTrials,TriggerTimes],1);
% iTrials         = TrialProp(:,1);
% TriggerTimes    = TrialProp(:,2);
% 
% StartTimes      = TriggerTimes+TimeRange(1);
% StopTimes       = TriggerTimes+TimeRange(2);
% 
% TimeWindows     = [StartTimes,StopTimes];
% nTW             = size(TimeWindows,1);
% message         = cell(nTW+1,1);
% 
% message{1}      = [num2str(nTW),' trials'];
% for iTW=1:nTW
%     message{iTW+1}    = [num2str(iTrials(iTW)),': [',num2str(StartTimes(iTW)),',',num2str(StopTimes(iTW)),']'];
% end
% % message = sort(message);
% 
% 
% YN  = questdlg(message, ...
%     'TimeWindows',...
%     'OK','Cancel','OK');
% switch YN
%     case 'OK'
%         Y  = makeIntervalChannel('Invalid Interval','manual',[],TimeWindows);
%         
%         
%         %% set filename
%         [parentpath,InputDir]   = fileparts(UD.parentpath);
%         parentpath      = getconfig(mfilename,'parentpath');
%         try
%         if(isempty(parentpath))
%             parentpath  = matpath;
%         else
%             parentpath  = fileparts(fileparts(parentpath));
%         end
%         catch
%             parentpath  = matpath;
%         end
%         parentpath      = fullfile(parentpath,InputDir);
%         fullfilename    = fullfile(parentpath,[Y.Name,'.mat']);
%         [filename, parentpath] = uiputfile(fullfilename);
%         setconfig(mfilename,'parentpath',parentpath);
%         fullfilename    = fullfile(parentpath,filename);
%         %%
%         
%         if(exist(fullfilename,'file')) % append previous file
%             ss  = load(fullfilename);
%             Y.Data= union(ss.Data',Y.Data','rows')';
%         end
%         save(fullfilename,'-struct','Y')
%         disp(fullfilename)
%         
%     otherwise
%         set(hLine,'Color',Color)
%         disp('User Pressed Cancel')
%         return;
% end
% 
