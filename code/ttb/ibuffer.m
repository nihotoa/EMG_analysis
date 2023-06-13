function Y  = ibuffer(X,nData,P)

Y   = X(P+1:end,:);
Y   = reshape(Y,1,numel(Y));
Y   = Y(1:nData);


