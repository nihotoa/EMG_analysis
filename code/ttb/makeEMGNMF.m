function [Y,Y_dat]  = makeEMGNMF(X,kf,nrep,nshuffle,alg)

% [Y,Y_dat]  = makeEMGNMF(X,kf,nrep,nshuffle,alg);
%
% kf  :  k-fold cross-validationの数(k) データをk個のセグメントに分けて、そのひとつをtestに使い、他をtrainに使う。
% そのため、Y.train.r2 などはk個分できるので、最終的にはそれを平均して使う。
% kf=1とすると、cross-validationを行わない。
%
% nrep:   optimaizationがLocalMinimaに陥らないために何回か繰り返して、一番誤差の少ない値を使う（例、10）
% nshuffle:   元データシャッフルしたデータで同じ解析を行うことを何回繰り返すかを指定（例、1）
% alg:     algorithm mult or als
%
% ex
% [Y,Y_dat]  = makeEMGNMF(X,4,10,1,'mult');


if(nargin<2)
    kf          = 4;
    nrep        = 10;
    nshuffle    = 1;
    alg         = 'mult';   % 'mult' or 'als'
elseif(nargin<3)
    nrep        = 10;
    nshuffle    = 1;
    alg         = 'mult';
elseif(nargin<4)
    nshuffle    = 1;
    alg         = 'mult';
elseif(nargin<5)
    alg         = 'mult';
end

% NMF用に転置する
[mm,nn]   = size(X);    % mm channels x nn data length

Y_dat.train.W     = cell(mm,kf);
% Y_dat.train.H     = cell(mm,kf);
% Y_dat.train.D     = cell(mm,kf);
Y_dat.test.W     = cell(mm,kf);
% Y_dat.test.H     = cell(mm,kf);
% Y_dat.test.D     = cell(mm,kf);

Y.nrep      = nrep;
Y.nshuffle  = nshuffle;
Y.algorithm = alg;
Y.train.latent       = nan(mm,kf);
Y.train.explained    = nan(mm,kf);
Y.train.r2           = nan(mm,kf);
Y.train.r2slope      = nan(mm,kf);
Y.test.latent        = nan(mm,kf);
Y.test.explained     = nan(mm,kf);
Y.test.r2            = nan(mm,kf);
Y.test.r2slope       = nan(mm,kf);


% X   = normalize(X,'mean');

for ii=1:mm
    disp([num2str(ii),'/',num2str(mm),' number of NMF'])
    
    
    % k-fold cross-validation
    if(kf>1)
        kfind   = false(kf,nn);
        for ikf=1:kf
            kfind(ikf,((ikf-1)*floor(nn./kf)+1):(ikf*floor(nn./kf))) = true;
        end
        
        for ikf=1:kf
            disp([num2str(ikf),'/',num2str(kf),' k-fold cross-validation'])
            
            % train
            XX  = X(:,~kfind(ikf,:));
            %         XX  = normalize(XX,'mean');
            %         [Y_dat.train.W{ii,ikf},Y_dat.train.H{ii,ikf},Y_dat.train.D{ii,ikf}]   = nnmf2(XX,ii,[],[],nrep,alg,'wh','mean');
            %         [Y_dat.train.W{ii,ikf},H]   = nnmf2(XX,ii,[],[],nrep,alg,'wh','mean');
            [Y_dat.train.W{ii,ikf},H]   = nnmf2(XX,ii,[],[],nrep,alg,'wh','none','mean');
            
            
            %         Xhat            = Y_dat.train.W{ii,ikf}*Y_dat.train.H{ii,ikf};
            Xhat            = Y_dat.train.W{ii,ikf}*H;
            E               = Xhat-XX;
            SSE             = sum(reshape(E,numel(E),1).^2);
            SST             = sum((reshape(XX,numel(XX),1)-mean(reshape(XX,numel(XX),1))).^2);
            Y.train.r2(ii,ikf)        = 1 - SSE./SST;     % Roh et al (2011) "Modules in the Brainstem and Spinal Cord Underlying Motor Behaviors" JNP
            
            Xvar            = var(reshape(XX,numel(XX),1),0);
            Y.train.latent(ii,ikf)    = var(reshape(Xhat,numel(Xhat),1),0);
            Y.train.explained(ii,ikf) = Y.train.latent(ii,ikf) / Xvar;
            
            % test
            XX  = X(:,kfind(ikf,:));
            %         XX  = normalize(XX,'mean');
            %         [Y_dat.test.W{ii,ikf},Y_dat.test.H{ii,ikf},Y_dat.test.D{ii,ikf}]   = nnmf2(XX,ii,Y_dat.train.W{ii,ikf},[],nrep,alg,'h','none');
            [Y_dat.test.W{ii,ikf},H]   = nnmf2(XX,ii,Y_dat.train.W{ii,ikf},[],nrep,alg,'h','none','none');
            
            % % %         Xhat            = Y_dat.test.W{ii,ikf}*Y_dat.test.H{ii,ikf};
            Xhat            = Y_dat.test.W{ii,ikf}*H;
            E               = Xhat-XX;
            SSE             = sum(reshape(E,numel(E),1).^2);
            SST             = sum((reshape(XX,numel(XX),1)-mean(reshape(XX,numel(XX),1))).^2);
            Y.test.r2(ii,ikf)        = 1 - SSE./SST;     % Roh et al (2011) "Modules in the Brainstem and Spinal Cord Underlying Motor Behaviors" JNP
            
            Xvar            = var(reshape(XX,numel(XX),1),0);
            Y.test.latent(ii,ikf)    = var(reshape(Xhat,numel(Xhat),1),0);
            Y.test.explained(ii,ikf) = Y.test.latent(ii,ikf) / Xvar;
            
        end
    else % without k-fold cross-validation
        ikf = 1;
        
        % train
        XX  = X;
        %         XX  = normalize(XX,'mean');
        %         [Y_dat.train.W{ii,ikf},Y_dat.train.H{ii,ikf},Y_dat.train.D{ii,ikf}]   = nnmf2(XX,ii,[],[],nrep,alg,'wh','mean');
        %         [Y_dat.train.W{ii,ikf},H]   = nnmf2(XX,ii,[],[],nrep,alg,'wh','mean');
        [Y_dat.train.W{ii,ikf},H]   = nnmf2(XX,ii,[],[],nrep,alg,'wh','none','mean');
        
        
        %         Xhat            = Y_dat.train.W{ii,ikf}*Y_dat.train.H{ii,ikf};
        Xhat            = Y_dat.train.W{ii,ikf}*H;
        E               = Xhat-XX;
        SSE             = sum(reshape(E,numel(E),1).^2);
        SST             = sum((reshape(XX,numel(XX),1)-mean(reshape(XX,numel(XX),1))).^2);
        Y.train.r2(ii,ikf)        = 1 - SSE./SST;     % Roh et al (2011) "Modules in the Brainstem and Spinal Cord Underlying Motor Behaviors" JNP
        
        Xvar            = var(reshape(XX,numel(XX),1),0);
        Y.train.latent(ii,ikf)    = var(reshape(Xhat,numel(Xhat),1),0);
        Y.train.explained(ii,ikf) = Y.train.latent(ii,ikf) / Xvar;
        
        % test
        XX  = X;
        %         XX  = normalize(XX,'mean');
        %         [Y_dat.test.W{ii,ikf},Y_dat.test.H{ii,ikf},Y_dat.test.D{ii,ikf}]   = nnmf2(XX,ii,Y_dat.train.W{ii,ikf},[],nrep,alg,'h','none');
        [Y_dat.test.W{ii,ikf},H]   = nnmf2(XX,ii,Y_dat.train.W{ii,ikf},[],nrep,alg,'h','none','none');
        
        % % %         Xhat            = Y_dat.test.W{ii,ikf}*Y_dat.test.H{ii,ikf};
        Xhat            = Y_dat.test.W{ii,ikf}*H;
        E               = Xhat-XX;
        SSE             = sum(reshape(E,numel(E),1).^2);
        SST             = sum((reshape(XX,numel(XX),1)-mean(reshape(XX,numel(XX),1))).^2);
        Y.test.r2(ii,ikf)        = 1 - SSE./SST;     % Roh et al (2011) "Modules in the Brainstem and Spinal Cord Underlying Motor Behaviors" JNP
        
        Xvar            = var(reshape(XX,numel(XX),1),0);
        Y.test.latent(ii,ikf)    = var(reshape(Xhat,numel(Xhat),1),0);
        Y.test.explained(ii,ikf) = Y.test.latent(ii,ikf) / Xvar;
        
    end
end
Y.train.r2slope  = [Y.train.r2(1,:); diff(Y.train.r2,1,1)];
Y.test.r2slope   = [Y.test.r2(1,:); diff(Y.test.r2,1,1)];




if(nshuffle>0)
    % shuffleでもtrain-testを行うが、testの時のデータのみを出力する。
    
    Y.shuffle.latent    = nan(mm,kf,nshuffle);
    Y.shuffle.explained = nan(mm,kf,nshuffle);
    Y.shuffle.r2        = nan(mm,kf,nshuffle);
    Y.shuffle.r2slope   = nan(mm,kf,nshuffle);
    Y_dat.shuffle.W     = cell(mm,kf,nshuffle);
    
    rand('state',0) % ランダムで選ぶけど、いつも同じセットが出るようにしているということ
    
    for ishuffle=1:nshuffle
        disp(['shuffle: ',num2str(ishuffle),'/',num2str(nshuffle)])
        Xshuf  = X;
        
%         % (1) shuffling across time
%         for ii=1:mm
%             Xshuf(ii,:)    = X(ii,randperm(nn));
%         end
%         disp('shuffling across time')
        
%         % (2) shuffling across time and muscles (Cheung et al 2009 PNAS)
%         Xshuf   = reshape(Xshuf,numel(Xshuf),1);
        Xshuf   = Xshuf(randperm(numel(Xshuf)));
        Xshuf   = reshape(Xshuf,size(X,1),size(X,2));
        disp('shuffling across time and muscles')

        
        
        %     Xvar    = var(reshape(Xshuf,numel(Xshuf),1),0);
        for ii=1:mm
            disp(['shuffle: ',num2str(ii),'/',num2str(mm)])
            
            if(ikf>1)
                % k-fold cross-validation
                kfind   = false(kf,nn);
                for ikf=1:kf
                    kfind(ikf,((ikf-1)*floor(nn./kf)+1):(ikf*floor(nn./kf))) = true;
                end
                
                for ikf=1:kf
                    disp([num2str(ikf),'/',num2str(kf),' k-fold cross-validation'])
                    
                    % train
                    XX  = Xshuf(:,~kfind(ikf,:));
                    %             XX  = normalize(XX,'mean');
                    [W,H]   = nnmf2(XX,ii,[],[],nrep,alg,'wh','none','mean');
                    Y_dat.shuffle.W{ii,ikf,ishuffle}    = W;
                    
                    % test
                    XX  = Xshuf(:,kfind(ikf,:));
                    %             XX  = normalize(XX,'mean');
                    [W,H]   = nnmf2(XX,ii,W,[],nrep,alg,'h','none','none');
                    
                    
                    Xhat            = W*H;
                    E               = Xhat-XX;
                    SSE             = sum(reshape(E,numel(E),1).^2);
                    SST             = sum((reshape(XX,numel(XX),1)-mean(reshape(XX,numel(XX),1))).^2);
                    Y.shuffle.r2(ii,ikf,ishuffle)        = 1 - SSE./SST;     % Roh et al (2011) "Modules in the Brainstem and Spinal Cord Underlying Motor Behaviors" JNP
                    
                    Xvar            = var(reshape(XX,numel(XX),1),0);
                    Y.shuffle.latent(ii,ikf,ishuffle)    = var(reshape(Xhat,numel(Xhat),1),0);
                    Y.shuffle.explained(ii,ikf,ishuffle) = Y.shuffle.latent(ii,ikf,ishuffle) / Xvar;
                    
                    
                    
                    
                end
                
                
            else % without crossvalidation
                ikf = 1;
                
                % train
                XX  = Xshuf;
                %             XX  = normalize(XX,'mean');
                [W,H]   = nnmf2(XX,ii,[],[],nrep,alg,'wh','none','mean');
                Y_dat.shuffle.W{ii,ikf,ishuffle}    = W;
                
                % test
                XX  = Xshuf;
                %             XX  = normalize(XX,'mean');
                [W,H]   = nnmf2(XX,ii,W,[],nrep,alg,'h','none','none');
                
                
                Xhat            = W*H;
                E               = Xhat-XX;
                SSE             = sum(reshape(E,numel(E),1).^2);
                SST             = sum((reshape(XX,numel(XX),1)-mean(reshape(XX,numel(XX),1))).^2);
                Y.shuffle.r2(ii,ikf,ishuffle)        = 1 - SSE./SST;     % Roh et al (2011) "Modules in the Brainstem and Spinal Cord Underlying Motor Behaviors" JNP
                
                Xvar            = var(reshape(XX,numel(XX),1),0);
                Y.shuffle.latent(ii,ikf,ishuffle)    = var(reshape(Xhat,numel(Xhat),1),0);
                Y.shuffle.explained(ii,ikf,ishuffle) = Y.shuffle.latent(ii,ikf,ishuffle) / Xvar;
                
                
                
                
                
            end
            
            
            
        end
        Y.shuffle.r2slope(:,:,ishuffle) = [Y.shuffle.r2(1,:,ishuffle); diff(Y.shuffle.r2(:,:,ishuffle),1,1)];
        
    end
    
end