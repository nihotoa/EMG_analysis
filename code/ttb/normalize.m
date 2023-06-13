function y  = normalize(x,type,varargin)
% y  = normalize(x,type,options)
% 
% input x must be row data
% type = {'sd'}, 'max', 'sum','rms'
% options:  'centering'
%           'percentage'


if nargin<2
    type    = 'sd';
    options = {''};
else
    options = varargin;
end

n   = size(x,2); %データのサンプル数(tの方)

if(ismember('centering',options))
    x   = detrend(x','constant')';
end

switch lower(type)
    case 'max'
        k   = max(x,[],2);
        y   = x ./ repmat(k,1,n);
    case 'sum'
        k   = sum(x,2);
        y   = x ./ repmat(k,1,n);
    case 'mean'
        k   = mean(x,2);
        y   = x ./ repmat(k,1,n);
    case 'sd'
        k   = std(x,[],2);
        y   = x ./ repmat(k,1,n);
    case 'rms'
        k   = rms(x,2,0);
        y   = x ./ repmat(k,1,n);
end

if(ismember('percentage',options))
    y   = y * 100;
end
end

