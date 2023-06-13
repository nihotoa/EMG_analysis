function Y = makeIntervalChannel(Name,command, varargin)
% Y = makeIntervalChannel(Name,'timestamp pairs',ref1(timestamp),ref2(timestamp));
% Y = makeIntervalChannel(Name,'window',ref1(timestamp),timewindow(sec));
% Y = makeIntervalChannel(Name,'manual',total timerange(sec),timewindows(sec));

switch command
    case 'timestamp pairs'
        interp_flag = 0;
        
        nargin = length(varargin);
        x1  = varargin{1};
        x2  = varargin{2};
        if(nargin>2)
            x3  = varargin{3};
            if(strcmpi(x3,'interp'))
                interp_flag = 1;
            end
        end

        if(isempty(x1.Data) || isempty(x2.Data))
            Y.TimeRange    = x1.TimeRange;
            Y.Reference1   = x1.Name;
            Y.Reference2   = x2.Name;
            Y.TimeUnits	= 'seconds';
            Y.Name         = Name;
            Y.Class        = 'interval channel';
            Y.Data         = [];
        else


            data1   = x1.Data ./ x1.SampleRate;
            data2   = x2.Data ./ x2.SampleRate;
            
            if(interp_flag)
                data1   = [0, data1];
                data2   = [data2, (x2.TimeRange(2) - x2.TimeRange(1))];
            end

            nx      = length(data1);
            ny      = length(data2);
            xind    = [1:nx];
            yind    = [1:ny];

            d1      = repmat(data1,ny,1);
            d2      = repmat(data2',1,nx);
            d3      = (d2-d1);
            d3(d3<=0) =NaN;

            [temp,indx] = min(d3,[],1);
            [temp,indy] = min(d3,[],2);


            min1    = full(sparse(indx,xind,ones(size(xind)),ny,nx));
            min2    = full(sparse(yind,indy,ones(size(yind)),ny,nx));
            min3    = (min1 & min2);

            [data2ind,data1ind,v]   = find(min3);

            data3   = [shiftdim(data1(data1ind)),shiftdim(data2(data2ind))]';

            Y.TimeRange    = x1.TimeRange;
            Y.Reference1   = x1.Name;
            Y.Reference2   = x2.Name;
            Y.TimeUnits	= 'seconds';
            Y.Name         = Name;
            Y.Class        = 'interval channel';
            Y.Data         = data3;

        end

    case 'window'
        ref         = varargin{1};
        TimeWindow  = varargin{2};

        if(isempty(ref.Data))
            Y.TimeRange     = ref.TimeRange;
            Y.Reference     = ref.Name;
            Y.TimeWindow    = TimeWindow;
            Y.TimeUnits     = 'seconds';
            Y.Name          = Name;
            Y.Class         = 'interval channel';
            Y.Data          = [];
        else
            data    = ref.Data ./ ref.SampleRate;
            data    = [data+TimeWindow(1);data+TimeWindow(2)];
            
            addflag = (data(1,:) >= 0 & data(2,:) <= (ref.TimeRange(2) - ref.TimeRange(1)));
            
            Y.TimeRange     = ref.TimeRange;
            Y.Reference     = ref.Name;
            Y.TimeWindow    = TimeWindow;
            Y.TimeUnits     = 'seconds';
            Y.Name          = Name;
            Y.Class         = 'interval channel';
            Y.Data          = data(:,addflag);

        end
        
    case 'manual' % Y = makeIntervalChannel(Name,'manual',total timerange(sec),timewindows(sec));
        TimeRange   = varargin{1};
        timewindows = varargin{2};
        
        Y.TimeRange = TimeRange;
        Y.Reference = 'manual';
        Y.TimeUnits = 'seconds';
        Y.Name      = Name;
        Y.Class     = 'interval channel';
        Y.Data      = timewindows';
        

end
% TimeRange: [1 1240]
%           Name: 'OutT1 On'
%          Class: 'timestamp channel'
%     SampleRate: 25000
%           Data: [1x205 double]

