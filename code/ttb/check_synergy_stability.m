function [gmeanr2,gstdr2]   = check_synergy_stability
%
% NMFID=12;
nEMG    = 12;

InputDir    = 'N:\tkitom\Analyses\EMGNMF\kfoldcv4_EMG_20111018';

FileNames   = {
    '._AobaT00203.mat'
    '._AobaT00301.mat'
    '._AobaT00903.mat'
    '._AobaT01106.mat'
    '._AobaT01202.mat'
    '._AobaT01702.mat'
    '._AobaT02402.mat'
    };

% FileNames   = {
% '._EitoT00108.mat'
% '._EitoT00204.mat'
% '._EitoT00404.mat'
% '._EitoT00501.mat'
% '._EitoT00603.mat'
% '._EitoT00702.mat'
% '._EitoT00802.mat'
% '._EitoT00902.mat' 
% '._EitoT01001.mat'
% '._EitoT01202.mat'
% '._EitoT01305.mat'
% '._EitoT01402.mat'
% '._EitoT01503.mat'
% '._EitoT01601.mat'
% '._EitoT01701.mat'
% '._EitoT01804.mat'
% '._EitoT02101.mat'
% '._EitoT02303.mat'
% '._EitoT02411.mat'
% };

nfile   = length(FileNames);

for NMFID=1:nEMG
    for ifile=1:nfile
        FileName   = FileNames{ifile};
        fullfilename    = fullfile(InputDir,FileName);
        S   = load(fullfilename);
        W   = mean(cat(3,S.test.W{NMFID,:}),3);
        if ifile==1
            oW  = nan(size(W,1),size(W,2),nfile);
        end
        oW(:,:,ifile)   = W;
        
    end
    
    ind = nan(size(oW,3),size(oW,2));
    aW  = nan(size(oW));
    nW  = size(oW,2);
    
    for ifile=1:nfile
        [temp,ind(ifile,:)]  = max(corr(oW(:,:,1),oW(:,:,ifile)));
        for iW=1:nW
            aW(:,iW,ifile)  = oW(:,ind(ifile,iW),ifile);
        end
    end
    
    meanW   = mean(aW,3);
    r2      = nan(nfile,nW);
    r       = nan(nfile,nW);
    for iW=1:nW
        r(:,iW)     = corr(aW(:,iW,:),meanW(:,iW));
        r2(:,iW)    = corr(aW(:,iW,:),meanW(:,iW)).^2;
    end
    
    
    meanr2  = mean(r2,1);
    stdr2   = std(r2,[],1);
    
    gmeanr2(NMFID) = mean(reshape(r2,numel(r2),1));
    gstdr2(NMFID) = std(reshape(r2,numel(r2),1));
    
    
    meanr  = mean(r,1);
    stdr   = std(r,[],1);
    
    gmeanr(NMFID) = mean(reshape(r,numel(r),1));
    gstdr(NMFID) = std(reshape(r,numel(r),1));
end


figure
plot(gmeanr2,'-ro')