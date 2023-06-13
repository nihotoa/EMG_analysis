function	[ypred, Werr] = one_leave_out_pred(X,Y,test_id,Model)
% Output prediction for set of cross validation test input data 
% by using one leave out prediction formula in least square estimation
%	[ypred, Werr] = one_leave_out_pred(X,Y,test_id,Model)
% 
% X : input data  [M x T]
% Y : output data [D x T]
% test_id : sample index for cross validation test [N x K]
%
%  % Weight for training data [X, Y]
%  SW = inv( X*X' + 1./A )
%     = A - A * X * inv(X'*A*X + I) * X' * A
%  W  = Y*X' * SW
%  
%  % --- Output prediction for leave-out test data [x]
%  x  : [M x N]     % leave-out test data
%  W_ : Weight for training data [X_ , Y_] leaving test data [x,y] from [X,Y]
%  
%  xSx = x' * SW * x 
%  y_p = W_ * x = ( W*x - y*xSx ) * inv(I-xSx)
%
% 2011-10-10 Made by M. Sato

MinCond = 1e-8;

if nargin < 4, Model = [];end;

if isfield(Model,'ix_act')
	% Get active index without time embedding
	ix_act = get_active_index(Model);
	X = X(ix_act,:,:);
end

if isfield(Model,'A')
	A = Model.A(:)';
else
	A = [];
end

if isfield(Model,'Dtau')
	X = delay_embed(X, Model.Tau, Model.Dtau);
end

[D,T,L] = size(Y);
[M,T,L] = size(X);

[N,K] = size(test_id);
ypred = zeros(D,T*N,K);

%fprintf('M=%d, T=%d, Ntrial=%d, Ntest=%d, Ncv=%d\n',M,T,L,N,K)

% Inverse covariance matrix
if isempty(A)
	if M <= T*N
		for k=1:K
			% Training data
			train_id = setdiff2([1:L], test_id(:,k));
			Xt = X(:,:,train_id);
			Yt = Y(:,:,train_id);
			Xt = Xt(:,:);
			Yt = Yt(:,:);
			
		    S  = Xt*Xt';
			W  = (Yt*Xt')/S;
			Xtest = X(:,:,test_id(:,k));
			ypred(:,:,k) = W * Xtest(:,:);
		end
		
		ypred = ypred(:,:);
		return
	else
	    S  = X(:,:)*X(:,:)';
		if rcond(S) > MinCond,
			SW  = inv( S ); 
		else
			SW  = pinv( S );
		end
	end
elseif M <= T*N
	fprintf('M=%d <= Ntest=%d\n',M,T*N)
	for k=1:K
		% Training data
		train_id = setdiff2([1:L], test_id(:,k));
		Xt = X(:,:,train_id);
		Yt = Y(:,:,train_id);
		Xt = Xt(:,:);
		Yt = Yt(:,:);
		
	    S  = Xt*Xt' + diag(1./A) ;
		W  = (Yt*Xt')/S;
		
		Xtest = X(:,:,test_id(:,k));
		ypred(:,:,k) = W * Xtest(:,:);
	end
	
	ypred = ypred(:,:);
	return;
	
elseif M <= T*L
	fprintf('M=%d <= Ndata=%d\n',M,T*L)
    S  = X(:,:)*X(:,:)' + diag(1./A) ;
	
	if rcond(S) > MinCond,
		SW  = inv( S ); 
	else
		SW  = pinv( S );
	end
else
	fprintf('M=%d > Ndata=%d\n',M,T*L)
	%  SW = inv( X*X' + 1./A )
	%     = A - (A * X) * inv(X'*A*X + I) * (X' * A)
	%  C  = ( X' * A * X + eye(T) );  
	XA = repmultiply(X(:,:)' , A);
    C  = XA * X(:,:) + eye(T);  % T x T
    
	if rcond(C) > MinCond,
		Cinv  = inv( C );  % M x M
	else
		Cinv  = pinv( C );
	end
	
	SW  = diag(A) - XA' * Cinv * XA;
end

% Weight for whole data
W  = (Y(:,:) * X(:,:)') * SW;

%  xSx = x' * SW * x 
%  yp  = W_ * x = ( W*x - y*xSx ) * inv(I-xSx)

for k=1:K
	x = X(:,:,test_id(:,k));
	y = Y(:,:,test_id(:,k));
	x = x(:,:);
	y = y(:,:);
	
	xSx = x' * SW * x ;
	ypred(:,:,k) = ( W*x - y*xSx ) / (eye(N*T)-xSx);
end

ypred = ypred(:,:);

if nargout==2 && ~isfield(Model,'W')
	Werr  = sum(abs(W(:) - Model.W(:)))/sum(abs(W(:)));
end

return

% 1st step regression target
Y_hat = W * X;
Y  = probit_target_binary(Yid, Y_hat);


%%%% DEBUG %%%%
%	for k=1:K
%		% Training data
%		train_id = setdiff2([1:T], test_id(:,k));
%		Xt = X(:,train_id);
%		Yt = Y(:,train_id);
%		
%	    S  = Xt*Xt' + diag(1./A) ;
%		W  = (Yt*Xt')/S;
%		
%		ypred(:,:,k) = W * X(:,test_id(:,k));
%	end
%	
%	ypred = reshape(ypred, [D, N*K]);
%	return
%%%% DEBUG %%%%
