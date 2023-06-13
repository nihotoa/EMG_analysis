function [Y,Y_dat]  = makeEMGNMFOhta(X,kf,nrep,nshuffle,alg,normalization_method)
%Y�͋؃V�i�W�[�̊�^����A�V���b�t��������̊�^���ɂ��Ă̏�񓙂������Ă���Y_dat�́A�e�؃V�i�W�[���ɂ�����؃V�i�W�[��W��H�������Ă���
% [Y,Y_dat]  = makeEMGNMF(X,kf,nrep,nshuffle,alg);
% 
% kf  :  k-fold cross-validation�̐�(k) �f�[�^��k�̃Z�O�����g�ɕ����āA���̂ЂƂ�test�Ɏg���A����train�Ɏg���B
% ���̂��߁AY.train.r2 �Ȃǂ�k���ł���̂ŁA�ŏI�I�ɂ͂���𕽋ς��Ďg���B
% kf=1�Ƃ���ƁAcross-validation���s��Ȃ��B
% 
% ex
% [Y,Y_dat]  = makeEMGNMF(X,4,10,1,'mult');


if(nargin<2)
    kf          = 4;  %�����̒l�ɂ���āA�N���X�o���f�[�V�������s�����ۂ��A�s���ꍇ�̕�����������ł���
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

% NMF�p�ɓ]�u����
[mm,nn]   = size(X);    % mm channels x nn data length

if kf > 1 %�N���X�o���f�[�V��������Ƃ�
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
else %���Ȃ��Ƃ�
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
 
for ii=1:mm %mm:�g�p����ؓd�̐�(�؃V�i�W�[�̐�)
    disp([num2str(ii),'/',num2str(mm),' number of NMF'])
    % k-fold cross-validation
    if kf > 1 %�N���X�o���f�[�V��������Ƃ�
        kfind   = false(kf,nn); %logical�l0��kf*nn�̃T�C�Y�ō쐬���Akfind�ɑ��
        for ikf=1:kf
            kfind(ikf,((ikf-1)*floor(nn./kf)+1):(ikf*floor(nn./kf))) = true; %kf = 4�̏ꍇ�A1�s�ڂ̑O��1/4��logical�l1����A2�s�ڂ�(1/4)+1 : 1/2�܂ł�logical�l1������
        end
    
        for ikf=1:kf
            disp([num2str(ikf),'/',num2str(kf),' k-fold cross-validation'])
            
            % train
    
            XX  = X(:,~kfind(ikf,:)); %�������Ƃ������h�̃f�[�^������(4�����Ȃ�3/4�f�[�^�̕�)
            XX  = normalize(XX,normalization_method); %�V�����f�[�^�̕��ςŐ��K��
           [Y_dat.train.W{ii,ikf},Y_dat.train.H{ii,ikf},Y_dat.train.D{ii,ikf}]   = nnmf2(XX,ii,[],[],nrep,alg,'wh',normalization_method); %��@�X�V������������nmf(�剮��)
    %       [Y_dat.train.W{ii,ikf},H]   = nnmf2(XX,ii,[],[],nrep,alg,'wh',normalization_method);
    %Y_dat��train��W��{�؃V�i�W�[�̐�,ikf�ڂ̃f�[�^�Z�b�g}�ɂ��̋؃V�i�W�[���̋�Ԋ��
    
            
             
             Xhat            = Y_dat.train.W{ii,ikf}*Y_dat.train.H{ii,ikf}; %�ŏI�I��w��h����č\�����ꂽ�ؓd
    %        Xhat            = Y_dat.train.W{ii,ikf}*H;
            E               = Xhat-XX; %�v���ؓd�ƍč\���ؓd�Ƃ̕΍�
            SSE             = sum(reshape(E,numel(E),1).^2);
            SST             = sum((reshape(XX,numel(XX),1)-mean(mean(XX))).^2);
            Y.train.r2(ii,ikf)        = 1 - SSE./SST;     % Roh et al (2010) JNP (�ŏI�I�ȋ؃V�i�W�[����v�Z���ꂽ��^��)
            
           % Xvar            = var(reshape(XX,numel(XX),1),0);
             Xvar = sum(var(XX,1,2)); %�v���ؓd�̊e�ؓ��̋ؓd�̕��U�𑫂����킹������
           %Y.train.latent(ii,ikf)    = var(reshape(Xhat,numel(Xhat),1),0);
             Y.train.latent(ii,ikf) = sum(var(Xhat,1,2)); %�č\���ؓd�̊e�ؓ��̋ؓd�̕��U�𑫂����킹������
           Y.train.explained(ii,ikf) = Y.train.latent(ii,ikf) / Xvar; %(�č\���ؓd���U/�v���ؓd���U)��^���݂����Ȃ���?
            
            % test(cross-valid���Ȃ��Ȃ�v��Ȃ�)
            
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
        XX  = X; %�N���X�o���f�[�V�����̃e���v�����g�p���邽�߂�,X��XX�ɑ��
        XX  = normalize(XX,normalization_method); %�V�����f�[�^�̕��ςŐ��K��
        [Y_dat.W{ii,1},Y_dat.H{ii,1},Y_dat.D{ii,1}]   = nnmf2(XX,ii,[],[],nrep,alg,'wh',normalization_method); %��@�X�V������������nmf(�剮��)
        %[Y_dat.train.W{ii,1},H]   = nnmf2(XX,ii,[],[],nrep,alg,'wh',normalization_method);
        %Y_dat��train��W��{�؃V�i�W�[�̐�,1}�ɂ��̋؃V�i�W�[���̋�Ԋ��(�f�[�^�Z�b�g�����ĂȂ�����A�񐔂�1)
        Xhat = Y_dat.W{ii,1}*Y_dat.H{ii,1}; %�ŏI�I��w��h����č\�����ꂽ�ؓd
        %Xhat= Y_dat.train.W{ii,ikf}*H;
        E = Xhat-XX; %�v���ؓd�ƍč\���ؓd�Ƃ̕΍�
        SSE = sum(reshape(E,numel(E),1).^2);
        SST = sum((reshape(XX,numel(XX),1)-mean(mean(XX))).^2);
        Y.r2(ii,1) = 1 - SSE./SST;     % Roh et al (2010) JNP (�ŏI�I�ȋ؃V�i�W�[����v�Z���ꂽ��^��)
            
       % Xvar            = var(reshape(XX,numel(XX),1),0);
       Xvar = sum(var(XX,1,2)); %�v���ؓd�̊e�ؓ��̋ؓd�̕��U�𑫂����킹������
       %Y.train.latent(ii,ikf)    = var(reshape(Xhat,numel(Xhat),1),0);
       Y.latent(ii,1) = sum(var(Xhat,1,2)); %�č\���ؓd�̊e�ؓ��̋ؓd�̕��U�𑫂����킹������
       Y.explained(ii,1) = Y.latent(ii,1) / Xvar; %(�č\���ؓd���U/�v���ؓd���U)��^���݂����Ȃ���?
    end
end

if kf > 1 %�N���X�o���f�[�V�����s���ꍇ
    Y.train.r2slope  = [Y.train.r2(1,:); diff(Y.train.r2,1,1)];
    Y.test.r2slope   = [Y.test.r2(1,:); diff(Y.test.r2,1,1)];
else %�s��Ȃ��ꍇ
    Y.r2slope  = [Y.r2(1,:); diff(Y.r2,1,1)];
end

if(nshuffle>0)
% shuffle�ł�train-test���s�����Atest�̎��̃f�[�^�݂̂��o�͂���B

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

