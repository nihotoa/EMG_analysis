function x  = ibuffermtx(y,P,nx,DIM)


if(nargin<3)
    DIM = [];
end

if(isempty(DIM))
    DIM = 1;
end



[N,nBuffer,ncol] = size(y);
if(DIM==1)
    y(1:P,:,:)  = [];
    for icol=1:ncol
        if(icol==1)
            x   = zeros(numel(y(:,:,icol)),ncol);

        end
        x(:,icol)   = reshape(y(:,:,icol),1,numel(y(:,:,icol)));
    end
elseif(DIM==2)
    y(1:P,:,:)  = [];
    for icol=1:ncol
        if(icol==1)
            x   = zeros(ncol,numel(y(:,:,icol)));
        end
        x(icol,:)   = reshape(y(:,:,icol),numel(y(:,:,icol)),1);
    end
%     x   = x';
end

if(size(x,1)> nx)
    x   = x(1:nx,:);
end