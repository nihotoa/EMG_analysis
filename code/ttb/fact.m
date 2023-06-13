function y  = fact(x)

[nrow,ncol] = size(x);

y   = zeros(size(x));

for irow=1:nrow
    for icol=1:ncol
        y(irow,icol)    = factorial(x(irow,icol));
    end
end
        