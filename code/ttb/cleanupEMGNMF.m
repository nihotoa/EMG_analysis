InputDir    = 'N:\tkitom\Analyses\EMGNMF\test20111005_kfoldcv4';

filenames   = {
'._AobaT00101.mat'
'._AobaT00203.mat'
'._AobaT00301.mat'
'._AobaT00702.mat'
'._AobaT00801.mat'
'._AobaT00903.mat'
'._AobaT01106.mat'
'._AobaT01202.mat'
'._AobaT01310.mat'
'._AobaT01702.mat'
'._AobaT02402.mat'
'._EitoT00108.mat'
'._EitoT00204.mat'
'._EitoT00404.mat'
'._EitoT00501.mat'
'._EitoT00603.mat'
'._EitoT00702.mat'
'._EitoT00802.mat'
'._EitoT00902.mat'
'._EitoT01001.mat'
'._EitoT01202.mat'
'._EitoT01305.mat'
'._EitoT01402.mat'
'._EitoT01503.mat'
'._EitoT01601.mat'
'._EitoT01701.mat'
'._EitoT01804.mat'
'._EitoT02101.mat'
'._EitoT02303.mat'
'._EitoT02411.mat'
};

nfile   = length(filenames);

for ifile=1:nfile
    fullfilename    = fullfile(InputDir,filenames{ifile});
    
    S   = load(fullfilename);
    
    if(isfield(S.test,'H'))
        S.test  = rmfield(S.test,'H');
    end
    if(isfield(S.test,'D'))
    S.test  = rmfield(S.test,'D');
    end
    
    if(isfield(S.train,'H'))
        S.train  = rmfield(S.train,'H');
    end
    if(isfield(S.train,'D'))
        S.train  = rmfield(S.train,'D');
    end
    save(fullfilename,'-struct','S');
    disp(fullfilename)
    
end