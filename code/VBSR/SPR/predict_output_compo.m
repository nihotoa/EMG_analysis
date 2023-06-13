function	[Y, ix] = predict_output_compo(X, Model, parm)
% Output contribution for each input component
% Input X should be normalized according to 'parm.data_norm' mode
% Time delay embedding for X is done in this function
%  [Y , ix] = predict_output_compo(X, Model, parm)
%  
% --- Input
%  X  : Input data  ( Xdim x T x Ntrial)
%  Xdim  =  # of input (original input space dimension)
%  T  =  # of time sample
% parm.Tau   = Lag time
% parm.Dtau  = Number of embedding dimension
% 
% --- Output
%  Y : Output contribution for each input component
%      by taking weighted sum over time delay using Model.W
%     ( N x M x (T- (D-1)*tau) x Ntrial )
%  Y(n,m,t,trial) = sum_j Model.W(n,m,j) .* X(m,t-tau*j,trial)
%  
%  N = # of output
%  M = # of selected input (space dimension after sparse estimation)
%  T = # of time samples
% ix : Selected input index after sparse estimation
%      (M x 1)
%
% 2010-6-20 Modified by M. Sato

if ~exist('parm','var'), parm = []; end;

if ~isfield(parm,'Tau')
	tau = 1 ; 
	D   = 1 ; 
else
	tau = parm.Tau;
	D   = parm.Dtau;
end

% Embedding dimension
% D = size(W,2)/size(X,1)

[M, Tx, Ntrial] = size(X);
[N, MD] = size(Model.W );
T = Tx - (D-1)*tau;

if	isfield(Model,'ix_act')
	Flag = zeros(M*D,1);
	% active index for embeded space
	Flag(Model.ix_act) = 1;
	% extract active input dimension
	ix = find( sum(reshape(Flag,[M,D]),2) > 0);
	X  = X(ix,:,:);
	
	% adjust size of W
	W = zeros(N,M*D);
	W(:,Model.ix_act) = Model.W;
	W = reshape(W,[N,M,D]);
	W = W(:,ix,:);
	
	M = length(ix);
	W = reshape(W,[N,M*D]);
else
	W = Model.W;
	ix = 1:M;
end


% Output from normalized input
Y = weight_out_compo_delay_time(X, W, T, tau);
Y = reshape(Y, [N,M,T,Ntrial]);
