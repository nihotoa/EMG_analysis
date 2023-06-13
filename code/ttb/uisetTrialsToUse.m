function SS = uisetTrialsToUse(S)

guimode_flag = false;

if(nargin<1)
    guimode_flag    = true;
end


if(guimode_flag)
    hAx     = gca;
    hFig    = gcf;
    
    UD          = get(hFig,'UserData');
    filename    = UD.filename(UD.h==hAx); 
    if(isempty(filename))
        disp('Select (click) one axis. Then try again.')
        return;
    end
    parentpath      = UD.parentpath;
    S               = UD.Data{UD.h==hAx}; 
end

if(isfield(S,'AnalysisType'))
    if(~ismember(S.AnalysisType,{'STA','PSTH'}))
        disp('AnalysisType must be STA or PSTH file')
        return;
    else
        Type        = S.AnalysisType;
        allTrials   = 1:S.nTrials;
    end
else
    if(~ismember(S.Class,{'timestamp channel'}))
        disp('Class must be timestamp channel')
        return;
    else
        Type        = S.Class;
        allTrials   = 1:size(S.Data,2);
    end
end

if(isfield(S,'TrialsToUse'))
    TrialsToUse = S.TrialsToUse;
else
    TrialsToUse = allTrials;
end

cellstrTrialsToUse = uiselect(num2cellstr(allTrials),1,'Select TrialsToUse',num2cellstr(TrialsToUse));

if(isempty(cellstrTrialsToUse))
    disp('User Pressed Cancel')
    return;
end

nCell   = length(cellstrTrialsToUse);
TrialsToUse = zeros(1,nCell);

for iCell=1:nCell
    TrialsToUse(iCell)  = str2double(cellstrTrialsToUse{iCell});
end

S.TrialsToUse   = TrialsToUse;

if(guimode_flag)
    fullfilename    = fullfile(parentpath,filename);
    save(fullfilename,'-struct','S')
else
    SS  = S;
end



    