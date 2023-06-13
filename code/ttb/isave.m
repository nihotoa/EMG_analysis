function Y  = isave(Tar, Ref, TimeWindow, Tau)
% TimeWindow, Tau in (s)

if nargin < 4
    StoreTrial_flag =0;
end
% Tar = topen;
% Ref = topen;

TimeWindowIndex = round(TimeWindow * Tar.SampleRate);
WindowLengthIndex   = TimeWindowIndex(2) - TimeWindowIndex(1) + 1;
TimeWindow      = TimeWindowIndex / Tar.SampleRate;
timestamp       = round((Ref.Data * Tar.SampleRate) / Ref.SampleRate);  % Targetのサンプリングレートにあわせる
nstamps         = length(timestamp);
nTarData        = length(Tar.Data);
TauIndex        = round(Tau * Tar.SampleRate);
nTau            = length(TauIndex);

timestamp       = reshape(repmat(TauIndex',1,nstamps) + repmat(timestamp,nTau,1),1,nstamps * nTau);
nstamps         = length(timestamp); % redefine # of timestamps

StartIndices    = timestamp + TimeWindowIndex(1);
StopIndices     = StartIndices + WindowLengthIndex -1;

XData           = [TimeWindowIndex(1):TimeWindowIndex(2)]/ Tar.SampleRate;

jj      = 0;
TrialData   = [];
YData       = zeros(1,WindowLengthIndex);
for ii = 1:nstamps
    if(mod(ii,1000)==0)
%     indicator(ii,nstamps,Tar.Name)
    end
    if(StartIndices(ii)>0 & StopIndices(ii)<=nTarData)
        jj  = jj + 1;
        YData           = YData(1,:) + Tar.Data([StartIndices(ii):StopIndices(ii)]);
    end
end
YData           = YData ./ jj;


Y.Name          = ['ISA (',Ref.Name,', ',Tar.Name,')'];
Y.TargetName    = Tar.Name;
Y.ReferenceName = Ref.Name;
Y.Class         = Tar.Class;
Y.AnalysisType  = 'ISA';
Y.TimeRange     = TimeWindow;
Y.SampleRate    = Tar.SampleRate;
Y.nTrials       = nstamps     
Y.TrialData     = TrialData;
Y.YData         = YData;
Y.XData         = XData;