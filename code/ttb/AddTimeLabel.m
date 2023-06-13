function S  = AddTimeLabel(S,Name,method,TimeWindow,varargin)

if(nargin<2)
    Name        = 'Label1';
    method      = 'localmax';
    TimeWindow  = [-inf inf];
elseif(nargin<3)
    method      = 'localmax';
    TimeWindow  = [-inf inf];
elseif(nargin<4)
    TimeWindow  = [-inf inf];
end

YData   = S.YData;
XData   = S.XData;
ind     = XData>=TimeWindow(1) & XData<=TimeWindow(2);

YData   = YData(ind);
XData   = XData(ind);

switch lower(method)
    case 'localmax'
        [Y,ind] = max(YData);
        X       = XData(ind);
    case 'localmin'
        [Y,ind] = min(YData);
        X       = XData(ind);
    case 'posinega'
        [Y,ind] = min(YData);
        ind     = 1:ind;
        
        YData   = YData(ind);
        XData   = XData(ind);

        [Y,ind] = max(YData);
        X       = XData(ind);
        
    case 'negaposi'
        [Y,ind] = max(YData);
        ind     = 1:ind;
        
        YData   = YData(ind);
        XData   = XData(ind);

        [Y,ind] = min(YData);
        X       = XData(ind);
        
    case 'firstlocalmax'
        th              = 0.1;
        [Ymin,Yminind] = min(YData);
        ind     = 1:Yminind;
        YData   = YData(ind);
        XData   = XData(ind);
        
        [Ymax,Ymaxind]  = max(YData);
        onsetind        = find(YData(1:Ymaxind)<=Ymax*th,1,'last')+1;
        offsetind       = Ymaxind + find(YData((Ymaxind+1):end)<=Ymax*th,1,'first')-1;
        ind     = onsetind:offsetind;
        
        YData   = YData(ind);
        XData   = XData(ind);
                
        ind     = YData(2:(end-1))>=YData(1:(end-2)) & YData(2:(end-1))>=YData(3:end);
        ind     = [false(1) ind false(1)];
        XData   = XData(ind);
               
        X       = min(XData);
            
end

switch method
    case 'delete'
        if(isfield(S,'TimeLabels'))
            
            Labelind     = strcmp({S.TimeLabels(:).Name},Name);
            Labelind     = find(Labelind);
            nLabelind    = length(Labelind);
            if(nLabelind>0)
                S.TimeLabels(Labelind)   = [];
            end
        end
        
    case 'copy'
        Ref = varargin{1};
        if(isfield(Ref,'TimeLabels'))
            Labelind    = strcmp({Ref.TimeLabels(:).Name},Name);
            Labelind    = find(Labelind);
            nLabelind   = length(Labelind);
            if(nLabelind>0)
                X   = Ref.TimeLabels(Labelind(1)).Time;
            else
                disp(['No ',Name,' exists in Source file.'])
                return;
            end
        else
            disp('No TimeLabel exists in Source file.')
            return;
        end
        
        if(~isfield(S,'TimeLabels'))
            S.TimeLabels(1).Name    = Name;
            S.TimeLabels(1).Time    = X;
        else
            Labelind     = strcmp({S.TimeLabels(:).Name},Name);
            Labelind     = find(Labelind);
            nLabelind    = length(Labelind);
            if(nLabelind<1)
                nLabels = length(S.TimeLabels);
                S.TimeLabels(nLabels+1).Name    = Name;
                S.TimeLabels(nLabels+1).Time    = X;
            elseif(nLabelind<2)
                S.TimeLabels(Labelind).Time     = X;
            else
                S.TimeLabels(Labelind(1)).Time  = X;
                S.TimeLabels(Labelind(2:end))   = [];
            end
        end
        
    otherwise
        if(~isfield(S,'TimeLabels'))
            S.TimeLabels(1).Name    = Name;
            S.TimeLabels(1).Time    = X;
        else
            Labelind     = strcmp({S.TimeLabels(:).Name},Name);
            Labelind     = find(Labelind);
            nLabelind    = length(Labelind);
            if(nLabelind<1)
                nLabels = length(S.TimeLabels);
                S.TimeLabels(nLabels+1).Name    = Name;
                S.TimeLabels(nLabels+1).Time    = X;
            elseif(nLabelind<2)
                S.TimeLabels(Labelind).Time     = X;
            else
                S.TimeLabels(Labelind(1)).Time  = X;
                S.TimeLabels(Labelind(2:end))   = [];
            end
        end
end

