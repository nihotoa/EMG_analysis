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
    
    
    % compiled analysis
    
    for ii=1:nTriggers         %:nfftPoints2:nSamples-nfftPoints2
        disp([num2str(ii),' / ',num2str(nTriggers)])
        selectedData{1} = DataMatrix{1}(:,ii);
        selectedData{2} = DataMatrix{2}(:,ii);
        [Hf(:,:,:,ii), Sf(:,:,:,ii), freq]    = dtransf([selectedData{1}, selectedData{2}], ARorder, nfftPoints, sampleRate, ARmethod);

    end

    % Eliminate NaN array
    NaNtrial    = find(any(any(any(isnan(Hf)))));
    Hf(:,:,:,NaNtrial)  = [];
    Sf(:,:,:,NaNtrial)  = [];
    nTriggers   = size(Hf,4);
    
    
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
    EndHold.compiled.cl.seg_size	= DataS.EndHold.compiled.cl.seg_size;
    EndHold.compiled.cl.samp_tot	= nTriggers * size(DataS.EndHold.data{1},1);
    EndHold.compiled.cl.seg_tot     = EndHold.compiled.cl.samp_tot / DataS.EndHold.compiled.cl.seg_size;
    EndHold.compiled.cl.samp_rate	= DataS.EndHold.compiled.cl.samp_rate;
    EndHold.compiled.cl.df          = DataS.EndHold.compiled.cl.df;
    EndHold.compiled.cl.f_c95       = DataS.EndHold.compiled.cl.f_c95;
    EndHold.compiled.cl.ch_c95      = DataS.EndHold.compiled.cl.ch_c95;

    EndHold.Name1       = DataS.EndHold.Name1;
    EndHold.Name2       = DataS.EndHold.Name2;
    EndHold.Nametrig	= DataS.EndHold.Nametrig;
    EndHold.SampleRate	= DataS.EndHold.SampleRate;
    
    save(fullfile(outpath,files{kk}),'EndHold')
    clear('EndHold');
end

beep
