function y  = dirfile(pathname)

y   = dir(pathname);
if(~isempty(y))
    y   = {y([y.isdir]==0).name}';
end

