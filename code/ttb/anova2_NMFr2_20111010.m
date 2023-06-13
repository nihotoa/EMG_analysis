% filenames   = {'N:\tkitom\Analyses\EMGNMF\test20111005_kfoldcv4\AobaT00101.mat'
% 'N:\tkitom\Analyses\EMGNMF\test20111005_kfoldcv4\AobaT00203.mat'
% 'N:\tkitom\Analyses\EMGNMF\test20111005_kfoldcv4\AobaT00301.mat'
% 'N:\tkitom\Analyses\EMGNMF\test20111005_kfoldcv4\AobaT00702.mat'
% 'N:\tkitom\Analyses\EMGNMF\test20111005_kfoldcv4\AobaT00801.mat'
% 'N:\tkitom\Analyses\EMGNMF\test20111005_kfoldcv4\AobaT00903.mat'
% 'N:\tkitom\Analyses\EMGNMF\test20111005_kfoldcv4\AobaT01106.mat'
% 'N:\tkitom\Analyses\EMGNMF\test20111005_kfoldcv4\AobaT01202.mat'
% 'N:\tkitom\Analyses\EMGNMF\test20111005_kfoldcv4\AobaT01310.mat'
% 'N:\tkitom\Analyses\EMGNMF\test20111005_kfoldcv4\AobaT01702.mat'
% 'N:\tkitom\Analyses\EMGNMF\test20111005_kfoldcv4\AobaT02402.mat'
% };




filenames   = {'N:\tkitom\Analyses\EMGNMF\test20111005_kfoldcv4\EitoT00108.mat'
'N:\tkitom\Analyses\EMGNMF\test20111005_kfoldcv4\EitoT00204.mat'
'N:\tkitom\Analyses\EMGNMF\test20111005_kfoldcv4\EitoT00404.mat'
'N:\tkitom\Analyses\EMGNMF\test20111005_kfoldcv4\EitoT00501.mat'
'N:\tkitom\Analyses\EMGNMF\test20111005_kfoldcv4\EitoT00603.mat'
'N:\tkitom\Analyses\EMGNMF\test20111005_kfoldcv4\EitoT00702.mat'
'N:\tkitom\Analyses\EMGNMF\test20111005_kfoldcv4\EitoT00802.mat'
'N:\tkitom\Analyses\EMGNMF\test20111005_kfoldcv4\EitoT00902.mat'
'N:\tkitom\Analyses\EMGNMF\test20111005_kfoldcv4\EitoT01001.mat'
'N:\tkitom\Analyses\EMGNMF\test20111005_kfoldcv4\EitoT01202.mat'
'N:\tkitom\Analyses\EMGNMF\test20111005_kfoldcv4\EitoT01305.mat'
'N:\tkitom\Analyses\EMGNMF\test20111005_kfoldcv4\EitoT01402.mat'
'N:\tkitom\Analyses\EMGNMF\test20111005_kfoldcv4\EitoT01503.mat'
'N:\tkitom\Analyses\EMGNMF\test20111005_kfoldcv4\EitoT01601.mat'
'N:\tkitom\Analyses\EMGNMF\test20111005_kfoldcv4\EitoT01701.mat'
'N:\tkitom\Analyses\EMGNMF\test20111005_kfoldcv4\EitoT01804.mat'
'N:\tkitom\Analyses\EMGNMF\test20111005_kfoldcv4\EitoT02101.mat'
'N:\tkitom\Analyses\EMGNMF\test20111005_kfoldcv4\EitoT02303.mat'
'N:\tkitom\Analyses\EMGNMF\test20111005_kfoldcv4\EitoT02411.mat'
};
r2=[];
g1=[];
g2=[];
nfiles  = length(filenames);

for ifile=1:nfiles
    filename    = filenames{ifile};
    S   = load(filename);
    
    temp    = S.test.r2(1:end,:)';
%     temp    = S.test.r2slope(2:end,:)';
    
    [nn,mm] = size(temp);
    
    
%     temp    = reshape(temp,numel(temp),1);
%     group1  = repmat(1:mm,nn,1);
%     group1  = reshape(group1,numel(group1),1);
%     group2  = repmat(ifile,numel(group1),1);
    
    r2  = [r2;temp];
%     g1  = [g1;group1];
%     g2  = [g2;group2];
end

[r2,g1,g2]
