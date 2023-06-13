function	[ModelAll, InfoAll] = ...
			iterative_spr_model(xdata, ydata, train_func, parm)
% Iterative Sparse probit estimation
% --- Usage
%	[ModelAll, InfoAll, parm] = ...
%		iterative_probit_model(xdata, ydata, train_func, parm)
%% Training data
%	xdata : [Xdim, Ntrain]);
%	ydata : [1, Ntrain]);
%
%  parm  : Structure for learning parameter
%  parm.Ntrain     : # of total training iteration
%  parm.Npre_train : # of initial stable training
%  parm.Nskip  :  skip # for print
%  parm.bias  = 0: no bias term
% 	          = 1: add bias term
%
%   ModelAll{n} : n-th single model
%	ModelAll{n},ix_act
%	ModelAll{n},W
%	InfoAll{n}.FE
%
%
% 2011-10-10 Made by M. Sato

if isfield(parm,'Max_err'),
	Max_err = parm.Max_err;
else
	Max_err = 1.0;
end

xmean = parm.xmean;
xnorm = parm.xnorm;

% Input dimension in original input data
Xdim = size(xdata,1);

ModelAll = cell(Xdim,1);
InfoAll  = cell(Xdim,1);

%
% --- Iterative Sparse estimation
%
ix_all  = 1:Xdim;
ix_rest = ix_all;

if isfield(parm,'Dtau')
	D = parm.Dtau;
	M_all = Xdim*D;
else
	D = 1;
	M_all = Xdim;
end

Mrest = Xdim;

for n=1:Xdim
	
	% --- Sparse estimation
	[Model, Info] = feval(train_func, xdata, ydata, [], parm);
	
	if isempty(Model.ix_act), 
		fprintf('No active input (iter=%d)\n',n)
		n = n-1;
		break; 
	end;
	
	% Get active index without time embedding
	ix_act = get_active_index(Model);
	
	% non-active index
	ix_rest = setdiff2(1:Mrest, ix_act);

	% active index in original input space
	ix_act = ix_all(ix_act); 
	
	% Delay embedding index in original time embedding space
	id  = repmat((0:(D-1))* Xdim ,[length(ix_act) 1]) ...
	    + repmat(ix_act(:), [1 D]);
	
	% Set original time embedding input index for active input
	Model.ix_act = id(:);
	Model.M_all  = M_all;
	Model.Xdim   = Xdim;
	
	Model.xmean  = xmean;
	Model.xnorm  = xnorm;
	
	ModelAll{n} = Model;
	InfoAll{n}  = Info;
	
	% --- Remove selected active input
	
	% Set non-active input for further effective input search
	xdata  = xdata(ix_rest,:,:);
	
	parm.xmean = parm.xmean(ix_rest);
	parm.xnorm = parm.xnorm(ix_rest);
	
	% original input index for non-active input
	Mrest  = length(ix_rest);
	ix_all = ix_all(ix_rest);
	
	% Check Training error
	if isempty(ix_rest) || Info.Err(end) >= Max_err , break; end;
end

ModelAll = { ModelAll{1:n} };
InfoAll  = { InfoAll{1:n} };

%parm.xmean = xmean;
%parm.xnorm = xnorm;

return


%Nclass = max(ydata(:));

%if isfield(parm,'bias') && parm.bias==1
%	% Add Bias term
%	[M,T,K] = size(xdata);
%	xdata = [xdata; ones(1,T,K)];
%end;
%
%% Normalize input data
%[xdata,nparm] = normalize_data(xdata, parm.data_norm);
%parm.xmean = nparm.xmean;
%parm.xnorm = nparm.xnorm;
