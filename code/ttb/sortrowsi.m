function x  = sortrowsi(x,ind)

ind = shiftdim(ind);
x   = [ind,x];
x   = sortrows(x,1);

x(:,1)=[];

