function s  =findclust(x)
% 
% x   = [1 0 0 1 1 1 1 1  0 0 0 0];
[x,nshift]  = shiftdim(x);

dx  = diff([0;x]);
idx = diff([0;x(end:-1:1)]);
idx = idx(end:-1:1);
first   = find(dx==1);
last    = find(idx==1);
n       = last - first +1;

s  = struct('first',num2cell(first),'last',num2cell(last),'n',num2cell(n));