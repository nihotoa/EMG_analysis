function xcorr_btc(maxlag,TimeRange,PairingMethod,diff3_flag,RefDataType)
% time-shifted correlation
% xcorr_btc(maxlag,TimeRange,PairingMethod,diff3_flag,RefDataType)
% PairingMethod    = 'all', one-to-one, 'combination';
% RefDataType   = direction of Target data {'normal'} 'inverse' 'transpose2'

if nargin < 2
    TimeRange       = [-inf inf];
    PairingMethod      = 'all';
    diff3_flag      = 0;
    RefDataType   = 'normal'; % direction of Target data {'normal'} 'inverse' 'transpose2'
elseif nargin < 3
    PairingMethod      = 'all';
    diff3_flag      = 0;
    RefDataType   = 'normal'; % direction of Target data {'normal'} 'inverse' 'transpose2'
elseif nargin < 4
    diff3_flag      = 0;
    RefDataType   = 'normal'; % direction of Target data {'normal'} 'inverse' 'transpose2'
elseif nargin < 5
    RefDataType   = 'normal'; % direction of Target data {'normal'} 'inverse' 'transpose2'
end

if(isempty(PairingMethod))
    PairingMethod      = 'all';
end

disp(['RefDataType= ' RefDataType])
alpha   = 0.05;

warning('off');


ParentDir   = getconfig(mfilename,'ParentDir');
try
    if(~exist(ParentDir,'dir'))
        ParentDir   = pwd;
    end
catch
    ParentDir   = pwd;
end
ParentDir   = uigetdir(ParentDir,'親フォルダを選択してください。');
if(ParentDir==0)
    disp('User pressed cancel.')
    return;
else
    setconfig(mfilename,'ParentDir',ParentDir);
end

InputDirs   = uiselect(dirdir(ParentDir),1,'対象とするExperimentsを選択してください');

InputDir    = InputDirs{1};
Allfiles    = dirmat(fullfile(ParentDir,InputDir));
Allfiles    = strfilt(Allfiles,'~._');


Reffiles    = uiselect(sortxls(Allfiles),1,'Reference fileを選択してください');
Tarfiles    = uiselect(sortxls(Allfiles),1,'Target fileを選択してください');

Tar         = load(fullfile(ParentDir,InputDir,Tarfiles{1}));
if(~isfield(Tar,'XData')) % dataのとき
    Trigfile     = uichoice(sortxls(Allfiles),'TimeRangeのトリガーとなるTime Stamp channelを選択してください');
    
    if(iscell(Trigfile))
        Trigfile     = Trigfile{1};
    end
    
    if(~isempty(Trigfile))
        StartTriggerIndex   = inputdlg({'Start Trigger Index:'},'Start Trigger',1,{'1'});
        if(isempty(StartTriggerIndex))
            disp('User Pressed cancel')
            return;
        else
            StartTriggerIndex   = str2double(StartTriggerIndex{1});
        end
    else
        StartTriggerIndex   = [];
    end
    mda_flag    = true;
else    % sta fileのとき
    Trigfile      = [];
    StartTriggerIndex   = [];
    mda_flag   = false;
end


nDir    = length(InputDirs);
nRef    = length(Reffiles);
nTar    = length(Tarfiles);

switch PairingMethod
    case 'all'
        RefInd  = reshape(repmat(1:nRef,nTar,1),nRef*nTar,1);
        TarInd  = reshape(repmat((1:nTar)',1,nRef),nRef*nTar,1);
        nPair   = nRef*nTar;
    case 'one-to-one'
        if(nRef~=nTar)
            error('Reference filesとTarget filesの数が違います.')
        end
        RefInd  = (1:nRef)';
        TarInd  = (1:nTar)';
        nPair   = nRef;
    case 'combination'
        if(nRef~=nTar)
            error('Reference filesとTarget filesの数が違います.')
        end
        RefInd  = sortrows([nchoosek(1:nRef,2);repmat((1:nRef)',1,2)]);
        TarInd  = RefInd(:,2);
        RefInd  = RefInd(:,1);
        nPair  = length(RefInd);
end




OutputDir   = getconfig(mfilename,'OutputDir');
try
    if(~exist(OutputDir,'dir'))
        OutputDir   = pwd;
    end
catch
    OutputDir   = pwd;
end
OutputDir   = uigetdir(OutputDir,'出力フォルダを選択してください。');
if(OutputDir==0)
    disp('User pressed cancel.')
    return;
else
    setconfig(mfilename,'OutputDir',OutputDir);
end


for iDir=1:nDir
    try
        
        InputDir    = InputDirs{iDir};
        disp([num2str(iDir),'/',num2str(nDir),':  ',InputDir])
        
        
        if(mda_flag && ~isempty(Trigfile))
            Trig        = load(fullfile(ParentDir,InputDir,Trigfile));
            Trig.Data   = Trig.Data ./ Trig.SampleRate;
            StartTime   = Trig.Data(StartTriggerIndex);
            TimeRange2  = TimeRange + StartTime;
        else                    % sta fileのとき
            TimeRange2  = TimeRange;
        end
        for iPair=1:nPair
            
            % load Reference
            if(iPair==1)
                Reffile = Reffiles{RefInd(iPair)};
                Ref     = load(fullfile(ParentDir,InputDir,Reffile));
            elseif(RefInd(iPair-1)~=RefInd(iPair))
                Reffile = Reffiles{RefInd(iPair)};
                Ref     = load(fullfile(ParentDir,InputDir,Reffile));
            else
                Reffile = Reffiles{RefInd(iPair)};
            end
            
            if(~mda_flag)    % sta fileのとき
                
                ind = (Ref.XData >= TimeRange2(1) & Ref.XData <= TimeRange2(2));
                X   = Ref.YData(ind)';
                
            else            % continuous fileのとき
                XData   = ([1:length(Ref.Data)]-1)/Ref.SampleRate;
                ind     = (XData >= TimeRange2(1) & XData <= TimeRange2(2));
                X       = Ref.Data(ind)';
            end
            
            if(diff3_flag)
                X   = filter([1 -3 3 -1],1,X);% Apply 3rd order difference;
            end
            
            switch RefDataType
                case 'normal'
                    X   = X;
                case 'inverse'
                    X   = X(end:-1:1);
                    disp('RefDataType: inverse');
                case 'transpose2'
                    halfind = round(size(X,1)/2);
                    X   = X([(halfind+1):end,1:halfind]);
                    disp('RefDataType: tranpose2');
            end
            
            % load Target 
            if(iPair==1)
                Tarfile = Tarfiles{TarInd(iPair)};
                Tar     = load(fullfile(ParentDir,InputDir,Tarfile));
            elseif(TarInd(iPair-1)~=TarInd(iPair))
                Tarfile = Tarfiles{TarInd(iPair)};
                Tar     = load(fullfile(ParentDir,InputDir,Tarfile));
            else
                Tarfile = Tarfiles{TarInd(iPair)};
            end
            
            
            if(~mda_flag)    % sta fileのとき
                ind     = (Tar.XData >= TimeRange2(1) & Tar.XData <= TimeRange2(2));
                Y       = Tar.YData(ind)';
            else            % continuous fileのとき
                XData   = ([1:length(Tar.Data)]-1)/Tar.SampleRate;
                ind     = (XData >= TimeRange2(1) & XData <= TimeRange2(2));
                Y       = Tar.Data(ind)';
            end
            
            
            if(diff3_flag)
                Y   = filter([1 -3 3 -1],1,Y);% Apply 3rd order difference;
            end

            
            
            % Prepare Output S
            clear('S');
                S.Name          = ['XCORR (',Ref.Name,', ',Tar.Name,')'];
                S.diff3_flag    = diff3_flag;
                S.PairingMethod = PairingMethod;
                S.TimeRange     = TimeRange2;
                S.maxlag        = maxlag;
                S.AnalysisType  = 'XCORR';
                S.TargetName    = deext(Tarfile);
                S.ReferenceName = deext(Reffile);
                S.TriggerName   = deext(Trigfile);
                S.StartTriggerIndex = StartTriggerIndex;
                if(~isempty(Trigfile))
                    S.nTrigger      = sum(Trig.Data >= TimeRange2(1) & Trig.Data <= TimeRange2(2));
                else
                    S.nTrigger  = [];
                end
                S.RefDataType   = RefDataType;
                
                % 相互相関係数行列
                maxlagind   = round(maxlag * Tar.SampleRate);
                lagind      = (-maxlagind):maxlagind;
                lag         =  lagind / Tar.SampleRate;
                nlag        = length(lag);
                
                S.xcorrlag      = lag;  % ch1がlag(i)分遅く起こったときのch2との相関係数がS.xcorr(:,i)に入っている。
                S.xcorrlaghelp  = 'Target(ex EMG)がlag(ii)分早く起こったときのReference(ex Spike)との相関係数がS.xcorr(1,ii)に入っている。';
                S.xcorr         = zeros(1,nlag);
                S.xcorrRmax     = [];
                S.xcorrRmaxlag  = [];
                S.xcorrPWHM = [];

                S.xcorr(1,:)    = xcov(Y, X, maxlagind, 'coeff');
                
                [temp,xcorrRmaxind] = max(abs(S.xcorr(1,:)));
                S.xcorrRmax     = S.xcorr(1,xcorrRmaxind);
                S.xcorrRmaxlag  = S.xcorrlag(xcorrRmaxind);
                
                %>> calculate pwhm
                pwhmind = nan(1,2);
                
                hm      = S.xcorrRmax / 2;
                xcorr_hm= (S.xcorr - hm) * sign(S.xcorrRmax);   % halfmaxを引いて、かつPeakが正になるように揃える。
                
                % pwhmのスタート時点を探す。
                if(maxlagind~=1)
                    temp    = find(xcorr_hm(xcorrRmaxind:-1:1)<0,1,'first'); 
                    if(~isempty(temp))
                        pwhmind(1)  = xcorrRmaxind - temp + 1;
                    end
                end
                
                % pwhmの終了時点を探す。
                if(maxlagind~=nlag)
                    temp    = find(xcorr_hm(xcorrRmaxind:nlag)<0,1,'first'); 
                    if(~isempty(temp))
                        pwhmind(2)  = xcorrRmaxind + temp - 1;
                    end
                end
                
                if(isnan(pwhmind(1)))
                    S.xcorrPWHMOnset    = nan;
                else
                    S.xcorrPWHMOnset    = S.xcorrlag(pwhmind(1));
%                     S.xcorrPWHMOnsetInd = pwhmind(1);
                end
                if(isnan(pwhmind(2)))
                    S.xcorrPWHMOffset   = nan;
                else
                    S.xcorrPWHMOffset   = S.xcorrlag(pwhmind(2));
%                     S.xcorrPWHMOffsetInd= pwhmind(2);
                end
                S.xcorrPWHM = (pwhmind(2) - pwhmind(1) + 1)  / Tar.SampleRate;
                %<<
                
                if(isfield(Tar,'Unit'))
                    S.Unit      = Tar.Unit;
                end
                
                
                Outputfile  = fullfile(OutputDir,InputDir,[S.Name,'.mat']);
                if(~exist(fileparts(Outputfile),'dir'))
                    mkdir(fileparts(Outputfile));
                end
                save(Outputfile,'-struct','S');
                disp([num2str(iPair),'/',num2str(nPair),': ',Outputfile])
%             end % iTar
        end % iRef
        
    catch
        errormsg    = ['****** Error occured in ',InputDirs{iDir}];
        disp(errormsg)
        errorlog(errormsg);
    end % try
end % iDir




warning('on');



