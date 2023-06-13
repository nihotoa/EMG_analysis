function [c,lags, N] = ubxcorr(x,y,maxlag,scaleType)
if(~isequal(size(x),size(y)))
    disp('x,y must be same size.')
    return
end

[x,nshift] = shiftdim(x);
[y,nshift] = shiftdim(y);

if(length(x) <= 2*maxlag)
    disp('length(x) and length(y) must be >= 2 * maxlength + 1.')
    return
end

y(1:maxlag) = zeros(maxlag,1);
y(end-maxlag+1:end) = zeros(maxlag,1);
N   = length(y) - 2*maxlag;

switch lower(scaleType)
    case 'none'
        [nonec,lags]    = xcorr(x,y,maxlag,'none');
        c   = nonec;
    case 'coeff'
        yN     = y(maxlag+1:maxlag+N);
        for ii=1:2*maxlag+1
            xN(:,ii)     =x(ii:ii+N-1);
        end
        corrcoefmtx = corrcoef([yN,xN]);
        c   = corrcoefmtx(1,2:2*maxlag+2)';
        lags    = [-maxlag:maxlag];
%         
%         sqx      = (x.^2);
%         sumsqx     = conv(sqx,ones(N,1));
%         sumsqx(end-N+2:end)    =[];
%         sumsqx(1:N-1)          =[];
%         c   = nonec./sqrt(sumsqy.*sumsqx);
    case 'unbiased'
        [nonec,lags]    = xcorr(x,y,maxlag,'none');
        c   = nonec/N;
end

% If first vector is a row, return a row
c = shiftdim(c,-nshift);


% EOF

