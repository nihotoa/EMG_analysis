function Y  = filterTimestampChannel(Name, command, varargin)
%Y  = filterTimestampChannel(Name, 'within interval', source(timestamp), ref(interval));
%Y  = filterTimestampChannel(Name, '~within interval', source(timestamp), ref(interval));
%Y  = filterTimestampChannel(Name, 'within interval exclusive', source(timestamp), ref(interval));   % もし、ひとつのInterval内に複数のtimestampが合った場合は、そのうちの一番初めのものだけをacceptする
%Y  = filterTimestampChannel(Name, 'timestamp occurred', source(timestamp), ref(timestamp), timerange[0 1](sec));
%Y  = filterTimestampChannel(Name, '~timestamp occurred', source(timestamp), ref(timestamp), timerange[0 1](sec));
%Y  = filterTimestampChannel(Name, 'nearest',source(timestamp), ref(timestamp));
%Y  = filterTimestampChannel(Name, 'signal RMS stays high', source(timestamp), ref(continuous), timerange[0 1](sec), threshold(V);
%Y  = filterTimestampChannel(Name, 'signal RMS stays low', source(timestamp), ref(continuous), timerange[0 1](sec), threshold(V);
%Y  = filterTimestampChannel(Name, 'signal stays high', source(timestamp), ref(continuous), timerange[0 1](sec), threshold(V);
%Y  = filterTimestampChannel(Name, 'signal stays low', source(timestamp), ref(continuous), timerange[0 1](sec), threshold(V);
%Y  = filterTimestampChannel(Name, 'accessory data equal', source(timestamp), 'PropertyName1', 'PropertyValue1'... );
%Y  = filterTimestampChannel(Name, 'accessory data range', source(timestamp), 'PropertyName1', 'PropertyValue1'... );


switch command
    case 'within interval' % Name, 'within interval', source(timestamp), ref(interval)
        source  = varargin{1};
        ref     = varargin{2};

        if(isempty(source.Data))% sourceにデータがある場合のみ
            Y.TimeRange = source.TimeRange;
            Y.Name      = Name;
            Y.Class	= 'timestamp channel';
            Y.SampleRate= source.SampleRate;
            Y.Data      = source.Data;
            if(isfield(source,'accessory_data'))
                Y.accessory_data    = source.accessory_data;
            end
        else
            nData   = length(source.Data);
            addflag = false(1,nData);
            Datasec = source.Data/source.SampleRate;

            if(size(ref.Data,2)>0)  % refにデータがある場合のみ
                for ii=1:nData
                    addflag(ii) = any(ref.Data(1,:)<=Datasec(ii) & ref.Data(2,:)>=Datasec(ii));
                end
            end

            % output
            Y.TimeRange = source.TimeRange;
            Y.Name      = Name;
            Y.Class	= 'timestamp channel';
            Y.SampleRate= source.SampleRate;
            Y.Data      = source.Data(addflag);
            if(isfield(source,'accessory_data'))
                Y.accessory_data    = source.accessory_data;
                nfield      = length(Y.accessory_data);
                for ifield=1:nfield
                    Y.accessory_data(ifield).Data   = Y.accessory_data(ifield).Data(addflag);
                end
            end
        end
    case '~within interval' % Name, '~within interval', source(timestamp), ref(interval)
        source  = varargin{1};
        ref     = varargin{2};

        if(isempty(source.Data))% sourceにデータがある場合のみ
            Y.TimeRange = source.TimeRange;
            Y.Name      = Name;
            Y.Class	= 'timestamp channel';
            Y.SampleRate= source.SampleRate;
            Y.Data      = source.Data;
            if(isfield(source,'accessory_data'))
                Y.accessory_data    = source.accessory_data;
            end
        else
            nData   = length(source.Data);
            addflag = false(1,nData);
            Datasec = source.Data/source.SampleRate;

            if(size(ref.Data,2)>0)  % refにデータがある場合のみ
                for ii=1:nData
                    addflag(ii) = any(ref.Data(1,:)<=Datasec(ii) & ref.Data(2,:)>=Datasec(ii));
                end
            end

            % output
            Y.TimeRange = source.TimeRange;
            Y.Name      = Name;
            Y.Class	= 'timestamp channel';
            Y.SampleRate= source.SampleRate;
            Y.Data      = source.Data(~addflag);
            if(isfield(source,'accessory_data'))
                Y.accessory_data    = source.accessory_data;
                nfield      = length(Y.accessory_data);
                for ifield=1:nfield
                    Y.accessory_data(ifield).Data   = Y.accessory_data(ifield).Data(~addflag);
                end
            end
        end
        
    case 'within interval exclusive'
        source  = varargin{1};
        ref     = varargin{2};

        if(isempty(source.Data))% sourceにデータがある場合のみ
            Y.TimeRange = source.TimeRange;
            Y.Name      = Name;
            Y.Class	= 'timestamp channel';
            Y.SampleRate= source.SampleRate;
            Y.Data      = source.Data;
            if(isfield(source,'accessory_data'))
                Y.accessory_data    = source.accessory_data;
            end
        else
            nData   = length(source.Data);
            addflag = false(1,nData);
            Dataind = 1:nData;
            Datasec = source.Data/source.SampleRate;

            if(size(ref.Data,2)>0)  % refにデータがある場合のみ
                nRefData    = size(ref.Data,2);
                for ii=1:nRefData
                    ind = Dataind(Datasec>=ref.Data(1,ii) & Datasec<=ref.Data(2,ii));
                    
                    if(~isempty(ind))   % もし、ひとつのInterval内に複数のtimestampが合った場合は、そのうちの一番初めのものだけをacceptする
                        if(length(ind) > 1)
                            ind = ind(1);
                        end
                        addflag(ind)    = true;
                    end
                    
                end
            end

            % output
            Y.TimeRange = source.TimeRange;
            Y.Name      = Name;
            Y.Class	= 'timestamp channel';
            Y.SampleRate= source.SampleRate;
            Y.Data      = source.Data(addflag);
            if(isfield(source,'accessory_data'))
                Y.accessory_data    = source.accessory_data;
                nfield      = length(Y.accessory_data);
                for ifield=1:nfield
                    Y.accessory_data(ifield).Data   = Y.accessory_data(ifield).Data(addflag);
                end
            end
        end
        
        
    case 'timestamp occurred' % Name, 'timestamp occurred', source(timestamp), ref(timestamp), timerange[0 1](sec)
        source  = varargin{1};
        ref     = varargin{2};
        timerange   = varargin{3};

        if(isempty(source.Data))% sourceにデータがある場合のみ
            Y.TimeRange = source.TimeRange;
            Y.Name      = Name;
            Y.Class	= 'timestamp channel';
            Y.SampleRate= source.SampleRate;
            Y.Data      = source.Data;
            if(isfield(source,'accessory_data'))
                Y.accessory_data    = source.accessory_data;
            end
        else
            nData   = length(source.Data);
            addflag = false(1,nData);
            Datasec = source.Data/source.SampleRate;

            if(size(ref.Data,2)>0)      % refにデータがある場合のみ
                refDatasec  = ref.Data/ref.SampleRate;

                for ii=1:nData
                    addflag(ii) = any(Datasec(ii)+timerange(1)<=refDatasec & Datasec(ii)+timerange(2)>=refDatasec);
                end
            end

            % output
            Y.TimeRange = source.TimeRange;
            Y.Name      = Name;
            Y.Class	= 'timestamp channel';
            Y.SampleRate= source.SampleRate;
            Y.Data      = source.Data(addflag);
            if(isfield(source,'accessory_data'))
                Y.accessory_data    = source.accessory_data;
                nfield      = length(Y.accessory_data);
                for ifield=1:nfield
                    Y.accessory_data(ifield).Data   = Y.accessory_data(ifield).Data(addflag);
                end
            end
        end

    case '~timestamp occurred' % Name, '~timestamp occurred', source(timestamp), ref(timestamp), timerange[0 1](sec)
        source  = varargin{1};
        ref     = varargin{2};
        timerange   = varargin{3};

        if(isempty(source.Data))% sourceにデータがある場合のみ
            Y.TimeRange = source.TimeRange;
            Y.Name      = Name;
            Y.Class	= 'timestamp channel';
            Y.SampleRate= source.SampleRate;
            Y.Data      = source.Data;
            if(isfield(source,'accessory_data'))
                Y.accessory_data    = source.accessory_data;
            end
        else
            nData   = length(source.Data);
            addflag = false(1,nData);
            Datasec = source.Data/source.SampleRate;

            if(size(ref.Data,2)>0)      % refにデータがある場合のみ
                refDatasec  = ref.Data/ref.SampleRate;

                for ii=1:nData
                    addflag(ii) = any(Datasec(ii)+timerange(1)<=refDatasec & Datasec(ii)+timerange(2)>=refDatasec);
                end
            end

            % output
            Y.TimeRange = source.TimeRange;
            Y.Name      = Name;
            Y.Class	= 'timestamp channel';
            Y.SampleRate= source.SampleRate;
            Y.Data      = source.Data(~addflag);
            if(isfield(source,'accessory_data'))
                Y.accessory_data    = source.accessory_data;
                nfield      = length(Y.accessory_data);
                for ifield=1:nfield
                    Y.accessory_data(ifield).Data   = Y.accessory_data(ifield).Data(~addflag);
                end
            end
        end
    case 'nearest'%Y  = filterTimestampChannel(Name, 'nearrst',source(timestamp), ref(timestamp));
        source  = varargin{1};
        ref     = varargin{2};
        
        if(isempty(source.Data))% sourceにデータがある場合のみ
            Y.TimeRange = source.TimeRange;
            Y.Name      = Name;
            Y.Class	= 'timestamp channel';
            Y.SampleRate= source.SampleRate;
            Y.Data      = source.Data;
            if(isfield(source,'accessory_data'))
                Y.accessory_data    = source.accessory_data;
            end
        else
            nData   = length(source.Data);
            addflag = false(1,nData);
            Datasec = source.Data/source.SampleRate;

            if(size(ref.Data,2)>0)      % refにデータがある場合のみ
                nRef    = length(ref.Data);
                refDatasec  = ref.Data/ref.SampleRate;
                
                ind     = zeros(nRef,1);
                for iRef=1:nRef
                    [temp,ind(iRef)]  = nearest(Datasec,refDatasec(iRef));
                end
                    
                addflag(ind)    = true;
            end

            % output
            Y.TimeRange = source.TimeRange;
            Y.Name      = Name;
            Y.Class	= 'timestamp channel';
            Y.SampleRate= source.SampleRate;
            Y.Data      = source.Data(addflag);
            if(isfield(source,'accessory_data'))
                Y.accessory_data    = source.accessory_data;
                nfield      = length(Y.accessory_data);
                for ifield=1:nfield
                    Y.accessory_data(ifield).Data   = Y.accessory_data(ifield).Data(addflag);
                end
            end
        end
        
    case 'signal RMS stays high'
        source  = varargin{1};
        ref     = varargin{2};
        TimeWindow   = varargin{3};
        th      = varargin{4};

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


        if(isempty(source.Data))% sourceにデータがある場合のみ
            Y.TimeRange = source.TimeRange;
            Y.Name      = Name;
            Y.Class	= 'timestamp channel';
            Y.SampleRate= source.SampleRate;
            Y.Data      = source.Data;
            if(isfield(source,'accessory_data'))
                Y.accessory_data    = source.accessory_data;
                
            end
        else
            TimeWindowIndex = round(TimeWindow * ref.SampleRate);
            WindowLengthIndex   = TimeWindowIndex(2) - TimeWindowIndex(1) + 1;
            timestamp       = round((source.Data * ref.SampleRate) / source.SampleRate);  % refのサンプリングレートにあわせる
            nstamps         = length(timestamp);
            nrefData        = length(ref.Data);
            addflag         = false(1,nstamps);

            StartIndices    = timestamp + TimeWindowIndex(1);
            StopIndices     = StartIndices + WindowLengthIndex -1;

            for ii = 1:nstamps
                if(StartIndices(ii)>0 && StopIndices(ii)<=nrefData)
                    addflag(ii) = (rms(double(ref.Data([StartIndices(ii):StopIndices(ii)]))) >= th);
                end
            end


            % output
            Y.TimeRange = source.TimeRange;
            Y.Name      = Name;
            Y.Class	= 'timestamp channel';
            Y.SampleRate= source.SampleRate;
            Y.Data      = source.Data(addflag);
            if(isfield(source,'accessory_data'))
                Y.accessory_data    = source.accessory_data;
                nfield      = length(Y.accessory_data);
                for ifield=1:nfield
                    Y.accessory_data(ifield).Data   = Y.accessory_data(ifield).Data(addflag);
                end
            end
        end
        
    case 'signal RMS stays low'
        source  = varargin{1};
        ref     = varargin{2};
        TimeWindow   = varargin{3};
        th      = varargin{4};

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


        if(isempty(source.Data))% sourceにデータがある場合のみ
            Y.TimeRange = source.TimeRange;
            Y.Name      = Name;
            Y.Class	= 'timestamp channel';
            Y.SampleRate= source.SampleRate;
            Y.Data      = source.Data;
            if(isfield(source,'accessory_data'))
                Y.accessory_data    = source.accessory_data;
                
            end
        else
            TimeWindowIndex = round(TimeWindow * ref.SampleRate);
            WindowLengthIndex   = TimeWindowIndex(2) - TimeWindowIndex(1) + 1;
            timestamp       = round((source.Data * ref.SampleRate) / source.SampleRate);  % refのサンプリングレートにあわせる
            nstamps         = length(timestamp);
            nrefData        = length(ref.Data);
            addflag         = false(1,nstamps);

            StartIndices    = timestamp + TimeWindowIndex(1);
            StopIndices     = StartIndices + WindowLengthIndex -1;

            for ii = 1:nstamps
                if(StartIndices(ii)>0 && StopIndices(ii)<=nrefData)
                    addflag(ii) = (rms(double(ref.Data([StartIndices(ii):StopIndices(ii)]))) <= th);
                end
            end


            % output
            Y.TimeRange = source.TimeRange;
            Y.Name      = Name;
            Y.Class	= 'timestamp channel';
            Y.SampleRate= source.SampleRate;
            Y.Data      = source.Data(addflag);
            if(isfield(source,'accessory_data'))
                Y.accessory_data    = source.accessory_data;
                nfield      = length(Y.accessory_data);
                for ifield=1:nfield
                    Y.accessory_data(ifield).Data   = Y.accessory_data(ifield).Data(addflag);
                end
            end
        end

    case 'signal stays high' %Y  = filterTimestampChannel(Name, 'signal stays high', source(timestamp), ref(continuous), timerange[0 1](sec), threshold(V);
        source  = varargin{1};
        ref     = varargin{2};
        TimeWindow   = varargin{3};
        th      = varargin{4};

%         % Unit adjustment
%         if(~isfield(ref,'Unit'))        %V -> d.u.
%             VoltageRange    = 5;
%             BitPrecision    = 16;
% 
%             cfactor         = pow2(BitPrecision - 1) / VoltageRange;
%             th              = th* cfactor;
% 
%             %             cfactor         = VoltageRange / pow2(BitPrecision - 1);
%             %             ref.Data        = double(ref.Data)* cfactor;
%         else
%             switch ref.Unit
%                 case 'uV'               %V  -> uV
%                     cfactor         = 1000*1000;
%                     th              = th* cfactor;
%                     %                     ref.Data    = ref.Data/1000/1000;
%                 case 'mV'               %V -> mV
%                     cfactor         = 1000;
%                     th              = th* cfactor;
%                     %                     ref.Data    = ref.Data/1000;
%             end
%         end


        if(isempty(source.Data))% sourceにデータがある場合のみ
            Y.TimeRange = source.TimeRange;
            Y.Name      = Name;
            Y.Class	= 'timestamp channel';
            Y.SampleRate= source.SampleRate;
            Y.Data      = source.Data;
            if(isfield(source,'accessory_data'))
                Y.accessory_data    = source.accessory_data;
                
            end
        else
            TimeWindowIndex = round(TimeWindow * ref.SampleRate);
            WindowLengthIndex   = TimeWindowIndex(2) - TimeWindowIndex(1) + 1;
            timestamp       = round((source.Data * ref.SampleRate) / source.SampleRate);  % refのサンプリングレートにあわせる
            nstamps         = length(timestamp);
            nrefData        = length(ref.Data);
            addflag         = false(1,nstamps);

            StartIndices    = timestamp + TimeWindowIndex(1);
            StopIndices     = StartIndices + WindowLengthIndex -1;

            for ii = 1:nstamps
                if(StartIndices(ii)>0 && StopIndices(ii)<=nrefData)
                    addflag(ii) = all(ref.Data(StartIndices(ii):StopIndices(ii))>=th);
                end
            end


            % output
            Y.TimeRange = source.TimeRange;
            Y.Name      = Name;
            Y.Class	= 'timestamp channel';
            Y.SampleRate= source.SampleRate;
            Y.Data      = source.Data(addflag);
            if(isfield(source,'accessory_data'))
                Y.accessory_data    = source.accessory_data;
                nfield      = length(Y.accessory_data);
                for ifield=1:nfield
                    Y.accessory_data(ifield).Data   = Y.accessory_data(ifield).Data(addflag);
                end
            end
        end
        
    case 'signal stays low'
        source  = varargin{1};
        ref     = varargin{2};
        TimeWindow   = varargin{3};
        th      = varargin{4};

%         % Unit adjustment
%         if(~isfield(ref,'Unit'))        %V -> d.u.
%             VoltageRange    = 5;
%             BitPrecision    = 16;
% 
%             cfactor         = pow2(BitPrecision - 1) / VoltageRange;
%             th              = th* cfactor;
% 
%             %             cfactor         = VoltageRange / pow2(BitPrecision - 1);
%             %             ref.Data        = double(ref.Data)* cfactor;
%         else
%             switch ref.Unit
%                 case 'uV'               %V  -> uV
%                     cfactor         = 1000*1000;
%                     th              = th* cfactor;
%                     %                     ref.Data    = ref.Data/1000/1000;
%                 case 'mV'               %V -> mV
%                     cfactor         = 1000;
%                     th              = th* cfactor;
%                     %                     ref.Data    = ref.Data/1000;
%             end
%         end
% 
% 
        if(isempty(source.Data))% sourceにデータがある場合のみ
            Y.TimeRange = source.TimeRange;
            Y.Name      = Name;
            Y.Class	= 'timestamp channel';
            Y.SampleRate= source.SampleRate;
            Y.Data      = source.Data;
            if(isfield(source,'accessory_data'))
                Y.accessory_data    = source.accessory_data;
                
            end
        else
            TimeWindowIndex = round(TimeWindow * ref.SampleRate);
            WindowLengthIndex   = TimeWindowIndex(2) - TimeWindowIndex(1) + 1;
            timestamp       = round((source.Data * ref.SampleRate) / source.SampleRate);  % refのサンプリングレートにあわせる
            nstamps         = length(timestamp);
            nrefData        = length(ref.Data);
            addflag         = false(1,nstamps);

            StartIndices    = timestamp + TimeWindowIndex(1);
            StopIndices     = StartIndices + WindowLengthIndex -1;

            for ii = 1:nstamps
                if(StartIndices(ii)>0 && StopIndices(ii)<=nrefData)
                    addflag(ii) = all(ref.Data(StartIndices(ii):StopIndices(ii))<=th);
                end
            end


            % output
            Y.TimeRange = source.TimeRange;
            Y.Name      = Name;
            Y.Class	= 'timestamp channel';
            Y.SampleRate= source.SampleRate;
            Y.Data      = source.Data(addflag);
            if(isfield(source,'accessory_data'))
                Y.accessory_data    = source.accessory_data;
                nfield      = length(Y.accessory_data);
                for ifield=1:nfield
                    Y.accessory_data(ifield).Data   = Y.accessory_data(ifield).Data(addflag);
                end
            end
        end
        
    case 'accessory data equal'
        source  = varargin{1};
        addflag    = true(size(source.Data));

        nPair   = floor(length(varargin)-1)/2;

        for iPair=1:nPair
            PropertyName    = varargin{iPair*2};
            PropertyValue   = varargin{iPair*2+1};
            ind             = strcmp({source.accessory_data.Name},PropertyName);
            addflag        = (addflag & ismember(source.accessory_data(ind).Data,PropertyValue));
        end

        % output
        Y           = source;
        Y.Name      = Name;
        Y.Data      = Y.Data(addflag);
        
        if(isfield(Y,'accessory_data'))
            nfield      = length(Y.accessory_data);
            for ifield=1:nfield
                Y.accessory_data(ifield).Data   = Y.accessory_data(ifield).Data(addflag);
            end
        end


    case 'accessory data range'
        source  = varargin{1};
        addflag    = true(size(source.Data));

        nPair   = floor(length(varargin)-1)/2;

        for iPair=1:nPair
            PropertyName    = varargin{iPair*2};
            PropertyValue   = varargin{iPair*2+1};
            if(length(PropertyValue)==1)
                PropertyValue   = repmat(PropertyValue,1,2);
            end
                
            ind             = strcmp({source.accessory_data.Name},PropertyName);
            addflag        = (addflag & source.accessory_data(ind).Data >= PropertyValue(1) & source.accessory_data(ind).Data <= PropertyValue(2));
        end

        % output
        Y           = source;
        Y.Name      = Name;
        Y.Data      = Y.Data(addflag);
        if(isfield(Y,'accessory_data'))
            nfield      = length(Y.accessory_data);
            for ifield=1:nfield
                Y.accessory_data(ifield).Data   = Y.accessory_data(ifield).Data(addflag);
            end
        end
    otherwise
        error(['invalid command:', command])
end

