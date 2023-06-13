function mra_btc(TimeRange,alpha,varargin)
% MRA_btc(TimeRange,alpha,normalize_method)

% MRA_btc([0 90],0.05,'sd','centering')

if nargin < 1
    TimeRange       = [-inf inf];
    alpha           = 0.05;
    normalize_method= [];
    normalize_flag  = 0;
elseif nargin < 2
    alpha           = 0.05;
    normalize_method= [];
    normalize_flag  = 0;
elseif nargin < 3
    normalize_method= [];
    normalize_flag  = 0;
else
    normalize_method= varargin;
    normalize_flag  = 1;
end


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

InputDirs  = getconfig(mfilename,'InputDirs');
try
    if(isempty(InputDirs) || ~iscell(InputDirs))
        InputDirs   = '';
    end
catch
    InputDirs   = '';
end
InputDirs   = uiselect(dirdir(ParentDir),1,'対象とするExperimentsを選択してください',InputDirs);
if(isempty(InputDirs))
    disp('User pressed cancel.');
    return;
else
    setconfig(mfilename,'InputDirs',InputDirs);
end


InputDir    = InputDirs{1};
FileNames   = dirmat(fullfile(ParentDir,InputDir));
FileNames   = strfilt(FileNames,'~._');


Tarfile     = getconfig(mfilename,'Tarfile');
try
    if(~ischar(Tarfile))
        Tarfile   = '';
    end
catch
    Tarfile   = '';
end
Tarfile     = uiselect(sortxls(FileNames),1,'従属変数（Y）とするfileを選択してください',Tarfile);
if(isempty(Tarfile))
    disp('User pressed cancel.');
    return;
else
    Tarfile     = Tarfile{1};
    setconfig(mfilename,'Tarfile',Tarfile);
end




Reffiles     = getconfig(mfilename,'Reffiles');
try
    if(~iscell(Reffiles))
        Reffiles   = '';
    end
catch
    Reffiles   = '';
end
Reffiles    = uiselect(sortxls(FileNames),1,'独立変数（X）とするfileを選択してください',Reffiles);
if(isempty(Reffiles))
    disp('User pressed cancel.');
    return;
else
    setconfig(mfilename,'Reffiles',Reffiles);
end


Tar         = load(fullfile(ParentDir,InputDir,Tarfile));
if(~isfield(Tar,'XData')) % MDAdataのとき
    
    
    Trigfile     = getconfig(mfilename,'Trigfile');
    try
        if(~ischar(Trigfile))
            Trigfile   = '';
        end
    catch
        Trigfile   = '';
    end
    Trigfile     = uiselect(sortxls(FileNames),1,'TimeRangeのトリガーとなるTime Stamp channelを選択してください。この機能を使わないときはCancelを押してください。',Trigfile);
    if(iscell(Trigfile) && ~isempty(Trigfile))
        
        Trigfile     = Trigfile{1};
    else
        Trigfile     = [];
    end
else
    Trigfile     = [];
end
setconfig(mfilename,'Reffiles',Reffiles);



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



nDir    = length(InputDirs);
nRef    = length(Reffiles);

for iDir=1:nDir
    try
        clear('S','X','Y');
        
        S.AnalysisType  = 'MRA';
        S.Name          = 'MRA (';
        S.TimeRange     = TimeRange;
        S.alpha         = alpha;
        S.normalize_method  = normalize_method;
        
        S.SampleRate    = [];
        S.TargetName    = Tarfile;
        S.ReferenceName = Reffiles';
        S.TriggerName   = Trigfile;
        
        InputDir    = InputDirs{iDir};
        disp([num2str(iDir),'/',num2str(nDir),':  ',InputDir])
        
        if(~isempty(Trigfile))
            Trig         = load(fullfile(ParentDir,InputDir,Trigfile));
            StartTime   = Trig.Data(1) ./ Trig.SampleRate;
            TimeRange2  = TimeRange + StartTime;
            S.TimeRange = TimeRange2;
        else                    % sta fileのとき
            TimeRange2  = TimeRange;
        end
        
        S.TimeRange2    = TimeRange2;
        
        % load Y(Target)
        Tar = load(fullfile(ParentDir,InputDir,Tarfile));
        if(isfield(Tar,'XData'))    % sta fileのとき
            ind     = (Tar.XData >= TimeRange2(1) & Tar.XData <= TimeRange2(2));
            Y       = Tar.YData(ind)';
        else            % continuous fileのとき
            XData   = ((1:length(Tar.Data))-1)/Tar.SampleRate;
            ind     = (XData >= TimeRange2(1) & XData <= TimeRange2(2));
            Y       = Tar.Data(ind)';
        end
        
        S.Name      = [S.Name,deext(Tar.Name),')'];
        S.SampleRate    = Tar.SampleRate;
        
        % load X(References)
        for iRef=1:nRef
            clear('Ref')
            Reffile     = fullfile(ParentDir,InputDir,Reffiles{iRef});
            Ref         = load(Reffile);
            
            if(isfield(Ref,'XData'))    % sta fileのとき
                ind     = (Ref.XData >= TimeRange2(1) & Ref.XData <= TimeRange2(2));
                if(iRef==1)
                    X   = zeros(size(Ref.YData(ind),2),nRef);
                end
                X(:,iRef)   = Ref.YData(ind)';
            else            % continuous fileのとき
                XData   = ((1:length(Ref.Data))-1)/Ref.SampleRate;
                ind     = (XData >= TimeRange2(1) & XData <= TimeRange2(2));
                if(iRef==1)
                    X   = zeros(size(Ref.Data(ind),2),nRef);
                end
                X(:,iRef)   = Ref.Data(ind)';
            end
            
            
        end
        
        if(normalize_flag==1)
            Y   = normalize(Y',normalize_method{:})';
            X   = normalize(X',normalize_method{:})';
        end
        
        % 重回帰分析
        % Vandermonde 行列 X
        
        X  = [ones(size(X,1),1),X];
        
        [S.nN,S.nP] = size(X);
        S.nP        = S.nP-1; % 定数項の分自由度を引く
       
        [S.b,S.bint]   = regress(Y,X,alpha);
        
        Yhat    = X * S.b;
        S.bH    = S.bint(:,2)<0 | S.bint(:,1)>0;
        S.Y     = Y;
        S.Yhat  = Yhat;
        S.stats.R       = corr(Yhat,Y);                             % 重相関係数
        S.stats.R2      = S.stats.R.^2;
        S.stats.Ra      = sqrt(1-(S.nN-1).*(1-S.stats.R2)./(S.nN-S.nP-1));    % 自由度調整済み重相関係数
        
        S.stats.F       = ((S.stats.R2) .* (S.nN-S.nP-1)) ./ ((1 - S.stats.R2) .* S.nP);  % F値
        S.stats.P       = 1-fcdf(S.stats.F,S.nP,S.nN-S.nP-1);                   % 有意確率
        S.stats.H       = S.stats.P < alpha;                                % 有意
        S.stats.E       = sum((Y - Yhat).^2);                         % 回帰の二乗誤差
        
        
        Outputdir       = fullfile(OutputDir,InputDir);
        Outputfile      = fullfile(Outputdir,[S.Name,'.mat']);
        if(~exist(Outputdir,'dir'))
            mkdir(Outputdir);
        end
        save(Outputfile,'-struct','S');
        disp(Outputfile)
        
    catch
        errormsg    = ['****** Error occured in ',InputDirs{iDir}];
        disp(errormsg)
        errorlog(errormsg);
    end
    %     indicator(0,0)
    
end
warning('off');



