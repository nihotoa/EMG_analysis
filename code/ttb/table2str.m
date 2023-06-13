function y  = table2str(x,xlabel,ylabel)

sumcol  = num2cellstr(sum(x,1));
sumrow  = num2cellstr(sum(x,2));
sumsum  = num2cellstr(sum(sum(x)));
x   = num2cellstr(x);
% x   = [[{''};ylabel'],[{''}][xlabel;x]];
x   = [[{''};ylabel';{'sum'}],[xlabel;x;sumcol],[{'sum'};sumrow;sumsum]];


[nrow,ncol] = size(x);
n   = zeros(nrow,ncol);

for irow=1:nrow
    for icol=1:ncol
        n(irow,icol)    = length(x{irow,icol});
    end
end

maxn    = max(max(n));

y   = '';
for irow=1:nrow
    for icol=1:ncol
        if(icol==1)
            eval(['y   = sprintf(''%s%',num2str(maxn+1),'s'',y,x{irow,icol});']);
        else
            eval(['y   = sprintf(''%s\t%',num2str(maxn+1),'s'',y,x{irow,icol});']);
        end
    end
    if(irow~=nrow)
        y   = sprintf('%s\n',y);
    end
end



