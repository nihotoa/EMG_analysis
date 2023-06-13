function x  = diff32(x,p)

[x,nshift]  = shiftdim(x);
nx  = length(x);
x   = buffer(x,p,0);

x   = [x(1,:); diff(x,2)]; % 1st
% x   = [x(1,:); diff(x,2)]; % 2nd
% x   = [x(1,:); diff(x,2)]; % 3rd

x   = reshape(x,numel(x),1);
x   = x(1:nx);

x   = shiftdim(x,nshift);
