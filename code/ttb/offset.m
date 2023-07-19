function y  = offset(x,type,varargin)
% y  = offset(x,type,options)
% 
% input x must be row data
% type = {'mean'}, 'min', 'max'
% options:  

if nargin<2
    type    = 'mean';
    options = {''};
else
    options = varargin;
end

[m,n]   = size(x);

switch lower(type)
    case 'mean'
        k   = nanmean(x,2);
        y   = x - repmat(k,1,n);
    case 'min'
        k   = min(x,[],2); %Xの各行(各筋電)の最低値をkに代入する
        y   = x - repmat(k,1,n); %筋電の値から最低値を引く
    
end

end

