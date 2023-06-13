function uiavesta_btc(method)
if nargin<1
    method  = 'average';
end

Tarfiles    = matexplorer(fullfile(datapath,'STA'));
nTar    = length(Tarfiles);
% OutputDir   = uigetdir(fullfile(datapath,'AVESTA'),'出力先フォルダを選択してください。');

for iTar=1:nTar
    Tarfile     = Tarfiles{iTar};
    s   = load(Tarfile);
    if(iTar==1)
        S.Name          = ['AVESTA',deext(s.Name)];
        S.TargetName    = s.TargetName;
        S.ReferenceName = s.ReferenceName;
        S.Class         = s.Class;
        S.AnalysisType  = 'AVESTA';
        S.SampleRate    = s.SampleRate;
        S.TrialData     = 1;
        S.nTrials       = nTar;
        S.CellNames     = Tarfiles;
        S.YData         = zeros(size(s.YData));
        S.XData         = s.XData;
        S.Unit          = s.Unit;
        S.data_file     = ['._',S.Name];

        SData.Name      = S.data_file;
        SData.hdr_file  = S.Name;
        SData.TrialData = zeros(nTar,size(s.YData,2));

    end
    
    
    if(~strcmp(S.TargetName,s.TargetName))
        S.TargetName    = [];
    end
    if(~strcmp(S.ReferenceName,s.ReferenceName))
        S.ReferenceName    = [];
    end

    SData.TrialData(iTar,:) = s.YData;

end

switch method 
    case 'average'
        S.YData = mean(SData.TrialData,1);
    case 'sum'
        S.YData = sum(SData.TrialData,1);
end

[Outputfile,OutputDir]  = uiputfile(fullfile(datapath,'AVESTA',[S.Name,'.mat']));

Outputfile_hdr  = fullfile(OutputDir,Outputfile);
Outputfile_dat  = fullfile(OutputDir,['._',Outputfile]);

S.Name      = deext(Outputfile_hdr);
S.data_file = deext(Outputfile_dat);

SData.Name  = deext(Outputfile_dat);
SData.hdr_file  = deext(Outputfile_hdr);

save(Outputfile_hdr,'-struct','S');
save(Outputfile_dat,'-struct','SData');


disp([Outputfile_hdr,'  n=',num2str(S.nTrials)]);

end