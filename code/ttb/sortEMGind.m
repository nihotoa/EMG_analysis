function ind =sortEMGind(x,ref)

nx  = length(x);
xx  = parseEMG(x);
ind = zeros(size(nx));

for ix=1:nx
    if(~isempty(xx{ix}))
        firstEMG    = ix;
        break;
    end
end



for ix=1:nx
    if(isempty(xx{ix}))
        ind(ix) = ix;
    else
        ind(ix) = strmatch(xx{ix},ref) + firstEMG - 1;
    end
end


        
        