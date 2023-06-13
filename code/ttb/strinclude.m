function y  = strinclude(strs,s)

if(iscell(strs))
    Y   = strfind(strs,s);
    y   = false(size(Y));
    
    for ii =1:length(Y)
        if(~isempty(Y{ii}))
            y(ii)   = true;
        end
    end
else
    Y   = strfind(strs,s);
    if(~isempty(Y))
        y   = true;
    else
        y   = false;
    end
end