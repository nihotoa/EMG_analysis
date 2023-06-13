function STArename

AnalysisObjects = gsma;
nAnalyses = length(AnalysisObjects);
if nAnalyses < 1
   disp('PeakAreas: No selected analysis -- nothing to do')
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
%       TrialsToUse   = get(AnalysesComponents(i), 'TrialsToUse');
%       nTotalTrials = get(AnalysesComponents(i), 'TrialCount');
%       nTrials = size(trialData, 1);
%       name = get(AnalysesComponents(i), 'Name'); 
        Reference  = get(AnalysesComponents(i),'Reference');
        Target  = get(AnalysesComponents(i),'Target');
        set(AnalysesComponents(i), 'Name', [Reference,',',Target]);
%         set(AnalysesComponents(i), 'Name', Target);
   end
end