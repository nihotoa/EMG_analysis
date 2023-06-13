function uiavestaxls_btc(method)
if nargin<1
    method          = 'average';
end

% xlsfilename        = uigetfullfile('*.xls','Experiment Excelファイルを選択してください。');
% xlsload(xlsfilename,'-cell','Animal','MDAfile','suffix','EMG');
xlsload(-1,'-cell','Animal','MDAfile','suffix','EMG');


ParentDir   = uigetdir(fullfile(datapath,'STA'),'STAデータが入っている「親」フォルダを選択してください。');
AnimalDirs  = sortxls(dirdir(ParentDir));
AnimalDirs  = uiselect(AnimalDirs,1,'ファイル選択に用いるフォルダを選択してください。');
InputDir    = sortxls(dirdir(fullfile(ParentDir,AnimalDirs{1})));
Tarfiles    = deext(dirmat(fullfile(ParentDir,AnimalDirs{1},InputDir{1})));
Tarfiles    = strfilt(Tarfiles,'STA ~._');
Tarfiles    = sortxls(Tarfiles);
Tarfiles    = uiselect(Tarfiles,1,'対象とするファイルを選択してください');

[temp,Tarfiles_prefix,Tarfiles_suffix] = autolabel(Tarfiles);

[OutputFile_hdr,OutputDir]  = uiputfile(fullfile(datapath,'AVESTA',[Tarfiles_prefix,Tarfiles_suffix,'.mat']),'出力先ファイルを選択してください。');

OutputFile_hdr  = deext(OutputFile_hdr);
OutputFile_dat  = ['._',OutputFile_hdr];

nList   = size(Animal,1);


for iList=1:nList
    AnimalDir   = strfilt(AnimalDirs,Animal{iList});
    InputDir    = [MDAfile{iList},num2str(suffix{iList},'%0.2d')];
    Tarfiles    = dirmat(fullfile(ParentDir,AnimalDir{1},InputDir));
    Tarfile     = strfilt(Tarfiles,[Tarfiles_prefix,' ',EMG{iList},' ',Tarfiles_suffix]);
    
    Inputfile   = fullfile(ParentDir,AnimalDir{1},InputDir,Tarfile{1});

    s   = load(Inputfile);

    if(iList==1)
        S.StoreTrial_flag   = 1;
        S.ISA_flag      = 0;
        S.maxtrials     = [0 Inf];
        S.Smoothing_flag    = s.Smoothing_flag;
        S.Name          = OutputFile_hdr;
        S.TargetName    = s.TargetName;
        S.ReferenceName = s.ReferenceName;
        S.Class         = s.Class;
        S.AnalysisType  = 'STA';
        S.TimeRange     = s.TimeRange;
        S.SampleRate    = s.SampleRate;
        S.TrialData     = 1;
        S.nTrials       = nList;
        S.CellNames     = cell(nList,1);
        S.YData         = zeros(size(s.YData));
        S.XData         = s.XData;
        S.Unit          = s.Unit;
        S.data_file     = OutputFile_dat;
        S.Method        = method;

        SData.Name      = OutputFile_dat;
        SData.hdr_file  = OutputFile_hdr;
        SData.TrialData = zeros(nList,size(s.YData,2));
    end

    if(~strcmp(S.TargetName,s.TargetName))
        S.TargetName    = [];
    end
    if(~strcmp(S.ReferenceName,s.ReferenceName))
        S.ReferenceName    = [];
    end


    S.CellNames{iList}       = Inputfile;
    SData.TrialData(iList,:) = s.YData;
    
    disp(['(',num2str(iList),'/',num2str(nList),') ',Inputfile])

end

switch method
    case 'average'
        S.YData = mean(SData.TrialData,1);
    case 'sum'
        S.YData = sum(SData.TrialData,1);
end

OutputFile_hdr  = fullfile(OutputDir,[OutputFile_hdr,'.mat']);
save(OutputFile_hdr,'-struct','S');
disp([OutputFile_hdr,'  n=',num2str(S.nTrials)]);

OutputFile_dat  = fullfile(OutputDir,[OutputFile_dat,'.mat']);
save(OutputFile_dat,'-struct','SData');
disp([OutputFile_dat,'  n=',num2str(S.nTrials)]);

end