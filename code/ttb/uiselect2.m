function vout  = uiselect(varargin)
% selectedlist  = uiselect(list,exclusive_flag,title,default_answer);
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
    if(iscell(varargin{1}) && isnumeric(varargin{2}))
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
    if(iscell(varargin{1}) && isnumeric(varargin{2}) && ischar(varargin{3}))
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
%% S
if(strcmp(command,'initialize'))
        S = uiselectfigure;

        set(S.fig,'UserData',S)
        uiwait;
        S   = get(S.fig,'UserData');
        close(fig)
        if(isempty(S.right_list))
            vout        = [];
        elseif(length(S.right_list)==1 && isempty(S.right_list{1}))          
            vout        = [];
        else
            vout        = S.right_list;
        end
        
        return;
end

S   = get(gcf,'UserData');
switch command
    case 'filt'
        orig_list   = S.orig_list(:);
        left_list   = S.left_list(:);
        right_list  = S.right_list(:);
        
        filtstr     = get(S.h.filtbox,'String');
        if(isempty(deblank(filtstr)))
            left_list   = orig_list;
        else
            left_list   = strfilt(orig_list,filtstr);
            if(isempty(left_list))
                left_list  = cell(1);
            end
        end
        S.exclusive
        if(S.exclusive==1)
            selected_ind    = ismember(left_list,right_list);
            left_list(selected_ind) = [];
            if(isempty(left_list))
                left_list   = cell(1);
            end
        end

        set(S.h.lbox,'String',left_list,'Value',[]);
        set(S.h.rbox,'String',right_list,'Value',[]);
        S.left_list     = left_list;
        S.right_list    = right_list;
        
    case 'add'
        orig_list   = S.orig_list(:);
        left_list   = S.left_list(:);
        right_list  = S.right_list(:);


        selected_ind    = get(S.h.lbox,'Value');
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
        if(S.exclusive==1)
            left_list(selected_ind) = [];
            if(isempty(left_list))
                left_list   = cell(1);
            end
        end

        [TF,add_ind]         = ismember(add_list,right_list);
        set(S.h.lbox,'String',left_list,'Value',[]);
        set(S.h.rbox,'String',right_list,'Value',add_ind(add_ind~=0));
        S.left_list     = left_list;
        S.right_list    = right_list;
        
    case 'delete'
        orig_list   = S.orig_list(:);
        left_list   = S.left_list(:);
        right_list  = S.right_list(:);


        selected_ind    = get(S.h.rbox,'Value');
        add_list        = right_list(selected_ind);
        if(length(add_list)==1 && isempty(add_list{1}))
            return
        end
        right_list(selected_ind)    = [];
        if(isempty(right_list))
            right_list  = cell(1);
        end
        if(S.exclusive==1)
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
        set(S.h.lbox,'String',left_list,'Value',add_ind(add_ind~=0));
        set(S.h.rbox,'String',right_list,'Value',[]);
        S.left_list     = left_list;
        S.right_list    = right_list;
        
    case 'add_all'
        orig_list   = S.orig_list(:);
        left_list   = S.left_list(:);
        right_list  = S.right_list(:);


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
        if(S.exclusive==1)
            left_list   = cell(1);
        end

        [TF,add_ind]         = ismember(add_list,right_list);
        set(S.h.lbox,'String',left_list,'Value',[]);
        set(S.h.rbox,'String',right_list,'Value',add_ind(add_ind~=0));
        S.left_list     = left_list;
        S.right_list    = right_list;
        
    case 'delete_all'
        orig_list   = S.orig_list(:);
        left_list   = S.left_list(:);
        right_list  = S.right_list(:);

        add_list        = right_list;
        if(length(add_list)==1 && isempty(add_list{1}))
            return
        end
        right_list  = cell(1);

        if(S.exclusive==1)
            if(length(left_list)==1 && isempty(left_list{1}))
                left_list   = orig_list(ismember(orig_list,add_list));
            else
                left_list   = orig_list(ismember(orig_list,[left_list;add_list]));
            end
        else
            left_list   = orig_list;
        end

        [TF,add_ind]         = ismember(add_list,left_list);
        set(S.h.lbox,'String',left_list,'Value',add_ind(add_ind~=0));
        set(S.h.rbox,'String',right_list,'Value',[]);
        S.left_list     = left_list;
        S.right_list    = right_list;
        
    case 'up'
        oldright_list   = S.right_list(:);
        right_list      = oldright_list;
        selected_ind    = get(S.h.rbox,'Value');
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
        
        set(S.h.rbox,'String',right_list,'Value',newselected_ind);
        S.right_list    = right_list;
        
    case 'top'
        oldright_list   = S.right_list(:);
        right_list      = oldright_list;
        selected_ind    = get(S.h.rbox,'Value');
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
        
        set(S.h.rbox,'String',right_list,'Value',newselected_ind);
        S.right_list    = right_list;

    case 'down'
        oldright_list   = S.right_list(:);
        right_list      = oldright_list;
        selected_ind    = get(S.h.rbox,'Value');
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
        
        set(S.h.rbox,'String',right_list,'Value',newselected_ind);
        S.right_list    = right_list;

    case 'bottom'
        oldright_list   = S.right_list(:);
        right_list      = oldright_list;
        selected_ind    = get(S.h.rbox,'Value');
        if((length(right_list)==1 && isempty(right_list{1})) || isempty(selected_ind))
            return
        end
        all_ind     = [1:length(right_list)];
        unselected_ind  = setdiff(all_ind,selected_ind);
        newselected_ind = [length(all_ind)-length(selected_ind)+1:length(all_ind)];
        if(newselected_ind(1)<1)
            return
        end
        newunselected_ind  = setdiff(all_ind,newselected_ind);
        
        right_list(newselected_ind) = oldright_list(selected_ind);
        right_list(newunselected_ind) = oldright_list(unselected_ind);
        
        set(S.h.rbox,'String',right_list,'Value',newselected_ind);
        S.right_list    = right_list;

    case 'ok'
        uiresume;
        
    case 'cancel'
        S.right_list = [];
        uiresume;
end
set(gcf,'UserData',S);



    function S = uiselectfigure
        left_list   = orig_list;
        right_list  = default_answer;
        if(exclusive==1)
            selected_ind    = ismember(left_list,right_list);
            left_list(selected_ind) = [];
            if(isempty(left_list))
                left_list   = cell(1);
            end
        end

        fig =figure('MenuBar','figure',...
            'Name',figtitle,...
            'NumberTitle','off',...
            'PaperUnits', 'centimeters',...
            'PaperOrientation','landscape',...
            'PaperPosition', [0.881189 0.634517 27.9151 19.715],...
            'PaperPositionMode','manual',...
            'Position',[155 188 784 653],...
            'Tag','uiselect',...
            'Toolbar','none');

        h.filtbox     = uicontrol(fig,'BackgroundColor',[1 1 1],...
            'Callback','uiselect2(''filt'')',...
            'HorizontalAlignment','left',...
            'String',[],...
            'Style','Edit',...
            'Units' , 'normalized',...
            'value' , [],...
            'Position' , [0.13 0.93 0.334659 0.03]);

        h.lbox     = uicontrol(fig,'BackgroundColor',[1 1 1],...
            'Max',100,...
            'Min',1,...
            'String',left_list,...
            'Style','listbox',...
            'Units' , 'normalized',...
            'value' , [],...
            'Position' , [0.13 0.11 0.334659 0.815]);

        h.rbox = uicontrol(fig,'BackgroundColor',[1 1 1],...
            'Max',100,...
            'Min',1,...
            'String',right_list,...
            'Style','listbox',...
            'Units' , 'normalized',...
            'value' , [],...
            'Position' , [0.570341 0.11 0.334659 0.815]);

        h.add   = uicontrol(fig,'BackgroundColor',get(fig,'Color'),...
            'Callback','uiselect2(''add'')',...
            'Style','Pushbutton',...
            'Units' , 'normalized',...
            'Position' , [0.49 0.82 0.05 0.05],...
            'String','>');

        h.delete    = uicontrol(fig,'BackgroundColor',get(fig,'Color'),...
            'Callback','uiselect2(''delete'')',...
            'Style','Pushbutton',...
            'Units' , 'normalized',...
            'Position' , [0.49 0.75 0.05 0.05],...
            'String','<');

        h.add_all   = uicontrol(fig,'BackgroundColor',get(fig,'Color'),...
            'Callback','uiselect2(''add_all'')',...
            'Style','Pushbutton',...
            'Units' , 'normalized',...
            'Position' , [0.49 0.68 0.05 0.05],...
            'String','>>');

        h.delete_all    = uicontrol(fig,'BackgroundColor',get(fig,'Color'),...
            'Callback','uiselect2(''delete_all'')',...
            'Style','Pushbutton',...
            'Units' , 'normalized',...
            'Position' , [0.49 0.61 0.05 0.05],...
            'String','<<');

        h.up        = uicontrol(fig,'BackgroundColor',get(fig,'Color'),...
            'Callback','uiselect2(''up'')',...
            'Style','Pushbutton',...
            'Units' , 'normalized',...
            'Position' , [0.49 0.54 0.05 0.05],...
            'String','A');

        h.top       = uicontrol(fig,'BackgroundColor',get(fig,'Color'),...
            'Callback','uiselect2(''top'')',...
            'Style','Pushbutton',...
            'Units' , 'normalized',...
            'Position' , [0.49 0.47 0.05 0.05],...
            'String','AA');

        h.down      = uicontrol(fig,'BackgroundColor',get(fig,'Color'),...
            'Callback','uiselect2(''down'')',...
            'Style','Pushbutton',...
            'Units' , 'normalized',...
            'Position' , [0.49 0.40 0.05 0.05],...
            'String','V');

        h.bottom     = uicontrol(fig,'BackgroundColor',get(fig,'Color'),...
            'Callback','uiselect2(''bottom'')',...
            'Style','Pushbutton',...
            'Units' , 'normalized',...
            'Position' , [0.49 0.33 0.05 0.05],...
            'String','VV');

        h.ok        = uicontrol(fig,'BackgroundColor',get(fig,'Color'),...
            'Callback','uiselect2(''ok'')',...
            'Style','Pushbutton',...
            'Units' , 'normalized',...
            'Position' , [0.60 0.02 0.12 0.05],...
            'String','OK');

        h.cancel    = uicontrol(fig,'BackgroundColor',get(fig,'Color'),...
            'Callback','uiselect2(''cancel'')',...
            'Style','Pushbutton',...
            'Units' , 'normalized',...
            'Position' , [0.75 0.02 0.12 0.05],...
            'String','Cancel');

        S.fig           = fig;
        S.h             = h;
        S.orig_list     = orig_list;
        S.left_list     = left_list;
        S.right_list    = right_list;
        S.exclusive     = exclusive;


    end
end