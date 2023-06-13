function aveXtalkMTX

ParentDir   = uigetdir(fullfile(datapath,'XTALKMTX'),'�e�t�H���_��I�����Ă��������B');
Tarfiles    = sortxls(dirmat(ParentDir));
% Tarfiles    = strfilt(Tarfiles,'~AVE');
Tarfiles    = uiselect(Tarfiles,1,'�ΏۂƂ���file��I�����Ă�������');

nTar        = length(Tarfiles);

for iTar =1:nTar
    Tarfile = Tarfiles{iTar};
    Tar     = load(fullfile(ParentDir,Tarfile));
    
    if(iTar==1)
        S.EMGName   = Tar.EMGName;
        S.Xtalk     = zeros([size(Tar.Xtalk),nTar]);
        S.AnalysisType  = 'XtalkMTX';
    end
    
    S.Xtalk(:,:,iTar)   = Tar.Xtalk;
end
S.Xtalkmax  = max(S.Xtalk,[],3);
S.Xtalkmin  = min(S.Xtalk,[],3);

S.Xtalk     = nanmean(S.Xtalk,3);

% [p,f]       = fileparts(ParentDir);
OutputFile  = fullfile(ParentDir,'AVEXtalkMTX.mat');

save(OutputFile,'-struct','S')
disp([OutputFile,' was saved.'])