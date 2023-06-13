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

H   = zeros(ntrial,1);
% hold(h,'off');

for itrial=1:ntrial
    nData   = sum(sdata.TrialData(itrial,:));
    x       = s.XData(sdata.TrialData(itrial,:));
    y       = ones(1,nData)*itrial;
        
    x       = reshape([x;x;nan(1,nData)],1,nData*3);
    y       = reshape([y-0.49;y+0.49;nan(1,nData)],1,nData*3);
    
    if(iscell(varargin))
        H(itrial)   = plot(h,x,y,varargin{:});
    else
        H(itrial)   = plot(h,x,y);
    end
    if(itrial==1)
        hold(h,'on');
    end
end

set(h,'TickDir','Out',...
    'XLim',[s.TimeRange(1) s.TimeRange(2)],...
    'YDir','reverse',...
    'YLim',[0.5 ntrial+0.5]);

if nargout>0
    hh = H;
end