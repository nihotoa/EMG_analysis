function trace2wcoh_btc(Outputdir)
% trace2wcoh_btc(Outputdir)
% ex.
% trace2wcoh_btc('071106');

warning('off');
if nargin<1
    error('Outputdir must be specified. (ex.) trace2wcoh_btc(''071106'')');
    %     return;
end



% --------------------------
% Set parameters
%

maxtrials    = 50;


ExpSets	={{'EitoT02703f','EitoT02704f'}};




% Reffile     = 'STA (Grip Onset (success valid), Non-filtered-subsample(uV)).mat';
% Reffile     = 'STA (Grip Onset (success valid)(0-500um), Field 1-subsample).mat';
Reffile     = 'STA (Grip Onset (svwostim), Field 1-subsample(uV)).mat';

Original_Tarfiles	= {'STA (Grip Onset (svwostim), FDI-subsample(uV)).mat',...
    'STA (Grip Onset (svwostim), ADP-subsample(uV)).mat',...
    'STA (Grip Onset (svwostim), 3DI-subsample(uV)).mat',...
    'STA (Grip Onset (svwostim), 2DI-subsample(uV)).mat',...
    'STA (Grip Onset (svwostim), AbPB-subsample(uV)).mat',...
    'STA (Grip Onset (svwostim), BRD-subsample(uV)).mat',...
    'STA (Grip Onset (svwostim), ED23-subsample(uV)).mat',...
    'STA (Grip Onset (svwostim), ECR-subsample(uV)).mat',...
    'STA (Grip Onset (svwostim), EDC-subsample(uV)).mat',...
    'STA (Grip Onset (svwostim), ECU-subsample(uV)).mat',...
    'STA (Grip Onset (svwostim), AbPL-subsample(uV)).mat',...
    'STA (Grip Onset (svwostim), 4DI-subsample(uV)).mat',...
    'STA (Grip Onset (svwostim), AbDM-subsample(uV)).mat',...
    'STA (Grip Onset (svwostim), FCR-subsample(uV)).mat',...
    'STA (Grip Onset (svwostim), FDS-subsample(uV)).mat',...
    'STA (Grip Onset (svwostim), FDPr-subsample(uV)).mat',...
    'STA (Grip Onset (svwostim), FDPu-subsample(uV)).mat',...
    'STA (Grip Onset (svwostim), FCU-subsample(uV)).mat',...
    'STA (Grip Onset (svwostim), PL-subsample(uV)).mat',...
    'STA (Grip Onset (svwostim), Biceps-subsample(uV)).mat',...
    'STA (Grip Onset (svwostim), Triceps-subsample(uV)).mat'};

Outputdir   = fullfile(datapath,'wcoh',Outputdir);
Sourcedir   = fullfile(datapath,'STA');

freqVec     = [1.25:1.25:100];   % Hz
% freqVec     = [2:2:100];   % Hz
sigma       = 0.128;            % sec

% --------------------------

Tarfiles    = uiselect(Original_Tarfiles,1,'対象となるファイルを選択してください。');
uiwait(msgbox(Tarfiles,'確認','modal'));

mkdir(Outputdir);
nExpSet	= length(ExpSets);
% nTarget	= length(Tarfiles);

for ii=1:nExpSet
    try
        currExpSet  = ExpSets{ii};
        firstExp	= currExpSet{1};
        nExp        = length(currExpSet);

        disp([num2str(ii),'/',num2str(nExpSet),' == ',firstExp])

        %     Tarfiles    = uiselect(Original_Tarfiles,1,firstExp);
        %     uiwait(msgbox(Tarfiles,firstExp,'modal'));

        nTarget	= length(Tarfiles);

        if(nTarget < 1)
            continue;
        end

        for jj=1:nExp
            Ref     = load(fullfile(Sourcedir,currExpSet{jj},Reffile));
            if(jj==1)
                RefData	= Ref.TrialData;
                RefName = Ref.TargetName;
                timeVec = Ref.XData;
                Fs      = Ref.SampleRate;
            else
                RefData	= [RefData;Ref.TrialData];
            end
        end
        ntrials = size(RefData,1);
        rand('state',0) % ランダムで選ぶけど、いつも同じセットが出るようにしているということ
        randind     = randperm(ntrials);

        if ntrials  > maxtrials
            RefData = RefData(randind(1:maxtrials),:);
        end

        clear('Ref');pack;

        for kk =1:nTarget
            Tarfile = Tarfiles{kk};
            for jj=1:nExp
                Tar     = load(fullfile(Sourcedir,currExpSet{jj},Tarfile));
                if(jj==1)
                    TarData	= Tar.TrialData;
                    TarName = Tar.TargetName;
                else
                    TarData	= [TarData;Tar.TrialData];
                end
            end

            if ntrials  > maxtrials
                TarData = TarData(randind(1:maxtrials),:);
            end

            clear('Tar');pack;
            Outputfile  = (fullfile(Outputdir,[firstExp,'_',RefName,'__',TarName,'.mat']));


            [cxy,txxx,fxxx,px,py,pxy,phi]   =trace2wcoh(RefData,TarData,freqVec,Fs,sigma);
            cl.sigma        = sigma;
            cl.seg_tot      = size(RefData,1);
            cl.samp_rate    = Fs;
            cl.ch_c95       = cohcl(0.05,size(RefData,1));
            freq            = freqVec;
            t               = timeVec;

            save(Outputfile,'px','py','pxy','cxy','phi','cl','freq','t')

            disp(['   ',num2str(kk),'/',num2str(nTarget),' -> ',Outputfile])
        end
    catch
        currExpSet  = ExpSets{ii};
        firstExp	= currExpSet{1};
        disp(['*** Error occured in ',firstExp])
    end

end

warning('on')
