function importmdadata
% IMPORTMDADATA
%
% import mda data (experiment or analyses)
%
% To import mda data
% 1) Open experiment or analyses on mda (run mda at earlier (<MATLAB7.1) platform)
% 2) Select experiment or analyses on mda
% 3) run 'importmdadata' on matlab
% 4) Choose 'experiment' or 'analyses' tab which you would like to import
% 5) Select experiment or analyses to import
% 6) Push 'import' button
% 7) Select output directory
%
% After these steps, script automatically save files which organized as
% "EXPERIMENTNAME/CHANNELNAME.mat" under the output folder specified in Step7.
%
%


% modified by Tomohiko Takei 2010/12/02: Continuous Data (experimet) is
% imported in unit of 'mV', indicating Voltage digitized by microstar PCI
% board.
% modified by Tomohiko Takei 2011/08/24: STA Data is
% imported in unit of 'mV'.
%



makefigure;

end


%----------------------------------
function makefigure(varargin)

Position    = getconfig(mfilename,'Position');
Position    = adjust_position(Position);

UD.h.fig =figure('Units','pixels',...
    'DeleteFcn',@fig_deletefcn,...
    'MenuBar','none',...
    'Name','Import MDA Data',...
    'NumberTitle','off',...
    'PaperUnits', 'centimeters',...
    'PaperOrientation','landscape',...
    'PaperPosition', [0.881189 0.634517 27.9151 19.715],...
    'PaperPositionMode','manual',...
    'Position',Position,...
    'Resize','off',...
    'ResizeFcn',[],...@fig_resizefnc,...
    'Tag','uiselect',...
    'Toolbar','none');

UD.h.experimentpb   = uicontrol(UD.h.fig,'Units','pixels',...
    'BackgroundColor',get(UD.h.fig,'Color'),...
    'Callback',@experimentpb_callback,...
    'HorizontalAlignment','center',...
    'String','Experiment',...
    'Style','pushbutton',...
    'Value' , 1,...
    'Position' , [Position(3)-285 Position(4)-35 80 26]);

UD.h.analysespb = uicontrol(UD.h.fig,'Units','pixels',...
    'BackgroundColor',get(UD.h.fig,'Color'),...
    'Callback',@analysespb_callback,...
    'HorizontalAlignment','center',...
    'String','Analyses',...
    'Style','pushbutton',...
    'Value' , 1,...
    'Position' , [Position(3)-165 Position(4)-35 80 26]);

UD.h.listbox = uicontrol(UD.h.fig,'Units','pixels',...
    'BackgroundColor',[1 1 1],...
    'Callback',@refresheditor,...
    'HorizontalAlignment','center',...
    'min',0,...
    'max',100,...
    'String',[],...
    'Style','listbox',...
    'Value' , 1,...
    'Position' , [10,60,Position(3)-20,Position(4)-105]);

UD.h.defaultpb  = uicontrol(UD.h.fig,'Units','pixels',...
    'BackgroundColor',get(UD.h.fig,'Color'),...
    'Callback',@defaultpb_callback,...
    'HorizontalAlignment','center',...
    'String','Default',...
    'Style','pushbutton',...
    'Value' , 1,...
    'Position' , [Position(3)-330 15 68 26]);

UD.h.loadxlspb  = uicontrol(UD.h.fig,'Units','pixels',...
    'BackgroundColor',get(UD.h.fig,'Color'),...
    'Callback',@loadxlspb_callback,...
    'HorizontalAlignment','center',...
    'String','load xls',...
    'Style','pushbutton',...
    'Value' , 1,...
    'Position' , [Position(3)-260 15 68 26]);

UD.h.importpb  = uicontrol(UD.h.fig,'Units','pixels',...
    'BackgroundColor',get(UD.h.fig,'Color'),...
    'Callback',@importpb_callback,...
    'HorizontalAlignment','center',...
    'String','import',...
    'Style','pushbutton',...
    'Value' , 1,...
    'Position' , [Position(3)-180 15 68 26]);

UD.h.cancelpb   = uicontrol(UD.h.fig,'Units','pixels',...
    'BackgroundColor',get(UD.h.fig,'Color'),...
    'Callback',@cancelpb_callback,...
    'HorizontalAlignment','center',...
    'String','cancel',...
    'Style','pushbutton',...
    'Value' , 1,...
    'Position' , [Position(3)-110 15 68 26]);


UD.h.editorpb  = uicontrol(UD.h.fig,'Units','pixels',...
    'BackgroundColor',get(UD.h.fig,'Color'),...
    'Callback',@editorpb_callback,...
    'FontSize',6,...
    'HorizontalAlignment','center',...
    'String','>',...
    'Style','pushbutton',...
    'UserData',false,...
    'Value', 1,...
    'Position' , [Position(3)-16 20 16 16]);

UD.h.experimentlabel  = uicontrol(UD.h.fig,'Units','pixels',...
    'BackgroundColor',get(UD.h.fig,'Color'),...
    'Callback',[],...
    'HorizontalAlignment','left',...
    'String','Experiment',...
    'Style','text',...
    'Value' , 1,...
    'Position' , [Position(3)+30 400 68 15]);

UD.h.experimenttxt  = uicontrol(UD.h.fig,'Units','pixels',...
    'BackgroundColor',get(UD.h.fig,'Color'),...
    'Callback',[],...
    'HorizontalAlignment','left',...
    'String','',...
    'Style','text',...
    'Value' , 1,...
    'Position' , [Position(3)+50 380 68 15]);


UD.h.totaltime1label  = uicontrol(UD.h.fig,'Units','pixels',...
    'BackgroundColor',get(UD.h.fig,'Color'),...
    'Callback',[],...
    'HorizontalAlignment','left',...
    'String','TotalTime1',...
    'Style','text',...
    'Value' , 1,...
    'Position' , [Position(3)+30 300 68 15]);


UD.h.totaltime1edit  = uicontrol(UD.h.fig,'Units','pixels',...
    'BackgroundColor',[1 1 1],...
    'Callback',@totaltimeedit_callback,...
    'HorizontalAlignment','right',...
    'String','',...
    'Style','edit',...
    'Value' , 1,...
    'Position' , [Position(3)+30 270 68 26]);

UD.h.totaltime2label  = uicontrol(UD.h.fig,'Units','pixels',...
    'BackgroundColor',get(UD.h.fig,'Color'),...
    'Callback',[],...
    'HorizontalAlignment','left',...
    'String','TotalTime2',...
    'Style','text',...
    'Value' , 1,...
    'Position' , [Position(3)+120 300 68 15]);


UD.h.totaltime2edit  = uicontrol(UD.h.fig,'Units','pixels',...
    'BackgroundColor',[1 1 1],...
    'Callback',@totaltimeedit_callback,...
    'HorizontalAlignment','right',...
    'String','',...
    'Style','edit',...
    'Value' , 1,...
    'Position' , [Position(3)+120 270 68 26]);

% default mode is Experiment
UD.mode = getconfig(mfilename,'mode');
if(isempty(UD.mode))
    UD.mode = 'experiment'; % or 'analyses'
end

guidata(UD.h.fig,UD)
applymode;
defaultpb_callback;
refresheditor;
end


%----------------------------------
function Position   = adjust_position(Position)

figsize = [350,450];

% Get screen size in pixels
screenunit  = get(0,'Units');
if ~strcmpi(screenunit,'pixels')
    set(0,'Units','pixels');
    screensize  = get(0,'ScreenSize');
    set(0,'Units',screenunit);
else
    screensize = get(0,'ScreenSize');
end
centerXY    = [round(screensize(3)/2), round(screensize(4)/2)];


if(isempty(Position))
    Position    = [centerXY(1)-round(figsize(1)/2), centerXY(2)-round(figsize(2)/2),figsize(1),figsize(2)];

elseif(Position(1) < screensize(1) | Position(2) < screensize(2) | (Position(1) + Position(3)) > screensize(3) | (Position(2) + Position(4)) > screensize(4))
    Position    = [centerXY(1)-round(figsize(1)/2), centerXY(2)-round(figsize(2)/2),figsize(1),figsize(2)];
else
    Position(3) = figsize(1);
    Position(4) = figsize(2);
end
end


%----------------------------------
function fig_deletefcn(varargin)
Position    = get(gcf,'Position');
setconfig(mfilename,'Position',Position);

end

%----------------------------------
function experimentpb_callback(varargin)
UD  = guidata(gcf);

UD.mode = 'experiment';
guidata(UD.h.fig,UD);

applymode;
refreshlist;
end

%----------------------------------
function analysespb_callback(varargin)
UD  = guidata(gcf);

UD.mode = 'analyses';
guidata(UD.h.fig,UD);

applymode;
refreshlist;
end

%----------------------------------
function defaultpb_callback(varargin)
getexperiments;
getanalyses;

UD  = guidata(gcf);

if(isempty(UD.Exps))
    UD.ExpList = [];
else
    nList   = length(UD.Exps);
    UD.ExpList = cell(nList,3);
    for iList   = 1:nList
        UD.ExpList{iList,1}    = UD.ExperimentNames{iList};
        UD.ExpList{iList,2}    = 1;
        UD.ExpList{iList,3}    = UD.TotalTime{iList};
    end
end

if(isempty(UD.Anas))
    UD.AnaList = [];
else
    nList   = length(UD.Anas);
    UD.AnaList = cell(nList,1);
    for iList   = 1:nList
        UD.AnaList{iList,1}    = UD.AnalysisNames{iList};
    end
end

guidata(UD.h.fig,UD);
refreshlist;
end


%----------------------------------
function loadxlspb_callback(varargin)
UD  = guidata(gcf);
xlsload(-1,'-cell','ExperimentName','Suffix','TotalTime1','TotalTime2','SpikeChannelName')
nList   = length(ExperimentName);
if(length(TotalTime1)~=nList || length(TotalTime2)~=nList)
    error('Input must have same length')
end
UD.ExpList  = [ExperimentName,TotalTime1,TotalTime2];
UD.Suffix   = Suffix;
UD.SpikeChannelName = SpikeChannelName;

guidata(UD.h.fig,UD);
refreshlist;
end

%----------------------------------
function editorpb_callback(varargin)
UD  = guidata(gcf);
if(get(UD.h.editorpb,'UserData'))
    Position    = get(UD.h.fig,'Position');
    Position(3) = Position(3) - 220;
    set(UD.h.fig,'Position',Position);
    set(UD.h.editorpb,'String','>');
    set(UD.h.editorpb,'UserData',false);
else
    Position    = get(UD.h.fig,'Position');
    Position(3) = Position(3) + 220;
    set(UD.h.fig,'Position',Position);
    set(UD.h.editorpb,'String','<');
    set(UD.h.editorpb,'UserData',true);
end
end


%----------------------------------
function cancelpb_callback(varargin)
UD  = guidata(gcf);
close(UD.h.fig)
end

%----------------------------------
function totaltimeedit_callback(varargin)
UD  = guidata(gcf);
ind = get(UD.h.listbox,'Value');

if(length(ind)>1)
    nList   = length(ind);
    for iList   =1:nList
        UD.ExpList{ind(iList),2}    = str2double(get(UD.h.totaltime1edit,'String'));
        UD.ExpList{ind(iList),3}    = str2double(get(UD.h.totaltime2edit,'String'));
    end
else
    UD.ExpList{ind,2}    = str2double(get(UD.h.totaltime1edit,'String'));
    UD.ExpList{ind,3}    = str2double(get(UD.h.totaltime2edit,'String'));
end
guidata(UD.h.fig,UD);
refreshlist;
refresheditor;
end

%----------------------------------
function applymode(varargin)
UD  = guidata(gcf);
selection_color = [0 0.5 0];

switch UD.mode
    case 'experiment'
        set(UD.h.experimentpb,  'BackgroundColor',selection_color,'ForegroundColor','w');
        set(UD.h.analysespb ,   'BackgroundColor',get(gcf,'Color'),'ForegroundColor','w');

        set(UD.h.experimentlabel,'Enable','on');
        set(UD.h.experimenttxt,'Enable','on');
        set(UD.h.totaltime1label,'Enable','on');
        set(UD.h.totaltime1edit,'Enable','on');
        set(UD.h.totaltime2label,'Enable','on');
        set(UD.h.totaltime2edit,'Enable','on');

        set(UD.h.loadxlspb,'Enable','on');

    case 'analyses'
        set(UD.h.experimentpb,  'BackgroundColor',get(gcf,'Color'),'ForegroundColor','w');
        set(UD.h.analysespb ,   'BackgroundColor',selection_color,'ForegroundColor','w');

        set(UD.h.experimentlabel,'Enable','off');
        set(UD.h.experimenttxt,'Enable','off');
        set(UD.h.totaltime1label,'Enable','off');
        set(UD.h.totaltime1edit,'Enable','off');
        set(UD.h.totaltime2label,'Enable','off');
        set(UD.h.totaltime2edit,'Enable','off');

        set(UD.h.loadxlspb,'Enable','off');

end
setconfig(mfilename,'mode',UD.mode);
end

%----------------------------------
function refreshlist(varargin)
UD  = guidata(gcf);

switch UD.mode
    case 'experiment'
        if(~isempty(UD.ExpList))
            value   = get(UD.h.listbox,'Value');
            nList   = size(UD.ExpList,1);
            if(value>nList | value < 1)
                value=1;
            end
            ListString  = cell(nList,1);
            for iList=1:nList
                ListString{iList}    = [UD.ExpList{iList,1},' [',num2str(UD.ExpList{iList,2}),',',num2str(UD.ExpList{iList,3}),']'];
            end
        else
            value       = 0;
            ListString  = [];
        end
    case 'analyses'
        if(~isempty(UD.AnaList))
            value   = get(UD.h.listbox,'Value');
            nList   = size(UD.AnaList,1);
            if(value>nList | value < 1)
                value=1;
            end
            ListString  = UD.AnaList;
        else
            value       = 0;
            ListString  = [];
        end
end
set(UD.h.listbox,'Value',value,'String',ListString);
end


%----------------------------------
function refresheditor(varargin)
UD  = guidata(gcf);

switch UD.mode
    case 'experiment'
        ind = get(UD.h.listbox,'Value');

        if(length(ind)>1)
            nList   = length(ind);
            const1  = true;
            const2  = true;
            const3  = true;

            for iList=2:nList
                const1  = strcmp(UD.ExpList{ind(1),1},UD.ExpList{ind(iList),1}) & const1;
                const2  = (UD.ExpList{ind(1),2}==UD.ExpList{ind(iList),2}) & const2;
                const3  = (UD.ExpList{ind(1),3}==UD.ExpList{ind(iList),3}) & const3;
            end

            if(const1)
                set(UD.h.experimenttxt,'FontAngle','normal','String',UD.ExpList{ind(1),1});
            else
                set(UD.h.experimenttxt,'FontAngle','italic','String',UD.ExpList{ind(1),1});
            end
            if(const2)
                set(UD.h.totaltime1edit,'FontAngle','normal','String',UD.ExpList{ind(1),2});
            else
                set(UD.h.totaltime1edit,'FontAngle','italic','String',UD.ExpList{ind(1),2});
            end
            if(const3)
                set(UD.h.totaltime2edit,'FontAngle','normal','String',UD.ExpList{ind(1),3});
            else
                set(UD.h.totaltime2edit,'FontAngle','italic','String',UD.ExpList{ind(1),3});
            end
        elseif(ind~=0)
            set(UD.h.experimenttxt,'FontAngle','normal','String',UD.ExpList{ind,1});
            set(UD.h.totaltime1edit,'FontAngle','normal','String',UD.ExpList{ind,2});
            set(UD.h.totaltime2edit,'FontAngle','normal','String',UD.ExpList{ind,3});
        end
    case 'analyses'

end

end

%----------------------------------
function getexperiments(varargin)
UD  = guidata(gcf);

UD.Exps = gsme;
if isempty(UD.Exps)
    UD.ExperimentNames  = [];
    UD.TotalTime        = [];
else
    UD.ExperimentNames  = get(UD.Exps,'Name');
    UD.TotalTime        = get(UD.Exps,'TotalTime');

    if(~iscell(UD.ExperimentNames))
        UD.ExperimentNames = {UD.ExperimentNames};
    end
    if(~iscell(UD.TotalTime))
        UD.TotalTime = {UD.TotalTime};
    end
end

guidata(UD.h.fig,UD)
end

%----------------------------------
function getanalyses(varargin)
UD  = guidata(gcf);

UD.Anas = gsma;

if(isempty(UD.Anas))
    UD.AnalysisNames  = [];
else
    UD.AnalysisNames  = get(UD.Anas,'Name');

    if(~iscell(UD.AnalysisNames))
        UD.AnalysisNames = {UD.AnalysisNames};
    end
end

guidata(UD.h.fig,UD)
end




%----------------------------------
function importpb_callback(varargin)
guiindicator(1,1,'initializing...')
% getexperiments;
UD  = guidata(gcf);

PlatForm    = 'mda';
SpikeName   = 'MSD';

switch UD.mode
    case 'experiment'

        iList   = get(UD.h.listbox,'Value');
        nList   = length(iList);
        if(isempty(iList))
            disp('No experiment is selected.')
            return;
        else
            disp(['>>> ',num2str(nList),' experiments selected.']);
        end
        UD.ExpList = UD.ExpList(iList,:);


        ChanNames   = getmdachannames(UD.Exps(1));
        if(isempty(ChanNames))
            disp('User pressed cancel.')
            return;
        end

        Outputparent    = getconfig(mfilename,'Outputparent');
        try
            if(~exist(Outputparent,'dir'))
                Outputparent    = pwd;
            end
        catch
            Outputparent    = pwd;
        end

        Outputparent    = uigetdir(Outputparent);
        if(isequal(Outputparent,0))
            disp('User pressed cancel.')
            return;
        else
            setconfig(mfilename,'Outputparent',Outputparent);
        end


        % R7.1より前だとcellfun関数の一番目の引数は関数名の文字列であることに対応
        version = ver('Matlab');
        ind     = find(version.Version=='.');
        if(length(ind)>1)
            version = version.Version(1:(ind(2)-1));
        else
            version = version.Version;
        end

        version = str2double(version);

        if(version<7.1)    % もしmatlabがR14sp3(matlab7.1より前だったら)
            ExpNamesLength  = min(cellfun('length',UD.ExperimentNames));
        else
            ExpNamesLength  = min(cellfun(@length,UD.ExperimentNames));
        end




        nError  = 0;
        for iList  = 1:nList
            ExperimentName  = UD.ExpList{iList,1};
            TimeRange       = [UD.ExpList{iList,2},UD.ExpList{iList,3}];
            if(isfield(UD,'Suffix'))
                if(~isempty(UD.Suffix))
                    Suffix          = UD.Suffix{iList};
                else
                    Suffix  = [];
                end
            else
                Suffix  = [];
            end

            if(isfield(UD,'SpikeChannelName'))
                if(~isempty(UD.SpikeChannelName))
                    SpikeChannelName    = UD.SpikeChannelName{iList};
                else
                    SpikeChannelName    = [];
                end
            else
                SpikeChannelName    = [];
            end


            try
                % find matched Experiment
                %                 ind     = strncmp(UD.ExperimentNames,UD.ExpList{iList,1},ExpNamesLength);
                ind     = strcmp(UD.ExperimentNames,UD.ExpList{iList,1});
                currExp = UD.Exps(ind);

                if(length(currExp)~=1)
                    error('ExperimentName does not match.')
                end
                if(isempty(currExp))
                    error('Matched Experiment was not found.')
                end

                % make output directory
                if(isempty(Suffix))
                    Outputpath      = fullfile(Outputparent,ExperimentName);
                else
                    if(isnumeric(Suffix))
                        Outputpath      = fullfile(Outputparent,[ExperimentName,num2str(Suffix,'%.2d')]);
                    else
                        Outputpath      = fullfile(Outputparent,[ExperimentName,Suffix]);
                    end
                end

                if(~exist(Outputpath,'dir'))
                    status  = mkdir(Outputpath);
                    if(status==0)
                        disp('**** Failure to make output directory.')
                    end
                end


                % get and save data
                if(~isempty(ChanNames))
                    IDs = experiment(currExp, 'findchannelobjs', ChanNames);
                else
                    IDs = [];
                end

                if(~isempty(IDs))
                    if any(isnull(IDs))
                        error('No channels found.');
                    end

                    nID = length(IDs);
                    for iID = 1:nID
                        try
                            Name        = get(IDs(iID), 'Name');
                            Class       = get(IDs(iID), 'Class');
                            SampleRate  = get(IDs(iID), 'SampleRate');
                            temp        = getdata(currExp, Name, TimeRange, {{}});
                            temp        = temp{:};
                            Outputfile  = [fullfile(Outputpath,Name),'.mat'];

                            switch Class
                                case 'continuous channel'
                                    ConversionFactor    = units('conversionfactor','signal units','digitizing units','milliVolts',get(IDs(iID),'Parent'));
                                    Data                = double(temp) * ConversionFactor;
                                    Unit                = 'mV';
                                case 'timestamp channel'
                                    if(size(temp,1)>1)
                                        Children = get(IDs(iID),'Children');
                                        nChild  = length(Children);
                                        accessory_flag  = false(1,nChild);
                                        for iChild  = 1:nChild
                                            accessory_flag(iChild)  = strcmp(get(Children(iChild),'Class'),'accessory data');
                                        end
                                        Children    = Children(accessory_flag);
                                        nChild      = length(Children);
                                        for iChild  = 1:nChild
                                            accessory_data(iChild).Name = get(Children(iChild),'Name');
                                            accessory_data(iChild).Data = temp(iChild+1,:);
                                        end
                                        Data    = temp(1,:) - TimeRange(1) * SampleRate;
                                    else
                                        Data    = temp - TimeRange(1) * SampleRate;
                                        accessory_data  = [];
                                    end
                                case 'interval channel'
                                    error('interval channelは今のところサポートしてません。というか、MDAのインターバルチャンネルはわかりづらくて嫌いです。代わりに、Start/Stopに使用するtimestampチャンネルをimportして、後でmakeOriginalChannelsを走らせてください。');
                            end

                            clear('temp')
                            mpack

                            %                             TimeRange   = [0 TimeRange(2)-TimeRange(1)]

                            switch Class
                                case 'continuous channel'
                                    S.PlatForm  = PlatForm;
                                    S.Name      = Name;
                                    S.Data      = Data;
                                    S.SampleRate= SampleRate;
                                    S.Class     = Class;
                                    S.TimeRange = [0 TimeRange(2)-TimeRange(1)];
                                    S.Unit      = Unit;
                                    save(Outputfile,'-struct','S')
                                    %                                     save(Outputfile,'PlatForm','Name','Data','SampleRate','Class','TimeRange','Unit')

                                case 'timestamp channel'
                                    if(~isempty(accessory_data))
                                        S.PlatForm  = PlatForm;
                                        S.Name      = Name;
                                        S.Data      = Data;
                                        S.accessory_data    = accessory_data;
                                        S.SampleRate= SampleRate;
                                        S.Class     = Class;
                                        S.TimeRange = [0 TimeRange(2)-TimeRange(1)];

                                        save(Outputfile,'-struct','S')
                                        %                                         save(Outputfile,'PlatForm','Name','Data','accessory_data','SampleRate','Class','TimeRange')
                                    else
                                        S.PlatForm  = PlatForm;
                                        S.Name      = Name;
                                        S.Data      = Data;
                                        S.SampleRate= SampleRate;
                                        S.Class     = Class;
                                        S.TimeRange = [0 TimeRange(2)-TimeRange(1)];

                                        save(Outputfile,'-struct','S')
                                        %                                         save(Outputfile,'PlatForm','Name','Data','SampleRate','Class','TimeRange')
                                    end
                                case 'interval channel'
                                    error('interval channelは今のところサポートしてません。というか、MDAのインターバルチャンネルはわかりづらくて嫌いです。代わりに、Start/Stopに使用するtimestampチャンネルをimportして、後でmakeOriginalChannelsを走らせてください。');
                            end
                            disp(['Imported (',num2str(iID),'/',num2str(nID),') => ', Outputfile])
                        catch
                            nError  = nError+1;
                            Name        = get(IDs(iID), 'Name');
                            Outputfile  = [fullfile(Outputpath,Name),'.mat'];
                            errormsg    = ['**** error occurred in ',Outputfile];
                            disp(errormsg);
                            errorlog([errormsg,'(',mfilename,')']);
                        end % try

                    end     % iID=1:nID


                else
                    nError  = nError+1;
                    Outputpath      = fullfile(Outputparent,ExperimentName);
                    errormsg    = ['No matched data for ',Outputpath];
                    disp(errormsg);
                    errorlog([errormsg,'(',mfilename,')']);
                end

                % SpikeChannelのインポート
                if(~isempty(SpikeChannelName))
                    IDs = experiment(currExp, 'findchannelobjs', SpikeChannelName);


                    if(~isempty(IDs))
                        if any(isnull(IDs))
                            error('No channels found.');
                        end

                        nID = length(IDs);
                        for iID = 1:nID
                            try
                                Name        = get(IDs(iID), 'Name');
                                Class       = get(IDs(iID), 'Class');
                                SampleRate  = get(IDs(iID), 'SampleRate');
                                temp        = getdata(currExp, Name, TimeRange, {{}});
                                temp        = temp{:};
                                Outputfile  = [fullfile(Outputpath,SpikeName),'.mat'];

                                if(~strcmp(Class,'timestamp channel'))
                                    error([Name, ' is not timestamp channel.'])
                                end

                                if(size(temp,1)>1)
                                    Children = get(IDs(iID),'Children');
                                    nChild  = length(Children);
                                    accessory_flag  = false(1,nChild);
                                    for iChild  = 1:nChild
                                        accessory_flag(iChild)  = strcmp(get(Children(iChild),'Class'),'accessory data');
                                    end
                                    Children    = Children(accessory_flag);
                                    nChild      = length(Children);
                                    for iChild  = 1:nChild
                                        accessory_data(iChild).Name = get(Children(iChild),'Name');
                                        accessory_data(iChild).Data = temp(iChild+1,:);
                                    end
                                    Data    = temp(1,:) - TimeRange(1) * SampleRate;
                                else
                                    Data    = temp - TimeRange(1) * SampleRate;
                                    accessory_data  = [];
                                end

                                clear('temp')
                                mpack

                                if(~isempty(accessory_data))
                                    S.PlatForm  = PlatForm;
                                    S.Name      = SpikeName;
                                    S.Data      = Data;
                                    S.accessory_data    = accessory_data;
                                    S.SampleRate= SampleRate;
                                    S.Class     = Class;
                                    S.TimeRange = [0 TimeRange(2)-TimeRange(1)];

                                    save(Outputfile,'-struct','S')
                                    %                                         save(Outputfile,'PlatForm','Name','Data','accessory_data','SampleRate','Class','TimeRange')
                                else
                                    S.PlatForm  = PlatForm;
                                    S.Name      = SpikeName;
                                    S.Data      = Data;
                                    S.SampleRate= SampleRate;
                                    S.Class     = Class;
                                    S.TimeRange = [0 TimeRange(2)-TimeRange(1)];

                                    save(Outputfile,'-struct','S')
                                    %                                         save(Outputfile,'PlatForm','Name','Data','SampleRate','Class','TimeRange')
                                end
                                disp(['Imported (',num2str(iID),'/',num2str(nID),') => ', Outputfile])
                            catch
                                nError  = nError+1;
                                %                             Name        = get(IDs(iID), 'Name');
                                Outputfile  = [fullfile(Outputpath,SpikeName),'.mat'];
                                errormsg    = ['**** error occurred in ',Outputfile];
                                disp(errormsg);
                                errorlog([errormsg,'(',mfilename,')']);
                            end % try

                        end     % iID=1:nID


                    else
                        nError  = nError+1;
                        Outputpath      = fullfile(Outputparent,ExperimentName);
                        errormsg    = ['No matched data for ',Outputpath];
                        disp(errormsg);
                        errorlog([errormsg,'(',mfilename,')']);
                    end
                else
                    IDs = [];
                end

            catch
                nError  = nError+1;
                Outputpath      = fullfile(Outputparent,ExperimentName);
                errormsg    = ['error occurred in ',Outputpath];
                disp(errormsg);
                errorlog([errormsg,'(',mfilename,')']);
            end
            guiindicator(iList,nList,'importing...')
        end         % for iList=1:nList

        if(nError~=0)
            disp([num2str(nError) ' errors occurred.']);
            disp([' see ',errorlog]);
        else
            disp(['<<< ',num2str(nList),' experiments successfully imported.']);
        end

    case 'analyses'
        iList   = get(UD.h.listbox,'Value');
        nList   = length(iList);
        if(isempty(iList))
            disp('No analysis is selected.')
            return;
        else
            disp(['>>> ',num2str(nList),' analyses selected.']);
        end
        UD.AnaList  = UD.AnaList(iList,:);
        UD.Anas     = UD.Anas(iList);

        ParentDir   = uigetdir(datapath);
        if(ParentDir==0)
            disp('User pressed cancel.')
            return;
        end

        nAna    = length(UD.Anas);
        for iAna=1:nAna
            Ana     = UD.Anas(iAna);
            AnaName = UD.AnaList{iAna};
            Comps   = analyses(Ana, 'componentobjs');

            nComp   = length(Comps);
            if(nComp == 0)
                disp(['PeakAreas: No components to do: ',AnaName]);
                continue;
            end

            for iComp =1:nComp
                Comp    = Comps(iComp);
                SubClass    = get(Comp,'SubClass');

                switch SubClass
                    case 'triggered average'    % STA
                        if(~get(Comp,'StoreTrials'))    % without storetrials
                            XConversionFactor    = units('conversionfactor', 'time', get(Comp, 'TimeUnits'), 'seconds');
                            YConversionFactor    = units('conversionfactor','signal units',get(Comp,'YUnits'),'milliVolts',Comp);

                            hdr.StoreTrial_flag = 0;
                            hdr.ISA_flag        = 0;
                            hdr.maxtrials       = [0 get(Comp,'TrialLimit')];
                            hdr.Smoothing_flag  = [];
                            hdr.Name            = [];
                            hdr.TargetName      = get(Comp,'Target');
                            hdr.ReferenceName   = get(Comp,'Reference');
                            hdr.Class           = 'analyses';
                            hdr.AnalysisType    = 'STA';
                            hdr.TimeRange       = [get(Comp, 'WindowStart'),get(Comp, 'WindowStop')] * XConversionFactor;
                            hdr.SampleRate      = get(Comp,'SampleRate');
                            hdr.TimeStamps      = get(Comp,'TrialTriggerTime');
                            hdr.TrialsToUse     = get(Comp,'TrialsToUse');
                            hdr.TrialData       = [];
                            hdr.nTrials         = get(Comp,'TrialCount');
                            hdr.YData           = double(get(Comp,'YData')) * YConversionFactor;
                            hdr.XData           = get(Comp,'XData') * XConversionFactor;
                            hdr.Unit            = 'mV';
                            hdr.Name            = ['STA (',hdr.ReferenceName,', ',hdr.TargetName,')'];
                            hdr.data_file       = ['._STA (',hdr.ReferenceName,', ',hdr.TargetName,')'];

                            dat.Name            = hdr.data_file;
                            dat.hdr_file        = hdr.Name;

                            % make output directory
                            OutputDir      = fullfile(ParentDir,AnaName);
                            if(~exist(OutputDir,'dir'))
                                mkdir(OutputDir);
                            end

                            Outputfile_hdr  = [fullfile(OutputDir,hdr.Name),'.mat'];
                            Outputfile_dat  = [fullfile(OutputDir,dat.Name),'.mat'];

                            save(Outputfile_hdr,'-struct','hdr');
                            disp(['Imported => ', Outputfile_hdr]);

                            save(Outputfile_dat,'-struct','dat');
                            disp(['Imported => ', Outputfile_dat]);

                        else    % with storetrials
                            XConversionFactor    = units('conversionfactor', 'time', get(Comp, 'TimeUnits'), 'seconds');
                            YConversionFactor    = units('conversionfactor','signal units',get(Comp,'YUnits'),'milliVolts',Comp);
                            TrialConversionFactor   = units('conversionfactor','signal units','digitizing units','milliVolts',Comp);

                            hdr.StoreTrial_flag = 1;
                            hdr.ISA_flag        = 0;
                            hdr.maxtrials       = [0 get(Comp,'TrialLimit')];
                            hdr.Smoothing_flag  = [];
                            hdr.Name            = [];
                            hdr.TargetName      = get(Comp,'Target');
                            hdr.ReferenceName   = get(Comp,'Reference');
                            hdr.Class           = 'analyses';
                            hdr.AnalysisType    = 'STA';
                            hdr.TimeRange       = [get(Comp, 'WindowStart'),get(Comp, 'WindowStop')] * XConversionFactor;
                            hdr.SampleRate      = get(Comp,'SampleRate');
                            hdr.TimeStamps      = get(Comp,'TrialTriggerTime');
                            hdr.TrialsToUse     = get(Comp,'TrialsToUse');
                            hdr.TrialData       = 1;
                            hdr.nTrials         = get(Comp,'TrialCount');
                            hdr.YData           = double(get(Comp,'YData')) * YConversionFactor;
                            hdr.XData           = get(Comp,'XData') * XConversionFactor;
                            hdr.Unit            = 'mV';
                            hdr.Name            = ['STA (',hdr.ReferenceName,', ',hdr.TargetName,')'];
                            hdr.data_file       = ['._STA (',hdr.ReferenceName,', ',hdr.TargetName,')'];

                            dat.Name            = hdr.data_file;
                            dat.hdr_file        = hdr.Name;
                            dat.TrialData       = double(get(Comp,'TrialData')) * TrialConversionFactor;

                            % make output directory
                            OutputDir      = fullfile(ParentDir,AnaName);
                            if(~exist(OutputDir,'dir'))
                                mkdir(OutputDir);
                            end

                            Outputfile_hdr  = [fullfile(OutputDir,hdr.Name),'.mat'];
                            Outputfile_dat  = [fullfile(OutputDir,dat.Name),'.mat'];

                            save(Outputfile_hdr,'-struct','hdr');
                            disp(['Imported => ', Outputfile_hdr]);

                            save(Outputfile_dat,'-struct','dat');
                            disp(['Imported => ', Outputfile_dat]);

                        end

                    case 'perievent histogram'
                        disp('under construction')
                        keyboard
                end % switch SubClass
            end % for iComp =1:nComp
            guiindicator(iAna,nAna,'importing...')
        end % for iAna =1:nAna

end % switch UD.mode


guiindicator(1,1,'done.')
pause(1)
guiindicator(1,0,'done.')
end