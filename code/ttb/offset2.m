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
        y = zeros(row,col); %出力結果(xにoffset処理を施したもの)
        k   = min(x,[],2); %Xの各行(各筋電)の最低値をkに代入する
        muscle_num = length(k);
        %↓最小値が０以上かどうかを判断
        judge_factor = find(k(k>0));
        for ii = 1:muscle_num
            judge_id = intersect(judge_factor,ii);
            if isempty(judge_id) %最小値が0より小さい
                y(ii,:) = x(ii,:) - repmat(k(ii),1,length(x));
            else %最小値が0より大きいとき
                y(ii,:) = x(ii,:);
            end
        end
end

end

