function uifmanova(alpha, comparison_method)
% comparison_method   多重検定を行うpairを選んでください。
%                     'all'        すべてのペアについて多重検定を行います。
%                     '条件名'  ひとつの条件を対照条件として、この条件とほかの条件のペアのみについて多重検定を行います。

if(nargin<1)
    alpha               = 0.05;
    comparison_method   = 'all';
elseif(nargin<2)
    comparison_method   = 'all';
end

ParentDir   = uigetdir(datapath,'親フォルダを選択してください。');
if(ParentDir==0)
    disp('User pressed cancel.')
    return;
end
InputDirs   = dirdir(ParentDir);
InputDirs   = uiselect(InputDirs,1,'対象となるExperimentを選択してください。');
InputDir    = InputDirs{1};
FileNames   = sortxls(strfilt(dirmat(fullfile(ParentDir,InputDir)),'~._'));
        
        
[gnames,Tarfiles,TimeWindow] = setdatagui(FileNames);

if(isempty(gnames))
    disp('User pressed cancel')
    return;
end

ncond   = length(gnames);

for iDir=1:length(InputDirs)
    try
        InputDir    = InputDirs{iDir};
        disp([num2str(iDir),'/',num2str(length(InputDirs)),':  ',InputDir])
        
        [refname,tarname]=getRefTarName(Tarfiles{1});
        OutputFile  = ['FMCMP(',tarname];


        for icond=1:ncond
            OutputFile  = [OutputFile,',',gnames{icond}];
            Tarfile = Tarfiles{icond};
            Tar_hdr = load(fullfile(ParentDir,InputDir,Tarfile),'nTrials','XData','SampleRate');
            Tar_dat = load(fullfile(ParentDir,InputDir,['._',Tarfile]),'TrialData');
            if(icond==1)
                Data = zeros(Tar_hdr.nTrials,ncond);
            end
            TW  = TimeWindow{icond};
            if(islogical(Tar_dat.TrialData))  % psth
                ind = Tar_hdr.XData >= TW(1) & Tar_hdr.XData<=TW(2);
                Data(:,icond)   = sum(Tar_dat.TrialData(:,ind),2) .* Tar_hdr.SampleRate ./ sum(ind); % sps
            else
                ind = Tar_hdr.XData >= TW(1) & Tar_hdr.XData<=TW(2);
                Data(:,icond)   = mean(Tar_dat.TrialData(:,ind),2);
            end
        end


        Y               = fmanova(Data,gnames,alpha,comparison_method);
        Y.TargetNames   = Tarfiles;
        Y.TimeWindow    = TimeWindow;


        OutputFile  = [OutputFile,').mat'];
        OutputFile  = fullfile(ParentDir,InputDir,OutputFile);

        save(OutputFile,'-struct','Y')

        clear('Tar_hdr','Tar_dat','Y')

        disp([' L-- :  ',OutputFile])


    catch
        errormsg    = ['****** Error occured in ',InputDirs{iDir}];
        disp(errormsg)
        errorlog(errormsg);
    end
    %     indicator(0,0)

end

end



function Y  = fmanova(Data, gnames, alpha, comparison_method)

Y.AnalysisType  = 'FMCMP';
Y.comparison    = comparison_method;
Y.gnames        = gnames;
Y.Data          = Data;
Y.nTrials       = size(Data,1);
Y.mean          = mean(Data,1);
Y.std           = std(Data,1,1);

if(Y.nTrials<2)
    Y.friedman  = [];
    Y.anova1    = [];
    disp('nTrials < 2')
    return;
    
end

ncond   = length(gnames);
switch lower(comparison_method)
    case 'all'
        comparison  = zeros(ncond*(ncond-1)/2,2);
        ncomp       = size(comparison,1);
        icomp       = 0;
        for icond=1:(ncond-1)
            for jcond=(icond+1):ncond
                icomp   = icomp + 1;
                comparison(icomp,1) = icond;
                comparison(icomp,2) = jcond;
            end
        end
        disp('comparison:   all')
    otherwise
        ctrlind  = strmatch(comparison_method,gnames,'exact');
        if(isempty(ctrlind))
            error(['指定した条件はありません',comparison_method]);
        end
        otherind    = setdiff(1:ncond,ctrlind);
        comparison  = zeros(ncond-1,2);
        ncomp       = size(comparison,1);
        for icomp=1:ncomp
            comparison(icomp,1) = ctrlind;
            comparison(icomp,2) = otherind(icomp);
        end
        disp(['comparison:   ',gnames{ctrlind}])
        
end


% friedman
Y.friedman.reps         = 1;
[Y.friedman.p,Y.friedman.table,Y.friedman.stats] = friedman(Data,Y.friedman.reps,'off');
Y.friedman.h            = Y.friedman.p < alpha;
Y.friedman.alpha        = alpha;
Y.friedman.ctype        = 'bonferroni';
Y.friedman.calpha       = alpha / ncomp;
Y.friedman.comparison   = comparison;

p   = zeros(ncomp,1);
h   = zeros(ncomp,1);


for icomp=1:ncomp
    [p(icomp),h(icomp)]  = signrank(Data(:,comparison(icomp,1)),Data(:,comparison(icomp,2)),'alpha',Y.friedman.calpha);
end

Y.friedman.comparison   = [comparison,p,h];


% anova1
[Y.anova1.p,Y.anova1.table,Y.anova1.stats] = anova1(Data,gnames,'off');

Y.anova1.h          = Y.anova1.p < alpha;
Y.anova1.alpha      = alpha;
Y.anova1.ctype      = 'bonferroni';
Y.anova1.calpha     = alpha / ncomp;
Y.anova1.comparison = comparison;

p   = zeros(ncomp,1);
h   = zeros(ncomp,1);

for icomp=1:ncomp
    [h(icomp),p(icomp)]  = ttest(Data(:,comparison(icomp,1)),Data(:,comparison(icomp,2)),Y.anova1.calpha,'both');
end

Y.anova1.comparison   = [comparison,p,h];
end


function [Name,FileName,TimeWindow] = setdatagui(FileNames)

h.fig =figure('MenuBar','none',...
    'Name','uianova1sta',...
    'NumberTitle','off',...
    'Position',[769   657   371   271],...
    'Toolbar','none');
centerfig(h.fig)

h.listbox  = uicontrol(h.fig,'BackgroundColor',[1 1 1],...
    'Callback',[],...
    'HorizontalAlignment','left',...
    'Max',100,...
    'Min',0,...
    'String',[],...
    'Style','listbox',...
    'Units' , 'normalized',...
    'value' , [],...
    'Position' , [0.0754717 0.232472 0.762803 0.667897]);

h.add  = uicontrol(h.fig,'BackgroundColor',get(h.fig,'Color'),...
    'Callback',{@add,h,FileNames},...
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

h.up  = uicontrol(h.fig,'BackgroundColor',get(h.fig,'Color'),...
    'Callback',{@up,h},...
    'HorizontalAlignment','center',...
    'String','A',...
    'Style','pushbutton',...
    'Units' , 'normalized',...
    'value' , [],...
    'Position' , [0.889488 0.526937 0.0539084 0.0738007]);

h.down   = uicontrol(h.fig,'BackgroundColor',get(h.fig,'Color'),...
    'Callback',{@down,h},...
    'HorizontalAlignment','center',...
    'String','v',...
    'Style','pushbutton',...
    'Units' , 'normalized',...
    'value' , [],...
    'Position' , [0.889488 0.426937 0.0539084 0.0738007]);

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

h.edittxt= uicontrol(h.fig,'BackgroundColor',get(h.fig,'Color'),...
    'Callback',{@edittxt,h},...
    'HorizontalAlignment','center',...
    'String','edittxt',...
    'Style','pushbutton',...
    'Units' , 'normalized',...
    'value' , [],...
    'Position' , [0.65 0.0774908 0.161725 0.0738007]);

UD.Name        = cell(1);
UD.FileName    = cell(1);
UD.TimeWindow  = cell(1);

guidata(h.fig,UD);

uiwait;
fids    = findobj(0,'Type','figure');
if(ismember(h.fig,fids))
    UD  = guidata(h.fig);
    if(~isempty(findobj(h.ok)))
        Name        = UD.Name;
        FileName    = UD.FileName;
        TimeWindow  = UD.TimeWindow;
        close(h.fig)
    end
else
    Name    = [];
    FileName    = [];
    TimeWindow  = [];
end


function ok(src,evnt,h)
uiresume;
end

function cancel(src,evnt,h)
close(h.fig);
end
end


function edittxt(src,evt,h)

UD  = guidata(h.fig);

if(~isempty(UD.Name{1}))
    nrow        = length(UD.Name);
    tempcell    = cell(nrow,1); 
    for irow=1:nrow
        tempcell{irow}  = ['''',UD.Name{irow},''',''',UD.FileName{irow},''',[',num2str(UD.TimeWindow{irow}(1),'%g'),',',num2str(UD.TimeWindow{irow}(2),'%g'),']'];
    end
    default_answer  = {str2mat(tempcell)};
else
    default_answer  = {''};
end
options.Resize='on';
options.WindowStyle='normal';
options.Interpreter='tex';

txt = inputdlg({'''Name'',''FileName'',[TimeWindow]'},'load text',10,default_answer,options);
if(isempty(txt))
    return;
end
txt = txt{1};
nrow=size(txt,1);
UD.Name        = cell(nrow,1);
UD.FileName    = cell(nrow,1);
UD.TimeWindow  = cell(nrow,1);


for irow=1:nrow
    tempcell    = eval(['{',txt(irow,:),'}']);
    UD.Name{irow}  = tempcell{1};
    UD.FileName{irow}  = tempcell{2};
    UD.TimeWindow{irow}  = tempcell{3};
end
guidata(h.fig,UD)
refreshlist(h)
end


function add(src,evt,h,FileNames)

UD  = guidata(h.fig);
[Name,FileName,TimeWindow]  = addgui(FileNames);

if(~isempty(UD.Name{1}))
    UD.Name        = [UD.Name;Name];
    UD.FileName    = [UD.FileName;FileName];
    UD.TimeWindow  = [UD.TimeWindow;TimeWindow];
else
    UD.Name        = {Name};
    UD.FileName    = {FileName};
    UD.TimeWindow  = {TimeWindow};
end
guidata(h.fig,UD)
refreshlist(h)
end

function delete(src,evt,h)

UD  = guidata(h.fig);
ind = get(h.listbox,'Value');

if(~isempty(UD.Name{1}) && ~isempty(ind))
    UD.Name(ind)        = [];
    UD.FileName(ind)    = [];
    UD.TimeWindow(ind)  = [];
    if(isempty(UD.Name))
        UD.Name        = cell(1);
        UD.FileName    = cell(1);
        UD.TimeWindow  = cell(1);

    end
    guidata(h.fig,UD)
    refreshlist(h)
end


end

function up(src,evt,h)

UD  = guidata(h.fig);
selected_ind = get(h.listbox,'Value');

if(~isempty(UD.Name{1}) && ~isempty(selected_ind))
    nlist       = length(UD.Name);
    all_ind     = 1:nlist;
    unselected_ind  = setdiff(all_ind,selected_ind);
    oldName     = UD.Name;
    oldFileName = UD.FileName;
    oldTimeWindow= UD.TimeWindow;
    
    newselected_ind = selected_ind -1;
    if(newselected_ind(1)<1)
        return;
    end
    newunselected_ind   = setdiff(all_ind,newselected_ind);
    
    
    
    UD.Name(newselected_ind)    = oldName(selected_ind);
    UD.Name(newunselected_ind)   = oldName(unselected_ind);
    UD.FileName(newselected_ind)    = oldFileName(selected_ind);
    UD.FileName(newunselected_ind)   = oldFileName(unselected_ind);
    UD.TimeWindow(newselected_ind)    = oldTimeWindow(selected_ind);
    UD.TimeWindow(newunselected_ind)   = oldTimeWindow(unselected_ind);
    
    guidata(h.fig,UD)
    refreshlist(h)
    
    set(h.listbox,'Value',newselected_ind)
end
end

function down(src,evt,h)

UD  = guidata(h.fig);
selected_ind = get(h.listbox,'Value');

if(~isempty(UD.Name{1}) && ~isempty(selected_ind))
    nlist       = length(UD.Name);
    all_ind     = 1:nlist;
    unselected_ind  = setdiff(all_ind,selected_ind);
    oldName     = UD.Name;
    oldFileName = UD.FileName;
    oldTimeWindow= UD.TimeWindow;
    
    newselected_ind = selected_ind +1;
    if(newselected_ind(1)>nlist)
        return;
    end
    newunselected_ind   = setdiff(all_ind,newselected_ind);
    
    
    
    UD.Name(newselected_ind)    = oldName(selected_ind);
    UD.Name(newunselected_ind)   = oldName(unselected_ind);
    UD.FileName(newselected_ind)    = oldFileName(selected_ind);
    UD.FileName(newunselected_ind)   = oldFileName(unselected_ind);
    UD.TimeWindow(newselected_ind)    = oldTimeWindow(selected_ind);
    UD.TimeWindow(newunselected_ind)   = oldTimeWindow(unselected_ind);
    
    guidata(h.fig,UD)
    refreshlist(h)
    
    set(h.listbox,'Value',newselected_ind)
end
end


function refreshlist(h)
UD  = guidata(h.fig);
if(~isempty(UD.Name{1}))
    nlist   = length(UD.Name);
    list    = cell(nlist,1);
    for ilist=1:nlist
        list{ilist} = ['"',UD.Name{ilist},'"; ',UD.FileName{ilist},' [',num2str(UD.TimeWindow{ilist}(1),'%g'),',',num2str(UD.TimeWindow{ilist}(2),'%g'),']'];
    end
    set(h.listbox,'string',list)
else
    set(h.listbox,'string',[])
end

end

function [Name,FileName,TimeWindow] = addgui(FileNames)



h.fig =figure('MenuBar','none',...
    'Name','uianova1sta',...
    'NumberTitle','off',...
    'Position',[508   545   664   145],...
    'Toolbar','none');
centerfig(h.fig)

h.nametxt  = uicontrol(h.fig,'BackgroundColor',get(h.fig,'Color'),...
    'Callback',[],...
    'HorizontalAlignment','left',...
    'String','Name',...
    'Style','text',...
    'Units' , 'normalized',...
    'value' , [],...
    'Position' , [0.0501193 0.7 0.143198 0.137931]);

h.filenametxt  = uicontrol(h.fig,'BackgroundColor',get(h.fig,'Color'),...
    'Callback',[],...
    'HorizontalAlignment','left',...
    'String','FileName',...
    'Style','text',...
    'Units' , 'normalized',...
    'value' , [],...
    'Position' , [0.0501193 0.5 0.143198 0.137931]);


h.timewindowtxt  = uicontrol(h.fig,'BackgroundColor',get(h.fig,'Color'),...
    'Callback',[],...
    'HorizontalAlignment','left',...
    'String','TimeWindow (sec)',...
    'Style','text',...
    'Units' , 'normalized',...
    'value' , [],...
    'Position' , [0.0501193 0.3 0.143198 0.137931]);

h.name  = uicontrol(h.fig,'BackgroundColor',[1 1 1],...
    'Callback',[],...
    'HorizontalAlignment','left',...
    'String','Name',...
    'Style','edit',...
    'Units' , 'normalized',...
    'value' , [],...
    'Position' , [0.200301 0.7 0.527623 0.137931]);

h.filename  = uicontrol(h.fig,'BackgroundColor',[1 1 1],...
    'Callback',[],...
    'HorizontalAlignment','left',...
    'String','FileName',...
    'Style','edit',...
    'Units' , 'normalized',...
    'value' , [],...
    'Position' , [0.200301 0.5 0.527623 0.137931]);

h.timewindow  = uicontrol(h.fig,'BackgroundColor',[1 1 1],...
    'Callback',[],...
    'HorizontalAlignment','left',...
    'String','[0,1]',...
    'Style','edit',...
    'Units' , 'normalized',...
    'value' , [],...
    'Position' , [0.200301 0.3 0.527623 0.137931]);

h.browse   = uicontrol(h.fig,'BackgroundColor',get(h.fig,'Color'),...
    'Callback',{@browse,h,FileNames},...
    'HorizontalAlignment','center',...
    'String','browse',...
    'Style','pushbutton',...
    'Units' , 'normalized',...
    'value' , [],...
    'Position' , [0.746988 0.5 0.0903614 0.137931]);

h.ok   = uicontrol(h.fig,'BackgroundColor',get(h.fig,'Color'),...
    'Callback',{@ok,h},...
    'HorizontalAlignment','center',...
    'String','OK',...
    'Style','pushbutton',...
    'Units' , 'normalized',...
    'value' , [],...
    'Position' , [.612952 0.0758621 0.0903614 0.137931]);

h.cancel   = uicontrol(h.fig,'BackgroundColor',get(h.fig,'Color'),...
    'Callback',{@cancel,h},...
    'HorizontalAlignment','center',...
    'String','Cancel',...
    'Style','pushbutton',...
    'Units' , 'normalized',...
    'value' , [],...
    'Position' , [0.746988 0.0758621 0.0903614 0.137931]);

uiwait;
if(~isempty(findobj(h.name)))
    Name        = get(h.name,'String');
    FileName    = get(h.filename,'String');
    TimeWindow  = eval(get(h.timewindow,'String'));
    close(h.fig)
end

function browse(src,evnt,h,FileNames)
filename = uichoice(FileNames);
set(h.filename,'String',filename);
end

function ok(src,evnt,h)
uiresume;

end

function cancel(src,evnt,h)
close(h.fig);
end


end


