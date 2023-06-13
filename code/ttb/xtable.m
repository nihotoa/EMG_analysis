function [y,label1,label2]  = xtable(x,label1,label2)
% x: 変数１、２のインデックス（scalar or char）が各コラムに並ぶ行列

if(size(x,2)~=2)
    error('input x must be 2 colums');
end
    

% if(~iscell(x))
%     if(isnumeric(x))
%         x   = num2cell(x);
%     elseif(ischar(x));
%         x   = {x};
%     end
% end

% nx  = size(x,1);

if(~exist('label1','var'))
    label1  = sortxls(unique(x(:,1)));
end

if(~exist('label2','var'))
    label2  = sortxls(unique(x(:,2)));
end

n1  = length(label1);
n2  = length(label2);

y   = zeros(n1,n2);

if(iscell(x))
    for ii1  = 1:n1
        for ii2 = 1:n2
            y(ii1,ii2)  = sum(strcmp(x(:,1),label1{ii1}) & strcmp(x(:,2),label2{ii2}));
        end
    end
else
    for ii1  = 1:n1
        for ii2 = 1:n2
            y(ii1,ii2)  = sum(x(:,1)==label1(ii1) &x(:,2)==label2(ii2));
        end
    end
end
