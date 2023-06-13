function S  = strreplace(S,oldstring,newstring)
noldstring  = length(oldstring);
nS          = length(S);


ind = strfind(S,oldstring);
while(~isempty(ind))
    ind(1);
    
    startind    = ind(1);
    stopind = startind+noldstring-1;
    
    if(startind==1)
    prefix  = '';
    else
        prefix  = S(1:(startind-1));
    end
    
    if(stopind==nS)
        postfix = '';
    else
        postfix = S((stopind+1):nS);
    end
    
    S   = [prefix,newstring,postfix];

    ind = strfind(S,oldstring);
end
end