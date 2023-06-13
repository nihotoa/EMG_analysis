function [aveW,W]   = averageNMFW(W,disp_opt)

if(nargin<2)
    disp_opt    = 0;
end

if(~isnumeric(W))
    error('W must be numeric')
end

% W   = cat(3,W);
nkf = size(W,3);


if(disp_opt==1)
    figure
    for ikf=1:nkf
        subplot(2,nkf+1,ikf)
        imagesc(W(:,:,ikf),[0 1])
        %     colormap('gray')
    end
    subplot(2,nkf+1,nkf+1)
    imagesc(mean(W,3),[0 1])
end

for ikf=1:nkf
    m   = corrcoefmtx(W(:,:,1),W(:,:,ikf));
    ind = maxind(m,[],2);
    
    if(sum(ind)==sum(unique(ind)))
        W(:,:,ikf)  = W(:,ind,ikf);
    else
        disp('not exclusive!!')
        W(:,:,ikf)  = nan(size(W(:,:,ikf)));
    end
    
end

aveW    = mean(W,3);


if(disp_opt==1)
    
    for ikf=1:nkf
        subplot(2,nkf+1,ikf+(nkf+1))
        imagesc(W(:,:,ikf),[0 1])
        %     colormap('gray')
    end
    subplot(2,nkf+1,(nkf+1)*2)
    imagesc(mean(W,3),[0 1])
end

end
