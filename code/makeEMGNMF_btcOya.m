%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
[your operation]
1. Go to the directory named monkey name (ex.) if you want to analyze Yachimun's data, please go to 'EMG_analysis/data/Yachimun'
2. Please run this code

[role of this code]
Perform muscle synergy analysis and save the results (as .mat file)

[Saved data location]
location:
/Volumes/SSPH/EMG_analysis/data/Yachimun/new_nmf_result/selected_folder_name (ex.) F170516_standard
file name: selected_folder_name + .mat (ex.)F170516_standard.mat => this file contains analysis conditions, VAF, and other data
                t_ + selected_folder_name + .mat (ex.)t_F170516_standard.mat => this file contains synergy data

[procedure]
ÅEfor Nibali('Nibali' is monkey name)
pre : untitled.m
post : makefold.m

ÅEanother monkey
pre:fitlerBat_SynNMFPre.m
post: SYNERGYPLOT.m

[Improvement points(Japanaese)]
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function makeEMGNMF_btcOya(TimeRange,kf,nrep,nshuffle,alg)
% setting parameters
if nargin<1
    TimeRange   = [0 Inf];
    kf          = 4; % How many parts of data to divide in cross-validation
    nrep        = 20; % repetition number of synergy search
    nshuffle    = 1; % whether you want to confirm shuffle
    alg         = 'mult'; % algorism of nnmf (mult: Multiplicative Update formula, als: Alternating Least Squares formula)
elseif nargin<2
    kf          = 4;
    nrep        = 20;
    nshuffle    = 1;
    alg         = 'mult';
elseif nargin<3
    nrep        = 20;                    
    nshuffle    = 1;
    alg         = 'mult';
elseif nargin<4
    nshuffle    = 1;
    alg         = 'mult';
elseif nargin<5
    alg         = 'mult';
end

warning('off');

% Determine ParentDir
ParentDir    = getconfig(mfilename,'ParentDir');
try
    if(~exist(ParentDir,'dir'))
        ParentDir    = pwd;
    end
catch
    ParentDir    = pwd;
end
disp('ÅyPlease select nmf_result fold (data/Yachimun/new_nmf_resultÅz)')
ParentDir   = uigetdir(ParentDir,'?e?t?H???_???I???????????????B');

if(ParentDir==0)
    disp('User pressed cancel.')
    return;
else
    setconfig(mfilename,'ParentDir',ParentDir);
end

% get info about dates of analysis data and used EMG
disp('ÅyPlease select all day folders you want to analyze (Multiple selections are possible)Åz)')
InputDirs   = uiselect(dirdir(ParentDir),1,'??????????Experiments???I??????????????');

InputDir    = InputDirs{1};
% Assign all file names contained in InputDirs{1} to Tarfiles
Tarfiles = sortxls(dirmat(fullfile(ParentDir,InputDir)));
disp('ÅyPlease select used EMG DataÅz')
Tarfiles    = uiselect(Tarfiles,1,'Target?');

% determine OutputDirs(where to save the result data)
OutputDir   = fullfile(ParentDir, InputDir);
day_part = regexp(InputDir, '\d+', 'match');
prev_day = day_part{1};
if(OutputDir==0)
    disp('User pressed cancel.')
    return;
else
    setconfig(mfilename,'OutputDir',OutputDir);
end


%% Extract synergies from each measurement data by daily iterations
nDir    = length(InputDirs);
nTar    = length(Tarfiles);

for iDir=1:nDir
    try
        InputDir    = InputDirs{iDir};
        disp([num2str(iDir),'/',num2str(nDir),':  ',InputDir])

        % create matrix of EMG data(XData)
        for iTar=1:nTar % each muscle
            clear('Tar')
            Tarfile     = Tarfiles{iTar};
            Inputfile   = fullfile(ParentDir,InputDir,Tarfile);

            % load filtered EMG (and assign it to Tar)
            Tar     = load(Inputfile);
            XData   = ((1:length(Tar.Data))-1)/Tar.SampleRate;
            ind     = (XData >= TimeRange(1) & XData <= TimeRange(2));

            if(iTar==1)
                X   = zeros(nTar,size(Tar.Data(ind), 2));
                Name = cell(nTar,1);
            end
            X(iTar,:)   = Tar.Data(ind);
            Name{iTar}  = deext(Tar.Name);
        end

        % Preprocessing for matrix of EMG dataset (X)

        % 1. offset so that the minimum value is 0
        X   = offset(X,'min');
        
        % 2. Each EMG is normalized by the mean of each EMG
        normalization_method    = 'mean';
        X     = normalize(X,normalization_method);
        
        % 3. set negative values to 0 (to avoind taking negative values)
        X(X<0)  = 0;
        
        % Perform NNMF(Non Negative Matrix Factorization) & extract muscle(it takes a lot of time!)
        [Y,Y_dat] = makeEMGNMFOya(X, kf, nrep, nshuffle, alg);

        % Postprocess
        % Add various information to structure Y
        Y.Name          = InputDir;
        Y.AnalysisType  = 'EMGNMF';
        Y.TargetName    = Name;
        Y.TimeRange     = TimeRange;
        Y.Info.Class        = Tar.Class;
        Y.Info.SampleRate   = Tar.SampleRate;
        Y.Info.Unit         = Tar.Unit;
        
        % create a full path of the file to save
        temp = regexp(InputDir, '\d+', 'match');
        current_day = temp{1};
        OutputDir = strrep(OutputDir, prev_day, current_day);
        prev_day = current_day;
        Outputfile      = fullfile(OutputDir,[InputDir,'.mat']);
        Outputfile_dat  = fullfile(OutputDir,['t_',InputDir,'.mat']);
        
        % save structure data to the specified path(contents of Outputfile & Outputfile_dat)
        save(Outputfile,'-struct','Y');
        disp(Outputfile)
        save(Outputfile_dat,'-struct','Y_dat');
        disp(Outputfile_dat)
    catch 
        errormsg    = ['****** Error occured in ',InputDirs{iDir}];
        disp(errormsg)
        errorlog(errormsg);
    end
end
%MailClient;
%sendmail('toya@ncnp.go.jp',InputDir,'makeEMGNMF_btc Analysis Done!!!');
warning('on');
end