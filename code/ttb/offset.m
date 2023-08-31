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
        k   = min(x,[],2); %X�̊e�s(�e�ؓd)�̍Œ�l��k�ɑ������
        y   = x - repmat(k,1,n); %�ؓd�̒l����Œ�l������
    
end

end

