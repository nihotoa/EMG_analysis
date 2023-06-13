function testPSEXtalk(psename)


xfactor     = 2;

% ParentDir   = uigetdir(fullfile(datapath,'STA'),'SpTAデータが入っている親フォルダを選択してください。');


ParentDir   = getconfig(mfilename,'ParentDir');
try
    if(~exist(ParentDir,'dir'));
        ParentDir   = pwd;
    end
catch
    ParentDir   = pwd;
end
ParentDir   = uigetdir(ParentDir,'SpTAデータが入っている親フォルダを選択してください。');
if(ParentDir==0)
    disp('User pressed cancel.')
    return;
else
    setconfig(mfilename,'ParentDir',ParentDir);
end


InputDirs   = uiselect(dirdir(ParentDir),1,'対象とするExperimentsを選択してください');



InputDir    = InputDirs{1};
files       = dirmat(fullfile(ParentDir,InputDir));
files       = strfilt(files,'~._');
files       = uiselect(files,1,'対象とするファイルを選択してください。');
[Trigs,EMGs]= getRefTarName(files);
EMGs        = sortxls(unique(EMGs));


nDirs       = length(InputDirs);
nEMG        = length(EMGs);
uiwait(msgbox(EMGs',['確認 nEMG=',num2str(nEMG)],'modal'));

% XtalkDir    = uigetdir(fullfile(datapath,'XTALKMTX'),'XTALKMTXデータが入っているフォルダを選択してください。');


XtalkDir    = getconfig(mfilename,'XtalkDir');
try
    if(~exist(XtalkDir,'dir'));
        XtalkDir    = pwd;
    end
catch
    XtalkDir    = pwd;
end
XtalkDir    = uigetdir(XtalkDir,'XTALKMTXデータが入っているフォルダを選択してください(例''XTALKMTX'')。');
if(XtalkDir==0)
    disp('User pressed cancel.')
    return;
else
    setconfig(mfilename,'XtalkDir',XtalkDir);
end






for iDir=1:nDirs
    InputDir    = InputDirs{iDir};
    Xtalk       = zeros(nEMG,1);

    try
        for iEMG=1:nEMG
            EMG = EMGs{iEMG};
            %                 file    = ['STA (',Trig,', ',EMG,').mat'];
            file    = strfilt(files,[EMG,' ~._']);
            if(length(file)~=1)
                error('フィルターしても唯一のファイルになりませんでした。ファイルの名前の付け方が特殊な可能性があります。')
            end
            file    = file{1};

            s   = load(fullfile(ParentDir,InputDir,file));
            %             if(~isempty(s.sigpeakind))
            if(isfield(s,psename))
                if(~isempty(s.(psename).sigpeakindTW))
                    %                 Xtalk(iEMG) = s.peaks(s.maxsigpeakind).peakd;
                    Xtalk(iEMG) = s.(psename).peaks(s.(psename).maxsigpeakindTW).peakd;
                else
                    Xtalk(iEMG) = NaN;
                end
            else
                Xtalk(iEMG) = NaN;
            end


        end

        Xtalk   = (repmat(Xtalk',nEMG,1) ./ repmat(Xtalk,1,nEMG)) * 100;
        Xtalk(logical(eye(size(Xtalk,1))))  = NaN;
        
        if(exist(fullfile(XtalkDir,'AVEXtalkMTX.mat'),'file'))
            s   = load(fullfile(XtalkDir,'AVEXtalkMTX.mat'));
            disp(fullfile(XtalkDir,'AVEXtalkMTX.mat'));
        else
            s   = load(fullfile(XtalkDir,InputDir(1:end-2)));
            disp(fullfile(XtalkDir,InputDir(1:end-2)));
        end

        
        if(length(s.EMGName)==nEMG)
            mismatch    = zeros(nEMG,1);
            for iEMG=1:nEMG
                a   = EMGs{iEMG};
                ind = strfind(a,'l');
                a(ind)  = [];
                b   = s.EMGName{iEMG};
                ind = strfind(b,'l');
                b(ind)  = [];
%                 
%                 mismatch(iEMG)  = isempty(strfind(a,b));
                mismatch(iEMG)  = ~strcmp(parseEMG(a),parseEMG(b));
            end
        else
            mismatch    = 1;
        end

        if(any(mismatch))
            error('用いているEMGが対応してません')
        else
            disp('EMG matched!')
        end
        Outputfile  = fullfile(ParentDir,InputDir,'PSEXtalk');

        if(exist([Outputfile,'.mat'],'file'))
            S = load(Outputfile);
            
        else
            S=[];
        end
        
        
        S.AnalysisType          = 'PSEXtalk';
        S.(psename).EMGName   = EMGs;
        S.(psename).PSERatio  = Xtalk;
        S.(psename).xtIndex   = (Xtalk ./ s.Xtalk);
        S.(psename).xtFactor  = xfactor;
        S.(psename).isXtalkMTX= (S.(psename).xtIndex < xfactor & S.(psename).xtIndex > 0);
        S.(psename).isXtalk   = any(S.(psename).isXtalkMTX,1)';


        save(Outputfile,'-struct','S');
        disp(Outputfile)
        
        for iEMG=1:nEMG
            clear('s')
            EMG = EMGs{iEMG};
            %                 file    = ['STA (',Trig,', ',EMG,').mat'];
            file    = strfilt(files,[EMG,' ~._']);
            if(length(file)~=1)
                error('フィルターしても唯一のファイルになりませんでした。ファイルの名前の付け方が特殊な可能性があります。')
            end
            file    = file{1};
            
            s   = load(fullfile(ParentDir,InputDir,file));
            s.(psename).isXtalk   = S.(psename).isXtalk(iEMG);
            save(fullfile(ParentDir,InputDir,file),'-struct','s');
            disp(['L-- ',fullfile(ParentDir,InputDir,file)])

        end

    catch
        errormsg    = ['****** Error occured in ',InputDirs{iDir}];
        disp(errormsg)
        errorlog(errormsg);
    end
    %     indicator(0,0)

end