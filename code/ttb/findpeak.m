function y  = findpeak(x,k,n)

ortho   = conv(x,ones(1,n));
anti    = ortho;
ortho   = ortho(n-1,end);
anti    = anti(1:end-n+1);

orthoNonzero    = (ortho> 0);
antiNonzero     = (anti > 0);

y   = ((ortho > k) & (antiNonzero)) | ((anti > k) & (orthoNonzero));