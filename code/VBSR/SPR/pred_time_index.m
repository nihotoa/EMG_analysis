function	[tx,ty,T] = pred_time_index(x,parm)
%  Time index for delay embedding prediction
%  [tx,ty,T] = pred_time_index(x,parm)
% --- Input
% x : Input data  : Xdim x Tsample x Ntrial
% parm : Time delay embedding parameter
% parm.Tau       = Lag time
%                  This can be set for each input dimension
% parm.Dtau      = Number of embedding dimension
% parm.Tpred     = Prediction time step :
%                  y(t+Tpred) = W * [x(t); ...; x(t-Tdelay)]
%                  ydata(t)   = W * xdata(t)
% --- Output
%	%  Time period for prediction
%	T  = number of time sample after time embedding
%	tx = time index for input x
%        if parm.Tau is vector, tx(n,:) is time index for x(n,:)
%	ty = time index for output
%
% Tdelay = Tau*(Dtau-1);
% X(1:Tdelay+1) -> Y(Tdelay + Tpred + 1)
% ypred(:,1:T)  =   y(:,ty)
% xpred(:,1:T+Tdelay) = x(:,tx);
%
% 2007/1/15 Made by M. Sato
% 2010/9/5  Made by M. Sato

[Xdim,Ndata,Ntrial] = size(x);

if nargin < 2,
	T = Ndata;
	tx = 1:T;
	ty = tx;
	return
end;

if ~isfield(parm,'Tpred')
	parm.Tpred = 0 ; 
end

if ~isfield(parm,'Tau')
	% Setting for function mapping ( No embedding case )
	parm.Tau   = 1 ; 
	parm.Dtau  = 1 ; 
end

if parm.Dtau == 1, parm.Tau   = 1 ; end;

% Time delay embedding parameter
Tpred  = parm.Tpred ;
Tau    = parm.Tau   ;
D      = parm.Dtau  ;
Tdelay = Tau*(D-1);
Npred  = length(Tpred);

if Npred > 1 && Npred ~= Xdim,
	error('If length(parm.Tau) > 1, it should be size(x,1) ')
end
%
% ---  Input & Output time period
%
TPRED = Tpred + Tdelay;

% -- Forward Prediction 
% X(1:Tdelay+1) -> Y(Tdelay + 1 + Tpred) = Y(TPRED + 1)
% X(1:Ndata)    -> Y(TPRED+1:Ndata+Tpred)
% -- Backward Prediction (Tpred < 0 , TPRED < 0)
% X((1-TPRED):(1-Tpred)) -> Y(1)

% Output time period for each input with Tpred
ty1 = max(  1   + TPRED, 1);
ty2 = min(Ndata + Tpred, Ndata);

% Common output period
ty1 = max(ty1);
ty2 = min(ty2);
ty  = [ty1:ty2];
% Time length of output
T   = ty2 - ty1 + 1;

% X(tx1:tx2) -> Y(ty1:ty2)
% ty1 = tx1 + TPRED;  tx1 = ty1 - TPRED;
% ty2 = tx2 + Tpred;  tx2 = ty2 - Tpred;

% Input time period
tx1 = ty1 - TPRED(:);
tx2 = ty2 - Tpred(:);

if Npred == 1 
	tx = tx1:tx2;
else
	Nx = T + Tdelay;
	tx = zeros(Xdim,Nx);
	
	for n=1:Xdim
		tx(n,:) = [tx1(n):tx2(n)];
	end
end
return
