
nkf = 4;
nNMF= 3;

W = cat(3,S.test.W{nNMF,:});

figure
for ikf=1:nkf
    subplot(2,nkf,ikf)
    imagesc(W(:,:,ikf),[0 1])
%     colormap('gray')
end

for ikf=1:nkf
    m   = corrcoefmtx(W(:,:,1),W(:,:,ikf));
    ind = maxind(m,[],2);
    
    if(sum(ind)==sum(unique(ind)))
        W(:,:,ikf)  = W(:,ind,ikf);
    else
        keyboard
    end
    
end


for ikf=1:nkf
    subplot(2,nkf,ikf+nkf)
    imagesc(W(:,:,ikf),[0 1])
%     colormap('gray')
end
