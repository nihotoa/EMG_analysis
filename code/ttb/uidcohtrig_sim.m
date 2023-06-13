function uidcohtrig

datapath    = uigetdir;
outpath = uigetdir;

files	= what(datapath);
files   = files.mat;

for kk   =1:length(files)
    DataS   = load(fullfile(datapath,files{kk}));
    disp(['Starting',fullfile(datapath,files{kk})])
    
    DataMatrix      = DataS.EndHold.data;
    nTriggers       = size(DataMatrix{1},2);
    nfftPoints      = DataS.EndHold.nfftpoints(1);
    ARorder         = nfftPoints - 1;
    ARmethod        = 'sbc';
    sampleRate      = DataS.EndHold.SampleRate;
    
%     for ii=1:nTriggers
%         randn('state',sum(100*clock));
%         DataMatrix{1}(:,ii) = randn(size(DataMatrix{1}(:,ii))) * std(DataMatrix{1}(:,ii)) + mean(DataMatrix{1}(:,ii));
%         randn('state',sum(100*clock));
%         DataMatrix{2}(:,ii) = randn(size(DataMatrix{2}(:,ii))) * std(DataMatrix{2}(:,ii)) + mean(DataMatrix{2}(:,ii));
%     end
    
    % compiled analysis
    
    for ii=1:nTriggers         %:nfftPoints2:nSamples-nfftPoints2
        disp([num2str(ii),' / ',num2str(nTriggers)])
        selectedData{1} = whiten(DataMatrix{1}(:,ii));
        selectedData{2} = whiten(DataMatrix{2}(:,ii));
        [Hf(:,:,:,ii), Sf(:,:,:,ii), freq]    = dtransf([selectedData{1}, selectedData{2}], ARorder, nfftPoints, sampleRate, ARmethod);

    end

    % average all individual Hf and Sf
    Hf  = mean(Hf,4);
    Sf  = mean(Sf,4);
    
    
    for ii=1:2
        for jj=1:2

            Hf(ii,jj,:)  = smoothing(Hf(ii,jj,:),3,@triang);
            Sf(ii,jj,:)  = smoothing(Sf(ii,jj,:),3,@triang);
        end
    end

    
    [EndHold.compiled.coh, EndHold.compiled.phase]  = dcoh(Hf,Sf,freq,'b');
    EndHold.compiled.freq   = freq;
    EndHold.compiled.coh(:,:,1) = zeros(size(EndHold.compiled.coh(:,:,1)));
    clear('selectedData', 'Hf', 'Sf');

    % output analysis
    save(fullfile(outpath,files{kk}),'EndHold')
    clear('EndHold');
end

beep
