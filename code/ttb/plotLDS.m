%
% varargout = plotLDS([n_point], varargin)
%
% IMPORTANT NOTE
% ==============
%
% This function will only work in MATLAB 7.3 or higher !!!
%
% DESCRIPTION
% ===========
% Function for plotting large data sets (e.g. time-series with more than 1e6 data points).
% The main benefit of this function can be seen in the fact that zooming and paning will work much smoother,
% since the data is automatically downsampled. This functionality is preserved when saving and reloading a figure.
%
% USAGE
% =====
% The usage is identical to the regular plot-command for vectors (x, y) with the following syntax supported:
%       
%       plotLDS(y)
%       plotLDS(x,y)
%       plotLDS(x,y,LineSpec)
%       plotLDS(..., PropName1, PropValue1, ..., PropNameN, PropValueN)
%       plotLDS(axis_handle, ...)
%
% Additionally one may specify the number of points (n_points) to be plotted as optional, first argument:
%
%       plotLDS(1e5, ...)    % Specify "n_points" as 1e5.
%
%
% HINTS & LIMITATIONS
% ===================
%
% "DeleteFcn" & "CreateFcn" are reserved for this function and should not be used otherwise for the created line.
%
% The "ActionPostCallback" (=> zoom & pan) is also used, but may also be used by the user ...
% it simply needs to be specified before the call to "plotLDS", e.g.:
% figure; h = zoom; set(h,'ActionPostCallback','disp(''hallo'')'); plotLDS(rand(1e6,1)); % Now try zooming
%
% Downsampling is simply performed by plotting only every n-th data point. Therefore, aliasing may occur !!!
%
% Data is clipped outside current axis, but is updated to the current limits after panning / zooming is finished.
%
% Using double-clicking in "zoom-in" modus might not work as expected, because the dispayed data-set
% is clipped. It is possible to return to the original data-set by using the scroll-wheel or the "zoom-out" tool.
%
% The x- & y-data is stored as application-data to the line-handle.
%
% Saved fig-files can get big, because the complete data is stored together with the decimated plot.
%
% The true x- and y-data for the line with handle "h", use ...
%   LDS = getappdata(h,'LDS_data'); x = LDS.x; y = LDS.y;
%
% EXAMPLES - Create data first, then use zoom & pan. Compare to regular plot-command !!!
% ======================================================================================
%
% y1 = rand(1,1e6); y2 = linspace(1,1e6,1e6); phi = linspace(0,2*pi,1e6);
%
% plotLDS(y1); figure; plotLDS(y2)                      % Example 1
%
% plotLDS(sin(1e4*y2))                                  % Example 2
%
% plotLDS(sin(phi),cos(phi),'.')                        % Example 3
%
% ax(1)=subplot(2,1,1); plotLDS(y1)                     % Example 4
% ax(2)=subplot(2,1,2); plotLDS(y2)
% linkaxes(ax,'x')
%
% plotLDS(y1); ax(1)=gca;                                % Example 5
% figure; plotLDS(y2); ax(2)=gca; 
% linkaxes(ax,'x') 
%
% plotLDS(y1,phi,'x_link','y1','y_link','phi')          % Example 6
%
% Example 6 demonstrates how to link data to the workspace. 
% This GREATLY reduces the memory need, but will only work for variables or strucure-fields from the base-workspace!!!
%

% AUTHOR
% ======
% Sebastian Hölz (shoelz "_AT_" ifm-geomar "_dot_" de)
%
% TODO & BUGS
% ===========
%
% There is still a memory issue preventing the linking of data to the workspace. Try the following:
%   y = rand(1e7,1); plotLDS(y,'y_link','y'); y(1) = 10;
% Changing the variable in the base-workspace will cause MATLAB to create a new (unwanted) copy of "y".
%
%
% VERSION
% =======
% 2.0   07.05.2008      Major rewrite
%                       Data can now be linked directly to the workspace. This is should be an enhancment
%                       concerning memory consumption, since data is not copied into LDSdata (but see bug ...).
%                       The according syntax is something like: "plotLDS(y,'ydatasource','y')"
%
% 1.3   29.04.2008      Major rewrite, after several bugs were noticed. 
%                       Handles are now stored differently and saving & reloading a figure with LDS_data now works.
%
% 1.2.1 11.03.2008      Removed bug for x = const. or y = const.
%                       Original zoom- & pan-ActionPostCallbacks are stored and evaluated after the LDS-ActionPostCallback.
%
% 1.2   25.02.2008      If x- or y-data are equal-spaced, they are only stored as [min dxy max] to save memory.
%                       Optional input "n_point": is kept as individual parameter for each line.
%
% 1.1   22.02.2008      Fixed bug for call, which creates several lines, e.g.: plotLDS(rand(1e6,2)).
%                       Will now work for monotonically increasing y-values and unstructured data as well.
%                       Will now work after saving and reloading a figure.
%
% 1.0   20.02.2008      First release
%

function varargout = plotLDS(varargin)
    
    % Check if n_points has been specified as first argument
    if isscalar(varargin{1}) && ~ishandle(varargin{1}) && round(varargin(1)==varargin{1}) && length(varargin)>1
        n_points = round(varargin{1});
        varargin(1) = [];
    else
        n_points = 1e4;
    end
    
    % Check for PropertyValuePairs
    PropValPairs = {};
    for i_Prop = 1:length(varargin)
        if ischar(varargin{i_Prop}) && any(strcmpi(varargin{i_Prop}, ...
                {'DisplayName' 'Annotation' 'Color' 'EraseMode' 'LineStyle' 'LineWidth' 'Marker' 'MarkerSize' ...
                'MarkerEdgeColor' 'MarkerFaceColor' 'XData' 'YData' 'ZData' 'BeingDeleted' 'ButtonDownFcn'    ...
                'Children' 'Clipping' 'CreateFcn' 'DeleteFcn' 'BusyAction' 'HandleVisibility' 'HitTest'       ...
                'Interruptible' 'Selected' 'SelectionHighlight'  'Tag' 'Type' 'UIContextMenu' 'UserData'      ...
                'Visible' 'Parent' 'XDataMode' 'XDataSource' 'YDataSource' 'ZDataSource' ...
                'x_link' 'y_link'}))
            
            PropValPairs = varargin(i_Prop:end);
            varargin = varargin(1:i_Prop-1);
            break
        end
    end
    
    % Check if axis-handle has been specified as first or second argument
    if isscalar(varargin{1}) && ishandle(varargin{1}) && strcmp(get(varargin{1},'type'),'axes')
        PropValPairs(end+1:end+2) = {'parent', varargin{1}};
        varargin(1) = [];
    end    
    
    % Check which type of plot-command was used and determine if data is linked to base workspace
   	if length(varargin)==3; 
        x = varargin{1}; y = varargin{2}; LineSpec = varargin{3}; x_arg = 1; y_arg = 2;
    elseif length(varargin)==2 && ischar(varargin{2})
        x = [1 1 length(varargin{1})]; y = varargin{1}; LineSpec = varargin{2}; x_arg = 0; y_arg = 1;
    elseif length(varargin)==2 && isnumeric(varargin{2})
        x = varargin{1}; y = varargin{2}; LineSpec = ''; x_arg = 1; y_arg = 2;
    elseif length(varargin) == 1
        x = [1 1 length(varargin{1})]; y = varargin{1}; LineSpec = ''; x_arg = 0; y_arg = 1;
    end
    
    ind=find(strcmpi(PropValPairs,'XDataSource')); 
    if x_arg && ~isempty(ind); x_link = PropValPairs{ind+1}; PropValPairs(ind:ind+1) = []; else x_link = ''; end
    ind=find(strcmpi(PropValPairs,'YDataSource')); 
    if y_arg && ~isempty(ind); y_link = PropValPairs{ind+1}; PropValPairs(ind:ind+1) = []; else y_link = ''; end
    
    n_abs = length(y);
    
    % Plot dummy-line, the rest will be handled in the nested-functions after the creation of the line
	h = plot([min(x) min(x) max(x) max(x)],[min(y) max(y) min(y) max(y)], ...
        LineSpec,PropValPairs{:},'CreateFcn',@LDS_AddHandle);

    if nargout==1; varargout{1} = h; end

    % ===================================
    function PostZoomPanCallback(varargin)

        LDS_global = getappdata(0,'LDS_global');
        for i_fig = 1:length(LDS_global)
            
            h_fig = LDS_global(i_fig);
            LDS_fig = getappdata(LDS_global(i_fig),'LDS_fig');
            
            for i_ax = 1:length(LDS_fig.h_ax)
                
                h_ax = LDS_fig.h_ax(i_ax);
                LDS_ax = getappdata(h_ax,'LDS_ax');
                
                % Check if current axis was changed
                if all(LDS_ax.xlim==xlim(h_ax)) && all(LDS_ax.ylim==ylim(h_ax))
                    continue
                else
                    XLIM = xlim(h_ax); YLIM = ylim(h_ax); 
                    LDS_ax.xlim = XLIM;
                    LDS_ax.ylim = YLIM;
                end

                % Update lines
                for i_line = 1:length(LDS_ax.h_line)
                    
                    h_line = LDS_ax.h_line(i_line);
                    l_dat = getappdata(h_line, 'LDS_data');

                    if l_dat.x_link; x = evalin('base',l_dat.x_link); else x = l_dat.x; end
                    if l_dat.y_link; y = evalin('base',l_dat.y_link); else y = l_dat.y; end
                    
                    % Determine indices
                    if l_dat.x_monotone || l_dat.y_monotone % This is a time-series-like or depth-plot-like plot
                        if l_dat.x_monotone
                            if l_dat.x_equal
                                ind1 = max([floor((XLIM(1)-diff(XLIM)-x(1))/x(2)) 1]);
                                ind2 = min([ceil((XLIM(2)+diff(XLIM)-x(1))/x(2))  l_dat.n_abs]);
                            else
                                ind1 = find(x>XLIM(1)-diff(XLIM), 1, 'first');
                                ind2 = find(x<XLIM(2)+diff(XLIM), 1, 'last');
                            end
                        else
                            if l_dat.y_equal
                                ind1 = max([floor((YLIM(1)-diff(YLIM)-y(1))/y(2)) 1]);
                                ind2 = min([ceil((YLIM(2)+diff(YLIM)-y(1))/y(2))  l_dat.n_abs]);
                            else
                                ind1 = find(y>YLIM(1)-diff(YLIM), 1, 'first');
                                ind2 = find(y<YLIM(2)+diff(YLIM), 1, 'last');
                            end
                        end

                        if isempty(ind1); ind1 = 1; end
                        if isempty(ind2); ind2 = l_dat.n_abs; end

                        n = ind2-ind1+1;
                        d_ind = ceil(n/l_dat.n_points);
                        ind = ind1:d_ind:ind2;
                        if ind(end)<ind2; ind(end+1)=ind2; end      %#ok

                    else % this is the unstructured case ...
                        ind_tmp = find( ...
                            (x>XLIM(1)-diff(XLIM)) & (x<XLIM(2)+diff(XLIM)) & ...
                            (y>YLIM(1)-diff(YLIM)) & (y<YLIM(2)+diff(YLIM)));

                        n = length(ind_tmp);
                        d_ind = ceil(n/l_dat.n_points);
                        ind = ind_tmp(1:d_ind:n);
                    end

                    if ishandle(l_dat.h);
                        if length(x)==3; x = ind*x(2); else x = x(ind)*1; end
                        if length(y)==3; y = ind*y(2); else y = y(ind)*1; end
                        set(l_dat.h,'xdata',x,'ydata',y); 
                    end

                end
                
                setappdata(h_ax, 'LDS_ax', LDS_ax)
            end
            
            % Call original pan- / and zomm-callbacks
            if nargin>0
                try eval(LDS_fig.pan_ActionPostCallback); end
                try eval(LDS_fig.zoom_ActionPostCallback); end
            end
        end
    end


    % ==============================
    function LDS_AddHandle(h_line, varargin)

        % Get handles of axis and figure, which contain h_line
        h_ax = get(h_line,'parent');
        while ~strcmp(get(h_ax,'type'),'axes'); h_ax = get(h_ax,'Parent'); end % Make sure that parent of h_line is not a hgtransorm or hggroup
        h_fig = get(h_ax,'parent');
        
        % Prepare LDS_global, LDS_fig, LDS_ax, LDS_line
        % LDS_global:   handles of figures containing lines with LDSdata;       stored in root
        % LDS_fig:      current callbacks & handles of axes containing LDSdata; stored in figure
        % LDS_ax:       current limits and handles of lines containing LDSdata; stored in axis
        % LDSdata:      information needed for LDSplot
        try LDS_global = getappdata(0,'LDS_global');    catch LDS_global = []; end
        try LDS_fig    = getappdata(h_fig,'LDS_fig');   catch LDS_fig = []; end
        try LDS_ax     = getappdata(h_ax,'LDS_ax');     catch LDS_ax = []; end
        try LDS_line   = getappdata(h_line,'LDS_line'); catch LDS_line = []; end
        
        % LDS_global & LDS_fig
        if isempty(find(h_fig == LDS_global, 1))
            LDS_global(end+1) = h_fig;
            
            % We need to add zoom- & pan-callbacks, this also tests, if a valid Matlab-Version is used
            try
                LDS_fig.zoom_ActionPostCallback = get(zoom,'ActionPostCallback');
                set(zoom,'ActionPostCallback', @PostZoomPanCallback);

                LDS_fig.pan_ActionPostCallback = get(pan,'ActionPostCallback');
                set(pan,'ActionPostCallback', @PostZoomPanCallback);
                
                LDS_fig.h_ax = [];

            catch
                error('PlotLDS:OldMatlabVersion', '\n\t%s\n\t%s\n', ...
                    'Sorry, your version of Matlab does not support the required zoom-features.', ...
                    'Matlab 7.3 or higher is required to use this function.')
            end
        end

        if isempty(find(h_ax==[LDS_fig.h_ax], 1))
            LDS_fig.h_ax(end+1)	= h_ax;
        end

        % LDS_ax
        if isempty(LDS_ax)
            % Set limits to zero. Otherwise line will not be updated in call to ZoomPanFcn
            LDS_ax.xlim   = [0 0];   
            LDS_ax.ylim   = [0 0];
            
            LDS_ax.h_line = [];
        end

        if isempty(find(h_line==[LDS_ax.h_line], 1))
            LDS_ax.h_line(end+1) = h_line;
        end
               
        % LDS_data
        db = dbstack;
        if strcmp(db(2).name,'plotLDS') % Upon loading of a figure containing LDSdata, this part will be skipped
            
            if x_link
                x = []; x_equal = 0; x_monotone = 0;
            elseif ~x_arg
                x = [1 1 n_abs]; x_equal = 1; x_monotone = 1;
            else
                % Check x-properties
                dx1 = x(2)-x(1);        x_equal    = 1;
                sign_dx1 = sign(dx1);   x_monotone = 1;
                for j = 3:length(x)
                    dx_j = x(j)-x(j-1);
                    if x_equal && dx_j ~= dx1
                        x_equal = 0; 
                    end
                    if x_monotone && sign(dx_j) ~= sign_dx1
                        x_monotone = 0;
                    end
                    if ~(x_equal || x_monotone); break; end
                end
                if x_monotone; x = [x(1) dx1 x(end)]; end
            end
                        
            if y_link
                y = []; y_equal = 0; y_monotone = 0;
            else
                % Check y-properties
                dy1 = y(2)-y(1);        y_equal    = 1;
                sign_dy1 = sign(dy1);   y_monotone = 1;
                for j = 3:length(y)
                    dy_j = y(j)-y(j-1);
                    if y_equal && dy_j ~= dy1
                        y_equal = 0; 
                    end
                    if y_monotone && sign(dy_j) ~= sign_dy1
                        y_monotone = 0;
                    end
                    if ~(y_equal || y_monotone); break; end
                end
                if y_monotone; y = [y(1) dy1 y(end)]; end
            end
                        
            unstructured = ~(x_monotone || y_monotone);

            LDS_data = ...
                struct('h',h_line,'n_points',n_points, 'n_abs', n_abs, ...
                'x',x,'x_equal',x_equal,'x_monotone',x_monotone,'x_link',x_link, ...
                'y',y,'y_equal',y_equal,'y_monotone',y_monotone,'y_link',y_link);
            
            setappdata(h_line,'LDS_data',LDS_data)
        end
        
        % Set application data
        setappdata(0,'LDS_global',LDS_global)
        setappdata(h_fig,'LDS_fig',LDS_fig)
        setappdata(h_ax,'LDS_ax',LDS_ax)

        set([h_fig h_ax h_line],'DeleteFcn',@LDS_DeleteHandle);
        PostZoomPanCallback
    end

    % ==============================
    function LDS_DeleteHandle(varargin)
        
        h = varargin{1};
        switch get(varargin{1},'type')
            case 'figure'
                LDS_global = getappdata(0,'LDS_global');
                LDS_global(LDS_global==h) = [];
                setappdata(0,'LDS_global',LDS_global)
                
            case 'axes'
                h_fig = get(h,'parent');
                LDS_fig = getappdata(h_fig,'LDS_fig');
                LDS_fig.h_ax(LDS_fig.h_ax==h) = [];
                setappdata(h_fig,'LDS_fig',LDS_fig)
                
            case 'line'
                h_ax = get(h,'parent');
                LDS_ax = getappdata(h_ax,'LDS_ax');
                LDS_ax.h_line(LDS_ax.h_line==h) = [];
                setappdata(h_ax,'LDS_ax',LDS_ax)
                
            otherwise
                disp(get(varargin{1},'type'))
        end
    end
end

