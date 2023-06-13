function Y  = filterIntervalChannel(Name, command, varargin)
%Y  = filterIntervalChannel(Name, 'timestamp occurred', sourse(interval), ref(timestamp) [, timeshift]);
%Y  = filterIntervalChannel(Name, '~timestamp occurred', sourse(interval), ref(timestamp) [, timeshift]);
%Y  = filterIntervalChannel(Name, 'interval occurred', sourse(interval), ref(interval));
%Y  = filterIntervalChannel(Name, '~interval occurred', sourse(interval), ref(interval));
%Y  = filterIntervalChannel(Name, 'duration', sourse(interval), [max min]);

if nargin < 5
    varargin{3} = 0;
end

switch command
    case 'timestamp occurred' % Name, 'timestamp occurred', sourse(interval), ref(timestamp [, timeshift])
        source  = varargin{1};
        ref     = varargin{2};
        timeshift   = varargin{3};

        if(isempty(source.Data))    % sourceにデータがある場合のみ
            Y.TimeRange = source.TimeRange;
            Y.Reference1   = source.Reference1;
            Y.Reference2   = source.Reference2;
            Y.TimeUnits	= 'seconds';
            Y.Name      = Name;
            Y.Class 	= 'interval channel';
            Y.Data      = source.Data;
        else

            nData   = size(source.Data,2);
            addflag = false(1,nData);

            if(size(ref.Data,2)>0)      % refにデータがある場合のみ
                refDatasec = ref.Data/ref.SampleRate + timeshift;
                for ii=1:nData
                    addflag(ii) = any(source.Data(1,ii)<=refDatasec & source.Data(2,ii)>=refDatasec);
                end
            end

            % output
            Y.TimeRange = source.TimeRange;
            Y.Reference1   = source.Reference1;
            Y.Reference2   = source.Reference2;
            Y.TimeUnits	= 'seconds';
            Y.Name      = Name;
            Y.Class 	= 'interval channel';
            Y.Data      = source.Data(:,addflag);
        end

    case '~timestamp occurred' % Name, '~timestamp occurred', sourse(interval), ref(timestamp [, timeshift])
        source  = varargin{1};
        ref     = varargin{2};
        timeshift   = varargin{3};


        if(isempty(source.Data))    % sourceにデータがある場合のみ
            Y.TimeRange = source.TimeRange;
            Y.Reference1   = source.Reference1;
            Y.Reference2   = source.Reference2;
            Y.TimeUnits	= 'seconds';
            Y.Name      = Name;
            Y.Class 	= 'interval channel';
            Y.Data      = source.Data;
        else
            nData   = size(source.Data,2);
            addflag = false(1,nData);

            if(size(ref.Data,2)>0)      % refにデータがある場合のみ
                refDatasec = ref.Data/ref.SampleRate + timeshift;
                for ii=1:nData
                    addflag(ii) = any(source.Data(1,ii)<=refDatasec & source.Data(2,ii)>=refDatasec);
                end
            end

            % output
            Y.TimeRange = source.TimeRange;
            Y.Reference1   = source.Reference1;
            Y.Reference2   = source.Reference2;
            Y.TimeUnits	= 'seconds';
            Y.Name      = Name;
            Y.Class 	= 'interval channel';
            Y.Data      = source.Data(:,~addflag);
        end

    case 'interval occurred' % %Y  = filterIntervalChannel(Name, 'interval occurred', sourse(interval), ref(interval));
        source  = varargin{1};
        ref     = varargin{2};

        if(isempty(source.Data))    % sourceにデータがある場合のみ
            Y.TimeRange = source.TimeRange;
            Y.Reference1   = source.Reference1;
            Y.Reference2   = source.Reference2;
            Y.TimeUnits	= 'seconds';
            Y.Name      = Name;
            Y.Class 	= 'interval channel';
            Y.Data      = source.Data;
        else

            nData       = size(source.Data,2);
            nRefData    = size(ref.Data,2);
            addflag     = false(1,nData);
            
            if(nRefData>0)      % refにデータがある場合のみ
                for iData=1:nData
                    for iRef=1:nRefData
                        addflagtemp1    = ~(source.Data(1,iData)>=ref.Data(1,iRef) & source.Data(1,iData)>=ref.Data(2,iRef));
                        addflagtemp2    = ~(source.Data(2,iData)<=ref.Data(1,iRef) & source.Data(2,iData)<=ref.Data(2,iRef));
                        addflagtemp     = addflagtemp1 & addflagtemp2;
                        
                        addflag(iData)  = (addflag(iData) | addflagtemp);
                    end
                end
            end

            % output
            Y.TimeRange = source.TimeRange;
            Y.Reference1   = source.Reference1;
            Y.Reference2   = source.Reference2;
            Y.TimeUnits	= 'seconds';
            Y.Name      = Name;
            Y.Class 	= 'interval channel';
            Y.Data      = source.Data(:,addflag);
        end
    
    case '~interval occurred' % %Y  = filterIntervalChannel(Name, '~interval occurred', sourse(interval), ref(interval));
        source  = varargin{1};
        ref     = varargin{2};

        if(isempty(source.Data))    % sourceにデータがある場合のみ
            Y.TimeRange = source.TimeRange;
            Y.Reference1   = source.Reference1;
            Y.Reference2   = source.Reference2;
            Y.TimeUnits	= 'seconds';
            Y.Name      = Name;
            Y.Class 	= 'interval channel';
            Y.Data      = source.Data;
        else

            nData       = size(source.Data,2);
            nRefData    = size(ref.Data,2);
            addflag     = false(1,nData);
            
            if(nRefData>0)      % refにデータがある場合のみ
                for iData=1:nData
                    for iRef=1:nRefData
                        addflagtemp1    = ~(source.Data(1,iData)>=ref.Data(1,iRef) & source.Data(1,iData)>=ref.Data(2,iRef));
                        addflagtemp2    = ~(source.Data(2,iData)<=ref.Data(1,iRef) & source.Data(2,iData)<=ref.Data(2,iRef));
                        addflagtemp     = addflagtemp1 & addflagtemp2;
                        
                        addflag(iData)  = (addflag(iData) | addflagtemp);
                    end
                end
            end
            
            % output
            Y.TimeRange = source.TimeRange;
            Y.Reference1   = source.Reference1;
            Y.Reference2   = source.Reference2;
            Y.TimeUnits	= 'seconds';
            Y.Name      = Name;
            Y.Class 	= 'interval channel';
            Y.Data      = source.Data(:,~addflag);
        end
        
        
    case 'duration'
        source  = varargin{1};
        th      = varargin{2};
        
        if(isempty(source.Data))    % sourceにデータがある場合のみ
            Y.TimeRange = source.TimeRange;
            Y.Reference1   = source.Reference1;
            Y.Reference2   = source.Reference2;
            Y.TimeUnits	= 'seconds';
            Y.Name      = Name;
            Y.Class 	= 'interval channel';
            Y.Data      = source.Data;
        else
            
            dur         = diff(source.Data,1);
            
            % output
            Y           = source;
            Y.Name      = Name;
            Y.Class 	= 'interval channel';
            Y.Data      = source.Data(:,dur>=th(1)&dur<=th(2));
        end
        

end
