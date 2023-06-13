function [Y,Y_data]  = psth(Tar, Ref, TimeWindow, bw)
% [Y,Y_data]  = psth(Tar, Ref, TimeWindow, binwidth)     in sec
%
% Y.
% Name
% data_file
% ReferenceName
% TargetName
% Class: 'timestamp channel'
% AnalysisType: 'PSTH'
% TimeRange   (sec)
% SampleRate
% TrialTriggerTime  (sec)
% TrialCount
% TrialsToUse
% StoreTrials
% XData       (sec)
% YData
% BinEdges    (sec)
% BinWidth    (sec)
%
% Y_data.
% Name
% hdr_file
% TrialData


RefData     = Ref.Data./Ref.SampleRate + Ref.TimeRange(1); % sec
TarData     = Tar.Data./Tar.SampleRate + Tar.TimeRange(1); % sec
StartTime   = RefData + TimeWindow(1);
StopTime    = RefData + TimeWindow(2);

% trim invalid Trigger(RefData)
RefData     = RefData(StartTime>=Ref.TimeRange(1) & StopTime<=Ref.TimeRange(2));
StartTime   = RefData + TimeWindow(1);
StopTime    = RefData + TimeWindow(2);

nTrials     = length(RefData);
TrialData   = cell(nTrials,1);

for iTrial=1:nTrials
    TrialData{iTrial}   = TarData(TarData>=StartTime(iTrial) & TarData<=StopTime(iTrial)) - RefData(iTrial);
end

[YData,XData,BinEdges]  = timestamp2psth(TrialData,TimeWindow,bw);

Y.Name          = ['PSTH (',Ref.Name,', ',Tar.Name,')'];
Y.data_file     = ['._',Y.Name,'.mat'];
Y.ReferenceName = Ref.Name;
Y.TargetName    = Tar.Name;
Y.Class         = Tar.Class;
Y.AnalysisType  = 'PSTH';
Y.TimeRange     = TimeWindow;
Y.SampleRate    = Tar.SampleRate;
Y.TrialTriggerTime  = RefData;
Y.nTrials       = nTrials;
if(isfield(Ref,'TrialsToUse'))
    Y.TrialsToUse   = Ref.TrialsToUse;
else
    Y.TrialsToUse   = [];
end
Y.StoreTrials   = 1;
Y.XData         = XData;
Y.YData         = YData;
Y.TrialData     = true;
Y.BinEdges      = BinEdges;
Y.BinWidth      = bw;

Y_data.Name         = ['._',Y.Name];
Y_data.hdr_file     = [Y.Name,'.mat'];
Y_data.TrialData    = TrialData;


end
