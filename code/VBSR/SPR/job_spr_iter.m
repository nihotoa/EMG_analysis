function	[Err,Nopt,SCnt] = job_spr_iter(xdata,ydata,train_func,parm)
% % --- training method ID
% train_func = @linear_sparse_space;
% % 1: linear_sparse_space 
% % 2: linear_sparse_space_vec
% % 3: linear_sparse_stepwise
% % 4: linear_sparse_stepwise_vec
% 
% % File name for trained model
% %modelfile = ['./test/model'];
% % plot for model selection
% parm.plot_mode = 1;
% 
% % Number of cross validation for generalization error
% parm.Ntest_try = 5;  % # of CV
% parm.Ntest_num = 1;  % # of test trial
% 
% % Number of cross validation for model selection
% parm.Ncv_try = 4; % # of CV
% parm.Ncv_num = 1; % # of test trial
% 
% % Error margin to select best model
% % smallest model satisfying ( CVerr <= min(CVerr) * (1 + parm.Err_min) )
% parm.Err_min = 0.05;
% parm.Max_err = 0.8;
% 
% % --- Basic Learning Parameters
% % # of training iteration
% parm.Ntrain = [1000]; 
% parm.Npre_train = 200;
% parm.Nskip  = 500;	% skip steps for display info
% 
% % --- Time delay embedding parameter
% parm.Tau   = 1 ;   % Lag time steps
% parm.Dtau  = 3 ;   % Number of embedding dimension
% parm.Tpred = 0 ;   % Prediction time step : y(t+Tpred) = W * x(t)
% 
% % --- Normalization parameter
% parm.data_norm  = 1; 
% % = 0: No Normalization is done
% % = 1: Zero mean & Normalize input and output
% % = 2: Add Bias term & Normalize input and output (mean is not changed)

if isfield(parm,'data_norm') && parm.data_norm==2
	% Add Bias term
	[M,T,K] = size(xdata);
	xdata = [xdata; ones(1,T,K)];
end;

% Time alignment for prediction using embedding input
[tx,ty] = pred_time_index(xdata,parm);
xdata = xdata(:,tx,:);
ydata = ydata(:,ty,:);

% Input dimension in original input data
Xdim = size(xdata,1);
% Number of trials
Ntrial = size(xdata,3);

% --- Number of cross validation for generalization error
Ntry  = parm.Ntest_try ; % # of CV
Ntest = parm.Ntest_num; % # of test sample

% --- Test sample index for cross validation test
Nstep = max(fix(Ntrial/Ntry), 1);
test_id = repmat((1:Ntest)',[1 Ntry]) + repmat((0:Ntry-1)*Nstep, [Ntest 1]);
ix = find( test_id > Ntrial );
test_id(ix) = test_id(ix) - Ntrial;

% # of training data
Ndata = Ntrial - Ntest;

% --- Number of cross validation for model selection in each training data set
Ncv   = parm.Ncv_try;
Nsamp = parm.Ncv_num;

% --- Test sample index in training data set for model selection error
Nstep = max(fix(Ndata/Ncv), 1);
check_id = repmat((1:Nsamp)',[1 Ncv]) + repmat((0:Ncv-1)*Nstep, [Nsamp 1]);
ix = find( check_id > Ndata );
check_id(ix) = check_id(ix) - Ndata;

Err  = zeros(Ntry,4); % Test error using best combined/single model
Nopt = zeros(Ntry,2); % # of selected input for best combined/single model

%	Err(n,1)  = n-th test error using best combined/single model
%	Err(n,2)  = n-th training error of best combined model
%	Err(n,3)  = n-th correlation coefficient for test data
%	Err(n,4)  = n-th test error using best single model
%
%	Nopt(n,1) =  # of selected input for best combined model
%	Nopt(n,2) =  # of selected input for best single model

% Cross validation for generalization error
for n=1:Ntry
	% Test data for generalization error
	xtest = xdata(:,:,test_id(:,n));
	ytest = ydata(:,:,test_id(:,n));

	% Training data
	train_id = setdiff2([1:Ntrial], test_id(:,n));
	
	xtrain = xdata(:,:,train_id);
	ytrain = ydata(:,:,train_id);
	
	% Normalize data
	[xtrain,nparm] = normalize_data(xtrain, parm.data_norm);
	parm.xmean = nparm.xmean;
	parm.xnorm = nparm.xnorm;
	
	% Iterative sparse estimation
	[ModelAll, InfoAll] = iterative_spr_model(xtrain,ytrain, train_func, parm);
	
	% Model selection error by N-leave out CV
	InfoStat = multiple_cv_error(xtrain,ytrain, ModelAll, InfoAll, check_id);
	
	% Select best combined model
	[Model, SC, err_train] = get_selected_model(ModelAll, InfoStat, parm);
	
	fprintf('--- Selected best combined model ---\n')
	fprintf('--- # of selected input for best combined model = %d (%d)\n', ...
			length(Model.ix_act), InfoStat.Nact(end))
	
	% Use normalization constant calculated by training data
	xtest  = normalize_data(xtest, parm.data_norm, parm);
	
	% Predict for test data using best combined model
	ypred = predict_output(xtest, Model);
	[err,rcor,yy,zz] = mean_sq_error(ytest, ypred);
	
	Err(n,1)  = mean(err)/mean(yy);
	Err(n,2)  = err_train;
	Err(n,3)  = mean(rcor)/sqrt(mean(yy)*mean(zz));
	
	Nopt(n,1) = length( get_active_index(Model) );
	
	fprintf('Train error = %g\n',err)
	fprintf('Test  error = %g\n',Err(n,1))
	fprintf('Test  corr  = %g\n',Err(n,3))
	
	infoStat = multiple_cv_error(xtest, ytest, ModelAll, InfoAll);
	Err(n,4)  = infoStat.ModelErr(1);
	Nopt(n,2) = infoStat.Nact(1) ;
	
	if isfield(parm,'plot_mode') && parm.plot_mode > 0,
		
		plot_cv_error(InfoStat, infoStat, parm);
		
		if parm.plot_mode == 2,
			fname = sprintf('%s-t%d.png', parm.modelfile, n);
			print( '-dpng', fname)
			close
		end
	end;
	
	if isfield(parm,'modelfile') && ~isempty(parm.modelfile)
		fname = sprintf('%s-t%d.mat', parm.modelfile, n);
		save(fname, 'Model', 'SC', 'parm', ...
			 'ModelAll', 'InfoAll', 'InfoStat','infoStat')
	end
	
	if n==1,
		SCnt = SC;
	else
		SCnt = SC + SCnt;
	end
end

return

	%%% DEBUG
	Xdim  = Model.Xdim
	Tau   = Model.Tau 
	Dtau  = Model.Dtau
	M_all = Model.M_all 
	xsize = size(xtest)
	%%% DEBUG
	
