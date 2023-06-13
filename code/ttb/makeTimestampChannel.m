function Y  = makeTimestampChannel(Name, command, varargin)
% Y   = makeTimestampChannel(Name, 'threshold', refchan(continuous), rising th(V), falling th(V));
% Y   = makeTimestampChannel(Name, 'rising threshold', refchan(continuous), th(V));
% Y   = makeTimestampChannel(Name, 'falling threshold', refchan(continuous), th(V));
% Y   = makeTimestampChannel(Name, 'shift', sourcechan, shift(sec));
% Y   = makeTimestampChannel(Name, 'shift cycles', sourcechan, nRelay, nCycles(integer));
% Y   = makeTimestampChannel(Name, 'merge', sourcechans(cell));
% Y   = makeTimestampChannel(Name, 'resample', refchan(timestamp), sample rate(Hz));
% Y   = makeTimestampChannel(Name, 'regular', timerange(sec), sample rate(Hz));
% Y   = makeTimestampChannel(Name, 'stimulus parameter', refchan(timestamp))

switch command
    case 'threshold' % Name, 'threshold', refchan(continuous), rising th(V), falling th(V)
        ref = varargin{1};
        rth = varargin{2};
        fth = varargin{3};

        if(isempty(ref.Data))
            Y.TimeRange = ref.TimeRange;
            Y.Name      = Name;
            Y.Class     = 'timestamp channel';
            Y.SampleRate= ref.SampleRate;
            Y.Data      = ref.Data;
        else
            % Unit adjustment
            if(~isfield(ref,'Unit'))        %V -> d.u.
                VoltageRange    = 5;
                BitPrecision    = 16;

                cfactor         = pow2(BitPrecision - 1) / VoltageRange;
                rth             = rth* cfactor;
                fth             = fth* cfactor;

                %             cfactor         = VoltageRange / pow2(BitPrecision - 1);
                %             ref.Data        = double(ref.Data)* cfactor;
            else
                switch ref.Unit
                    case 'uV'               %V  -> uV
                        cfactor         = 1000*1000;
                        rth             = rth* cfactor;
                        fth             = fth* cfactor;
                        %                     ref.Data    = ref.Data/1000/1000;
                    case 'mV'               %V -> mV
                        cfactor         = 1000;
                        rth             = rth* cfactor;
                        fth             = fth* cfactor;
                        %                     ref.Data    = ref.Data/1000;
                end
            end

            % find threshold crossing
            indr    = (ref.Data >= rth & [NaN ref.Data(1:end-1)] < rth);
            indf    = (ref.Data <= fth & [NaN ref.Data(1:end-1)] > fth);
            ind     = (indr | indf);

            % output
            Y.TimeRange = ref.TimeRange;
            Y.Name      = Name;
            Y.Class	= 'timestamp channel';
            Y.SampleRate= ref.SampleRate;
            Y.Data      = find(ind) - 1;    % ˆê”Ô‰‚ß‚Ìindex‚ª‚O‚É‚È‚é‚æ‚¤‚É‚P‚ðˆø‚­
        end

    case 'rising threshold' % Name, 'rising threshold', refchan(continuous), th(V)
        ref = varargin{1};
        th = varargin{2};

        if(isempty(ref.Data))
            Y.TimeRange = ref.TimeRange;
            Y.Name      = Name;
            Y.Class	= 'timestamp channel';
            Y.SampleRate= ref.SampleRate;
            Y.Data      = ref.Data;
        else

            % Unit adjustment
            if(~isfield(ref,'Unit'))        %V -> d.u.
                VoltageRange    = 5;
                BitPrecision    = 16;

                cfactor         = pow2(BitPrecision - 1) / VoltageRange;
                th              = th* cfactor;

                %             cfactor         = VoltageRange / pow2(BitPrecision - 1);
                %             ref.Data        = double(ref.Data)* cfactor;
            else
                switch ref.Unit
                    case 'uV'               %V  -> uV
                        cfactor         = 1000*1000;
                        th              = th* cfactor;
                        %                     ref.Data    = ref.Data/1000/1000;
                    case 'mV'               %V -> mV
                        cfactor         = 1000;
                        th              = th* cfactor;
                        %                     ref.Data    = ref.Data/1000;
                end
            end


            % find threshold crossing
            ind     = (ref.Data >= th & [NaN ref.Data(1:end-1)] < th);

            % output
            Y.TimeRange = ref.TimeRange;
            Y.Name      = Name;
            Y.Class     = 'timestamp channel';
            Y.SampleRate= ref.SampleRate;
            Y.Data      = find(ind) - 1;    % ˆê”Ô‰‚ß‚Ìindex‚ª‚O‚É‚È‚é‚æ‚¤‚É‚P‚ðˆø‚­
        end

    case 'falling threshold' % Name, 'falling threshold', refchan(continuous), th(V)
        ref = varargin{1};
        th = varargin{2};

        if(isempty(ref.Data))
            Y.TimeRange = ref.TimeRange;
            Y.Name      = Name;
            Y.Class	= 'timestamp channel';
            Y.SampleRate= ref.SampleRate;
            Y.Data      = ref.Data;
        else
            % Unit adjustment
            if(~isfield(ref,'Unit'))        %V -> d.u.
                VoltageRange    = 5;
                BitPrecision    = 16;

                cfactor         = pow2(BitPrecision - 1) / VoltageRange;
                th              = th* cfactor;

                %             cfactor         = VoltageRange / pow2(BitPrecision - 1);
                %             ref.Data        = double(ref.Data)* cfactor;
            else
                switch ref.Unit
                    case 'uV'               %V  -> uV
                        cfactor         = 1000*1000;
                        th              = th* cfactor;
                        %                     ref.Data    = ref.Data/1000/1000;
                    case 'mV'               %V -> mV
                        cfactor         = 1000;
                        th              = th* cfactor;
                        %                     ref.Data    = ref.Data/1000;
                end
            end


            % find threshold crossing
            ind     = (ref.Data <= th & [NaN ref.Data(1:end-1)] > th);

            % output
            Y.TimeRange = ref.TimeRange;
            Y.Name      = Name;
            Y.Class     = 'timestamp channel';
            Y.SampleRate= ref.SampleRate;
            Y.Data      = find(ind) - 1;    % ˆê”Ô‰‚ß‚Ìindex‚ª‚O‚É‚È‚é‚æ‚¤‚É‚P‚ðˆø‚­
        end


    case 'shift' % Name, 'timestamp occurred', source(timestamp), ref(timestamp), timerange[0 1](sec)
        source  = varargin{1};
        shift   = varargin{2};

        if(isempty(source.Data))% source‚Éƒf[ƒ^‚ª‚ ‚éê‡‚Ì‚Ý
%             Y.TimeRange = source.TimeRange;
%             Y.Name      = Name;
%             Y.Class     = 'timestamp channel';
%             Y.SampleRate= source.SampleRate;
%             Y.Data      = source.Data;
            Y           = source;
            Y.Name      = Name;
        else
            DataRange   = [0 (source.TimeRange(2)-source.TimeRange(1))*source.SampleRate];
            %             addflag = false(1,nData);
            shiftind    = shift * source.SampleRate;

            % output
%             Y.TimeRange = source.TimeRange;
%             Y.Name      = Name;
%             Y.Class     = 'timestamp channel';
%             Y.SampleRate= source.SampleRate;
%             
            Y           = source;
            Y.Name      = Name;
            Y.Data      = round(source.Data + shiftind);
            if(isfield(Y,'accessory_data'))
                nfield  = length(Y.accessory_data);
                for ifield=1:nfield
                    Y.accessory_data(ifield).Data  = Y.accessory_data(ifield).Data(Y.Data>= DataRange(1) & Y.Data<= DataRange(2));
                end
            end
            Y.Data      = Y.Data(Y.Data>= DataRange(1) & Y.Data<= DataRange(2));

        end
        
    case 'shift cycles' % Name, 'timestamp occurred', source(timestamp), ref(timestamp), timerange[0 1](sec)
        source  = varargin{1};
        nRelay  = varargin{2};
        nCycle  = varargin{3};
        if(isfield(source,'accessory_data'))
            if(isempty(source.Data))% source‚Éƒf[ƒ^‚ª‚ ‚éê‡‚Ì‚Ý
                Y           = source;
                Y.Name      = Name;
            else
                DataRange   = [0 (source.TimeRange(2)-source.TimeRange(1))*source.SampleRate];
                %             addflag = false(1,nData);
                ifield      = strmatch(['Frequency',num2str(nRelay)],{source.accessory_data.Name});
                Freqs       = source.accessory_data(ifield).Data;
                
                shift       = nCycle ./ Freqs;
                shiftind    = shift .* source.SampleRate;
                
                % output
                %             Y.TimeRange = source.TimeRange;
                %             Y.Name      = Name;
                %             Y.Class     = 'timestamp channel';
                %             Y.SampleRate= source.SampleRate;
                %
                Y           = source;
                Y.Name      = Name;
                Y.Data      = round(source.Data + shiftind);
                if(isfield(Y,'accessory_data'))
                    nfield  = length(Y.accessory_data);
                    for ifield=1:nfield
                        Y.accessory_data(ifield).Data  = Y.accessory_data(ifield).Data(Y.Data>= DataRange(1) & Y.Data<= DataRange(2));
                    end
                end
                Y.Data      = Y.Data(Y.Data>= DataRange(1) & Y.Data<= DataRange(2));
                
            end
        else
            Y           = source;
            Y.Name      = Name;
        end

        
    case 'merge' % Name, 'timestamp occurred', source(timestamp), ref(timestamp), timerange[0 1](sec)
        sources = varargin{1};

        nsource = length(sources);
        for isource=1:nsource
            if(isource==1)
                Y   = sources{isource};
            else
                Y.Data  = [Y.Data,sources{isource}.Data];
            end

        end
        Y.Name  = Name;
        Y.Data  = sort(Y.Data);
        
    case 'resample' % Name, 'resample', refchan(timestamp), sample rate(Hz)
        Y           = varargin{1};
        SampleRate  = varargin{2};
        
        Y.Data      = round(Y.Data * SampleRate / Y.SampleRate);
        Y.SampleRate= SampleRate;
    
    case 'regular'% Y   = makeTimestampChannel(Name, 'regular', timerange(sec), sample rate(Hz));
        TimeRange   = varargin{1};
        SampleRate  = varargin{2};
        
        Y.TimeRange = TimeRange;
        Y.Name      = Name;
        Y.Class     = 'timestamp channel';
        Y.SampleRate=   SampleRate;
        nData       = (TimeRange(2)-TimeRange(1))*SampleRate;
        Y.Data      = (0:nData);
       
    case 'stimulus parameter'
        ref     = varargin{1};
        
        Y       = readStimID(ref);
        Y.Name  = Name;
        
                
end


function S  = readStimID(ref)

basefreq    = 1000; % Hz
nCh         = 8;


SampleRate  = ref.SampleRate;
% baseisi     = SampleRate./basefreq;  % step
baseisi     = 1./basefreq;  %s


S   = filterTimestampChannel(ref.Name, '~timestamp occurred', ref, ref, [-0.008 -1/SampleRate]);



for iCh=1:nCh
    temp    = filterTimestampChannel(ref.Name, 'timestamp occurred', S, ref, [baseisi*iCh baseisi*(iCh+1)]-baseisi/2);
    
    S.accessory_data(iCh).Name  = ['Relay',num2str(iCh)];
    S.accessory_data(iCh).Data  = double(ismember(S.Data,temp.Data));
    
end

