function    [W] = weight_update_embed(X,dY,W,XX,A,tau);

% Y : N x T  x Ntrial
% X : M x Tx x Ntrial
% W : N x (M*D)
% Xdelay(t) = [X(t+tau*(D-1)); ... ; X(t+tau); X(t)]

[N ,T ,Ntrial]  = size(dY);
M = size(X,1); 
D = size(W,2)/M;
Tdelay = tau*(D-1);

% dY = Y - W * X
wid = 0;
tid = 1 + Tdelay;

for j=1:D
	% Loop for each time delay
	tend = tid + T - 1;
	for m=1:M
		% Loop for each spatial dimension
		wid = wid +1;
		dYX = zeros(N,1);
		for n = 1:Ntrial
			dYX = dYX + dY(:,:,n) * X(m, tid:tend, n)';
		end
		
	    dW  = (dYX - A(wid) * W(:,wid) )./ (XX(wid) + A(wid));
	    W(:,wid)  = W(:,wid) + dW;
			
		for n = 1:Ntrial
			dY(:,:,n) = dY(:,:,n) - dW * X(m, tid:tend, n);
		end
	end
	tid = tid - tau;
end

