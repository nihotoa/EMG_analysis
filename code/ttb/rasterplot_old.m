function hh = rasterplot(varargin)
% (hh = )rasterplot(s,sdata)      s: psth file created by psth.m
% (hh = )rasterplot(AX,s,sdata)
% (hh = )rasterplot(s,sdata,'PropName','PropValue1',...)
% (hh = )rasterplot(AX,s,sdata,'PropName','PropValue1',...)

if nargin < 3
    s   = varargin{1};
    sdata   = varargin{2};
    h   = gca;
    varargin    = [];
elseif nargin < 4
    if isstruct(varargin{1})
        s   = varargin{1};
        sdata   = varargin{2};
        h   = gca;
        varargin    = varargin(2:end);
    elseif isstruct(varargin{2})
        s   = varargin{2};
        sdata   = varargin{3};
        h   = varargin{1};
        varargin    = [];
    end
else
    if isstruct(varargin{1})
        s   = varargin{1};
        sdata   = varargin{2};
        h   = gca;
        varargin    = varargin(3:end);
    elseif isstruct(varargin{2})
        s   = varargin{2};
        sdata   = varargin{3};
        h   = varargin{1};
        varargin    = varargin(4:end);
    end
end


if(~strcmp(s.AnalysisType,'PSTH'))
    error('入力したのはPSTHファイルじゃないです。')
end

if(any(size(s.TrialData)==0))
    error('TrialDataが足りません')
end

[ntrial,ntime]     = size(sdata.TrialData);

x  = repmat(s.XData,ntrial,1);
y  = repmat([1:ntrial]',1,ntime);

% keyboard
if(iscell(varargin))

    H  = plot(h,repmat(x(sdata.TrialData),1,2)',[y(sdata.TrialData)-0.49,y(sdata.TrialData)+0.49]',varargin{:});
else
    H  = plot(h,repmat(x(sdata.TrialData),1,2)',[y(sdata.TrialData)-0.49,y(sdata.TrialData)+0.49]');
end
% keyboard
set(h,'TickDir','Out',...
    'XLim',[s.TimeRange(1) s.TimeRange(2)],...
    'YDir','reverse',...
    'YLim',[0.5 ntrial+0.5]);

if nargout>0
    hh = H;
end