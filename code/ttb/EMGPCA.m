function [Y,S]  = EMGPCA(X)


[Y.coeff, S, Y.latent]    = princomp(X);
Y.explained = Y.latent ./ sum(Y.latent) *100;

% [Y,S]   = invertPCA(Y,S);

function [Y,S]   = invertPCA(Y,S)
[nrow,ncol] = size(Y.coeff);
cfactor = ones(1,ncol);

% [M,I]   = max(abs(Y.coeff),[],1);
% for ii=1:ncol
%     if(Y.coeff(I(ii),ii) < 0)
%         cfactor(ii) = -1;
%     end
% end

% 
I   = sum(Y.coeff,1);
cfactor = double(I >= 0) - double(I < 0);



Y.coeff = Y.coeff.*repmat(cfactor,nrow,1);

[nrow,ncol] = size(S);
S       = S.*repmat(cfactor,nrow,1);


