function [h,p,ci,stats] = ttest(x,m,alpha,tail,dim)
%TTEST  One-sample and paired-sample t-test.
%   H = TTEST(X) performs a t-test of the hypothesis that the data in the
%   vector X come from a distribution with mean zero, and returns the
%   result of the test in H.  H=0 indicates that the null hypothesis
%   ("mean is zero") cannot be rejected at the 5% significance level.  H=1
%   indicates that the null hypothesis can be rejected at the 5% level.
%   The data are assumed to come from a normal distribution with unknown
%   variance.
%
%   X can also be a matrix or an N-D array.   For matrices, TTEST performs
%   separate t-tests along each column of X, and returns a vector of
%   results.  For N-D arrays, TTEST works along the first non-singleton
%   dimension of X.
%
%   TTEST treats NaNs as missing values, and ignores them.
%
%   H = TTEST(X,M) performs a t-test of the hypothesis that the data in
%   X come from a distribution with mean M.  M must be a scalar.
%
%   H = TTEST(X,Y) performs a paired t-test of the hypothesis that two
%   matched samples, in the vectors X and Y, come from distributions with
%   equal means. The difference X-Y is assumed to come from a normal
%   distribution with unknown variance.  X and Y must have the same length.
%   X and Y can also be matrices or N-D arrays of the same size.
%
%   H = TTEST(...,ALPHA) performs the test at the significance level
%   (100*ALPHA)%.  ALPHA must be a scalar.
%
%   H = TTEST(...,TAIL) performs the test against the alternative
%   hypothesis specified by TAIL:
%       'both'  -- "mean is not zero (or M)" (two-tailed test)
%       'right' -- "mean is greater than zero (or M)" (right-tailed test)
%       'left'  -- "mean is less than zero (or M)" (left-tailed test)
%   TAIL must be a single string.
%
%   [H,P] = TTEST(...) returns the p-value, i.e., the probability of
%   observing the given result, or one more extreme, by chance if the null
%   hypothesis is true.  Small values of P cast doubt on the validity of
%   the null hypothesis.
%
%   [H,P,CI] = TTEST(...) returns a 100*(1-ALPHA)% confidence interval for
%   the true mean of X, or of X-Y for a paired test.
%
%   [H,P,CI,STATS] = TTEST(...) returns a structure with the following fields:
%      'tstat' -- the value of the test statistic
%      'df'    -- the degrees of freedom of the test
%      'sd'    -- the estimated population standard deviation.  For a
%                 paired test, this is the std. dev. of X-Y.
%
%   [...] = TTEST(X,M,ALPHA,TAIL,DIM) or TTEST(X,Y,ALPHA,TAIL,DIM) works
%   along dimension DIM of X, or of X and Y.  Pass in [] to use default
%   values for M, Y, ALPHA, or TAIL.
%
%   See also TTEST2, ZTEST, SIGNTEST, SIGNRANK, VARTEST.

%   References:
%      [1] E. Kreyszig, "Introductory Mathematical Statistics",
%      John Wiley, 1970, page 206.

%   Copyright 1993-2010 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $  $Date: 2010/05/10 17:59:24 $

if nargin < 2 || isempty(m)
    m = 0;
elseif ~isscalar(m) % paired t-test
    if ~isequal(size(m),size(x))
        error('stats:ttest:InputSizeMismatch',...
            'The data in a paired t-test must be the same size.');
    end
    x = x - m;
    m = 0;
end

if nargin < 3 || isempty(alpha)
    alpha = 0.05;
elseif ~isscalar(alpha) || alpha <= 0 || alpha >= 1
    error('stats:ttest:BadAlpha','ALPHA must be a scalar between 0 and 1.');
end

if nargin < 4 || isempty(tail)
    tail = 0;
elseif ischar(tail) && (size(tail,1)==1)
    tail = find(strncmpi(tail,{'left','both','right'},length(tail))) - 2;
end
if ~isscalar(tail) || ~isnumeric(tail)
    error('stats:ttest:BadTail', ...
        'TAIL must be one of the strings ''both'', ''right'', or ''left''.');
end

if nargin < 5 || isempty(dim)
    % Figure out which dimension mean will work along
    dim = find(size(x) ~= 1, 1);
    if isempty(dim), dim = 1; end
end

nans = isnan(x);
if any(nans(:))
    samplesize = sum(~nans,dim);
else
    samplesize = size(x,dim); % a scalar, => a scalar call to tinv
end
df = max(samplesize - 1,0);
xmean = nanmean(x,dim);
sdpop = nanstd(x,[],dim);
ser = sdpop ./ sqrt(samplesize);
tval = (xmean - m) ./ ser;
if nargout > 3
    stats = struct('tstat', tval, 'df', cast(df,class(tval)), 'sd', sdpop);
    if isscalar(df) && ~isscalar(tval)
        stats.df = repmat(stats.df,size(tval));
    end
end

% Compute the correct p-value for the test, and confidence intervals
% if requested.
if tail == 0 % two-tailed test
    p = 2 * tcdf(-abs(tval), df);
    if nargout > 2
        crit = tinv((1 - alpha / 2), df) .* ser;
        ci = cat(dim, xmean - crit, xmean + crit);
    end
elseif tail == 1 % right one-tailed test
    p = tcdf(-tval, df);
    if nargout > 2
        crit = tinv(1 - alpha, df) .* ser;
        ci = cat(dim, xmean - crit, Inf(size(p)));
    end
elseif tail == -1 % left one-tailed test
    p = tcdf(tval, df);
    if nargout > 2
        crit = tinv(1 - alpha, df) .* ser;
        ci = cat(dim, -Inf(size(p)), xmean + crit);
    end
else
    error('stats:ttest:BadTail',...
        'TAIL must be ''both'', ''right'', or ''left'', or 0, 1, or -1.');
end
% Determine if the actual significance exceeds the desired significance
h = cast(p <= alpha, class(p));
h(isnan(p)) = NaN; % p==NaN => neither <= alpha nor > alpha


end


function x = tinv(p,v);
%TINV   Inverse of Student's T cumulative distribution function (cdf).
%   X=TINV(P,V) returns the inverse of Student's T cdf with V degrees
%   of freedom, at the values in P.
%
%   The size of X is the common size of P and V. A scalar input
%   functions as a constant matrix of the same size as the other input.
%
%   See also TCDF, TPDF, TRND, TSTAT, ICDF.

%   References:
%      [1]  M. Abramowitz and I. A. Stegun, "Handbook of Mathematical
%      Functions", Government Printing Office, 1964, 26.6.2

%   Copyright 1993-2009 The MathWorks, Inc.
%   $Revision: 1.1.8.1 $  $Date: 2010/03/16 00:17:47 $

if nargin < 2,
    error('stats:tinv:TooFewInputs','Requires two input arguments.');
end

[errorcode p v] = distchck(2,p,v);

if errorcode > 0
    error('stats:tinv:InputSizeMismatch',...
        'Requires non-scalar arguments to match in size.');
end

% Initialize Y to zero, or NaN for invalid d.f.
if isa(p,'single') || isa(v,'single')
    x = NaN(size(p),'single');
else
    x = NaN(size(p));
end

% The inverse cdf of 0 is -Inf, and the inverse cdf of 1 is Inf.
x(p==0 & v > 0) = -Inf;
x(p==1 & v > 0) = Inf;

k0 = (0<p & p<1) & (v > 0);

% Invert the Cauchy distribution explicitly
k = find(k0 & (v == 1));
if any(k)
    x(k) = tan(pi * (p(k) - 0.5));
end

% For small d.f., call betaincinv which uses Newton's method
k = find(k0 & (v < 1000));
if any(k)
    q = p(k) - .5;
    df = v(k);
    t = (abs(q) < .25);
    z = zeros(size(q),class(x));
    oneminusz = zeros(size(q),class(x));
    if any(t)
        % for z close to 1, compute 1-z directly to avoid roundoff
        oneminusz(t) = betaincinv(2.*abs(q(t)),0.5,df(t)/2,'lower');
        z(t) = 1 - oneminusz(t);
    end
    t = ~t; % (abs(q) >= .25);
    if any(t)
        z(t) = betaincinv(2.*abs(q(t)),df(t)/2,0.5,'upper');
        oneminusz(t) = 1 - z(t);
    end
    x(k) = sign(q) .* sqrt(df .* (oneminusz./z));
end

% For large d.f., use Abramowitz & Stegun formula 26.7.5
% k = find(p>0 & p<1 & ~isnan(x) & v >= 1000);
k = find(k0 & (v >= 1000));
if any(k)
    xn = norminv(p(k));
    df = v(k);
    x(k) = xn + (xn.^3+xn)./(4*df) + ...
        (5*xn.^5+16.*xn.^3+3*xn)./(96*df.^2) + ...
        (3*xn.^7+19*xn.^5+17*xn.^3-15*xn)./(384*df.^3) +...
        (79*xn.^9+776*xn.^7+1482*xn.^5-1920*xn.^3-945*xn)./(92160*df.^4);
end
end

function p = tcdf(x,v)
%TCDF   Student's T cumulative distribution function (cdf).
%   P = TCDF(X,V) computes the cdf for Student's T distribution
%   with V degrees of freedom, at the values in X.
%
%   The size of P is the common size of X and V. A scalar input
%   functions as a constant matrix of the same size as the other input.
%
%   See also TINV, TPDF, TRND, TSTAT, CDF.

%   References:
%      [1] M. Abramowitz and I. A. Stegun, "Handbook of Mathematical
%      Functions", Government Printing Office, 1964, 26.7.
%      [2] L. Devroye, "Non-Uniform Random Variate Generation",
%      Springer-Verlag, 1986
%      [3] E. Kreyszig, "Introductory Mathematical Statistics",
%      John Wiley, 1970, Section 10.3, pages 144-146.

%   Copyright 1993-2009 The MathWorks, Inc.
%   $Revision: 1.1.8.1 $  $Date: 2010/03/16 00:17:44 $

normcutoff = 1e7;
if nargin < 2,
    error('stats:tcdf:TooFewInputs','Requires two input arguments.');
end

[errorcode x v] = distchck(2,x,v);

if errorcode > 0
    error('stats:tcdf:InputSizeMismatch',...
        'Requires non-scalar arguments to match in size.');
end

% Initialize P.
if isa(x,'single') || isa(v,'single')
    p = NaN(size(x),'single');
else
    p = NaN(size(x));
end

nans = (isnan(x) | ~(0<v)); %  v==NaN ==> (0<v)==false
cauchy = (v == 1);
normal = (v > normcutoff);

% General case: first compute F(-|x|) < .5, the lower tail.
%
% See Abramowitz and Stegun, formulas and 26.7.1/26.5.27 and 26.5.2
general = ~(cauchy | normal | nans);
xsq = x.^2;
% For small v, form v/(v+x^2) to maintain precision
t = (v < xsq) & general;
if any(t(:))
    p(t) = betainc(v(t) ./ (v(t) + xsq(t)), v(t)/2, 0.5, 'lower') / 2;
end

% For large v, form x^2/(v+x^2) to maintain precision
t = (v >= xsq) & general;
if any(t(:))
    p(t) = betainc(xsq(t) ./ (v(t) + xsq(t)), 0.5, v(t)/2, 'upper') / 2;
end

% For x > 0, F(x) = 1 - F(-|x|).
xpos = (x > 0);
p(xpos) = 1 - p(xpos); % p < .5, cancellation not a problem

% Special case for Cauchy distribution.  See Devroye pages 29 and 450.
p(cauchy) = .5 + atan(x(cauchy))/pi;

% Normal Approximation for very large nu.
p(normal) = normcdf(x(normal));

% Make the result exact for the median.
p(x == 0 & ~nans) = 0.5;
end

function [p,plo,pup] = normcdf(x,mu,sigma,pcov,alpha)
%NORMCDF Normal cumulative distribution function (cdf).
%   P = NORMCDF(X,MU,SIGMA) returns the cdf of the normal distribution with
%   mean MU and standard deviation SIGMA, evaluated at the values in X.
%   The size of P is the common size of X, MU and SIGMA.  A scalar input
%   functions as a constant matrix of the same size as the other inputs.
%
%   Default values for MU and SIGMA are 0 and 1, respectively.
%
%   [P,PLO,PUP] = NORMCDF(X,MU,SIGMA,PCOV,ALPHA) produces confidence bounds
%   for P when the input parameters MU and SIGMA are estimates.  PCOV is a
%   2-by-2 matrix containing the covariance matrix of the estimated parameters.
%   ALPHA has a default value of 0.05, and specifies 100*(1-ALPHA)% confidence
%   bounds.  PLO and PUP are arrays of the same size as P containing the lower
%   and upper confidence bounds.
%
%   See also ERF, ERFC, NORMFIT, NORMINV, NORMLIKE, NORMPDF, NORMRND, NORMSTAT.

%   References:
%      [1] Abramowitz, M. and Stegun, I.A. (1964) Handbook of Mathematical
%          Functions, Dover, New York, 1046pp., sections 7.1, 26.2.
%      [2] Evans, M., Hastings, N., and Peacock, B. (1993) Statistical
%          Distributions, 2nd ed., Wiley, 170pp.

%   Copyright 1993-2010 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $  $Date: 2010/05/10 17:59:06 $

if nargin<1
    error('stats:normcdf:TooFewInputs','Input argument X is undefined.');
end
if nargin < 2
    mu = 0;
end
if nargin < 3
    sigma = 1;
end

% More checking if we need to compute confidence bounds.
if nargout>1
    if nargin<4
        error('stats:normcdf:TooFewInputs',...
            'Must provide covariance matrix to compute confidence bounds.');
    end
    if ~isequal(size(pcov),[2 2])
        error('stats:normcdf:BadCovariance',...
            'Covariance matrix must have 2 rows and columns.');
    end
    if nargin<5
        alpha = 0.05;
    elseif ~isnumeric(alpha) || numel(alpha)~=1 || alpha<=0 || alpha>=1
        error('stats:normcdf:BadAlpha',...
            'ALPHA must be a scalar between 0 and 1.');
    end
end

try
    z = (x-mu) ./ sigma;
catch
    error('stats:normcdf:InputSizeMismatch',...
        'Non-scalar arguments must match in size.');
end

% Prepare output
p = NaN(size(z),class(z));
if nargout>=2
    plo = NaN(size(z),class(z));
    pup = NaN(size(z),class(z));
end

% Set edge case sigma=0
p(sigma==0 & x<mu) = 0;
p(sigma==0 & x>=mu) = 1;
if nargout>=2
    plo(sigma==0 & x<mu) = 0;
    plo(sigma==0 & x>=mu) = 1;
    pup(sigma==0 & x<mu) = 0;
    pup(sigma==0 & x>=mu) = 1;
end

% Normal cases
if isscalar(sigma)
    if sigma>0
        todo = true(size(z));
    else
        return;
    end
else
    todo = sigma>0;
end
z = z(todo);

% Use the complementary error function, rather than .5*(1+erf(z/sqrt(2))),
% to produce accurate near-zero results for large negative x.
p(todo) = 0.5 * erfc(-z ./ sqrt(2));

% Compute confidence bounds if requested.
if nargout>=2
    zvar = (pcov(1,1) + 2*pcov(1,2)*z + pcov(2,2)*z.^2) ./ (sigma.^2);
    if any(zvar<0)
        error('stats:normcdf:BadCovariance',...
            'PCOV must be a positive semi-definite matrix.');
    end
    normz = -norminv(alpha/2);
    halfwidth = normz * sqrt(zvar);
    zlo = z - halfwidth;
    zup = z + halfwidth;
    
    plo(todo) = 0.5 * erfc(-zlo./sqrt(2));
    pup(todo) = 0.5 * erfc(-zup./sqrt(2));
end
end




function m = nanmean(x,dim)
%NANMEAN Mean value, ignoring NaNs.
%   M = NANMEAN(X) returns the sample mean of X, treating NaNs as missing
%   values.  For vector input, M is the mean value of the non-NaN elements
%   in X.  For matrix input, M is a row vector containing the mean value of
%   non-NaN elements in each column.  For N-D arrays, NANMEAN operates
%   along the first non-singleton dimension.
%
%   NANMEAN(X,DIM) takes the mean along dimension DIM of X.
%
%   See also MEAN, NANMEDIAN, NANSTD, NANVAR, NANMIN, NANMAX, NANSUM.

%   Copyright 1993-2004 The MathWorks, Inc.
%   $Revision: 1.1.8.1 $  $Date: 2010/03/16 00:15:50 $

% Find NaNs and set them to zero
nans = isnan(x);
x(nans) = 0;

if nargin == 1 % let sum deal with figuring out which dimension to use
    % Count up non-NaNs.
    n = sum(~nans);
    n(n==0) = NaN; % prevent divideByZero warnings
    % Sum up non-NaNs, and divide by the number of non-NaNs.
    m = sum(x) ./ n;
else
    % Count up non-NaNs.
    n = sum(~nans,dim);
    n(n==0) = NaN; % prevent divideByZero warnings
    % Sum up non-NaNs, and divide by the number of non-NaNs.
    m = sum(x,dim) ./ n;
end

end


function y = nanstd(varargin)
%NANSTD Standard deviation, ignoring NaNs.
%   Y = NANSTD(X) returns the sample standard deviation of the values in X,
%   treating NaNs as missing values.  For a vector input, Y is the standard
%   deviation of the non-NaN elements of X.  For a matrix input, Y is a row
%   vector containing the standard deviation of the non-NaN elements in
%   each column of X. For N-D arrays, NANSTD operates along the first
%   non-singleton dimension of X.
%
%   NANSTD normalizes Y by (N-1), where N is the sample size.  This is the
%   square root of an unbiased estimator of the variance of the population
%   from which X is drawn, as long as X consists of independent, identically
%   distributed samples and data are missing at random.
%
%   Y = NANSTD(X,1) normalizes by N and produces the square root of the
%   second moment of the sample about its mean.  NANSTD(X,0) is the same as
%   NANSTD(X).
%
%   Y = NANSTD(X,FLAG,DIM) takes the standard deviation along dimension
%   DIM of X.
%
%   See also STD, NANVAR, NANMEAN, NANMEDIAN, NANMIN, NANMAX, NANSUM.

%   Copyright 1993-2006 The MathWorks, Inc.
%   $Revision: 1.1.8.1 $  $Date: 2010/03/16 00:15:53 $

% Call nanvar(x,flag,dim) with as many inputs as needed
y = sqrt(nanvar(varargin{:}));
end


function y = nanvar(x,w,dim)
%NANVAR Variance, ignoring NaNs.
%   Y = NANVAR(X) returns the sample variance of the values in X, treating
%   NaNs as missing values.  For a vector input, Y is the variance of the
%   non-NaN elements of X.  For a matrix input, Y is a row vector
%   containing the variance of the non-NaN elements in each column of X.
%   For N-D arrays, NANVAR operates along the first non-singleton dimension
%   of X.
%
%   NANVAR normalizes Y by N-1 if N>1, where N is the sample size of the
%   non-NaN elements.  This is an unbiased estimator of the variance of the
%   population from which X is drawn, as long as X consists of independent,
%   identically distributed samples, and data are missing at random.  For
%   N=1, Y is normalized by N.
%
%   Y = NANVAR(X,1) normalizes by N and produces the second moment of the
%   sample about its mean.  NANVAR(X,0) is the same as NANVAR(X).
%
%   Y = NANVAR(X,W) computes the variance using the weight vector W.  The
%   length of W must equal the length of the dimension over which NANVAR
%   operates, and its non-NaN elements must be nonnegative.  Elements of X
%   corresponding to NaN elements of W are ignored.
%
%   Y = NANVAR(X,W,DIM) takes the variance along dimension DIM of X.
%
%   See also VAR, NANSTD, NANMEAN, NANMEDIAN, NANMIN, NANMAX, NANSUM.

%   Copyright 1984-2005 The MathWorks, Inc.
%   $Revision: 1.1.8.1 $  $Date: 2010/03/16 00:15:55 $

if nargin < 2 || isempty(w), w = 0; end

sz = size(x);
if nargin < 3 || isempty(dim)
    % The output size for [] is a special case when DIM is not given.
    if isequal(x,[]), y = NaN(class(x)); return; end
    
    % Figure out which dimension sum will work along.
    dim = find(sz ~= 1, 1);
    if isempty(dim), dim = 1; end
elseif dim > length(sz)
    sz(end+1:dim) = 1;
end

% Need to tile the mean of X to center it.
tile = ones(size(sz));
tile(dim) = sz(dim);

if isequal(w,0) || isequal(w,1)
    % Count up non-NaNs.
    n = sum(~isnan(x),dim);
    
    if w == 0
        % The unbiased estimator: divide by (n-1).  Can't do this when
        % n == 0 or 1, so n==1 => we'll return zeros
        denom = max(n-1, 1);
    else
        % The biased estimator: divide by n.
        denom = n; % n==1 => we'll return zeros
    end
    denom(n==0) = NaN; % Make all NaNs return NaN, without a divideByZero warning
    
    x0 = x - repmat(nanmean(x, dim), tile);
    y = nansum(abs(x0).^2, dim) ./ denom; % abs guarantees a real result
    
    % Weighted variance
elseif numel(w) ~= sz(dim)
    error('MATLAB:nanvar:InvalidSizeWgts','The length of W must be compatible with X.');
elseif ~(isvector(w) && all(w(~isnan(w)) >= 0))
    error('MATLAB:nanvar:InvalidWgts','W must be a vector of nonnegative weights, or a scalar 0 or 1.');
else
    % Embed W in the right number of dims.  Then replicate it out along the
    % non-working dims to match X's size.
    wresize = ones(size(sz)); wresize(dim) = sz(dim);
    wtile = sz; wtile(dim) = 1;
    w = repmat(reshape(w, wresize), wtile);
    
    % Count up non-NaNs.
    n = nansum(~isnan(x).*w,dim);
    
    x0 = x - repmat(nansum(w.*x, dim) ./ n, tile);
    y = nansum(w .* abs(x0).^2, dim) ./ n; % abs guarantees a real result
end
end

function y = nansum(x,dim)
%NANSUM Sum, ignoring NaNs.
%   Y = NANSUM(X) returns the sum of X, treating NaNs as missing values.
%   For vector input, Y is the sum of the non-NaN elements in X.  For
%   matrix input, Y is a row vector containing the sum of non-NaN elements
%   in each column.  For N-D arrays, NANSUM operates along the first
%   non-singleton dimension.
%
%   Y = NANSUM(X,DIM) takes the sum along dimension DIM of X.
%
%   See also SUM, NANMEAN, NANVAR, NANSTD, NANMIN, NANMAX, NANMEDIAN.

%   Copyright 1993-2004 The MathWorks, Inc.
%   $Revision: 1.1.8.1 $  $Date: 2010/03/16 00:15:54 $

% Find NaNs and set them to zero.  Then sum up non-NaNs.  Cols of all NaNs
% will return zero.
x(isnan(x)) = 0;
if nargin == 1 % let sum figure out which dimension to work along
    y = sum(x);
else           % work along the explicitly given dimension
    y = sum(x,dim);
end
end

function [errorcode,varargout] = distchck(nparms,varargin)
%DISTCHCK Checks the argument list for the probability functions.

%   Copyright 1993-2004 The MathWorks, Inc.
%   $Revision: 1.1.8.1 $  $Date: 2010/03/16 00:13:22 $

errorcode = 0;
varargout = varargin;

if nparms == 1
    return;
end

% Get size of each input, check for scalars, copy to output
isscalar = (cellfun('prodofsize',varargin) == 1);

% Done if all inputs are scalars.  Otherwise fetch their common size.
if (all(isscalar)), return; end

n = nparms;

for j=1:n
    sz{j} = size(varargin{j});
end
t = sz(~isscalar);
size1 = t{1};

% Scalars receive this size.  Other arrays must have the proper size.
for j=1:n
    sizej = sz{j};
    if (isscalar(j))
        vj = varargin{j};
        if isnumeric(vj)
            t = zeros(size1,class(vj));
        else
            t = zeros(size1);
        end
        t(:) = varargin{j};
        varargout{j} = t;
    elseif (~isequal(sizej,size1))
        errorcode = 1;
        return;
    end
end
end