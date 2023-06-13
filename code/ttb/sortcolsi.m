function x  = sortcolsi(x,ind)
x   = x';
ind = shiftdim(ind);
x   = [ind,x];
x   = sortrows(x,1);

x(:,1)=[];

x   =x';

