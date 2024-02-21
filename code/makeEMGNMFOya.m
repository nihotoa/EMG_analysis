function [Y,Y_dat]  = makeEMGNMFOya(X,kf,nrep,nshuffle,alg)
%{
explanation of input arguments:
X: matrix of EMG data ([mm, nn] = size(X)], mm: number of muscle, nn: data length)
kf: How many parts of data to divide for cross-validation
nrep: repetition number of synergy search
nshuffle: whether to shuffle the data
alg: Algorithm to be used for NNMF
%}

%{
explanation of output arguments:
Y: structure data. matrix of spatial pattern (W) and temporal pattern (H) of synergy are stored
Y_dat: structure data. this contains a lot of information about synergy(the type of algorithm used, on parameters and thresholds set, etc...)
analysis()
%}

% set parameters
if(nargin<2)
    kf = 4;  
    nrep = 5;
    nshuffle = 1;
    alg = 'mult';   % algorithm to be used ('mult' or 'als')
elseif(nargin<3)
    nrep = 10;
    nshuffle = 1;
    alg = 'mult';
elseif(nargin<4)
    nshuffle = 1;
    alg = 'mult';
elseif(nargin<5)
    alg = 'mult';
end

% create empty structure data
[mm,nn]   = size(X);    % mm channels x nn data length

Y_dat.train.W = cell(mm,kf);
Y_dat.train.H = cell(mm,kf);
Y_dat.train.D = cell(mm,kf);
Y_dat.test.W = cell(mm,kf);
Y_dat.test.H = cell(mm,kf);
Y_dat.test.D = cell(mm,kf);

Y.nrep = nrep;
Y.nshuffle = nshuffle;
Y.algorithm = alg;
Y.train.latent = nan(mm,kf);
Y.train.explained = nan(mm,kf);
Y.train.r2 = nan(mm,kf);
Y.train.r2slope = nan(mm,kf);
Y.test.latent = nan(mm,kf);
Y.test.explained = nan(mm,kf);
Y.test.r2 = nan(mm,kf);
Y.test.r2slope = nan(mm,kf);

X   = normalize(X,'mean');

%%  Perform NNMF to extract muscle synergy
% set the number of synergyies from 1 to mm and extract synergies

for ii=1:mm % ii means number of synergy
    disp([num2str(ii),'/',num2str(mm),' number of NMF'])

    % k-fold cross-validation
    kfind   = false(kf,nn);
    for ikf=1:kf
        kfind(ikf,((ikf-1)*floor(nn./kf)+1):(ikf*floor(nn./kf))) = true;
    end
    
    % which division data to use as test data
    for ikf=1:kf
        disp([num2str(ikf),'/',num2str(kf),' k-fold cross-validation'])
        
        %% Perform NNMF on train data

        % create train data from X matrix
        XX  = X(:,~kfind(ikf,:));
        XX  = normalize(XX,'mean');

        % perform nnmf
        [Y_dat.train.W{ii,ikf},Y_dat.train.H{ii,ikf},Y_dat.train.D{ii,ikf}]   = nnmf2(XX,ii,[],[],nrep,alg,'wh','mean');
        % reconstructed EMG (from W & H)
        Xhat = Y_dat.train.W{ii,ikf}*Y_dat.train.H{ii,ikf};
        % difference between measuredEMG & reconsructed EMG
        E = Xhat-XX;
        % SSE(sum of squares of error), SST(sum of squared total) 
        SSE = sum(reshape(E,numel(E),1).^2);
        SST = sum((reshape(XX,numel(XX),1)-mean(mean(XX))).^2);
        Y.train.r2(ii,ikf) = 1 - SSE./SST;     % Roh et al (2010) JNP
        Xvar = sum(var(XX,1,2));
        Y.train.latent(ii,ikf) = sum(var(Xhat,1,2));
        Y.train.explained(ii,ikf) = Y.train.latent(ii,ikf) / Xvar;
      
        %% Perform NNMF on test data

        % create test data from X matrix
        XX = X(:,kfind(ikf,:));
        XX = normalize(XX,'mean');

        % perform nnmf
        [Y_dat.test.W{ii,ikf},Y_dat.test.H{ii,ikf},Y_dat.test.D{ii,ikf}]   = nnmf2(XX,ii,Y_dat.train.W{ii,ikf},[],nrep,alg,'wh','none');
        Xhat = Y_dat.test.W{ii,ikf}*Y_dat.test.H{ii,ikf};
        E = Xhat-XX;
        SSE = sum(reshape(E,numel(E),1).^2);
        SST = sum((reshape(XX,numel(XX),1)-mean(mean(XX))).^2);
        Y.test.r2(ii,ikf) = 1 - SSE./SST;     % Roh et al (2010) JNP
        Xvar = sum(var(XX,1,2));
        Y.test.latent(ii,ikf) = sum(var(Xhat,1,2));
        Y.test.explained(ii,ikf) = Y.test.latent(ii,ikf) / Xvar;
    end
end
Y.train.r2slope = [Y.train.r2(1,:); diff(Y.train.r2,1,1)];
Y.test.r2slope  = [Y.test.r2(1,:); diff(Y.test.r2,1,1)];
 

% Perform the same process on shuffled data
% remarks: In shuffle analysis,  only test data is output
if(nshuffle>0)
    Y.shuffle.latent = nan(mm,kf,nshuffle);  
    Y.shuffle.explained = nan(mm,kf,nshuffle);
    Y.shuffle.r2 = nan(mm,kf,nshuffle);
    Y.shuffle.r2slope = nan(mm,kf,nshuffle);
    
    for ishuffle=1:nshuffle
        disp(['shuffle: ',num2str(ishuffle),'/',num2str(nshuffle)])
        Xshuf  = X;
        
        % perform shuffle (sort each EMG data in random permutation)
        for ii=1:mm
            Xshuf(ii,:) = X(ii,randperm(nn));
        end
    
        for ii=1:mm
            disp(['shuffle: ',num2str(ii),'/',num2str(mm)])
            
            % k-fold cross-validation
            kfind   = false(kf,nn);
            for ikf=1:kf
                kfind(ikf,((ikf-1)*floor(nn./kf)+1):(ikf*floor(nn./kf))) = true;
            end
            
            for ikf=1:kf
                disp([num2str(ikf),'/',num2str(kf),' k-fold cross-validation'])
                
                % train
                XX = Xshuf(:,~kfind(ikf,:));
                XX = normalize(XX,'mean');
                [W,H] = nnmf2(XX,ii,[],[],nrep,alg,'wh','mean');
                
                % test
                XX = Xshuf(:,kfind(ikf,:));
                XX = normalize(XX,'mean');
                [W,H] = nnmf2(XX,ii,W,[],nrep,alg,'h','none');
                Xhat = W*H;
                E = Xhat-XX;
                SSE = sum(reshape(E,numel(E),1).^2);
                SST = sum((reshape(XX,numel(XX),1)-mean(mean(XX))).^2);
                Y.shuffle.r2(ii,ikf,ishuffle) = 1 - SSE./SST;     % Roh et al (2010) JNP
                Xvar = sum(var(XX,1,2));
                Y.shuffle.latent(ii,ikf,ishuffle) = sum(var(Xhat,1,2));
                Y.shuffle.explained(ii,ikf,ishuffle) = Y.shuffle.latent(ii,ikf,ishuffle) / Xvar;
            end
        end
        Y.shuffle.r2slope(:,:,ishuffle) = [Y.shuffle.r2(1,:,ishuffle); diff(Y.shuffle.r2(:,:,ishuffle),1,1)];
    end
end
