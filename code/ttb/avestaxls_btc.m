function avestaxls_btc(method, UseLabel, NonLinear_flag)
if nargin<1
    NonLinear_flag  = 0;
    UseLabel        = 1;
    method          = 'average';
elseif nargin<2
    NonLinear_flag  = 0;
    UseLabel        = 1;
elseif nargin<3
    NonLinear_flag  = 0;
end

Listfilename        = uigetfullfile('*.xls','Experiment Excelファイルを選択してください。');
uiwait(msgbox('[MDAfile, suffix, EMG]','modal'));
[temp1,temp2,TarList]  = xlsread(Listfilename,-1); % Unit-EMG pair Name (string cells)

uiwait(msgbox('[PSEtype]','modal'));
[LabelList,temp1,temp2]  = xlsread(Listfilename,-1); % PSEtype Name (double)


ParentDir   = uigetdir(fullfile(datapath,'STA'),'STAデータが入っている「親」フォルダを選択してください。');
InputDirs   = sortxls(dirdir(ParentDir));
InputDir    = uiselect(InputDirs,1,'ファイル選択に用いるフォルダを選択してください。');
Tarfiles    = deext(dirmat(fullfile(ParentDir,InputDir{1})));
Tarfiles    = strfilt(Tarfiles,'STA ~._');
Tarfiles    = sortxls(Tarfiles);
Tarfiles    = uiselect(Tarfiles,1,'対象とするファイルを選択してください');

OutputDir   = uigetdir(fullfile(datapath,'AVESTA'),'出力先フォルダを選択してください。');

nTar        = length(Tarfiles);
nDir        = length(InputDirs);
nList       = size(TarList,1);
% Labels      = sortxls(unique(LabelList));
nLabel      = length(UseLabel);
Labelind    = ismember(LabelList,UseLabel);
if(nList~=size(LabelList,1))
    error('選択したcell数が違います')
end

for iTar=1:nTar
    try
        Tarfile = Tarfiles{iTar};
        EMGName = parseEMG(Tarfile);
        EMGind  = false(nList,1);
        EMGind(strmatch(EMGName,TarList(:,3),'exact'))  = true;
        Listind = 1:nList;
        Listind = Listind(Labelind & EMGind);
        nListind= length(Listind);

        Name_hdr  = ['AVE',Tarfile,'[Label'];
        Name_dat  = ['._AVE',Tarfile,'[Label'];
        for iLabel  =1:nLabel
            Name_hdr  = [Name_hdr,num2str(UseLabel(iLabel)),','];
            Name_dat  = [Name_dat,num2str(UseLabel(iLabel)),','];
        end
        Name_hdr  = [Name_hdr(1:end-1),']'];
        Name_dat  = [Name_dat(1:end-1),']'];

        Outputfile_hdr  = fullfile(OutputDir,Name_hdr);
        Outputfile_dat  = fullfile(OutputDir,Name_dat);

        if(nListind~=0)
            for iListind = 1:nListind
                ind         = Listind(iListind);
                InputDir    = [TarList{ind,1},TarList{ind,2}];
                Inputfile   = fullfile(ParentDir,InputDir,Tarfile);

                s   = load(Inputfile);

                if(iListind==1)
                    S.Name          = Name_hdr;
                    S.TargetName    = s.TargetName;
                    S.ReferenceName = s.ReferenceName;
                    S.Class         = s.Class;
                    S.AnalysisType  = 'AVESTA';
                    S.SampleRate    = s.SampleRate;
                    S.TrialData     = 1;
                    S.nTrials       = 0;
                    S.CellNames     = cell(nListind,1);
                    S.YData         = zeros(size(s.YData));
                    S.XData         = s.XData;
                    S.Unit          = s.Unit;
                    S.data_file     = Name_dat;
                    S.Method        = method;

                    SData.Name      = Name_dat;
                    SData.hdr_file  = Name_hdr;
                    SData.TrialData = zeros(nListind,size(s.YData,2));
                end

                S.nTrials                   = S.nTrials + 1;
                S.CellNames{iListind}       = fullfile(ParentDir,InputDir);
                S.YData                     = S.YData + s.YData;

                SData.TrialData(iListind,:) = s.YData;
            end
            switch method
                case 'average'
                    S.YData = S.YData ./ S.nTrials;
                case 'sum'
                    S.YData = S.YData;
            end

        else
            ind = 1:nList;
            ind = ind(EMGind);
            ind = ind(1);

            InputDir    = [TarList{ind,1},TarList{ind,2}];
            Inputfile   = fullfile(ParentDir,InputDir,Tarfile);

            s   = load(Inputfile);

            S.Name          = Name_hdr;
            S.TargetName    = s.TargetName;
            S.ReferenceName = s.ReferenceName;
            S.Class         = s.Class;
            S.AnalysisType  = 'AVESTA';
            S.SampleRate    = s.SampleRate;
            S.TrialData     = 1;
            S.nTrials       = 0;
            S.CellNames     = cell(1);
            S.YData         = zeros(size(s.YData));
            S.XData         = s.XData;
            S.Unit          = s.Unit;
            S.data_file     = Name_dat;
            S.Method        = method;

            SData.Name      = Name_dat;
            SData.hdr_file  = Name_hdr;
            SData.TrialData = [];

        end
        save(Outputfile_hdr,'-struct','S');
        save(Outputfile_dat,'-struct','SData');


        if(NonLinear_flag)
            S.YData         = sigmoid(S.YData,1,5,1).*S.YData;
            SData.TrialData = sigmoid(SData.TrialData,1,5,1).*SData.TrialData;

            save([Outputfile_hdr,'_nl'],'-struct','S');
            save([Outputfile_dat,'_nl'],'-struct','SData');
        end

        disp([Outputfile_hdr,'  n=',num2str(S.nTrials)]);
    catch
        errormsg    = ['****** Error occured in ',Tarfiles{iTar}];
        disp(errormsg)
        errorlog(errormsg);
    end
    %     indicator(0,0)

end