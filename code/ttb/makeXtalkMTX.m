function makeXtalkMTX(TimeWindow,method)
% makeXtalkMTX([-0.01 0.01],'exact')
% makeXtalkMTX([-0.01 0.01],'peak to peak')
if(nargin<1)
    TimeWindow  = [-0.01 0.01];
    method      = 'exact';  % or 'peak to peak'
end

ParentDir   = getconfig(mfilename,'ParentDir');
try
    if(~exist(ParentDir,'dir'));
        ParentDir   = pwd;
    end
catch
    ParentDir   = pwd;
end
ParentDir   = uigetdir(ParentDir,'EMG-TAデータが入っている親フォルダを選択してください。');
if(ParentDir==0)
    disp('User pressed cancel.')
    return;
else
    setconfig(mfilename,'ParentDir',ParentDir);
end



InputDirs   = uiselect(dirdir(ParentDir),1,'対象とするExperimentsを選択してください');



InputDir    = InputDirs{1};
files       = strfilt(dirmat(fullfile(ParentDir,InputDir)),'~._');
[Trigs,EMGs]= getRefTarName(files);
Trigs       = sortxls(unique(Trigs));
EMGs        = sortxls(unique(EMGs));

nDirs       = length(InputDirs);
nTrig       = length(Trigs);
nEMG        = length(EMGs);
if(nTrig~=nEMG)
    error('TriggerとSampleEMGの数があってません');
end


OutputDir   = getconfig(mfilename,'OutputDir');
try
    if(~exist(OutputDir,'dir'));
        OutputDir   = pwd;
    end
catch
    OutputDir   = pwd;
end
OutputDir   = uigetdir(OutputDir,'出力フォルダを選択してください。必要に応じて作成してください(例　''XTALKMTX'')。');
if(OutputDir==0)
    disp('User pressed cancel.')
    return;
else
    setconfig(mfilename,'OutputDir',OutputDir);
end


for iDir=1:nDirs
    InputDir    = InputDirs{iDir};
    Xtalk       = zeros(nTrig,nEMG);
    AutoXtalk   = zeros(nTrig,1);

    try
        switch method
            case 'peak to peak'
                for iTrig=1:nTrig
                    Trig    = Trigs{iTrig};
                    for iEMG=1:nEMG
                        EMG = EMGs{iEMG};
                        file    = ['STA (',Trig,', ',EMG,').mat'];

                        s   = load(fullfile(ParentDir,InputDir,file));
                        ind = (s.XData>=TimeWindow(1) & s.XData<=TimeWindow(2));
                        Xtalk(iTrig,iEMG)   = max(s.YData(ind)) - min(s.YData(ind));

                        if(iTrig==iEMG)
                            AutoXtalk(iTrig)    = max(s.YData(ind)) - min(s.YData(ind));
                        end
                    end
                end
                
            case 'exact'
                for iTrig=1:nTrig
                    jTrig   = [1:nTrig];
                    jTrig   = jTrig(jTrig~=iTrig);

                    Trig    = Trigs{iTrig};
                    EMG     = EMGs{iTrig};
                    file    = ['STA (',Trig,', ',EMG,').mat'];

                    s   = load(fullfile(ParentDir,InputDir,file));
                    ind = (s.XData>=TimeWindow(1) & s.XData<=TimeWindow(2));
                    [temp,maxind]   = max(nanmask(s.YData,ind));
                    [temp,minind]   = min(nanmask(s.YData,ind));
                    Xtalk(iTrig,iTrig)  = abs(s.YData(maxind) - s.YData(minind));
                    AutoXtalk(iTrig)    = abs(s.YData(maxind) - s.YData(minind));


                    for iEMG=jTrig
                        EMG = EMGs{iEMG};
                        file    = ['STA (',Trig,', ',EMG,').mat'];

                        s   = load(fullfile(ParentDir,InputDir,file));
                        Xtalk(iTrig,iEMG)   = abs(s.YData(maxind) - s.YData(minind));
                    end
                end
        end

        AutoXtalk   = repmat(AutoXtalk,1,nEMG);

        Xtalk   = (Xtalk ./ AutoXtalk) * 100;

        S.EMGName   = EMGs;
        S.Xtalk     = Xtalk;
        S.AnalysisType  = 'XtalkMTX';
        S.Method    = method;

        Outputfile  = fullfile(OutputDir,InputDir);
        save(Outputfile,'-struct','S');
        disp(Outputfile)
    catch
        errormsg    = ['****** Error occured in ',InputDirs{iDir}];
        disp(errormsg)
        errorlog(errormsg);
    end
    %     indicator(0,0)

end