function tawindow(command)
global gsobj
% XData   = gsobj.scope.XData;

switch command
    case 'add'
        h   = gsobj.handles.scope;
        XData   = gsobj.scope.XData;
        waitforbuttonpress;
        point1      = get(h,'CurrentPoint');    % button down detected
        finalRect   = rbbox;                    % return figure units
        point2      = get(h,'CurrentPoint');  % button up detected
        point1      = point1(1,1:2);            % extract x and y
        point2      = point2(1,1:2);
        p1 = min(point1,point2);                % calculate locations
        offset = abs(point1-point2);            % and dimensions
        p1(1)  = nearest(XData,p1(1));
        x = [p1(1) p1(1)];
        y = [p1(2) p1(2)+offset(2)];
        %         keyboard

        if(isfield(gsobj,'tawindow') & isfield(gsobj.tawindow,'add') & ~isempty(gsobj.tawindow.add))
            ii = length(gsobj.tawindow.add)+1;
            gsobj.tawindow.add(ii).XData    = x(1);
            gsobj.tawindow.add(ii).YData    = y;
        else
            gsobj.tawindow.add(1).XData    = x(1);
            gsobj.tawindow.add(1).YData    = y;
        end

    case 'except'
        h   = gsobj.handles.scope;
        XData   = gsobj.scope.XData;
        waitforbuttonpress;
        point1      = get(h,'CurrentPoint');    % button down detected
        finalRect   = rbbox;                    % return figure units
        point2      = get(h,'CurrentPoint');  % button up detected
        point1      = point1(1,1:2);            % extract x and y
        point2      = point2(1,1:2);
        p1 = min(point1,point2);                % calculate locations
        offset = abs(point1-point2);            % and dimensions
        p1(1)  = nearest(XData,p1(1));
        x = [p1(1) p1(1)];
        y = [p1(2) p1(2)+offset(2)];
        %         keyboard

        if(isfield(gsobj,'tawindow') & isfield(gsobj.tawindow,'except') & ~isempty(gsobj.tawindow.except))
            ii = length(gsobj.tawindow.except)+1;
            gsobj.tawindow.except(ii).XData    = x(1);
            gsobj.tawindow.except(ii).YData    = y;
        else
            gsobj.tawindow.except(1).XData    = x(1);
            gsobj.tawindow.except(1).YData    = y;
        end
        
    case 'delete'
        waitforbuttonpress;
        h   = gco;
        if(isfield(gsobj,'tawindow') & isfield(gsobj.tawindow,'add') & ~isempty(gsobj.tawindow.add))
            hadd    = gsobj.handles.tawindow.add;
            ind     = find(hadd==h);
            if(~isempty(ind))
                tawindow_type   = 'add';
                tawindow_ind    = ind;
            end
        end
        if(isfield(gsobj,'tawindow') & isfield(gsobj.tawindow,'except') & ~isempty(gsobj.tawindow.except))
            hexcept    = gsobj.handles.tawindow.except;
            ind     = find(hexcept==h);
            if(~isempty(ind))
                tawindow_type   = 'except';
                tawindow_ind    = ind;
            end
        end
        eval(['gsobj.tawindow.',tawindow_type,'(',num2str(tawindow_ind),')=[];']);


end

tawindow2addflag
gsscope_plot
