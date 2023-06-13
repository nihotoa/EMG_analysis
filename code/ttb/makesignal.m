function [X,T]  = makesignal

  
[x,t] = sinf(25,250,20);

X   = zeros(10,1024);

for ii=1:10


% X(ii,257:281)  =x;
X(ii,267:291)  =x;
end
X   = X + 0.1 * rand(size(X));

T   = [0:1023]*0.004;

