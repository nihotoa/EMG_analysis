function y  = dirdir(pathname)

y   = dir(pathname);
if(~isempty(y))
    y   = {y([0 0 y(3:end).isdir]==1).name}';
end


