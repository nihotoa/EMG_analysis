function	[InfoStat] = ...
			multiple_cv_error(xdata, ydata, ModelAll, InfoAll, test_id)
% Cross validation test error for multiple trained models
% --- Usage
%	InfoStat = multiple_cv_error(xdata, ydata, ModelAll, InfoAll, test_id)
%	
% --- Input
%   Training/Test data
%	xdata : [Xdim, Ndata]);
%	ydata : [1, Ndata]);
%
%   Set of trained models
%   ModelAll{m} : m-th single model
%	ModelAll{m},ix_act
%	ModelAll{m},W
%	InfoAll{m}.FE
%
%   test_id : Test sample index for cross validation test : [Nsamp x Ntry]
%   If isempty(test_id), 'xdata' is test data
%
% --- Output
%	InfoStat.CheckErr(m) : Model selection error of m-th combined model 
%	InfoStat.ModelErr(m) : Test error of m-th single model
%	InfoStat.Nact(m)     : # of selected input of m-th combined model
%
%	InfoStat.TrainErr 
%	InfoStat.Fmax   = 
%	InfoStat.Xdim   = 
%	InfoStat.M_all  = 
%
% 2011-10-10 Made by M. Sato

Xdim  = size(xdata,1);
[Ydim,T,L] = size(ydata);
Ndata = T*L;
Nall  = length(ModelAll);

TrainErr = zeros(Nall,1);
CheckErr = zeros(Nall,1);
ModelErr = zeros(Nall,1);
Fmax   = zeros(Nall,1);
Nact   = zeros(Nall,1);

if nargin < 5 || isempty(test_id),
	% 'xdata' is test data
	test_id = [];
	Ntest = L;
	ytest = ydata;
else
	[Num, Ntry] = size(test_id);
	Ntest = Num*Ntry;
	% test data
	ytest = ydata(:,:,test_id(:));
end

yy  = var(ydata(:),1);
yyt = var(ytest(:),1);

Ysum  = zeros(Ydim, T*Ntest);
Ypred = zeros(Ydim, T*Ntest);
psum  = 0;
%ysize = size(Ypred)

% Cross validation error estimation using N-leave out formula
for n=1:Nall
	% --- Trained Sparse model
	Model = ModelAll{n};
	Info  = InfoAll{n};
	
	% Training error
	Fmax(n) = Info.FE(end);
	Nact(n) = length(Model.ix_act);
	
	% Prediction output for 'xdata'
	ypred = predict_output(xdata, Model);
	
%	ysize = size(ypred)
	
	% Training/(Test) error
	TrainErr(n) = mean((ydata(:)-ypred(:)).^2 )/yy;
	
	if ~isempty(test_id)
		% N-leave out prediction for test data specified by 'test_id'
		ypred = one_leave_out_pred(xdata, ydata, test_id, Model);
	end
	
%	ysize = size(ypred)
	
	% Weight factor by free energy
	prob = exp(Fmax(n));
	
	% --- Combined model prediction
	Ysum  = Ysum + prob * reshape(ypred,[Ydim, T*Ntest]);
	psum  = psum + prob;
	Ypred = Ysum / psum;

	ModelErr(n) = mean((ypred(:)-ytest(:)).^2 )/yyt;
	CheckErr(n) = mean((Ypred(:)-ytest(:)).^2 )/yyt;
	
end

InfoStat.TrainErr = TrainErr ;
InfoStat.ModelErr = ModelErr ;
InfoStat.CheckErr = CheckErr;

InfoStat.Fmax  = Fmax  ;
InfoStat.Nact  = cumsum( Nact );
InfoStat.Xdim  = Xdim ;
InfoStat.M_all = Xdim;


%return
%
%if Nclass > 2,
%	if isfield(parm,'Nsample')
%		Xrange = 3;        % range of dense sampling region
%		N1 = parm.Nsample; % number of dense sampling points
%		N2 = ceil(N1/2);   % number of medium sampling points 
%	else
%		Xrange = 3;
%		N1 = 100;
%		N2 = 40;
%	end
%	
%	% Sample points for numerical integration
%	xsamp = gen_gauss_sample(Xrange,N1,N2);
%end


%	if Nclass == 2,
%		Y = probit_target_binary(ydata, Y_hat);
%	else
%		Y = probit_target(ydata, Y_hat, xsamp);
%	end
%	
%	ypred = one_leave_out_pred(xdata,Y,test_id,Model);
