function [Y,S]  = EMGICA(X)
p   = 100;
[n,m]   = size(X);
Y.X     = normalize(X','rms');

[Y.coeff,S] = sobi2(Y.X,m,p);
% [Y.coeff,S] = sobi(X',m,p);
S   =S';

% ‚±‚Ì‚Ü‚Ü‚Å‚ÍS‚Ì•ªU‚ª‚·‚×‚Ä“¯‚¶‚É‚È‚é‚æ‚¤‚É‚È‚Á‚Ä‚¢‚é‚Ì‚ÅAcoeff(i,1).^2 + coeff(i,2).^2 + ...
% +coeff(n,1).^2 = 1‚É‚È‚é‚æ‚¤‚É•ÏŠ·‚·‚éB
A   = sqrt(sum(Y.coeff.^2,1));
Y.coeff = Y.coeff./repmat(A,m,1);
S   = (S.*repmat(A,n,1));
Y.latent    = std(S,0,1)';
Y.explained = Y.latent ./ sum(Y.latent) *100;


% Y.latent    = sqrt(sum(Y.coeff.^2,1));
% Y.explained = Y.latent ./ sum(Y.latent) *100;



% [Y.coeff, S, Y.latent]    = princomp(X);
% Y.explained = Y.latent ./ sum(Y.latent) *100;

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


