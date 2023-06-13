function Data=mdagetdata(icomponent)

if nargin<1
    AnalysisObjects = gsma;
    nAnalyses = length(AnalysisObjects);
    if nAnalyses < 1
       disp('PeakAreas: No selected analysis -- nothing to do')
       return;
    elseif nAnalyses > 2
       disp('PeakAreas: Too many selected analysis -- nothing to do')
       return;
    end
    

    for ana = 1:nAnalyses
       analysisName = get(AnalysisObjects(ana), 'Name');
       FullName = get(AnalysisObjects(ana), 'FullName');
       AnalysesComponents = analyses(AnalysisObjects(ana), 'componentobjs');
       nAnalysesComponents = length(AnalysesComponents);
       if nAnalysesComponents == 0
          disp(['PeakAreas: No components to do: ' analysisName]);
          break;
       end

       maxTrials = 0;
       for i = 1:nAnalysesComponents
    %       analysisType = get(AnalysesComponents(i), 'SubClass');
    %       spikeName = get(AnalysesComponents(i), 'Target');
    %       TimeUnits = get(AnalysesComponents(i), 'TimeUnits');
    % %       YDataUnits = get(AnalysesComponents(i), 'YUnits');
    %       ConversionFactor = units('conversionfactor', 'time', TimeUnits, 'milliseconds');     
    %       WindowStart = get(AnalysesComponents(i), 'WindowStart') * ConversionFactor;
    %       WindowStop = get(AnalysesComponents(i), 'WindowStop') * ConversionFactor;             
    %       trialData = get(AnalysesComponents(i), 'TrialData');
    %       trialTimes = get(AnalysesComponents(i), 'TrialTriggerTime');
    % %       TrialsToUse   = get(AnalysesComponents(i), 'TrialsToUse');
    % %       nTotalTrials = get(AnalysesComponents(i), 'TrialCount');
    %       nTrials = size(trialData, 1);
    % xData = get(AnalysesComponents(i), 'XData') * ConversionFactor;
    % name = get(AnalysesComponents(i), 'Name');

          AnalysesComponentsList{i}   = get(AnalysesComponents(i), 'Name');
       end
       figure('Name',FullName,...
           'NumberTitle','off',...
           'MenuBar','none',...
           'PaperOrientation','portrait',...
           'PaperPosition',[-2 4.91751 26.4382 19.8287],...%[-2.72314 4.91751 26.4382 19.8287]
           'PaperPositionMode','manual',...
           'PaperType','A4',...
           'Pointer','arrow',...
           'Units','pixels',...
           'Position',[400 400 200 250]);
       uicontrol('BackgroundColor',[1 1 1],...
           'Style','listbox',...
           'HorizontalAlignment','center',...
           'Units','pixels',...
           'Position',[10 50 180 190],...
           'Tag','ACList',...
           'String',AnalysesComponentsList);

       uicontrol('BackgroundColor',get(gcf,'Color'),...
           'Style','pushbutton',...
           'Callback','data=mdagettd(get(findobj(gcf,''Tag'',''ACList''),''Value''));close(gcf)',...
           'HorizontalAlignment','center',...
           'Units','pixels',...
           'Position',[10 10 80 30],...
           'String','OK');
       uicontrol('BackgroundColor',get(gcf,'Color'),...
           'Style','pushbutton',...
           'Callback','close(gcf)',...
           'HorizontalAlignment','center',...
           'Units','pixels',...
           'Position',[110 10 80 30],...
           'String','Cancel');
    end
else
    
    AnalysisObjects = gsma;
    nAnalyses = length(AnalysisObjects);
    if nAnalyses < 1
       disp('PeakAreas: No selected analysis -- nothing to do')
       return;
    elseif nAnalyses > 2
        disp('PeakAreas: Too many selected analysis -- nothing to do')
        return;
    end
    % fprintf(fid,'FileName\tSpike\tTrigger\tComponents\tnTrials\tBaseStart(ms)\tBaseEnd(ms)\tBaseMean(Hz)\tBaseSTD(Hz)\tStart(ms)\tStartValue(Hz)\tEnd(ms)\tEndValue(Hz)\tPeakTime(ms)\tPeak(Hz)\tMean(Hz)\tp\t(<0.05)\n');

    analysisName = get(AnalysisObjects(1), 'Name');
    FullName = get(AnalysisObjects(1), 'FullName');
    AnalysesComponents = analyses(AnalysisObjects(1), 'componentobjs');
    nAnalysesComponents = length(AnalysesComponents);
    if nAnalysesComponents == 0
       disp(['PeakAreas: No components to do: ' analysisName]);
       return;
    end
       
    Data.analysisType = get(AnalysesComponents(icomponent), 'SubClass');
    Data.spikeName = get(AnalysesComponents(icomponent), 'Target');
    Data.TimeUnits = get(AnalysesComponents(icomponent), 'TimeUnits');
%     Data.YDataUnits = get(AnalysesComponents(icomponent), 'YUnits');
    Data.ConversionFactor = units('conversionfactor', 'time', Data.TimeUnits, 'milliseconds');     
    Data.WindowStart = get(AnalysesComponents(icomponent), 'WindowStart') * Data.ConversionFactor;
    Data.WindowStop = get(AnalysesComponents(icomponent), 'WindowStop') * Data.ConversionFactor;             
    load Aoba
    sss  = eval(['Aoba.',analysisName]);
    eval(['TrialsToUse   = [',sss,'];'])
    Data.TrialsToUse = TrialsToUse;
    TrialData = get(AnalysesComponents(icomponent), 'TrialData');
    Data.TrialData   = TrialData(TrialsToUse);
    trialTimes = get(AnalysesComponents(icomponent), 'TrialTriggerTime');
    Data.trialTimes = trialTimes(TrialsToUse);
    %    Data.TrialsToUse   = get(AnalysesComponents(icomponent), 'TrialsToUse');
    %       nTotalTrials = get(AnalysesComponents(icomponent), 'TrialCount');
    Data.nTrials    = size(Data.TrialData, 1);
    Data.xData   = get(AnalysesComponents(icomponent), 'XData') * Data.ConversionFactor;
    Data.name = get(AnalysesComponents(icomponent), 'Name');
            
end
 