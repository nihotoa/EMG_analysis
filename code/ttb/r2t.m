function T  =r2t(R,N)
% convert correlation coefficient to t score 
% 
% Reference:
% 心理学のためのデータ解析テクニカルブック　p224

[R,nshift] = shiftdim(R);

T   = (R*sqrt(N-2))./sqrt(1-R.^2);

T = shiftdim(T,-nshift);

% EOF