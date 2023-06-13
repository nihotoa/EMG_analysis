function [y,xx]  = parsepath(x)

if(strcmp(x(1),filesep))
    x(1)  = [];
end
if(strcmp(x(end),filesep))
    x(end)  = [];
end
xx  = x;

x   = [filesep,x,filesep];
ind = strfind(x,filesep);

if(isempty(ind))
    y   =x;
else
    nind    = length(ind);
    y   = cell(1,nind-1);
    
    for iind=1:(nind-1)
        if(ind(iind+1)-ind(iind)>1)
            y{iind}   = x((ind(iind)+1):(ind(iind+1)-1));
        else
            y{iind}   = [];
        end
    end
end
    