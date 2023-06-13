function y  =smoothing(x,n,type,dim)
% x     data
% n     window size (if type == 'manual', then n == window shape (ex [0.5 1 0.5])
% type  window type
% 
% type=='manual'のときでも、wnの合計が1になるようにnormalizeされます。

% Written by TT

error(nargchk(2, 4, nargin, 'struct'))
if nargin<3
    type    = 'boxcar';
    dim     = [];
elseif nargin<4
    dim     = [];
end

if(strcmp(type,'manual'))
    wn  = n;
    wn  = wn/sum(wn);
    n   = length(wn);
else
    wn  = window(type,n);
    wn  = wn/sum(wn);
end

if mod(n,2)==0
    error('n must be even.')
end



dims=size(x);

% filterをかける次元を決定
if(isempty(dim))
   dim=find(dims>1,1,'first');
end

% filterをかける次元の最後にn-1分の0を付加
dims(dim)   = n-1;
X   = cat(dim,x,zeros(dims));
y   = filter(wn,1,X,[],dim);

% 有効なyの切り出し
dims(dim)   = 1;
ind = [false((n-1)/2,1);true(size(y,dim)-n+1,1);false((n-1)/2,1)];
ind = shiftdim(ind,1-dim);
ind = repmat(ind,dims);

% 有効なyの並べ替え
y   = reshape(y(ind),size(x));
