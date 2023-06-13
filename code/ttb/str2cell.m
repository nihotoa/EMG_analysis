function y  = str2cell(x)

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
