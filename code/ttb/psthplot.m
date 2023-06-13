function hh = psthplot(varargin)
% (hh = )psthplot(s)          s:  psth file created by psth.m
% (hh = )plot(s,bw)       bw: Binwidth in sec
% (hh = )psthplot(AX,s)
% (hh = )psthplot(s,'PropName','PropValue1',...)
% (hh = )psthplot(AX,s,'PropName','PropValue1',...)

if nargin < 2
    s   = varargin{1};
    h   = gca;
    varargin    = [];
elseif nargin < 3
    if isstruct(varargin{1})
        s   = varargin{1};
        h   = gca;
        varargin    = varargin(2:end);
    elseif isstruct(varargin{2})
        s   = varargin{2};
        h   = varargin{1};
        varargin    = [];
    end
else
    if isstruct(varargin{1})
        s   = varargin{1};
        h   = gca;
        varargin    = varargin(2:end);
    elseif isstruct(varargin{2})
        s   = varargin{2};
        h   = varargin{1};
        varargin    = varargin(3:end);
    end
end


if(~strcmp(s.AnalysisType,'PSTH'))
    error('入力したのはPSTHファイルじゃないです。')
end

narg    = length(varargin);
YUnit   = 'totalcounts';
for iarg=1:narg
    if(ischar(varargin{iarg}))
        if(strmatch(lower(varargin{iarg}),'yunit'))
            YUnit   = varargin{iarg+1};
            varargin(iarg:iarg+1)    = [];
            break;
        end
    end
end
switch lower(YUnit)
    case 'total counts'
        YData   = s.YData;
    case 'counts/trial'
        YData   = s.YData ./ s.nTrials;
    case 'frequency'
        YData   = s.YData ./ s.nTrials ./ s.BinWidth;
end

if(iscell(varargin))
    H  = bar(h,s.BinData,YData,varargin{:},'BarWidth',1);
else
    H  = bar(h,s.BinData,YData,'BarWidth',1);
end
set(h,'box','off',...
    'TickDir','Out',...
    'XLim',[s.TimeRange(1) s.TimeRange(2)]);

if nargout>0
    hh = H;
end