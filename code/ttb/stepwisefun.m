function [sw, Y, order]  = stepwisefun(X,nperms,hfun,varargin)
if(~isa(hfun,'function_handle'))
    error('third input must be function_handle');
end

X   = shiftdim(X)';
nX  = length(X);

if(isempty(nperms))
    Y       = X;
    order   = 1:nX;
    nperms  = 1;
    sw      = nan(nperms,nX);
else
    Y       = nan(nperms,nX);
    order   = nan(nperms,nX);
    sw      = nan(nperms,nX);
    rand('state',0);% ランダムで選ぶけど、いつも同じセットが出るようにしているということ
    for iperm=1:nperms
        order(iperm,:)  = randperm(nX);
        Y(iperm,:)      = X(order(iperm,:));
    end
end

for iperm=1:nperms
    for iX=1:nX
        sw(iperm,iX)    = hfun(Y(iperm,1:iX));
    end
end
