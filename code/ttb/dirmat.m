function y  = dirmat(pathname)

y   = what(pathname);

if(~isempty(y(1).mat))
    y   = y(1).mat;
else
    y   = [];
end

