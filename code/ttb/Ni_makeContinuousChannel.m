function Y  = makeContinuousChannel(Name, command, varargin)
% Y   = makeContinuousChannel(Name, 'histogram', refchan(timestamp), sampling rate(Hz));
% Y   = makeContinuousChannel(Name, 'spike kernel smoothing', refchan(timestamp), sample rate(Hz), gausian_sd(sec));
% Y   = makeContinuousChannel(Name, 'unit conversion', refchan(continuous), gain, offset, unit);   gain＝1Vがいくつになるか(指定した単位による)を指定する。
% Y   = makeContinuousChannel(Name, 'resample', refchan(continuous), sample rate(Hz), average_flag);
% Y   = makeContinuousChannel(Name, 'linear smoothing', refchan(continuous), window(sec));
% Y   = makeContinuousChannel(Name, 'kernel smoothing', refchan(continuous), gausian_sd(sec));
% Y   = makeContinuousChannel(Name, 'butter', refchan(continuous),filter_type('low','high','stop'), filter_order, filter_w(Hz), filter_direction('normal','reverse','both');
% Y   = makeContinuousChannel(Name, 'cheby2', refchan(continuous),filter_type('low','high','stop'), filter_order, filter_w(Hz), filter_R(dB), filter_direction('normal','reverse','both'));
% Y   = makeContinuousChannel(Name, 'fir1', refchan(continuous),filter_type('low','high','stop','bandpass'), filter_order, filter_w(Hz), filter_direction('normal','reverse','both');

% Y   = makeContinuousChannel(Name, 'interspike interval', refchan(timestamp), sample rate(Hz));
% Y   = makeContinuousChannel(Name, 'remove artifact', refchan(continuous), ArtifactTimes(timestamp chan), timewindow);
% Y   = makeContinuousChannel(Name, 'detrend', refchan(continuous), varargin);
%         ex1. S=makeContinuousChannel('New','detrend',s)
%         ex1. S=makeContinuousChannel('New','detrend',s,'const')
%         ex1. S=makeContinuousChannel('New','detrend',s,'linear',10)
%         see also detrend
% Y   = makeContinuousChannel(Name, 'rectify', refchan(continuous));
% Y   = makeContinuousChannel(Name, 'conversion', refchan(timestamp or interval), sample rate(Hz));
% Y   = makeContinuousChannel(Name, 'derivative', refchan(continuous), N(th));
% Y   = makeContinuousChannel(Name, 'integral',   refchan(continuous), N(th));

switch command
    case 'histogram' % Name, 'histogram', refchan(continuous), sampling rate
        ref = varargin{1};
        SampleRate  = varargin{2};
        TotalTime   = ref.TimeRange(2)-ref.TimeRange(1);
        
        XData       = linspace(0,TotalTime,TotalTime*SampleRate + 1);   % sec
        XData(end)  = [];
        
        if(isempty(ref.Data))
            
            Y.TimeRange = ref.TimeRange;
            Y.Name      = Name;
            Y.Class     = 'continuous channel';
            Y.SampleRate= SampleRate;
            Y.Data      = zeros(size(XData));
            Y.Unit      = 'sps';
        else

            % output
            Y.TimeRange = ref.TimeRange;
            Y.Name      = Name;
            Y.Class     = 'continuous channel';
            Y.SampleRate= SampleRate;
            Y.Data      = ref.Data  / ref.SampleRate;  % sec
            Y.Data      = hist(Y.Data,XData)*SampleRate;
            Y.Unit      = 'sps';
            
        end
        
    case 'spike kernel smoothing' % Name, 'threshold', refchan(continuous), rising th(V), falling th(V)
        ref = varargin{1};
        SampleRate  = varargin{2};
        sd  = varargin{3};
                
        
        Y   = makeContinuousChannel(Name,'histogram',ref,SampleRate);
        Y   = makeContinuousChannel(Name,'kernel smoothing',Y,sd);
        
        
    case 'unit conversion' % Name, 'threshold', refchan(continuous), rising th(V), falling th(V)
        Y       = varargin{1};
        gain    = varargin{2};
        offset  = varargin{3};
        unit    = varargin{4};
        cfactor    = 1;
        Y.Name  = Name;
        Y.Data  = (Y.Data + offset)*cfactor*gain;
        Y.Unit  = unit;
        
        
    case 'resample' % Y   = makeContinuousChannel(Name, 'resample', refchan(continuous), sample rate(Hz), average_flag);
        ref             = varargin{1};
        SampleRate      = varargin{2};
        if(nargin<5)
            average_flag    = 0;
        else
            average_flag    = varargin{3};
        end
        
        
        if(ref.SampleRate == SampleRate)
            Y       = ref;
            Y.Name  = Name;
            return;
        end
        Y           = ref;
        Y.Name  = Name;
        
        Y.SampleRate  = SampleRate;
        nData       = length(Y.Data);
        XData       = ((1:nData)-1)./ref.SampleRate + ref.TimeRange(1); % sec
        TotalTime   = ref.TimeRange(2) - ref.TimeRange(1);
        newnData    = floor(TotalTime*SampleRate);
        newTotalTime    = newnData/SampleRate;
        newTimeRange   = [0 newTotalTime]+ref.TimeRange(1);
        newXData    = ((1:newnData)-1)./SampleRate + newTimeRange(1);
        Y.TimeRange = newTimeRange;
        
        if(average_flag==1)
            disp('resample: average')
            ws      = 1./SampleRate;
            ref     = makeContinuousChannel(ref.Name, 'linear smoothing', ref, ws);
            
        end
        
        if(ref.SampleRate > SampleRate)
            % downsample: "interp1" with 'nearest' method
            disp('resample: downsample')
            
            Y.Data  = interp1(XData,ref.Data,newXData,'nearest');
            
        elseif (ref.SampleRate < SampleRate)
            % upsample: "interp1" with 'spline' method
            disp('resample: upsample')
            
            Y.Data  = interp1(XData,ref.Data,newXData,'spline');
        end
        
        
        
        
    case 'resampleold' % Y   = makeContinuousChannel(Name, 'resample', refchan(continuous), sample rate(Hz), average_flag);
        ref             = varargin{1};
        SampleRate      = varargin{2};
        if(nargin<5)
            average_flag    = 0;
        else
            average_flag    = varargin{3};
        end
        
        if(ref.SampleRate > SampleRate)
            % downsample
            disp('resample: downsample')
            
            Y           = ref;
            Y.Name      = Name;
            
            dind        = ceil(ref.SampleRate/SampleRate);
            Y.SampleRate  = ref.SampleRate./dind;
            
            if(average_flag==1)
                disp('resample: average')
                if(mod(dind,2)==0)
                    wn  = [0.5,ones(1,dind-1),0.5]./dind;
                else
                    wn  = ones(1,dind)./dind;
                end
                Y.Data  = conv2(Y.Data,wn,'same');
                %                 Y.Data  = smoothing(Y.Data,wn,'manual');
            end
            
            Y.Data  = Y.Data(1:dind:end);
            
            
        elseif(ref.SampleRate < SampleRate)
            disp('resample: upsample')
            
            Y       = ref;
            Y.Name  = Name;
            
            
            TotalTime   = ref.TimeRange(2) - ref.TimeRange(1);
            XData       = linspace(0,TotalTime,TotalTime*ref.SampleRate+1);
            XData(end)  = [];
            XDatai      = linspace(0,TotalTime,TotalTime*SampleRate+1);
            XDatai(end) = [];
            Y.Data      = interp1(XData,ref.Data,XDatai,'*spline');
            Y.SampleRate= SampleRate;
        else
            Y       = ref;
            Y.Name  = Name;
            
        end
        
        
        
        
        

    case 'linear smoothing'        % (Name, 'linear smoothing', refchan(continuous), window(sec));
        Y      = varargin{1};
        window = varargin{2};  %sec
        npnt   = round(window * Y.SampleRate);
        
        kernel  = ones(1,npnt)/npnt;
        Y.Name  = Name;
        Y.Data  = conv2(Y.Data,kernel,'same');
        
%         Y.Data  = smoothing(Y.Data,npnt,'boxcar');

        
    case 'kernel smoothing' % Name, 'threshold', refchan(continuous), rising th(V), falling th(V)
        ref = varargin{1};
        sd  = varargin{2};
                        
        
        sd  = round(sd * ref.SampleRate);
        kernel  = normpdf(-sd*5:sd*5,0,sd);
        
        Y       = ref;
        Y.Name  = Name;
        Y.Data  = conv2(ref.Data,kernel,'same');
        
    case 'butter'           % Name, 'butter', refchan(continuous),,filter_type('low','high','stop'), filter_order, filter_w
        
%         lbuf            = 50000;
        Y               = varargin{1};
        filter_type     = varargin{2};
        filter_order    = varargin{3};
        filter_w        = varargin{4};
        if(length(varargin)>4)
            filter_direction    = varargin{5};
        else
            filter_direction    = 'normal';
        end
        filter_w        = (filter_w .* 2) ./ Y.SampleRate;
%         nData           = length(Y.Data);
%         nbuf            = ceil(nData ./ lbuf);
        
        [B,A]   = butter(filter_order,filter_w,filter_type);
        Y.Name  = Name;
        
        switch lower(filter_direction)
            case 'normal'
                Y.Data  = filter(B,A,Y.Data);
            case 'reverse'
                Y.Data  = filter(B,A,Y.Data(end:-1:1));
                Y.Data  = Y.Data(end:-1:1);
            case 'both'
                Y.Data  = filtfilt(B,A,Y.Data);
        end
       
    case 'cheby2'           % Name, 'butter', refchan(continuous),,filter_type('low','high','stop'), filter_order, filter_w
        Y               = varargin{1};
        filter_type     = varargin{2};
        filter_order    = varargin{3};
        filter_w        = varargin{4};
        filter_R        = varargin{5};
        if(nargin>5)
            filter_direction    = varargin{6};
        else
            filter_direction    = 'normal';
        end
        filter_w        = (filter_w .* 2) ./ Y.SampleRate;
        
        [B,A]   = cheby2(filter_order,filter_R,filter_w,filter_type);
        Y.Name  = Name;
        
        switch lower(filter_direction)
            case 'normal'
                Y.Data  = filter(B,A,Y.Data);
            case 'reverse'
                Y.Data  = filter(B,A,Y.Data(end:-1:1));
                Y.Data  = Y.Data(end:-1:1);
            case 'both'
                Y.Data  = filtfilt(B,A,Y.Data);
        end
        
        
    case 'fir1'           % Name, 'fir1', refchan(continuous),filter_type('low','high','stop','bandpass'), filter_order, filter_w
        
        Y               = varargin{1};
        filter_type     = varargin{2};
        filter_order    = varargin{3};
        filter_w        = varargin{4};
        if(length(varargin)>4)
            filter_direction    = varargin{5};
        else
            filter_direction    = 'normal';
        end
        filter_w        = (filter_w .* 2) ./ Y.SampleRate;
        
        B   = fir1(filter_order,filter_w,filter_type);
        Y.Name  = Name;
        
        switch lower(filter_direction)
            case 'normal'
                Y.Data  = filter(B,1,Y.Data);
            case 'reverse'
                Y.Data  = filter(B,1,Y.Data(end:-1:1));
                Y.Data  = Y.Data(end:-1:1);
            case 'both'
                Y.Data  = filtfilt(B,1,Y.Data);
        end



    case 'interspike interval'%Name, 'interspike interval',refchan(timestamp), SampleRate(Hz)
        
        ref = varargin{1};
        SampleRate  = varargin{2};
%         ref = makeTimestampChannel(Name,'resample',ref,SampleRate);
        
        if(isempty(ref.Data))
            
            Y.TimeRange = ref.TimeRange;
            Y.Name      = Name;
            Y.Class     = 'continuous channel';
            Y.SampleRate= ref.SampleRate;
            Y.Data      = zeros(1,(ref.TimeRange(2)-ref.TimeRange(1))*ref.SampleRate);
            Y.Unit      = 'sps';
        else

            % output
            Y.TimeRange = ref.TimeRange;
            Y.Name      = Name;
            Y.Class     = 'continuous channel';
            Y.SampleRate= ref.SampleRate;
            Y.Data      = zeros(1,(ref.TimeRange(2)-ref.TimeRange(1))*ref.SampleRate);
            nData       = length(ref.Data);
            
            for iData=2:nData
                if( (ref.Data(iData) - ref.Data(iData-1))~=0)

                    ind = [ref.Data(iData-1) ref.Data(iData)];
                    n   = ind(2) - ind(1) + 1;
                    FR  = ref.SampleRate / (ind(2) - ind(1));
                    
%                     % method#1 scalar interpolation
                    Y.Data((ind(1)+1):ind(2))   = FR; 

                    % method#2linear interpolation
%                     Y.Data(ind(1):ind(2)) = linspace(Y.Data(ind(1)),FR,n);
                end
            end

            Y.Unit      = 'sps';
        end
        
        Y   = makeContinuousChannel(Y.Name, 'resample', Y, SampleRate, 1);  % resample (and average)
        
    case 'remove artifact with noise'
        ref   = varargin{1};
        AT  = varargin{2};
        window  = varargin{3};
        
        window  = round(window * ref.SampleRate);
        windowlength    = window(2) - window(1) + 1;  
        AT.Data = round(AT.Data * ref.SampleRate / AT.SampleRate);
        nAT = length(AT.Data);
        
%         sd  = std(ref.Data,0);
        
        Y   = ref;
        Y.Name  = Name;
        
        for iAT =1:nAT
            ind = AT.Data(iAT) + window;
            sd  = std(ref.Data(ind),0);
            Y.Data(ind(1):ind(2))  = linspace(ref.Data(ind(1)),ref.Data(ind(2)),windowlength) + sd .* randn(1,windowlength);
        end
        
        
    case 'remove artifact'
        ref   = varargin{1};
        AT  = varargin{2};
        window  = varargin{3};
        
        window  = (window * AT.SampleRate);
%         AT.Data = round(AT.Data * ref.SampleRate / AT.SampleRate);
        nAT = length(AT.Data);
        nData   = length(ref.Data);
        
%         sd  = std(ref.Data,0);
        
        Y   = ref;
        Y.Name  = Name;
        
        for iAT =1:nAT
            ind = ceil((AT.Data(iAT) + window)* ref.SampleRate / AT.SampleRate);
%             ind = AT.Data(iAT) + window;
            ind = [max(1,ind(1)) min(nData,ind(2))];
            windowlength    = ind(2) - ind(1) + 1;
%             sd  = std(ref.Data(ind),0);
            Y.Data(ind(1):ind(2))  = linspace(Y.Data(ind(1)),Y.Data(ind(2)),windowlength);
        end
        
    case 'detrend'
        ref   = varargin{1};
        varargin(1) =[];
        
        Y   = ref;
        Y.Name  = Name;
        if(isempty(varargin))
            Y.Data  = detrend(Y.Data);
        else
            Y.Data  = detrend(Y.Data,varargin{:});
        end
        
    case 'rectify'
        ref   = varargin{1};
                
        Y   = ref;
        Y.Name  = Name;
        Y.Data  = abs(Y.Data);
        
    case 'conversion'
        ref         = varargin{1};
        SampleRate  = varargin{2};
        
        switch ref.Class
            case 'interval channel'
                
                S   = makeTimestampChannel(Name,'regular',ref.TimeRange,SampleRate);
                ref = filterTimestampChannel(Name,'within interval',S,ref);
                clear('S');
                
            case 'timestamp channel'
                ref = makeTimestampChannel(Name,'resample',ref,SampleRate);
        end
        
        Y.TimeRange = ref.TimeRange;
        Y.Name      = Name;
        Y.Class     = 'continuous channel';
        Y.SampleRate= SampleRate;
        nData       = (Y.TimeRange(2)-Y.TimeRange(1))*Y.SampleRate;
        Y.Data      = false(1,nData);
        Y.Data(ref.Data+1)    = true;      
    
    case 'derivative'   % Y   = makeContinuousChannel(Name, 'derivative', refchan(continuous), N(th));

        ref     = varargin{1};
        N       = varargin{2};
        
        Y       = ref;
        Y.Name  = Name;
        Y.Data  = deriv(Y.Data,N);
        
    case 'integral'   % Y   = makeContinuousChannel(Name, 'derivative', refchan(continuous), N(th));

        ref     = varargin{1};
        N       = varargin{2};
        
        Y       = ref;
        Y.Name  = Name;
        Y.Data  = integ(Y.Data,N);
end
end
