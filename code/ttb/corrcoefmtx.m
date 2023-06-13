function m  = corrcoefmtx(ref,tar)


[ndata1,nref]   = size(ref);
[ndata2,ntar]   = size(tar);

if(ndata1~=ndata2)
    error('data length not matched.')
end

m   = nan(nref,ntar);

for iref=1:nref
    for itar=1:ntar
        temp    = corrcoef(ref(:,iref),tar(:,itar));
        m(iref,itar)    = temp(1,2);
    end
end


