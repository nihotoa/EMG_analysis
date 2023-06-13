function y  = xlscell2mat(x)
% excelからコピーしてx = clipboard('paste')で得られた文字列から配列を復元し、セル配列にする



% function y  = str2cell(x)

if(any(double(x)==32))
    Y   = str2num(x);
else
    Y   =[];
end

if(isempty(Y))
    nrow    = size(strread(x,'%s','delimiter','\n'),1);
    x  = strread(x,'%s','delimiter','\t');
    y  = reshape(x,numel(x)/nrow,nrow)';
else
    y  = num2cell(Y);
end


% 
% 
% if(isempty(x))
%     y   = [];
%     return;
% end
% 
% X   = double(x);
% 
% row = sum(X==10);
% col = sum(X==9) / row +1;
% X   = [9,X];
% 
% ind = find(X==9 | X==10);
% nind    = length(ind);
% 
% y   = cell(col*row,1); 
% 
% for ii  = 1:(nind-1)
%     if((ind(ii)+1)==ind(ii+1))
%         y{ii} = [];
%     else
%         y{ii} = char(X((ind(ii)+1):(ind(ii+1)-1)));
%         if(~isempty(str2double(y{ii})) && ~isnan(str2double(y{ii})))
%             y{ii}   = str2double(y{ii});
%         end
%     end
% end
% 
% y   = reshape(y,col,row)';
% 
% 
% 
