function [Y,Y_dat]  = makeEMGNMFOhta(X,kf,nrep,nshuffle,alg,normalization_method)
%Yは筋シナジーの寄与率や、シャッフルした後の寄与率についての情報等が入っているY_datは、各筋シナジー数における筋シナジーのWとHが入っている
% [Y,Y_dat]  = makeEMGNMF(X,kf,nrep,nshuffle,alg);
% 
% kf  :  k-fold cross-validationの数(k) データをk個のセグメントに分けて、そのひとつをtestに使い、他をtrainに使う。
% そのため、Y.train.r2 などはk個分できるので、最終的にはそれを平均して使う。
% kf=1とすると、cross-validationを行わない。
% 
% ex
% [Y,Y_dat]  = makeEMGNMF(X,4,10,1,'mult');


if(nargin<2)
    kf          = 4;  %ここの値によって、クロスバリデーションを行うか否か、行う場合の分割数を決定できる
    nrep        = 5;
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

if kf > 1 %クロスバリデーションするとき
    Y_dat.train.W     = cell(mm,kf);
    Y_dat.train.H     = cell(mm,kf);
    Y_dat.train.D     = cell(mm,kf);
    Y_dat.test.W     = cell(mm,kf);
    Y_dat.test.H     = cell(mm,kf);
    Y_dat.test.D     = cell(mm,kf);
    
    
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
else %しないとき
    Y_dat.W     = cell(mm,kf);
    Y_dat.H     = cell(mm,kf);
    Y_dat.D     = cell(mm,kf);

    Y.nrep      = nrep;
    Y.nshuffle  = nshuffle;
    Y.algorithm = alg;
    Y.latent       = nan(mm,kf);
    Y.explained    = nan(mm,kf);
    Y.r2           = nan(mm,kf);
    Y.r2slope      = nan(mm,kf);
end

X   = normalize(X,normalization_method);
 
for ii=1:mm %mm:使用する筋電の数(筋シナジーの数)
    disp([num2str(ii),'/',num2str(mm),' number of NMF'])
    % k-fold cross-validation
    if kf > 1 %クロスバリデーションするとき
        kfind   = false(kf,nn); %logical値0をkf*nnのサイズで作成し、kfindに代入
        for ikf=1:kf
            kfind(ikf,((ikf-1)*floor(nn./kf)+1):(ikf*floor(nn./kf))) = true; %kf = 4の場合、1行目の前半1/4にlogical値1入り、2行目の(1/4)+1 : 1/2までにlogical値1が入る
        end
    
        for ikf=1:kf
            disp([num2str(ikf),'/',num2str(kf),' k-fold cross-validation'])
            
            % train
    
            XX  = X(:,~kfind(ikf,:)); %分けたとき多数派のデータが入る(4分割なら3/4データの方)
            XX  = normalize(XX,normalization_method); %新しいデータの平均で正規化
           [Y_dat.train.W{ii,ikf},Y_dat.train.H{ii,ikf},Y_dat.train.D{ii,ikf}]   = nnmf2(XX,ii,[],[],nrep,alg,'wh',normalization_method); %乗法更新則を加味したnmf(大屋作)
    %       [Y_dat.train.W{ii,ikf},H]   = nnmf2(XX,ii,[],[],nrep,alg,'wh',normalization_method);
    %Y_dat→train→Wの{筋シナジーの数,ikf個目のデータセット}にその筋シナジー数の空間基底
    
            
             
             Xhat            = Y_dat.train.W{ii,ikf}*Y_dat.train.H{ii,ikf}; %最終的なwとhから再構成された筋電
    %        Xhat            = Y_dat.train.W{ii,ikf}*H;
            E               = Xhat-XX; %計測筋電と再構成筋電との偏差
            SSE             = sum(reshape(E,numel(E),1).^2);
            SST             = sum((reshape(XX,numel(XX),1)-mean(mean(XX))).^2);
            Y.train.r2(ii,ikf)        = 1 - SSE./SST;     % Roh et al (2010) JNP (最終的な筋シナジーから計算された寄与率)
            
           % Xvar            = var(reshape(XX,numel(XX),1),0);
             Xvar = sum(var(XX,1,2)); %計測筋電の各筋肉の筋電の分散を足し合わせたもの
           %Y.train.latent(ii,ikf)    = var(reshape(Xhat,numel(Xhat),1),0);
             Y.train.latent(ii,ikf) = sum(var(Xhat,1,2)); %再構成筋電の各筋肉の筋電の分散を足し合わせたもの
           Y.train.explained(ii,ikf) = Y.train.latent(ii,ikf) / Xvar; %(再構成筋電分散/計測筋電分散)寄与率みたいなもの?
            
            % test(cross-validしないなら要らない)
            
            XX  = X(:,kfind(ikf,:));
            XX  = normalize(XX,normalization_method);
             [Y_dat.test.W{ii,ikf},Y_dat.test.H{ii,ikf},Y_dat.test.D{ii,ikf}]   = nnmf2(XX,ii,Y_dat.train.W{ii,ikf},[],nrep,alg,'wh','none');
    %        [Y_dat.test.W{ii,ikf},H]   = nnmf2(XX,ii,Y_dat.train.W{ii,ikf},[],nrep,alg,'h','none');
            
             Xhat            = Y_dat.test.W{ii,ikf}*Y_dat.test.H{ii,ikf};
    %        Xhat            = Y_dat.test.W{ii,ikf}*H;
            E               = Xhat-XX;
            SSE             = sum(reshape(E,numel(E),1).^2);
            SST             = sum((reshape(XX,numel(XX),1)-mean(mean(XX))).^2);
            Y.test.r2(ii,ikf)        = 1 - SSE./SST;     % Roh et al (2010) JNP
            
           % Xvar            = var(reshape(XX,numel(XX),1),0);
            Xvar = sum(var(XX,1,2));
           % Y.test.latent(ii,ikf)    = var(reshape(Xhat,numel(Xhat),1),0);
            Y.test.latent(ii,ikf)    = sum(var(Xhat,1,2));
           Y.test.explained(ii,ikf) = Y.test.latent(ii,ikf) / Xvar;
            
            
            
            
        end
    else
        XX  = X; %クロスバリデーションのテンプレを使用するために,XをXXに代入
        XX  = normalize(XX,normalization_method); %新しいデータの平均で正規化
        [Y_dat.W{ii,1},Y_dat.H{ii,1},Y_dat.D{ii,1}]   = nnmf2(XX,ii,[],[],nrep,alg,'wh',normalization_method); %乗法更新則を加味したnmf(大屋作)
        %[Y_dat.train.W{ii,1},H]   = nnmf2(XX,ii,[],[],nrep,alg,'wh',normalization_method);
        %Y_dat→train→Wの{筋シナジーの数,1}にその筋シナジー数の空間基底(データセット分けてないから、列数は1)
        Xhat = Y_dat.W{ii,1}*Y_dat.H{ii,1}; %最終的なwとhから再構成された筋電
        %Xhat= Y_dat.train.W{ii,ikf}*H;
        E = Xhat-XX; %計測筋電と再構成筋電との偏差
        SSE = sum(reshape(E,numel(E),1).^2);
        SST = sum((reshape(XX,numel(XX),1)-mean(mean(XX))).^2);
        Y.r2(ii,1) = 1 - SSE./SST;     % Roh et al (2010) JNP (最終的な筋シナジーから計算された寄与率)
            
       % Xvar            = var(reshape(XX,numel(XX),1),0);
       Xvar = sum(var(XX,1,2)); %計測筋電の各筋肉の筋電の分散を足し合わせたもの
       %Y.train.latent(ii,ikf)    = var(reshape(Xhat,numel(Xhat),1),0);
       Y.latent(ii,1) = sum(var(Xhat,1,2)); %再構成筋電の各筋肉の筋電の分散を足し合わせたもの
       Y.explained(ii,1) = Y.latent(ii,1) / Xvar; %(再構成筋電分散/計測筋電分散)寄与率みたいなもの?
    end
end

if kf > 1 %クロスバリデーション行う場合
    Y.train.r2slope  = [Y.train.r2(1,:); diff(Y.train.r2,1,1)];
    Y.test.r2slope   = [Y.test.r2(1,:); diff(Y.test.r2,1,1)];
else %行わない場合
    Y.r2slope  = [Y.r2(1,:); diff(Y.r2,1,1)];
end

if(nshuffle>0)
% shuffleでもtrain-testを行うが、testの時のデータのみを出力する。

    Y.shuffle.latent    = nan(mm,kf,nshuffle);  
    Y.shuffle.explained = nan(mm,kf,nshuffle);
    Y.shuffle.r2        = nan(mm,kf,nshuffle);
    Y.shuffle.r2slope   = nan(mm,kf,nshuffle);
    
    for ishuffle=1:nshuffle
        disp(['shuffle: ',num2str(ishuffle),'/',num2str(nshuffle)])
        Xshuf  = X;
        
        for ii=1:mm
            Xshuf(ii,:)    = X(ii,randperm(nn));
        end
        
    %     Xvar    = var(reshape(Xshuf,numel(Xshuf),1),0);
    
        for ii=1:mm
            disp(['shuffle: ',num2str(ii),'/',num2str(mm)])
            
            
            % k-fold cross-validation
            if kf > 1
                kfind   = false(kf,nn);
                for ikf=1:kf
                    kfind(ikf,((ikf-1)*floor(nn./kf)+1):(ikf*floor(nn./kf))) = true;
                end
                
                for ikf=1:kf
                    disp([num2str(ikf),'/',num2str(kf),' k-fold cross-validation'])
                    
                    % train
                    XX  = Xshuf(:,~kfind(ikf,:));
                    XX  = normalize(XX,normalization_method);
                    [W,H]   = nnmf2(XX,ii,[],[],nrep,alg,'wh',normalization_method);
                    
                    % test
                    XX  = Xshuf(:,kfind(ikf,:));
                    XX  = normalize(XX,normalization_method);
                    [W,H]   = nnmf2(XX,ii,W,[],nrep,alg,'h','none');
                    
                    
                    Xhat            = W*H;
                    E               = Xhat-XX;
                    SSE             = sum(reshape(E,numel(E),1).^2);
                    SST             = sum((reshape(XX,numel(XX),1)-mean(mean(XX))).^2);
                    Y.shuffle.r2(ii,ikf,ishuffle)        = 1 - SSE./SST;     % Roh et al (2010) JNP
                    
                    %Xvar            = var(reshape(XX,numel(XX),1),0);
                    Xvar = sum(var(XX,1,2));
                    %Y.shuffle.latent(ii,ikf,ishuffle)    = var(reshape(Xhat,numel(Xhat),1),0);
                    Y.shuffle.latent(ii,ikf,ishuffle)     = sum(var(Xhat,1,2));
                    Y.shuffle.explained(ii,ikf,ishuffle) = Y.shuffle.latent(ii,ikf,ishuffle) / Xvar;                
                end
            else
                 disp('No-cross-validation')
                    
                    % train
                    XX  = Xshuf;
                    XX  = normalize(XX,normalization_method);
                    [W,H]   = nnmf2(XX,ii,[],[],nrep,alg,'wh',normalization_method);
                    Xhat            = W*H;
                    E               = Xhat-XX;
                    SSE             = sum(reshape(E,numel(E),1).^2);
                    SST             = sum((reshape(XX,numel(XX),1)-mean(mean(XX))).^2);
                    Y.shuffle.r2(ii,1,ishuffle)        = 1 - SSE./SST;     % Roh et al (2010) JNP
                    
                    %Xvar            = var(reshape(XX,numel(XX),1),0);
                    Xvar = sum(var(XX,1,2));
                    %Y.shuffle.latent(ii,ikf,ishuffle)    = var(reshape(Xhat,numel(Xhat),1),0);
                    Y.shuffle.latent(ii,1,ishuffle)     = sum(var(Xhat,1,2));
                    Y.shuffle.explained(ii,1,ishuffle) = Y.shuffle.latent(ii,1,ishuffle) / Xvar; 
            end  
        end
        Y.shuffle.r2slope(:,:,ishuffle) = [Y.shuffle.r2(1,:,ishuffle); diff(Y.shuffle.r2(:,:,ishuffle),1,1)];
    end
end

