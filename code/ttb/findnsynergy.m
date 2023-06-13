% function [nsynergy,mse]    = findnsynergy
method  = 'fitshuffle';
% method  = 'ttest';
% method  = 'diff2';
% method  = 'chueng2009'
% method  = 'chueng2005'


% 
% [S,filename]=topen;
% 
figure('Numbertitle','off','Name',filename);
hAx = gca;
% 
% 
% 
% testr2= mean(S.test.r2,2)';
% shuffler2= mean(S.shuffle.r2,2)';
% 
% testr2slope= mean(S.test.r2slope,2)';
% shuffler2slope= mean(S.shuffle.r2slope,2)';


plot(hAx,testr2,'b-o')
hold on

plot(hAx,shuffler2,'r-o')


switch method
    case 'fitshuffle'
        th  = 10^-5;
        nn  = length(testr2);
                
        mse = nan(1,nn);
        for ii=1:nn
            Y   = testr2(ii:nn);
            X   = shuffler2(ii:nn);
            A   = Y/[X;ones(size(X))];
            Yhat    = A*[X;ones(size(X))];
            mse(ii) = mean((Y-Yhat).^2);
        end
        
        nsynergy = find(mse<th,1,'first');
        
        Y   = testr2(nsynergy:nn);
        X   = shuffler2(nsynergy:nn);
        A   = Y/[X;ones(size(X))];
        X   = shuffler2;
        Yhat    = A*[X;ones(size(X))];
        plot(hAx,1:nn,Yhat,'k-')
        
        
        
    case 'diff2'
        nn  = length(testr2);
        alpha   = 0.05./nn;
        
        difftestr2slope = [S.test.r2slope(1,:);diff(S.test.r2slope,1,1)];
        
        p   = nan(1,nn);
        h   = nan(1,nn);
        
        for ii=1:nn
            [h(ii),p(ii)]   = ttest(difftestr2slope(ii,:));
            h2(ii)   = p(ii)>=alpha;
        end
        nsynergy    = find(h2,1,'first')-1;
        
        bar(2:nn,mean(difftestr2slope(2:nn,:),2)','Parent',hAx)
        
    case 'ttest'
        th  = 0.75;
        nn  = length(testr2);
        alpha   = 0.05./nn;
        
        p   = nan(1,nn);
        h   = nan(1,nn);
        
        for ii=1:nn
        [h(ii),p(ii)]   = ttest2(S.test.r2slope(ii,:),S.shuffle.r2slope(ii,:)*th,alpha/2,'left');
        end
        nsynergy    = find(h,1,'first')-1;
        
        bar(2:nn,[testr2slope(2:nn);shuffler2slope(2:nn);shuffler2slope(2:nn)*th]','Parent',hAx)
        
    case 'chueng2009'
        th  = 0.75;
        nsynergy    = find(testr2slope<th.*shuffler2slope,1,'first')-1;
        bar([testr2slope;shuffler2slope;shuffler2slope*th]','Parent',hAx)
        
        
    case 'chueng2005'
        th  = 10^-5;
        
        nn  = length(testr2);
        mse = nan(1,nn);
        for ii=1:nn
            %% test
            Y   = testr2(ii:nn);
            X   = ii:nn;
            A   = Y/[X;ones(size(X))];
            Xhat    = ii:nn;
            Yhat    = A*[Xhat;ones(size(Xhat))];
            mse(ii) = mean((Y-Yhat).^2);
            
            
        end
        
        nsynergy = find(mse<th,1,'first');
        
        
        
        
        Y   = testr2(nsynergy:nn);
        X   = nsynergy:nn;
        A   = Y/[X;ones(size(X))];
        Xhat    = 1:nn;
        Yhat    = A*[Xhat;ones(size(Xhat))];
        plot(hAx,Xhat,Yhat,'k-')
end


plot(nsynergy,testr2(nsynergy),'k*')
