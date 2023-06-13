function [Yhat,E]  = segfit(X,Y,BP,method)

% 区分的線形フィット
% BP: break point

[Y,nshift]  = shiftdim(Y);
X           = shiftdim(X);

N   = length(Y);
nBP = length(BP);


switch method
    case 'exclude'
        % Build regressor with linear pieces + DCs
        % 1~BPまでとBP+1~endまでで別々にRegressionする。
        BP  = [0,BP,N];
        A   = zeros(N,2*(nBP+1));
        
        for iBP =1:(nBP+1)
            ind = (BP(iBP)+1):BP(iBP+1);
            M   = length(ind);
            A(ind,iBP*2-1)  = X(ind);
            A(ind,iBP*2)    = ones(M,1);
        end
        
        P   = A\Y;
        Yhat= A*P;
        E   = Y-Yhat;
        
        Yhat= shiftdim(Yhat,-nshift);
        E   = shiftdim(E,-nshift);
        
        
    case 'detrend'
        % Build regressor with linear pieces + DCs
        % detrend(x,'linear',bp)と同じ方法
        BP  = [0,BP,N];
        A   = [zeros(N,nBP+1),ones(N,1)];
        
        for iBP =1:(nBP+1)
            ind = (BP(iBP)+1):BP(end);
            M   = length(ind);
            A(ind,iBP)      = (1:M)'./M;
        end
        
        P   = A\Y;
        Yhat= A*P;
        E   = Y-Yhat;
        
        Yhat= shiftdim(Yhat,-nshift);
        E   = shiftdim(E,-nshift);
        
    case 'include'
        % Build regressor with linear pieces + DCs
        % 1~BPまでとBP~endまでで別々にRegressionする。
        BP      = [1,BP,N];
        Yhat    = nan(N,nBP+1);
        E       = nan(N,nBP+1);
        
        for iBP =1:(nBP+1)
            A   = zeros(N,2);
            
            ind = BP(iBP):BP(iBP+1);
            M   = length(ind);
            A(ind,1)    = X(ind);
            A(ind,2)    = ones(M,1);
            
            P       = A\Y;
            Yhat(:,iBP)   = A*P;
            E(ind,iBP)      = Y(ind)-Yhat(ind,iBP);
        end
        
        
        if(nshift==1)
            Yhat= Yhat';
            E   = E';
        end
        
end

