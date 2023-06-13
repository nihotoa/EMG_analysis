function avecov_btc(Name,PCAth)

% PCAth   = 3;


InputDir    = uigetdir(fullfile(datapath,'COVMTX'),'COVMTXデータが入っているフォルダを選択してください。');
files       = uiselect(sortxls(deext(dirmat(InputDir))),1,'平均する対象となるファイルを選択してください');
OutputDir   = InputDir;

Outputfile  = fullfile(OutputDir,['AVECOV(',Name,').mat']);
nfile       = length(files);
if(exist(Outputfile,'file'))
    S       = load(Outputfile);
end


for ifile=1:nfile
    s   = load(fullfile(InputDir,files{ifile}));
    if(ifile==1)
        
        
        
        S.Name      = ['AVECOV(',Name,')'];
        S.AnalysisType  = 'AVECOV';
        S.MFName    = files;
        S.nfiles    = nfile;
        S.Label     = s.Name(2:end);
        
        nLabel      = length(S.Label);
        GroupInd    = zeros(1,nLabel);
        
        S.mrA_all   = zeros(nfile,nLabel);
        S.corrcoef_all  = zeros(nfile,nLabel);
        S.mrAHhist  = zeros(1,nLabel);
        S.mrAHhistp = zeros(1,nLabel);
        S.maxmrA    = zeros(1,nfile);
        S.maxcorrcoef   = zeros(1,nfile);
        
        S.GroupmrA_all       = zeros(nfile,3);
        S.Groupcorrcoef_all  = zeros(nfile,3);
        S.GroupmrAHhist      = zeros(1,3);
        S.GroupmrAHhistp     = zeros(1,3);
        S.GroupmaxmrAhist       = zeros(1,3);
        S.Groupmaxcorrcoefhist  = zeros(1,3);
        
        S.GroupLabel    = {'EMG',['PCA1-',num2str(PCAth)],['PCA',num2str(PCAth+1),'-']};
        for iLabel=1:nLabel
            if(~isempty(parseEMG(S.Label{iLabel})))
                GroupInd(iLabel)    = 1;
            elseif(str2double(S.Label{iLabel}((end-1):end))<=PCAth)
                GroupInd(iLabel)    = 2;
            else
                GroupInd(iLabel)    = 3;
            end
        end
        nGroup  = max(GroupInd);
    end
    S.mrA_all(ifile,:)      = s.mrA(2:end)';
    S.corrcoef_all(ifile,:) = s.corrcoef(1,2:end);
    S.mrAHhist              = S.mrAHhist + s.mrAH(2:end)';
    
    for iGroup=1:nGroup
        S.GroupmrAHhist(iGroup)         = S.GroupmrAHhist(iGroup) + mean(s.mrAH([false (GroupInd==iGroup)]));
        S.GroupmrA_all(ifile,iGroup)    = mean(s.mrA([false (GroupInd==iGroup)]));
        S.Groupcorrcoef_all(ifile,iGroup)   = mean(s.corrcoef([false (GroupInd==iGroup)]));
    end
    
    S.maxmrA(ifile)         = find(abs(s.mrA(2:end))==max(abs(s.mrA(2:end))),1);
    S.GroupmaxmrAhist(GroupInd(S.maxmrA(ifile)))    = S.GroupmaxmrAhist(GroupInd(S.maxmrA(ifile)))+1;
    S.maxcorrcoef(ifile)    = find(abs(s.corrcoef(1,2:end))==max(abs(s.corrcoef(1,2:end))),1);
    S.Groupmaxcorrcoefhist(GroupInd(S.maxcorrcoef(ifile)))    = S.Groupmaxcorrcoefhist(GroupInd(S.maxcorrcoef(ifile)))+1;
end
XData   = 1:length(S.Label);
S.mrAHhistp         = S.mrAHhist/nfile;
S.GroupmrAHhist     = S.GroupmrAHhist/nfile;
S.maxmrAhist        = hist(S.maxmrA,XData);
S.maxcorrcoefhist   = hist(S.maxcorrcoef,XData);
S.maxmrAhistp       = S.maxmrAhist/nfile;
S.maxcorrcoefhistp  = S.maxcorrcoefhist/nfile;
S.GroupmaxmrAhistp       = S.GroupmaxmrAhist/nfile;
S.Groupmaxcorrcoefhistp  = S.Groupmaxcorrcoefhist/nfile;



save(Outputfile,'-struct','S');
disp(Outputfile)

