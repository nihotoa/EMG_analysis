function errorfiles  = makemdachannel(Expdirs)
if nargin<1
    Expdirs  = uiselectdir(matpath);
    for ii=1:length(Expdirs)
    end

    if(~iscell(Expdirs))
        Expdirs = {Expdirs};
    end

    nExp    = length(Expdirs)

    %% declare source channels

    ch1name = 'smoothed Index Torque(N).mat';
    ch2name = 'smoothed Thumb Torque(N).mat';
    ch3name = 'Grip Onset (svwostim).mat';


    for iExp    =1:nExp
        Expdir = Expdirs{iExp};
        %% load source channels
        try
            ch1 = load(fullfile(Expdir,ch1name));
            ch2 = load(fullfile(Expdir,ch1name));
            ch3 = load(fullfile(Expdir,ch1name));
        catch
            rethrow(lasterror)
        end

        %% create channel header

        Y1.TimeRange    = ch1.TimeRange;
        Y1.Name         = 'Total Torque(N)';
        Y1.Class        = 'continuous channel';
        Y1.SampleRate   = ch1.SampleRate;
        Y1.Unit         = 'N';

        Y2.TimeRange    = ch1.TimeRange;
        Y2.Name         = 'Total deriv Torque(Nps)';
        Y2.Class        = 'continuous channel';
        Y2.SampleRate   = ch1.SampleRate;
        Y2.Unit         = 'Nps';

        Y3.Name          = 'Release Onset (svwostim).mat';
        Y3.Class         = 'timestamp channel';
        Y3.SampleRate    = ch1.SampleRate;



        %% create channel data
        Y1.Data	= ch1.Data + ch2.Data;
        Y2.Data = [0 diff(Y1.Data)]*Y2.SampleRate;
        Y3.Data = [];
        
        for ii=1:length(Ind)
            Y3.Data(ii)=WindowMatrix(ii,Ind(ii));
        end
        
        
        
        %% save channels file

        save(fullfile(OutputDir,Y1.Name),'-struct','Y1');
        save(fullfile(OutputDir,Y2.Name),'-struct','Y2');
        save(fullfile(OutputDir,Y3.Name),'-struct','Y3');
    end

