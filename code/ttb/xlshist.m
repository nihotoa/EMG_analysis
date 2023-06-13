function [y,p]  = xlshist(m)

if nargin<1
    m   =10;
end


[n,t,r] = txls;
[y,x]       = hist(n,m);

figure;
subplot(211)
bar(x,y,'stack')
legend(t)

subplot(212)
p   = y./repmat(sum(y,2),1,size(y,2));
bar(x,p,'stack')
legend(t)
