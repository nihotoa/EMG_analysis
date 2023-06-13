function [h,p,r,t,df]    = corrtest(X1,X2)


% Reference:
% 心理学のためのデータ解析テクニカルブック　p224


alpha    = 0.05;
r   = corr(X1,X2);
n   = length(X1);
df  = n-2;

t   = (r*(sqrt(n-2)))/(sqrt(1-r.^2));

%　両側検定なので、正の値のtだけを考えて、片側0.025％水準で考える
p   = 2*(1 - tcdf(abs(t),df));

h   = p<alpha;