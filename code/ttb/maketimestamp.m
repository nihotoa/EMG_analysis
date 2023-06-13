function [Y1,Y2,Y3]  = maketimestamp(ch1,ch2,ch3)

% ch1 = load('L:\tkitom\MDAdata\mat\AobaT00101\smoothed Index Torque(N).mat');
% ch2 = load('L:\tkitom\MDAdata\mat\AobaT00101\smoothed Thumb Torque(N).mat');
% ch3 = load('L:\tkitom\MDAdata\mat\AobaT00101\Grip Onset (success valid).mat');

SampleRate  = ch1.SampleRate;
dt          = 1/SampleRate;
TimeRange   = ch1.TimeRange;
nData       = length(ch1.Data);
% Window  = [0:200];

Y1.TimeRange    = TimeRange;
Y1.Name         = ch1.Name;
Y1.Class        = 'continuous channel';
Y1.SampleRate   = SampleRate;
Y1.Unit         = 'N';

Y2.TimeRange    = TimeRange;
Y2.Name         = ch2.Name;
Y2.Class        = 'continuous channel';
Y2.SampleRate   = SampleRate;
Y2.Unit         = 'Nps';

Y3.TimeRange    = TimeRange;
Y3.Name         = 'Total Torque(N)';
Y3.Class        = 'continuous channel';
Y3.SampleRate   = SampleRate;
Y3.Unit         = 'N';

Y4.TimeRange    = TimeRange;
Y4.Name         = 'Total deriv Torque(Nps)';
Y4.Class        = 'continuous channel';
Y4.SampleRate   = SampleRate;
Y4.Unit         = 'N';


Y5.Name          = 'Grip peak deriv Torque (success valid)';
Y5.Class         = 'timestamp channel';
Y5.SampleRate    = SampleRate;


%% Y1 Y2 Data 
% detrend
bpw     = SampleRate*300;       % 5•ªŠÔ‚Ìƒf[ƒ^‚Ì’·‚³
if(nData >= bpw)                    % detrend bp‚ð‚â‚é‚É‚½‚é’·‚³‚ª‚ ‚é‚Æ‚«‚¾‚¯
    Y1.Data = detrend(ch1.Data,'linear',[1:bpw:nData]);
    Y2.Data = detrend(ch2.Data,'linear',[1:bpw:nData]);
else
    Y1.Data = detrend(ch1.Data);
    Y2.Data = detrend(ch2.Data);
end
% zero offset
Y1.Data = Y1.Data - mean(Y1.Data(Y1.Data<prctile(Y1.Data,25)));
Y2.Data = Y2.Data - mean(Y2.Data(Y2.Data<prctile(Y2.Data,25)));


%% Y3 Y4 Data

Y3.Data	= Y1.Data + Y2.Data;
Y4.Data = [0 diff(Y3.Data)] * SampleRate;


%% Y5 
WindowMatrix    = repmat(ch3.Data',1,length(Window)) + repmat(Window,length(ch3.Data),1);
dataMatrix      = Y2.Data(WindowMatrix);
[YData,Ind]     = max(dataMatrix,[],2);
for ii=1:length(Ind)
    Y3.Data(ii)=WindowMatrix(ii,Ind(ii));
end


% Y3.Data          = XData;

% function Y  = maketimestamp
% 
% ch1 = load('L:\tkitom\MDAdata\mat\AobaT00203\smoothed Index Torque(N).mat');
% ch2 = load('L:\tkitom\MDAdata\mat\AobaT00203\smoothed Thumb Torque(N).mat');
% ch3 = load('L:\tkitom\MDAdata\mat\AobaT00203\Grip Onset (success valid).mat');
% SampleRate  = 1000;
% Window  = [0:200];
% data	= ch1.Data + ch2.Data;
% data    = [0 diff(data)];
% 
% WindowMatrix    = repmat(ch3.Data',1,length(Window)) + repmat(Window,length(ch3.Data),1);
% dataMatrix      = data(WindowMatrix);
% [YData,Ind]         = max(dataMatrix,[],2);
% for ii=1:length(Ind)
%     XData(ii)=WindowMatrix(ii,Ind(ii));
% end
% 
% Y.Name          = 'Grip PeakDevTotque (success valid)';
% Y.Class         = 'timestamp channel';
% Y.SampleRate    = SampleRate;
% Y.Data          = XData;