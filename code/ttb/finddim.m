function y  = finddim(x)

y   = size(x);

y   = find(y~=1,1,'first');
end