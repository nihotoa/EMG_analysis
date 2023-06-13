function [y,n]  = stepwise_allpair(nn)


y   = false(power(2,nn),nn);


for ii  =1:power(2,nn)
    
    y(ii,1:length(dec2binvec(ii-1)))=logical(dec2binvec(ii-1));
end

n   = sum(double(y),2);

y   = sortmtx(y,n,1);

n   = sum(double(y),2);
    