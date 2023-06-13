function varargout  =areaedged(H,x,y,varargin)
% NaN‚Ì’l‚ğLEVEL(default=0)‚Æ‚µA‚½‚¾‚»‚Ì—§‚¿ã‚ª‚è‚Í‹}s‚Éƒvƒƒbƒg‚µ‚Ü‚·B
if (nargin > 3) && isnumeric(varargin{1})
    LEVEL   = varargin{1};
    if length(varargin) > 1
        varargin    = varargin(2:end);
    else
        varargin    = [];
    end
else
    LEVEL   = 0;
end

% NaN‚Æ‚Ì‹«ŠE‚Éƒf[ƒ^‚ğ‘}“ü‚·‚é
if(~isnan(y(1)))
    X(1)    = x(1);
    Y(1)    = LEVEL;
    X(2)    = x(1);
    Y(2)    = y(1);
    eod     = 2;
else
    X(1)    = x(1);
    Y(1)    = LEVEL;
    eod     = 1;
end


for ii=2:length(y)
    if(isnan(y(ii-1)) && ~isnan(y(ii)))
        X(eod+1)    = x(ii);
        X(eod+2)    = x(ii);
        Y(eod+1)    = LEVEL;
        Y(eod+2)    = y(ii);
        eod = eod + 2;
    elseif(~isnan(y(ii-1)) && isnan(y(ii)))
        X(eod+1)    = x(ii-1);
        X(eod+2)    = x(ii);
        Y(eod+1)    = LEVEL;
        Y(eod+2)    = LEVEL;
        eod = eod + 2;
    elseif(~isnan(y(ii-1)) && ~isnan(y(ii)))
        X(eod+1)    = x(ii);
        Y(eod+1)    = y(ii);
        eod = eod + 1;
    elseif(isnan(y(ii-1)) && isnan(y(ii)))
        X(eod+1)    = x(ii);
        Y(eod+1)    = LEVEL;
        eod = eod + 1;
    end
end

if(Y(end) ~= LEVEL)
    X(end+1)    = X(end);
    Y(end+1)    = LEVEL;
end
   

% keyboard
% disp(LEVEL)
if isempty(varargin)
    h  = area(H,X,Y,LEVEL);
else
    h  = area(H,X,Y,LEVEL,varargin{:});
end

if nargout > 0
    varargout{1}   = h;
    
end

