function uiEditChannel(command)

hFig    = gcf;
hAx     = gca;
hObj    = gco;

UD      = get(hFig,'UserData');
iAx     = UD.h==hAx;
S       = UD.Data{iAx};



if(isfield(S,'AnalysisType'))
    switch S.AnalysisType
        case 'STA'
            iData   = get(hObj,'UserData');
            iData   = iData.iTrial;
            
            switch command
                                   
                case 'not to use'
                    
                    if(~isfield(S,'TrialsToUse'))
                        S.TrialsToUse = 1:S.nTrials;
                    end
                    S.TrialsToUse     = setdiff(S.TrialsToUse,iData);
                                        
                case 'to use'
                    if(~isfield(S,'TrialsToUse'))
                        S.TrialsToUse = 1:S.nTrials;
                    end
                    S.TrialsToUse     = union(S.TrialsToUse,iData);
                    
                case 'property'
                    get(hObj,'UserData')
                    
                case 'edit'
                    keyboard
                    
            end
            
    end
    
    
else
    switch S.Class
        case 'timestamp channel'
            iData   = get(hObj,'XData');
            iData   = iData(1)*S.SampleRate;
            
            switch command
                case 'delete'
                    [XData,iData]   = nearest(S.Data,iData);
                    if(~isfield(S,'TrialsToUse'))
                        S.TrialsToUse = 1:size(S.Data,2);
                    end
                    S.Data(iData)   = [];
                    S.TrialsToUse(S.TrialsToUse>iData)  = S.TrialsToUse(S.TrialsToUse>iData) -1;
                    %         delete(hObj)
                    
                case 'not to use'
                    [XData,iData]   = nearest(S.Data,iData);
                    if(~isfield(S,'TrialsToUse'))
                        S.TrialsToUse = 1:size(S.Data,2);
                    end
                    S.TrialsToUse     = setdiff(S.TrialsToUse,iData);
                    %         set(hObj,'Color',[0.5 0.5 0.5])
                    
                case 'to use'
                    [XData,iData]   = nearest(S.Data,iData);
                    if(~isfield(S,'TrialsToUse'))
                        S.TrialsToUse = 1:size(S.Data,2);
                    end
                    S.TrialsToUse     = union(S.TrialsToUse,iData);
                    %         set(hObj,'Color',[0.5 0 0])
                case 'edit'
                    keyboard

            end
        case 'interval channel'
    end
    
end

UD.Data{iAx}    = S;
set(hFig,'UserData',UD);
displaydata('plotData',hAx)