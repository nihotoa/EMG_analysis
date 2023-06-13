function xlsload(file,varargin)
%  xlsload(xlsfilename,varname1,varname2,...)
%  xlsload(xlsfilename,'-cell',varname1,varname2,...)

% xlsfile = uigetfullfile('*.xls','Experiment Excelファイルを選択してください。');
% xlsload(xlsfile,'Name','Data');

if nargin < 1
    UD.file     = uigetfullfile;
    UD.Names    = {'variable1'};
    UD.file_flag    = true;
elseif(file==-1)
    UD.file     = file;
    UD.Names    = varargin;
    UD.file_flag    = false;
else
    if(exist(file,'file'))
        UD.file    = file;
        UD.Names   = varargin;
        UD.file_flag    = true;
    else
        UD.file_flag    = true;
        UD.Names   = [file,varargin];
        UD.file    = uigetfullfile;
    end
end

if(any(strcmp(UD.Names,'-cell')))
    UD.cellmode_flag   = true;
    UD.Names(strcmp(UD.Names,'-cell'))=[];
    disp('cellmode_flag=1')
else
    UD.cellmode_flag   = false;
end

UD.Values   = cell(size(UD.Names));

UD  = makefigure(UD);

if(UD.file_flag)
    connect_Excel;
end

set(UD.fig,'UserData',UD)

uiwait

% resume
try
    UD  = get(gcf,'UserData');
    nNames  = length(UD.Names);
    
    for iName   =1:nNames
        assignin('caller',UD.Names{iName},UD.Values{iName});
    end
    
    if(UD.file_flag)
        UD.ExcelWorkbook.Close(false); % close workbook without saving any changes
    end
    
    close(UD.fig);
catch
    disp('error')
end

end

function connect_Excel
UD  = get(gcf,'UserData');
try
    % Attempt to start Excel as ActiveX server process.
    UD.Excel = actxserver('excel.application');

    % open workbook
    UD.ExcelWorkbook = UD.Excel.workbooks.Open(UD.file);

    % Make Excel interface the active window.
    set(UD.Excel,'Visible',true);

catch
    err = lasterror;
    try
        UD.ExcelWorkbook.Close(false); % close workbook without saving any changes
    end
    rethrow(err);	% rethrow original error
end

end


function UD = makefigure(UD)
% initialise dialog
UD.fig  = figure('Color',[0.8 0.8 0.8],...
    'Menubar','none',...
    'Name','xlsload',...
    'NumberTitle','off',...
    'Position',[681 550 560 420],...
    'Resize','on',...
    'Toolbar','none');

UD.h.list  = uicontrol(UD.fig,'Units','normalized',...
    'BackgroundColor',[1 1 1],...
    'Callback',@CB_listselect,...
    'ListboxTop',1,...
    'Max',1,...
    'Min',0,...
    'Position',[0.0726257 0.0857143 0.312849 0.821429],...
    'Style','listbox',...
    'String',UD.Names);

UD.h.text   = uicontrol(UD.fig,'Units','normalized',...
    'BackgroundColor',[0.8 0.8 0.8],...
    'Position',[0.495345 0.257143 0.391061 0.645238],...
    'Style','text');

UD.h.select = uicontrol(UD.fig,'Units','normalized',...
    'BackgroundColor',[0.8 0.8 0.8],...
    'Callback',@CB_select,...
    'Position',[0.40    0.1 0.141527 0.0642857],...
    'String','Select',...
    'Style','pushbutton');

UD.h.edit = uicontrol(UD.fig,'Units','normalized',...
    'BackgroundColor',[0.8 0.8 0.8],...
    'Callback',@CB_edit,...
    'Position',[0.60    0.1 0.141527 0.0642857],...
    'String','Edit',...
    'Style','pushbutton');

UD.h.ok     = uicontrol(UD.fig,'Units','normalized',...
    'BackgroundColor',[0.8 0.8 0.8],...
    'Callback',@CB_ok,...
    'Position',[0.80    0.1 0.141527 0.0642857],...
    'String','OK',...
    'Style','pushbutton');

UD.h.menu.option  =  uimenu(UD.fig,'Label','&Option');
UD.h.menu.select  =  uimenu(UD.h.menu.option,'Label','Select',...
    'Callback',@CB_select,...
    'Enable','on',...
    'Accelerator','v');

set(UD.fig,'UserData',UD);
end

function CB_listselect(varargin)
UD  = get(gcf,'UserData');
ind = get(UD.h.list,'Value');

data    = UD.Values{ind};
if(isempty(UD.Values{ind}))
    message = '<no data>';
else

    message = ['<',num2str(size(data)),' ',class(data),'>'];
    data    = reshape(data,1,numel(data));
    if(isnumeric(data))
        data    = num2cellstr(data);
    elseif(ischar(data))
        data    = {data};
    end
    message = [message,'',data];
end
set(UD.h.text,'string',message);
end

function CB_select(varargin)
UD  = get(gcf,'UserData');
ind = get(UD.h.list,'Value');

if(UD.file_flag)
    UD.Excel.Selection.Copy;
end

if(UD.cellmode_flag)
        UD.Values{ind}  = xlscell2mat(clipboard('paste'));
%     UD.Values{ind}  = str2cell(clipboard('paste'));
else
        UD.Values{ind}  = parsecell(xlscell2mat(clipboard('paste')));
%     UD.Values{ind}  = parsecell(str2cell(clipboard('paste')));
end

if(UD.file_flag)
    UD.Excel.Selection.Application.CutCopyMode  = false;
end

set(UD.fig,'UserData',UD);
CB_listselect;
end

function CB_edit(varargin)
UD  = get(gcf,'UserData');
ind = get(UD.h.list,'Value');
ind = ind(1);

danswer = cell(1);
if(isempty(UD.Values{ind}))
    danswer{1}   = '';
    answer=inputdlg(UD.Names{ind},'Edit...',1,danswer);
elseif(ischar(UD.Values{ind}))
    danswer{1}   = UD.Values{ind};
    answer=inputdlg(UD.Names{ind},'Edit...',1,danswer);
elseif(isnumeric(UD.Values{ind}))
    answer  = UD.Values{ind};
    disp('answerの変数を書き換えてください')
    keyboard
end
if(iscell(answer))
    answer  = answer{1};
end

if(~isempty(answer))
    UD.Values{ind}  = answer;
    set(UD.fig,'UserData',UD);
    CB_listselect;
else
    disp('cancel')
end
end


function CB_ok(varargin)
uiresume;

end