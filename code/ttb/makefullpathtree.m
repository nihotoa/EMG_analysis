function x  = makefullpathtree(x,currpath)

nn  = length(x);

for ii =1:nn
    X   = x{ii};
    if(~strcmp(X(1),filesep))
        X   = [filesep,X];
    end    
    if(~strcmp(X(end),filesep))
        X   = [X,filesep];
    end

    ind     = strfind(X,filesep);
    level   = length(ind) - 1;
    
    if(strmatch(x{ii},currpath))
        select_icon   = '[-]';
    else
        select_icon   = '[+]';
    end
   
    x{ii}   = [repmat('    ',1,level),select_icon,' ',X((ind(end-1)+1):(ind(end)-1))];
end