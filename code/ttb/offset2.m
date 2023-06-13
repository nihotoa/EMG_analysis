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
        k   = mean(x,2);
        y   = x - repmat(k,1,n);
    case 'min'
        [row,col] = size(x);
        y = zeros(row,col); %�o�͌���(x��offset�������{��������)
        k   = min(x,[],2); %X�̊e�s(�e�ؓd)�̍Œ�l��k�ɑ������
        muscle_num = length(k);
        %���ŏ��l���O�ȏォ�ǂ����𔻒f
        judge_factor = find(k(k>0));
        for ii = 1:muscle_num
            judge_id = intersect(judge_factor,ii);
            if isempty(judge_id) %�ŏ��l��0��菬����
                y(ii,:) = x(ii,:) - repmat(k(ii),1,length(x));
            else %�ŏ��l��0���傫���Ƃ�
                y(ii,:) = x(ii,:);
            end
        end
end

end

