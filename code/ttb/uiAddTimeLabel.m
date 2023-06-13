function hAx    = uiAddTimeLabel(command)

switch lower(command)
    case 'manual'
        hAx = uiSelectAxis;
        
        [Y,temp]    = ginput(1);
        XData   = get(findobj(hAx,'-depth',1,'-property','XData'),'XData');
        if(~isempty(XData))
            if(iscell(XData))
                XData   = cellfun(@sort,XData,'UniformOutput',false);
                XData   = cellfun(@nearest,XData,num2cell(repmat(Y,size(XData))),'UniformOutput',false);
                Y   = nearest(sort([XData{:}]),Y);
            else
                Y   = nearest(sort(XData),Y);
            end
        end
        
        
    case 'localextreme'
        [XY,hAx] = uimean('XY');
        
        X       = XY(:,1);
        Y       = XY(:,2);
        
        base    = mean([Y(1),Y(end)]);
        Y       = abs(Y-base);
        [Y,ind] = max(Y);
        Y       = X(ind);
    
    
    case 'localmax'
        [Y,hAx] = uimean('maxY_X');
    case 'localmin'
        [Y,hAx] = uimean('minY_X');
    case 'areastart'
        [X,hAx] = uimean('X');
                
        hObj    = findobj(hAx,'Type','patch');
        if(~isempty(hObj))
            Y   = get(hObj,'XData');
            if(iscell(Y))
                Y   = cellfun(@min,Y);
                Y   = sort(Y);
            end
            
            ind = Y>=min(X) & Y<=max(X);
            if(sum(ind)<1)
                warndlg({'No matched area'},'uiAddTimeLabel')
                return;
            else
                Y   = Y(ind);
                Y   = Y(1);
            end
                        
        else
            disp('No area exists.');
            return;
        end
        
    case 'areastop'
        [X,hAx] = uimean('X');
                
        hObj    = findobj(hAx,'Type','patch');
        if(~isempty(hObj))
            Y   = get(hObj,'XData');
            if(iscell(Y))
                Y   = cellfun(@max,Y);
                Y   = sort(Y);
            end
            
            ind = Y>=min(X) & Y<=max(X);
            if(sum(ind)<1)
                warndlg({'No matched area'},'uiAddTimeLabel')
                return;
            else
                Y   = Y(ind);
                Y   = Y(1);
            end
                        
        else
            disp('No area exists.');
            return;
        end
        
    case 'firstlocalmax'
        [XY,hAx]    = uimean('XY');
        XData       = XY(:,1);
        YData       = XY(:,2);
        
        ind     = YData(2:(end-1))>=YData(1:(end-2)) & YData(2:(end-1))>=YData(3:end);
        ind     = [false(1);ind;false(1)];
        XData   = XData(ind);
        
        Y       = min(XData);
        
    case 'delete'
        hAx = uiSelectAxis;
end

fig = get(hAx,'Parent');
UD  = get(fig,'UserData');
iAx = UD.h==hAx;
if(sum(iAx)<1)
    msgbox('DisplayをReloadしてから再度トライして下さい。')
    return;
else
    S   = UD.Data{iAx};
end

if(strcmpi(command,'delete'))
    if(~isfield(S,'TimeLabels'))
        disp('No TimeLabel exists.')
        return;
    else
        nLabels = length(S.TimeLabels);
        Names   = cell(nLabels,1);
        for iLabel =1:nLabels
            Names{iLabel}   = [S.TimeLabels(iLabel).Name,' [',num2str(S.TimeLabels(iLabel).Time),']'];
        end
        [Names,indLabel]  = uiselect(Names,1,'Select TimeLabels to delete.');
        S.TimeLabels(indLabel)   = [];
    end

else
    Name    = getName(command);
    if(isempty(Name))
        disp('User pressed cancel.')
        return;
    end
    
    if(~isfield(S,'TimeLabels'))
        S.TimeLabels(1).Name    = Name;
        S.TimeLabels(1).Time    = Y;
    else
        Labelind     = strcmp({S.TimeLabels(:).Name},Name);
        Labelind     = find(Labelind);
        nLabelind    = length(Labelind);
        if(nLabelind<1)
            nLabels = length(S.TimeLabels);
            S.TimeLabels(nLabels+1).Name    = Name;
            S.TimeLabels(nLabels+1).Time    = Y;
        elseif(nLabelind<2)
            S.TimeLabels(Labelind).Time      = Y;
        else
            S.TimeLabels(Labelind(1)).Time   = Y;
            S.TimeLabels(Labelind(2:end))    = [];
        end
    end
end
UD.Data{iAx}    = S;
set(fig,'UserData',UD);

fullfilename    = fullfile(UD.parentpath,[S.Name,'.mat']);
save(fullfilename,'-struct','S');
% disp(fullfilename)
if(~strcmpi(command,'delete'))
    disp([Name,': ',num2str(Y)])
end

% [filename,pathname] = uiputfile(fullfilename);
% 
% if isequal(filename,0) || isequal(pathname,0)
%     disp('User pressed cancel')
% else
%     fullfilename    = fullfile(pathname,filename);
%     save(fullfilename,'-struct','S');
%     disp(fullfilename)
% end

end

function Name   = getName(command)
Name   = getconfig(mfilename,command);
if(isempty(Name))
    Name   = 'Label1';
end
Name   = inputdlg({'Label Name:'},'uiAddTimeLabel',1,{Name});
if(isempty(Name))
    Name    = [];
else
    Name   = Name{1};
    setconfig(mfilename,command,Name);
end
end
