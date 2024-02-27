function[wbest,hbest,normbest] = nnmf2(a,k,w0,h0,nrep,alg,target_param,pre_normalize,post_normalize)
%{ 
explanation of input arguments:
a:  matrix of EMG data ([mm,nn]=size(a) mm channels x nn data length)
k:  number of synergies (factors in NNMF) to extract
w0,h0: Initial values of W_matrix (spatial pattern. [mm, k] = size(W)) & H_matrix (temporal pattern. [k, nn] = size(H)) 
target_param: which matrix should be updated? ('wh' or 'h'). basically 'wh' is fine
post_normalize: whether to perform amplitude normalization of H_matrix after optimization of H. 'mean'or 'none'. (Default is 'none')
%}

%{ 
explanation of output arguments:
wbest: return the matrix of spatial pattern (after nnmf optimization)
hbest: return the matrix of temporal pattern(after nnmf optimization)
normbest: return the norm of the difference between reconstructed EMG and original EMG
%}

% set parameters (threshold setting in MU method of nnmf)
maxiter = 1000; % maximum number of multiplicative updates
tolx    = 10^-4; %threshold of dVAF

if(nargin<3)
    w0      = [];
    h0      = [];
    nrep    =1;
    alg     = 'als';
    target_param    = 'wh';
    pre_normalize   = 'none';
    post_normalize  = 'none';
elseif(nargin<4)
    h0      = [];
    nrep    =1;
    alg     = 'als';
    target_param    = 'wh';
    pre_normalize   = 'none';
    post_normalize  = 'none';
elseif(nargin<5)
    nrep    =1;
    alg     = 'als';
    target_param    = 'wh';
    pre_normalize   = 'none';
    post_normalize  = 'none';
   
elseif(nargin<6)
    alg     = 'als';
    target_param    = 'wh';
    pre_normalize   = 'none';
    post_normalize  = 'none';
elseif(nargin<7)
    target_param    = 'wh';
    pre_normalize   = 'none';
    post_normalize  = 'none';
elseif(nargin<8)
    pre_normalize   = 'none';
    post_normalize  = 'none';
elseif(nargin<9)
    post_normalize  = 'none';
end

w0isempty   = isempty(w0); % wether the matrix is empty or not
h0isempty   = isempty(h0);

% Check required arguments
[n,m] = size(a); %n: muscle num, m: length of data
if ~isscalar(k) || ~isnumeric(k) || k<1 || k>min(m,n) || k~=round(k) 
    error('stats:nnmf:BadK',...
        'K must be a positive integer no larger than the number of rows or columns in A.');
end

% create flag to identify differences in algorithm
if(strcmp(alg,'mult')) 
    ismult  = true;
else
    ismult  = false;
end

% Creation of pseudo-random numbers
S = RandStream.getGlobalStream; 
fprintf('repetition\titeration\tSSE\tVAF\tdVAF\tAlgorithm\n');

% pre_normalize
switch pre_normalize
    case 'mean'
        a = normalize(a,'mean'); 
        disp([mfilename,': pre_normalize = mean']);
    case 'none'
        disp([mfilename,': pre_normalize = none']);
end


for irep=1:nrep
    
    if(w0isempty)
        w0  = rand(S,n,k); % create a random number matrix of size n(muscle num)*k
    end
    if(h0isempty)
        h0  = rand(S,k,m); % create a random number matrix of size k*m(length of data)
    end
    
    % Perform a factorization
    [w1,h1,norm1,iter1,SSE1,VAF1,dVAF1] =    nnmf1(a,w0,h0,ismult,target_param,maxiter,tolx);
    
    fprintf('%7d\t%7d\t%12g\t%12g\t%12g\t%s\t%s\n',irep,iter1,SSE1,VAF1,dVAF1,alg,target_param);

    % change parameters based on which initial random number matrix was the best
    if(irep==1) 
        wbest   = w1;
        hbest   = h1;
        normbest    = norm1;
        iterbest    = iter1;
        SSEbest     = SSE1;
        VAFbest     = VAF1;
        dVAFbest    = dVAF1;
        irepbest    = irep;
    else
        if(norm1<normbest)
            wbest   = w1;
            hbest   = h1;
            normbest    = norm1;
            iterbest    = iter1;
            SSEbest     = SSE1;
            VAFbest     = VAF1;
            dVAFbest    = dVAF1;
            irepbest    = irep;
        end
    end
end

fprintf('Final result:\n');
fprintf('%7d\t%7d\t%12g\t%12g\t%12g\n',irepbest,iterbest,SSEbest,VAFbest,dVAFbest);

if normbest==Inf
    error('stats:nnmf:NoSolution',...
        'Algorithm could not converge to a finite solution.')
end

hlen = sqrt(sum(hbest.^2,2));
if any(hlen==0)
    warning('stats:nnmf:LowRank',...
        'Algorithm converged to a solution of rank %d rather than %d as specified.',...
        k-sum(hlen==0), k);
    hlen(hlen==0) = 1;
end

% amplitude normalizetion of H_matrix
switch post_normalize
    case 'mean'
        A   = mean(hbest,2);
        wbest   = wbest .* repmat(A',size(wbest,1),1);
        hbest   = hbest ./ repmat(A ,1,size(hbest,2));
        disp([mfilename,': post_normalize = mean']);
    case 'none'
        disp([mfilename,': post_normalize = none']);
end

% Then order by w
[~,idx] = sort(sum(wbest.^2,1),'descend');
wbest = wbest(:,idx);
hbest = hbest(idx,:);

end

%% define local function

function [w,h,dnorm,iter,SSE,VAF,dVAF] = nnmf1(a,w0,h0,ismult,target_param,maxiter,tolx)
%{ 
explanation of output arguments:
w:final version of spatial pattern after optimization 
h: final version of spatial pattern after optimization 
dnorm: norm of difference between measured EMG and reconstructed EMG => to evaluate the discrepancy
iter: how many multiplicative updates have been performed?
SSE: final version of SSE
VAF: final version of VAF
dVAF: final version of dVAF
%}

% Single non-negative matrix factorization
sqrteps = sqrt(eps); % define machine epsilon for less error in calculations
for iter=1:maxiter 
    if ismult
        % Multiplicative update formula
        switch lower(target_param)
            case 'wh' 
                numerator   = w0'*a; % 
                h = h0 .* (numerator ./ ((w0'*w0)*h0 + eps(numerator)));
                numerator   = a*h'; %XH^T
                w = w0 .* (numerator ./ (w0*(h*h') + eps(numerator)));
            case 'h' % update only h
                numerator   = w0'*a;
                h = h0 .* (numerator ./ ((w0'*w0)*h0 + eps(numerator)));
                w = w0;
        end
    else
        % Alternating least squares
        switch lower(target_param)
            case 'wh'
                h = max(0, w0\a);
                w = max(0, a/h);
            case 'h'
                h = max(0, w0\a);
                w = w0;
        end
    end
    
    
    % Get norm, SSE, SST and VAF
    b = w*h; % reconstructed EMG (created from W, H after muluticative update)
    A   = reshape(a,numel(a),1); % converts a (measured EMG) into a vector by reshape
    B   = reshape(b,numel(b),1); % converts b (reconstructed EMG) into a vector by reshape
    D   = A-B; %X-wh (difference between measured EMG and reconstructed EMG)

    dnorm   = sqrt(sum(D.^2)/length(D)); % find the norm of the difference
    SSE = sum(D.^2);    % sum of squared residuals (errors)
    SST = sum((A-mean(A)).^2);  % sum of squared total?

    dw = max(max(abs(w-w0) / (sqrteps+max(max(abs(w0))))));
    dh = max(max(abs(h-h0) / (sqrteps+max(max(abs(h0))))));
    delta = max(dw,dh);
    
    % Check for convergence
    % create an array to record VAF and dVAF(differencce from previous iteration)
    if(iter==1) 
        VAF     = nan(1,maxiter);
        dVAF    = nan(1,maxiter);
    end
    
    VAF(iter)  = 1 - SSE./SST;
    
    if(iter==1)
        dVAF(iter) = VAF(iter);
    else
        dVAF(iter) = VAF(iter)-VAF(iter-1);
    end

    % whether to break iteration and terminate optimization
     if iter>20
        if delta <= 1e-4
            break; 
        elseif dVAF(iter) <= tolx
            break;
        elseif iter==maxiter
            break
        end
     end

    % Remember previous iteration results
    w0 = w;
    h0 = h;
end
VAF = VAF(iter);
dVAF = dVAF(iter);

end

