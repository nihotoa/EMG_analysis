function rs = randseed(n)

r   = logical(rand(1,(n*n+1)/2)>0.5);
rs  = logical(zeros(n,n));

kk  =0;
for ii=1:n-1
    for jj  =ii+1:n
       kk   =kk+1;
       rs(ii,jj)    = r(kk);
    end
end

rs  = rs' | rs;

kk  =0;
for ii=1:n-1
    for jj  =ii+1:n
       kk   =kk+1;
       rs(ii,jj)    = ~r(kk);
    end
end

rs  = double(rs);