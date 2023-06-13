function [Model, Info] = linear_map_sparse_cov(X,Y,Model,parm)
%  Estimate linear weight matrix for input-output mapping
%     Automatic Relevance Prior for each input dimension
%     is imposed to get sparse weight matrix
%
%   [Model, Info] = linear_map_sparse_cov(X,Y,Model,parm)
%
% --- Input
%  X  : Input data  ( M x T )
%  Y  : Output data ( N x T )
%  N  =  # of output
%  M  =  # of input
%  T  =  # of data
%
%  Model : Structure for estimated model
%  Model.SY0 :  Output data variance                 ( 1 x 1 )
%  Model.A0  :  (Output data var)/(Input data var)   ( 1 x 1 )
%
%  parm  : Structure for learning parameter
%  parm.Ntrain :  # of training
%  parm.Nskip  :  skip # for print
%  parm.a_min  :  Min value for pruning small variance component
%  parm.Prune  :  = 1 : Prune small variance & irrelevant input dimension
%
% --- Output
%  Model : Structure for estimated model
%  Model.SY  :  Noise variance         ( 1 x 1 )
%  Model.SW  :  Weight variance        ( M x M )
%  Model.W   :  Weight matrix          ( N x M )
%  Model.A   :  Prior weight variance  ( N x M ) ARD hyper parameter
%
%  Info  : Structure for learning process history
%  Info.FE  = LP + H : Free energy
%  Info.LP  = - (Log error)
%  Info.H   = - (# of effective weight parameters)
%
% 2007/1/26 Made by M. Sato

% Constants
MINVAL  = 1.0e-15;
MinCond = 1.0e-10;

% # of total training iteration
Ntrain = parm.Ntrain;

Nskip  = 100;   % skip steps for display info
a_min  = 1e-10; % Minimum value for weight pruning
Fdiff  = 1e-10; % Threshold for convergence
Ncheck = 100;   % Minimum number of training iteration
Fstep  = 5;     % Free energy convergence check step
Prune  = 1;     % Prune mode

if isfield(parm,'Nskip'), Nskip  = parm.Nskip; end;
if isfield(parm,'Fdiff'), Fdiff   = parm.Fdiff; end;
if isfield(parm,'a_min'), a_min   = parm.a_min ; end;
if isfield(parm,'Prune'), Prune = parm.Prune; end;
if isfield(parm,'Ncheck'), Ncheck = parm.Ncheck; end
if isfield(parm,'Fstep'),Fstep  = parm.Fstep ; end

% # of embedding dimension
if isfield(parm,'Dtau')
	D    = parm.Dtau; 
	tau  = parm.Tau;
else
	D    = 1;
	tau  = 1;
end

% Dimension
[M ,Tx ,Nx ]= size(X); % input dim
[N ,Ty ,Ny ]= size(Y); % output dim

if Nx~=Ny, error('Trial number is different for input & output'); end
if Tx~=Ty, error('Time sample is different for input & output'); end

% Reshape into 2D matrix
T = Tx*Nx; % # of data
X = reshape(X, [M T]);
Y = reshape(Y, [N T]);

% # of stable VB-update in initial training
if isfield(parm,'Npre_train')
	Npre_train = parm.Npre_train;
else
	if Tall >= M*D
		Npre_train = fix(Ntrain/2);
	else
		Npre_train = Ntrain;
	end
end
if Npre_train > Ntrain, Npre_train = Ntrain; end;

fprintf('linear map sparse covariance start\n')
fprintf('--- Output Dimension  = %d\n',N)
fprintf('--- Input  Dimension  = %d\n',M)
fprintf('--- Embedding  Dimension  = %d\n',D)
fprintf('--- Number of trials  = %d\n',Nx)
fprintf('--- Number of training sample = %d\n',Tx)
fprintf('--- Total update iteration    = %d (%d)\n',Ntrain,Npre_train)

%  
% --- Initialization
%  A  : Initial variable to use 1st update
%     : 1 x M

% Input/Output variance
sx = mean(repadd(X, - mean(X,2)).^2, 2);
sy = mean(repadd(Y, - mean(Y,2)).^2, 2);

A0  = 1./mean(sx);
SY0 = mean(sy);

if isempty(Model)
	A   = repmat(A0, [1,M]);
	W   = zeros(N,M);
	SY  = SY0;
else
	A   = Model.A ;	 % 1 x M
	W   = Model.W ;  % N x M
	SY  = mean(Model.SY);  % 1 x 1
end

if isfield(parm,'Ta0') && parm.Ta0 > 0,
	Ta0 = parm.Ta0;
	a0  = parm.a0 * A0;
else
	Ta0 = 0;
	a0  = 1;
end

%  --- Initialization by other method ---
% Model.mode = 'scalar': ARD term = alpha * W^2 
% Model.mode = 'cov'   : ARD term = alpha * W^2 * SY(^-1) 
%
if isfield(Model, 'mode') &&  strcmp(Model.mode,'scalar')==1,
	fprintf('Old result is used as initial value\n')
	fprintf('Old method = %s\n', Model.method)
	A  = sum(A,1)./(sum(SY));
end

A = max(A,MINVAL);

% Original input dimension
M_ALL = M;

if isfield(Model,'ix_act')
	% Active index
	IX_act = Model.ix_act;

	X = X(IX_act,:); 	% M x T
	M = length(IX_act);
else
	IX_act = 1:M;
end

% Initial active index
M_all  = M;
A_all  = A/max(A) ;
ix_act_old = 1:M;

ix_act = find( A_all > a_min );   % effective indices
Mnew   = length(ix_act);  		% # of effective input

if Mnew < M,
    % convert to relative index
    jx_act = trans_index(ix_act,ix_act_old,M_all);
    
    M   = Mnew;
    A   = A(jx_act) ;  			% 1 x M
    W   = W(:,jx_act) ;  		% N x M
	X 	= X(jx_act,:);			% M x T
end

% Input covariance
%XX  = (X * X')/T;   	% M x M
%YX  = (Y * X')/T;       % N x M
%YY  = sum(Y.^2,2)/T;    % N x 1

% Covariance matrix (not normalised)
YX  = (Y * X');       % N x M
YY  = sum(Y.^2,2);    % N x 1

fprintf('a_min = %g\n', a_min)
fprintf('SY0   = %g\n', SY0)
fprintf('SY    = %g\n', SY)

% Working variable
if T <= M
	XX = []; 
	CC = zeros(T,T);
	SW = zeros(T,T);
else
	XX = (X * X');   	  % M x M
	CC = zeros(M,M);
	SW = zeros(M,M);
end

G_A = zeros(1,M);       % 1 x M
log_a = 0;
A_old = A;

% Free energy histry
FE  = zeros(Ntrain,1);
LP  = zeros(Ntrain,1);
H   = zeros(Ntrain,1);
MM  = zeros(Ntrain,1);
Err = zeros(Ntrain,1);

% ARD hyper param. history
if isfield(parm,'Debug') & ~isempty(parm.Debug) & parm.Debug > 0
	Debug = 1;
	A_tmp = zeros(M_all, ceil(Ntrain/Nskip));
else
	Debug = 0;
end

k_save  = 0;

%%%%%% Learning Loop %%%%%%
for k=1:Ntrain
	% ARD hyper variance parameter
	% A = 1/alpha

	if T < M
	    % Weight variance
	    % inv(X*X' + 1./A) = A - A * X * inv(X'*A*X + 1) * X' * A
		%  C = ( X' *A* X + eye(T) );  
		XA = repmultiply(X' , A); % T x M
	    CC = XA * X + eye(T);  % T x T
		
		% Weight update
	    % inv(X*X' + 1./A) = A - A * X * Cinv * X' * A
		% W0 = YX .* A;
		% W  = W0 - (((W0 * X) * Cinv) * X') .* A;
		% W  = W0 - ((W0 * X) / C ) * XA;
		W  = repmultiply(YX , A);
		XC = X / CC;
		W  = W - (W * XC) * XA;
		
		%  G_A = diag( X * inv(C) * X' *A )
		%      = diag( (X / C) * X') .*A 
		G_A  = A .* sum(X .* XC, 2)';
		
		% Log variance
		log_sw  = - log_det(CC) ;
		if mod(k, Nskip)==0, fprintf('- '); end
	else
		if isempty(XX)
			% covariance matrix in reduced space
			XX = X * X';
			% save original index
			IX_act = IX_act(ix_act);
			% new active index in reduced space
			ix_act = 1:M;
			M_all  = M;
			A_all  = A;
		end
		
		% Weight covariance
    	SW  = XX + diag(1./A);
		
		% Weight update
		W  = YX / SW;
		
		% SW  = XX + diag(1./A)
		% G_A = diag( XX * inv(SW))
		%     = 1 - diag(inv(SW)) ./A
		G_A = diag( XX /SW )';
		
		log_sw  = - log_det(SW) - sum(log(A));
		if mod(k, Nskip)==0, fprintf('+ '); end
	end
	
	WW = sum(W.^2, 1);
    % Noise variance update
    SY = (sum(YY) - sum(sum(W.*YX)))/(N*T);
    
    if (SY/SY0) <= MINVAL,
	    % Error
	    dY  = Y - W * X;        % N x T
	    dYY = sum(dY.^2, 2);  	% N x 1
	
	    SY  = (sum(dYY) + sum( WW./A ))/(N*T);
	    % Prevent zero variance
	    SY  = max( SY, MINVAL);
	    fprintf('*')
	end
	
	% Log variance
    log_sy  = N * log(SY) ;
    
    if Ta0 > 0,
	    log_a   = Ta0 * sum( - log(A./a0) - a0./A + 1);
	end
	
    % Free energy
    H(k)   =   0.5*N * (log_sw - M);
    LP(k)  = - 0.5*(T * log_sy) ;
    FE(k)  = LP(k) + H(k);
    Err(k) = (SY)./(SY0);
    MM(k)  = M;

    % Estimation Gain
    %jx_act = find(G_A > a_min);
    G_A = max((G_A), MINVAL);

    % Hyper parameter for weight variance (ARD)
	if k <= Npre_train,
		% VB update rule
		% N * A  = (1./SY)' * (W.^2) + N * (A - A.*G_A)  ; 
		% A  = (WW./SY + N * (A - A.*G_A) + 2*Ta0*a0)./( N + 2*Ta0 );
		% A^2 = A .* (WW./SY) ./ (G_A * N);	
	    A  = sqrt(A.*(WW./SY)./(G_A * N));
	else
	    % Accelerated update rule
		%	A  = (1./SY)' * (W.^2) ./ (G_A * N);	
	    A  = ((WW./SY) + 2*Ta0*a0)./(G_A * N + 2*Ta0);
	end
	
    % Prune small variance
    if Prune == 1
	    % Find active input dimension
	    ix_act_old = ix_act;
	    
	    % Recover all component
	    switch	Prune
	    case	1
		    A_all(ix_act) = WW/max(WW);    % Prune by Weight
	    case	2
		    A_all(ix_act) = A /max(A);	   % Prune by Alpha
	    case	3
		    A_all(ix_act) = A * (1/SX);    % Prune by Alpha
	    end
	    
	    % Find active input dimension (absolute index)
	    ix_act = find( A_all > a_min ); % effective indices
	    Mnew   = length(ix_act);  		% # of effective input
	    
	    if Mnew < M,
		    % convert to relative index
		    jx_act = trans_index(ix_act,ix_act_old,M_all);
		    
		    M   = Mnew;
		    A   = A(jx_act) ;  			% 1 x M
		    W   = W(:,jx_act) ;  		% N x M
			X 	= X(jx_act,:);			% M x T
			YX  = YX(:,jx_act);  	 	% N x M
			if ~isempty(XX)
				XX	= XX(jx_act,jx_act);	% M x M
			end
		end
	else
		A = max(A,MINVAL);
    end

    if mod(k, Nskip)==0
        % Save history
		if Debug == 1
        	k_save = k_save + 1;
        	A_tmp(:,k_save) = A_all(:);
		end
		
        fprintf('Iter = %4d, M = %4d, err = %g, F = %g, H = %g\n', ...
               k, M, Err(k), FE(k), - H(k));
    end

	if k > Ncheck && M == MM(k-1)
		Adif = max(abs(A - A_old));
	else
		Adif = 1;
	end
	if Adif < Fdiff, 
		fprintf('Converged : Alpha change = %g\n',Adif)
		break; 
	end;
	
	A_old = A;
	
%		Fdif = (FE(k) - FE(k-Fstep))/abs(FE(k));
%	else
%		Fdif = Fdiff + 1;
%	end
end

% convert to relative index
ix_act = IX_act(ix_act);

% Active index
Model.ix_act = ix_act;
Model.M_all  = M_ALL ;

% Save trained variable
%  W & A is sufficient for cov-method initialization
Model.A  = A ;
Model.W  = W ;
Model.SY = SY;

% Input dimension in original input data
Model.Xdim   = Xdim ;
% --- Time delay embedding parameter
Model.Tau   = tau  ;   % Lag time steps
Model.Dtau  = D ;   % Number of embedding dimension

% Save setup parameter
% Prediction time step : y(t+Tpred) = W * x(t)
Model.Tpred = parm.Tpred;   

Model.method = 'linear_map_sparse_cov';
Model.mode   = 'cov';
Model.sparse = 'sparse';

% Save history
Info.FE  = FE(1:k);
Info.LP  = LP(1:k);
Info.H   = H(1:k) ;
Info.Err = Err(1:k);
Info.M   = MM(1:k);

if exist('A_tmp','var')
	Info.A   = A_tmp(:,1:k_save) ;
end


%%% ---- Index transformation from old active_index to current active_index
function	jx = trans_index(ix,ix_old,M)
% ix = ix_old(jx)

N = length(ix_old);
Itrans = zeros(M,1);
Itrans(ix_old) = 1:N;

jx = Itrans(ix);
