function	W = get_estimated_weight(Model,parm,wmode);
% Return Full Weight matrix from 'Model'
%
%  W = get_estimated_weight(Model); 
%  W = get_estimated_weight(Model,parm);
%  W = get_estimated_weight(Model,parm,wmode);
% --- input
% Model.W : Weight matrix for active input [Ydim x Nactive]
% Model.ix_act : active input index
% Model.M_all  : original input dimension including time dimension
% Model.Dtau   : Time delay embedding dimension (Old version have not this)
%  parm.Dtau   : Time delay embedding dimension
%
%  In the default mode, 
%  no scale renormalization is done:
%  Weight for normalized input and output is returned.
%
%  If wmode is given and wmode = 1, 
%  normalization constants are scaled back into the weight matrix 'W' 
%  Weight for original input and output is returned.
%
%  parm.xnorm
%  parm.ynorm
%  
% --- output
% W : Weight matrix : 3D-array [Ydim x Xdim x Dtau)]
% W(n,m,:) : temporal weight vector for n-th output & m-th input data
% Dtau : Time embedding dim
% Ydim : Output space dim
% Xdim : Input space dim
%
% 2008-5-20 Masa-aki Sato

if nargin < 2, parm  = []; end;
if nargin < 3, wmode = 0; end;

if isfield(Model,'Dtau')
	Dtau  = Model.Dtau;
elseif isfield(parm,'Dtau')
	Dtau  = parm.Dtau;
else
	Dtau  = 1;
end

M_all = Model.M_all;
Ydim  = size(Model.W,1);
Xdim  = M_all/Dtau;

if isfield(Model,'ix_act')
	% Active index
	ix_act = Model.ix_act;

	W = zeros(Ydim ,M_all);
	W(:,ix_act) = Model.W;
else
	W =  Model.W;
end

if wmode==1
	if isfield(parm,'xnorm'), 
		error('parm does not have the field xnorm');
	end
	if length(parm.xnorm) == Xdim,
		parm.xnorm = repmat(parm.xnorm ,[Dtau 1]);
	end
	
	% Scale back by normalization factor
	if isfield(parm,'xnorm') 
		W = repmultiply( W, 1./parm.xnorm(:)');
	end
	if isfield(parm,'ynorm')
		W = repmultiply( W, parm.ynorm);
	end
end

W = reshape( W, [Ydim, Xdim, Dtau]);
