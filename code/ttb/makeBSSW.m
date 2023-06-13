function W  = makeBSSW(X,p,exl,th)

% fo  filter order    (pnt)
% exl extra xcorr length (pnt)
% th  exit thershold 0.1%=1e-3

nsig    = size(X,2);
disp(['makeBSSW: nsig=',num2str(nsig),' p+1=',num2str(p+1),' exl=',num2str(exl),' th=',num2str(th)])

% generate the cross-correlation matrices `M' and `R(0)'
% using separating filter length 11, i.e q=10
%
% extra correlation lags= 25, i.e. -l  = l  = (10+25)=35
%                                    1    2
% [M,R]=gen_mr(10,25,X);

[M,R]   = gen_mr(p,exl,X);
disp('gen_mr')

% Estimate the separating filter W using extended constant diagonal algorithm
% (4,4,10,25,1e-3,M,R)
% no. of sources = 4
% no. of sensors = 4
% filter order = 10
% extra x-correlation lag = 25
% exit thershold 0.1%=1e-3
% x-correlation matrix M = M
% x-correlation matrix R(0) = R
% W=ecda(4,4,10,25,1e-3,M,R);


W   = ecda(nsig,nsig,p,exl,th,M,R);
% W   =  cda(nsig,nsig,p,exl,th,M,R);
% W   =  cpa(nsig,nsig,p,exl,th,M,R);


disp('ecda')
% convert vector form of W to matrix form.
% W_b=w2w(no.of sources, W);
W       = w2w(nsig,W);

disp('w2w')