function y  =combination(a,b)
%   y  =combination(a,b)
%   y  = aCb


if(a > b)
    y   = factorial(a)/(factorial(b)*factorial(a-b));
elseif(a==b)
    y   = 1;
else
    y   = [];
end
