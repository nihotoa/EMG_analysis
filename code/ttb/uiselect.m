function varargout  = uiselect(varargin)
% [selectedlist,ind]= uiselect(list,exclusive_flag,title,default_answer);
%       list            must be cell array
%       exclusive_flag  0= inclusive mode; 1= [exclusive mode]
%       title           string
%       default_answer  cell array or string
%
%       selectedlist    cell array or empty
%   bug: 同じ名前のものがあると右boxに移動したときに同じものとして認識される。indexbaseの管理が必要
%
%       081012  implemented default_answer


%% argin check
error(nargchk(1, 4, nargin, 'struct'))
command = 'initialize';

if nargin < 1
    error('uiselect error: No input argment.')
elseif nargin == 1
    if(iscell(varargin{1}))
        orig_list   = varargin{1};
        exclusive   = 1;    % 0= inclusive mode; 1= exclusive mode
        figtitle    = 'uiselect';
        default_answer  = cell(1);
    elseif(ischar(varargin{1}))
        command = varargin{1};
        exclusive   = 1;    % 0= inclusive mode; 1= exclusive mode
        figtitle    = 'uiselect';
        default_answer  = cell(1);
    else
        error('uiselect error: No list array.')
    end
elseif nargin == 2
    if(iscell(varargin{1}) && ~isempty(varargin{2}))
        orig_list   = varargin{1};
        exclusive   = varargin{2};
        figtitle    = 'uiselect';
        default_answer  = cell(1);
    elseif(iscell(varargin{1}) && isempty(varargin{2}))
        orig_list   = varargin{1};
        exclusive   = 1;
        figtitle    = 'uiselect';
        default_answer  = cell(1);
    else
        error('uiselect error: Invalid syntax.')
    end
elseif nargin == 3
    if(iscell(varargin{1}) && ~isempty(varargin{2}) && ischar(varargin{3}))
        orig_list   = varargin{1};
        exclusive   = varargin{2};
        figtitle    = varargin{3};
        default_answer  = cell(1);
    elseif(iscell(varargin{1}) && isempty(varargin{2}) && ischar(varargin{3}))
        orig_list   = varargin{1};
        exclusive   = 1;
        figtitle    = varargin{3};
        default_answer  = cell(1);
    else
        error('uiselect error: Invalid syntax.')
    end
elseif nargin == 4
    if(iscell(varargin{1}) && ~isempty(varargin{2}) && ischar(varargin{3}))
        orig_list   = varargin{1};
        exclusive   = varargin{2};
        figtitle    = varargin{3};
        default_answer  = varargin{4};
    elseif(iscell(varargin{1}) && isempty(varargin{2}) && ischar(varargin{3}))
        orig_list   = varargin{1};
        exclusive   = 1;
        figtitle    = varargin{3};
        default_answer  = varargin{4};
    else
        error('uiselect error: Invalid syntax.')
    end
    if(ischar(default_answer))
        default_answer  = {default_answer};
    end
end
%% UD
if(strcmp(command,'initialize'))
    % インデックス化する
    [orig_list,origorig_list]   = strind(orig_list);

    UD = uiselectfigure;

    set(UD.fig,'UserData',UD)
    uiwait;
    UD   = get(UD.fig,'UserData');
    close(UD.fig)

    if(isempty(UD.right_list))
        %             Selectedlist        = {};
        ind                 = [];
    elseif(length(UD.right_list)==1 && isempty(UD.right_list{1}))
        %             Selectedlist        = {};
        ind                 = [];
    else
        Selectedlist        = UD.right_list;
        nlist   = length(Selectedlist);
        ind     = zeros(1,length(Selectedlist));
        for ilist=1:nlist
            %             ind                 = find(ismember(UD.orig_list,UD.right_list));
            ind(ilist)  = strmatch(Selectedlist{ilist},UD.orig_list,'exact');
        end
    end

    Selectedlist    = origorig_list(ind);
    % Deal with output argument
    varargout{1}        = Selectedlist;
    if(nargout>1)
        varargout{2}    = ind;
    end

    return;
end

UD   = get(gcf,'UserData');
switch command
    case 'defans'


        orig_list   = UD.orig_list(:);
        left_list   = UD.left_list(:);
        right_list  = UD.right_list(:);

        defansstr   = get(UD.h.defansbox,'String');
        try
            defans      = eval([defansstr,';']);
        catch
            defans      = [];
        end
        if(~isempty(defans))
            selected_ind    = ismember(defans,orig_list);
            defans(~selected_ind)    = [];
            if(isempty(defans))
                defans      = cell(1);
            end
            right_list      = defans;
            left_list       = orig_list;
        end
        if(UD.exclusive==1  && ~(length(right_list)==1 && isempty(right_list{1})))    % もしexclusivemodeであれば、、、
            selected_ind    = ismember(left_list,right_list);
            left_list(selected_ind) = [];
            if(isempty(left_list))
                left_list   = cell(1);
            end
        end

        set(UD.h.lbox,'String',left_list,'Value',[]);
        set(UD.h.rbox,'String',right_list,'Value',[]);
        UD.left_list     = left_list;
        UD.right_list    = right_list;
        
    case 'paste'
        
        orig_list   = UD.orig_list(:);
        left_list   = UD.left_list(:);
        right_list  = UD.right_list(:);
        
        defans  = xlscell2mat(clipboard('paste'));
%         defans  = str2cell(clipboard('paste'));
        
        if(~isempty(defans))
            selected_ind    = ismember(defans,orig_list);
            defans(~selected_ind)    = [];
            if(isempty(defans))
                defans      = cell(1);
            end
            right_list      = defans;
            left_list       = orig_list;
        end
        if(UD.exclusive==1  && ~(length(right_list)==1 && isempty(right_list{1})))    % もしexclusivemodeであれば、、、
            selected_ind    = ismember(left_list,right_list);
            left_list(selected_ind) = [];
            if(isempty(left_list))
                left_list   = cell(1);
            end
        end

        set(UD.h.lbox,'String',left_list,'Value',[]);
        set(UD.h.rbox,'String',right_list,'Value',[]);
        UD.left_list     = left_list;
        UD.right_list    = right_list;
        
    case 'copy'
        
        right_list  = UD.right_list(:);
        
        mat2clip(right_list);


    case 'filt'
        orig_list   = UD.orig_list(:);
        left_list   = UD.left_list(:);
        right_list  = UD.right_list(:);

        filtstr     = get(UD.h.filtbox,'String');
        if(isempty(deblank(filtstr)))
            left_list   = orig_list;
        else
            left_list   = strfilt(orig_list,filtstr);
            if(isempty(left_list))
                left_list  = cell(1);
            end
        end
        if(UD.exclusive==1 && ~(length(right_list)==1 && isempty(right_list{1})))    % もしexclusivemodeで右にデータがあれば、、、
            selected_ind    = ismember(left_list,right_list);
            left_list(selected_ind) = [];
            if(isempty(left_list))
                left_list   = cell(1);
            end
        end

        set(UD.h.lbox,'String',left_list,'Value',[]);
        set(UD.h.rbox,'String',right_list,'Value',[]);
        UD.left_list     = left_list;
        UD.right_list    = right_list;

    case 'add'
        orig_list   = UD.orig_list(:);
        left_list   = UD.left_list(:);
        right_list  = UD.right_list(:);


        selected_ind    = get(UD.h.lbox,'Value');
        add_list        = left_list(selected_ind);
        if(length(add_list)==1 && isempty(add_list{1}))
            return
        end
        if(length(right_list)==1 && isempty(right_list{1}))
            right_list   = add_list;
        else
            add_list    = add_list(~ismember(add_list,right_list));
            right_list  = [right_list; add_list];
        end
        if(UD.exclusive==1)
            left_list(selected_ind) = [];
            if(isempty(left_list))
                left_list   = cell(1);
            end
        end

        [TF,add_ind]         = ismember(add_list,right_list);
        set(UD.h.lbox,'String',left_list,'Value',[]);
        set(UD.h.rbox,'String',right_list,'Value',add_ind(add_ind~=0));
        UD.left_list     = left_list;
        UD.right_list    = right_list;

    case 'delete'
        orig_list   = UD.orig_list(:);
        left_list   = UD.left_list(:);
        right_list  = UD.right_list(:);


        selected_ind    = get(UD.h.rbox,'Value');
        add_list        = right_list(selected_ind);
        if(length(add_list)==1 && isempty(add_list{1}))
            return
        end
        right_list(selected_ind)    = [];
        if(isempty(right_list))
            right_list  = cell(1);
        end
        if(UD.exclusive==1)
            if(length(left_list)==1 && isempty(left_list{1}))
                left_list   = orig_list(ismember(orig_list,add_list));
            else
                %                     keyboard
                left_list   = orig_list(ismember(orig_list,[left_list;add_list]));
            end
        else
            left_list   = orig_list;
        end

        [TF,add_ind]         = ismember(add_list,left_list);
        set(UD.h.lbox,'String',left_list,'Value',add_ind(add_ind~=0));
        set(UD.h.rbox,'String',right_list,'Value',[]);
        UD.left_list     = left_list;
        UD.right_list    = right_list;

    case 'add_all'
        orig_list   = UD.orig_list(:);
        left_list   = UD.left_list(:);
        right_list  = UD.right_list(:);


        add_list        = left_list;
        if(length(add_list)==1 && isempty(add_list{1}))
            return
        end
        if(length(right_list)==1 && isempty(right_list{1}))
            right_list   = add_list;
        else
            add_list    = add_list(~ismember(add_list,right_list));
            right_list  = [right_list; add_list];
        end
        if(UD.exclusive==1)
            left_list   = cell(1);
        end

        [TF,add_ind]         = ismember(add_list,right_list);
        set(UD.h.lbox,'String',left_list,'Value',[]);
        set(UD.h.rbox,'String',right_list,'Value',add_ind(add_ind~=0));
        UD.left_list     = left_list;
        UD.right_list    = right_list;

    case 'delete_all'
        orig_list   = UD.orig_list(:);
        left_list   = UD.left_list(:);
        right_list  = UD.right_list(:);

        add_list        = right_list;
        if(length(add_list)==1 && isempty(add_list{1}))
            return
        end
        right_list  = cell(1);

        if(UD.exclusive==1)
            if(length(left_list)==1 && isempty(left_list{1}))
                left_list   = orig_list(ismember(orig_list,add_list));
            else
                left_list   = orig_list(ismember(orig_list,[left_list;add_list]));
            end
        else
            left_list   = orig_list;
        end

        [TF,add_ind]         = ismember(add_list,left_list);
        set(UD.h.lbox,'String',left_list,'Value',add_ind(add_ind~=0));
        set(UD.h.rbox,'String',right_list,'Value',[]);
        UD.left_list     = left_list;
        UD.right_list    = right_list;

    case 'up'
        oldright_list   = UD.right_list(:);
        right_list      = oldright_list;
        selected_ind    = get(UD.h.rbox,'Value');
        if((length(right_list)==1 && isempty(right_list{1})) || isempty(selected_ind))
            return
        end
        all_ind     = [1:length(right_list)];
        unselected_ind  = setdiff(all_ind,selected_ind);
        newselected_ind = selected_ind - 1;
        if(newselected_ind(1)<1)
            return
        end
        newunselected_ind  = setdiff(all_ind,newselected_ind);

        right_list(newselected_ind) = oldright_list(selected_ind);
        right_list(newunselected_ind) = oldright_list(unselected_ind);

        set(UD.h.rbox,'String',right_list,'Value',newselected_ind);
        UD.right_list    = right_list;

    case 'top'
        oldright_list   = UD.right_list(:);
        right_list      = oldright_list;
        selected_ind    = get(UD.h.rbox,'Value');
        if((length(right_list)==1 && isempty(right_list{1})) || isempty(selected_ind))
            return
        end
        all_ind     = [1:length(right_list)];
        unselected_ind  = setdiff(all_ind,selected_ind);
        newselected_ind = [1:length(selected_ind)];
        if(newselected_ind(1)<1)
            return
        end
        newunselected_ind  = setdiff(all_ind,newselected_ind);

        right_list(newselected_ind) = oldright_list(selected_ind);
        right_list(newunselected_ind) = oldright_list(unselected_ind);

        set(UD.h.rbox,'String',right_list,'Value',newselected_ind);
        UD.right_list    = right_list;

    case 'down'
        oldright_list   = UD.right_list(:);
        right_list      = oldright_list;
        selected_ind    = get(UD.h.rbox,'Value');
        if((length(right_list)==1 && isempty(right_list{1})) || isempty(selected_ind))
            return
        end
        all_ind     = [1:length(right_list)];
        unselected_ind  = setdiff(all_ind,selected_ind);
        newselected_ind = selected_ind + 1;
        if(newselected_ind(end)>all_ind(end))
            return
        end
        newunselected_ind  = setdiff(all_ind,newselected_ind);

        right_list(newselected_ind) = oldright_list(selected_ind);
        right_list(newunselected_ind) = oldright_list(unselected_ind);

        set(UD.h.rbox,'String',right_list,'Value',newselected_ind);
        UD.right_list    = right_list;

    case 'bottom'
        oldright_list   = UD.right_list(:);
        right_list      = oldright_list;
        selected_ind    = get(UD.h.rbox,'Value');
        if((length(right_list)==1 && isempty(right_list{1})) || isempty(selected_ind))
            return
        end
        all_ind     = [1:length(right_list)];
        unselected_ind  = setdiff(all_ind,selected_ind);
        newselected_ind = [length(all_ind)-length(selected_ind)+1:length(all_ind)];

        newunselected_ind  = setdiff(all_ind,newselected_ind);

        right_list(newselected_ind) = oldright_list(selected_ind);
        right_list(newunselected_ind) = oldright_list(unselected_ind);

        set(UD.h.rbox,'String',right_list,'Value',newselected_ind);
        UD.right_list    = right_list;

    case 'ok'
        uiresume;

    case 'cancel'
        UD.right_list = {[]};
        uiresume;
end

if(get(UD.h.rbox,'ListBoxTop')>length(UD.right_list))
    set(UD.h.rbox,'ListBoxTop',1);
end
if(get(UD.h.lbox,'ListBoxTop')>length(UD.left_list))
    set(UD.h.lbox,'ListBoxTop',1);
end


if(isempty(UD.right_list{1}))
    nitems  = 0;
else
    nitems  = length(UD.right_list);
end
set(UD.h.resultbox,'String',[num2str(nitems),' item(s)']);
set(gcf,'UserData',UD);



    function UD = uiselectfigure
        left_list   = orig_list;
        right_list  = default_answer;
        if(exclusive==1 && ~isempty(right_list{1}))
            selected_ind    = ismember(left_list,right_list);
            left_list(selected_ind) = [];
            if(isempty(left_list))
                left_list   = cell(1);
            end
        end

        fig =figure('MenuBar','figure',...
            'Name',figtitle,...
            'NumberTitle','off',...            'Windowstyle','docked',...
            'PaperUnits', 'centimeters',...
            'PaperOrientation','landscape',...
            'PaperPosition', [0.881189 0.634517 27.9151 19.715],...
            'PaperPositionMode','manual',...
            'Position',[155 188 784 653],...
            'Tag','uiselect',...
            'Toolbar','none');
        centerfig(fig)

        h.resultbox     = uicontrol(fig,'BackgroundColor',get(fig,'Color'),...
            'Callback',[],...
            'HorizontalAlignment','center',...
            'String',[],...
            'Style','Text',...
            'Units' , 'normalized',...
            'value' , [],...
            'Position' , [0.570341 0.93 0.334659 0.03]);

        h.filtbox     = uicontrol(fig,'BackgroundColor',[1 1 1],...
            'Callback','uiselect(''filt'')',...
            'HorizontalAlignment','left',...
            'String',[],...
            'Style','Edit',...
            'Units' , 'normalized',...
            'value' , [],...
            'Position' , [0.13 0.90 0.334659 0.03]);

%         h.defansbox     = uicontrol(fig,'BackgroundColor',[1 1 1],...
%             'Callback','uiselect(''defans'')',...
%             'HorizontalAlignment','left',...
%             'String',[],...
%             'Style','Edit',...
%             'Units' , 'normalized',...
%             'value' , [],...
%             'Position' , [0.570341 0.90 0.334659 0.03]);
        
         h.pastebutton   = uicontrol(fig,'BackgroundColor',get(fig,'Color'),...
            'Callback','uiselect(''paste'')',...
            'HorizontalAlignment','center',...
            'String','Paste',...
            'Style','Pushbutton',...
            'Units' , 'normalized',...
            'value' , [],...
            'Position' , [0.570341 0.90 0.16 0.03]);
        
        h.copybutton   = uicontrol(fig,'BackgroundColor',get(fig,'Color'),...
            'Callback','uiselect(''copy'')',...
            'HorizontalAlignment','center',...
            'String','Copy',...
            'Style','Pushbutton',...
            'Units' , 'normalized',...
            'value' , [],...
            'Position' , [0.7450 0.90 0.16 0.03]);
        
        h.lbox     = uicontrol(fig,'BackgroundColor',[1 1 1],...
            'Max',100,...
            'Min',1,...
            'String',left_list,...
            'Style','listbox',...
            'Units' , 'normalized',...
            'value' , [],...
            'Position' , [0.13 0.11 0.334659 0.785]);

        h.rbox = uicontrol(fig,'BackgroundColor',[1 1 1],...
            'Max',100,...
            'Min',1,...
            'String',right_list,...
            'Style','listbox',...
            'Units' , 'normalized',...
            'value' , [],...
            'Position' , [0.570341 0.11 0.334659 0.785]);

        h.add   = uicontrol(fig,'BackgroundColor',get(fig,'Color'),...
            'Callback','uiselect(''add'')',...
            'Style','Pushbutton',...
            'Units' , 'normalized',...
            'Position' , [0.49 0.82 0.05 0.05],...
            'String','>');

        h.delete    = uicontrol(fig,'BackgroundColor',get(fig,'Color'),...
            'Callback','uiselect(''delete'')',...
            'Style','Pushbutton',...
            'Units' , 'normalized',...
            'Position' , [0.49 0.75 0.05 0.05],...
            'String','<');

        h.add_all   = uicontrol(fig,'BackgroundColor',get(fig,'Color'),...
            'Callback','uiselect(''add_all'')',...
            'Style','Pushbutton',...
            'Units' , 'normalized',...
            'Position' , [0.49 0.68 0.05 0.05],...
            'String','>>');

        h.delete_all    = uicontrol(fig,'BackgroundColor',get(fig,'Color'),...
            'Callback','uiselect(''delete_all'')',...
            'Style','Pushbutton',...
            'Units' , 'normalized',...
            'Position' , [0.49 0.61 0.05 0.05],...
            'String','<<');

        h.up        = uicontrol(fig,'BackgroundColor',get(fig,'Color'),...
            'Callback','uiselect(''up'')',...
            'Style','Pushbutton',...
            'Units' , 'normalized',...
            'Position' , [0.49 0.54 0.05 0.05],...
            'String','A');

        h.top       = uicontrol(fig,'BackgroundColor',get(fig,'Color'),...
            'Callback','uiselect(''top'')',...
            'Style','Pushbutton',...
            'Units' , 'normalized',...
            'Position' , [0.49 0.47 0.05 0.05],...
            'String','AA');

        h.down      = uicontrol(fig,'BackgroundColor',get(fig,'Color'),...
            'Callback','uiselect(''down'')',...
            'Style','Pushbutton',...
            'Units' , 'normalized',...
            'Position' , [0.49 0.40 0.05 0.05],...
            'String','V');

        h.bottom     = uicontrol(fig,'BackgroundColor',get(fig,'Color'),...
            'Callback','uiselect(''bottom'')',...
            'Style','Pushbutton',...
            'Units' , 'normalized',...
            'Position' , [0.49 0.33 0.05 0.05],...
            'String','VV');

        h.ok        = uicontrol(fig,'BackgroundColor',get(fig,'Color'),...
            'Callback','uiselect(''ok'')',...
            'Style','Pushbutton',...
            'Units' , 'normalized',...
            'Position' , [0.60 0.02 0.12 0.05],...
            'String','OK');

        h.cancel    = uicontrol(fig,'BackgroundColor',get(fig,'Color'),...
            'Callback','uiselect(''cancel'')',...
            'Style','Pushbutton',...
            'Units' , 'normalized',...
            'Position' , [0.75 0.02 0.12 0.05],...
            'String','Cancel');

        UD.fig           = fig;
        UD.h             = h;
        UD.orig_list     = orig_list;
        UD.left_list     = left_list;
        UD.right_list    = right_list;
        UD.exclusive     = exclusive;

        if(isempty(UD.right_list{1}))
            nitems  = 0;
        else
            nitems  = length(UD.right_list);
        end
        set(UD.h.resultbox,'String',[num2str(nitems),' item(s)']);

    end
end