function y  = bin2ana(x,binwidth)
[x,nshift]  = shiftdim(x);

% correct data length
lx  = length(x);
if mod(lx,binwidth)~=0
    x   = [x; logical(zeros(binwidth-mod(lx,binwidth),1))];
    lx  = lx +  binwidth-mod(lx,binwidth);
end

y   = reshape(x,binwidth,lx/binwidth);
y   = sum(y,1)';
y   = shiftdim(y,-nshift);
    

