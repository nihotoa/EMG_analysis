function hL = tdsplot(ax, x, y, varargin)
%hL = tdsplot(ax, x, y, numPoints,varargin)
%DSPLOT Create down sampled plot.
%   This function creates a down sampled plot to improve the speed of
%   exploration (zoom, pan).
%
%   DSPLOT(X, Y) plots Y versus X by downsampling if there are large number
%   of elements. X and Y needs to obey the following:
%     1. X must be a monotonically increasing vector.
%     2. If Y is a vector, it must be the same size as X.
%     3. If Y is a matrix, one of the dimensions must line up with X.
%
%   DSPLOT(Y) plots the columns of Y versus their index.
%
%   hLine = DSPLOT(X, Y) returns the handles of the line. Note that the
%   lines may be downsampled, so they may not represent the full data set.
%
%   DSPLOT(X, Y, NUMPOINTS) or DSPLOT(Y, [], NUMPOINTS) specifies the
%   number of points (roughly) to display on the screen. The default is
%   50000 points (~390 kB doubles). NUMPOINTS can be a number greater than
%   500.
%
%   It is very likely that more points will be displayed than specified by
%   NUMPOINTS, because it will try to plot any outlier points in the range.
%   If the signal is stochastic or has a lot of sharp changes, there will
%   be more points on plotted on the screen.
%
%   The figure title (name) will indicate whether the plot shown is
%   downsampled or is the true representation.
%
%   The figure can be saved as a .fig file, which will include the actual
%   data. The figure can be reloaded and the actual data can be exported to
%   the base workspace via a menu.
%
%   Run the following examples and zoom/pan to see the performance.
%
%  Example 1: (with small details)
%   x  = linspace(0, 2*pi, 1000000);
%   y1 = sin(x)+.02*cos(200*x)+0.001*sin(2000*x)+0.0001*cos(20000*x);
%   dsplot(x,y1);title('Down Sampled');
%   % compare with
%   figure;plot(x,y1);title('Normal Plot');
%
%  Example 2: (with outlier points)
%   x  = linspace(0, 2*pi, 1000000);
%   y1 = sin(x) + .01*cos(200*x) + 0.001*sin(2000*x);
%   y2 = sin(x) + 0.3*cos(3*x)   + 0.001*randn(size(x));
%   y1([300000, 700000, 700001, 900000]) = [0, 1, -2, 0.5];
%   y2(300000:500000) = y2(300000:500000) + 1;
%   y2(500001:600000) = y2(500001:600000) - 1;
%   y2(800000) = 0;
%   dsplot(x, [y1;y2]);title('Down Sampled');
%   % compare with
%   figure;plot(x, [y1;y2]);title('Normal Plot');
%
%  See also PLOT.

%  Version:
%   v1.0 - first version (Aug 1, 2007)
%   v1.1 - added CreateFcn for the figure so that when the figure is saved
%          and re-loaded, the zooming and panning works. Also added a menu
%          item for saving out the original data back to the base
%          workspace. (Aug 10, 2007)
%
%  Jiro Doke
%  August 1, 2007



%--------------------------------------------------------------------------
numPoints   = 10000;

if size(x, 2) > 1  % it's a row vector -> transpose
    x = x';
    y = y';
end

% Number of lines
numSignals = size(y, 2);

% Attempt to find outliers. Use a running average technique
filterWidth = ceil(min([50, length(x)/10])); % max window size of 50
a  = double(y) - filter(ones(filterWidth,1)/filterWidth, 1, double(y));
[iOutliers, jOutliers] = find(abs(a - repmat(mean(a), size(a, 1), 1)) > ...
    repmat(4 * std(a), size(a, 1), 1));
clear a;

% Always create new figure because it messes around with zoom, pan, datacursors.
hFig    = gcf;
% figName = '';

% Create template plot using NaNs
if(isempty(varargin))
    hLine   = plot(ax,NaN(2, numSignals), NaN(2, numSignals));
else
    hLine   = plot(ax,NaN(2, numSignals), NaN(2, numSignals),varargin{:});
end
h   =title(ax,'');
assignin('base','h',h);


% Set Axis UserData
UD.hLine    = hLine;
UD.x        = x;
UD.y        = y;
UD.numPoints    = numPoints;
UD.numSignals   = numSignals;
UD.iOutliers    = iOutliers;
UD.jOutliers    = jOutliers;
setappdata(ax,'tdsplot',UD);


% Define CreateFcn for the figure
set(zoom(hFig), 'ActionPostCallback', @mypostcallback);
set(pan(hFig) , 'ActionPostCallback', @mypostcallback);

% Update lines
updateLines(ax,[]);


% Deal with output argument
if nargout == 1
    hL = hLine;
end



%--------------------------------------------------------------------------
    function mypostcallback(obj,evd) %#ok

        % This callback that gets called when the mouse is released after zooming or panning.
        axs  = get(hFig,'Children');
        axsind   = false(1,length(axs));
        for iax =1:length(axs)
            if(isappdata(axs(iax),'tdsplot'))
                axsind(iax)   = true;
            end
        end
        axs = axs(axsind);      % axs containing appdata 'tdsplot'.

        for iax = 1:length(axs)
%             updateLines(axs(iax));
%             disp(get(hFig, 'SelectionType'))
             switch get(hFig, 'SelectionType')
                    case {'normal', 'alt'}
                        
                        updateLines(axs(iax),xlim(axs(iax)));
                    case 'open'
                        updateLines(axs(iax),[]);
             end
        end


    end
end


function updateLines(ax,rng)
% This helper function is for determining the points to plot on the
% screen based on which portion is visible in the current limits.
debug_mode  = false;

% rng         = xlim(ax);
UD          = getappdata(ax,'tdsplot');
    if(isempty(rng))
        rng     = [min(UD.x) max(UD.x)];
    end

% find indeces inside the range
id = find(UD.x >= rng(1) & UD.x <= rng(2));

% if there are more points than we want
if length(id) > UD.numPoints / UD.numSignals

    % see how many outlier points are in this range
    blah = UD.iOutliers > id(1) & UD.iOutliers < id(end);

    % determine indeces of points to plot.
    idid = round(linspace(id(1), id(end), round(UD.numPoints/UD.numSignals)))';

    x2 = cell(UD.numSignals, 1);
    y2 = x2;
    for iSignals = 1:UD.numSignals
        % add outlier points
        ididid = unique([idid; UD.iOutliers(blah & UD.jOutliers == iSignals)]);
        x2{iSignals} = UD.x(ididid);
        y2{iSignals} = UD.y(ididid, iSignals);
    end

    downsample_flag = true;


else % no need to down sample
    downsample_flag = false;

    x2 = repmat({UD.x(id)}, UD.numSignals, 1);
    y2 = mat2cell(UD.y(id, :), length(id), ones(1, UD.numSignals))';

end

set(UD.hLine, {'xdata', 'ydata'} , [x2, y2]);

if(downsample_flag)
    set(get(ax,'Title'),'FontAngle','italic');
else
    set(get(ax,'Title'),'FontAngle','normal');
end

if(debug_mode)
    for ii=1:length(UD.hLine)
        if(downsample_flag)
            disp([num2str(UD.hLine(ii)),' downsampled --',num2str(rng)])   % % % % %
        else
            disp([num2str(UD.hLine(ii)),' true --',num2str(rng)])   % % % % %
        end
    end
%     a=lasterror;
%     disp(a.message)
end

end
