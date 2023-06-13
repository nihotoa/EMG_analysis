function [YData,XData,ZData]  = staconvxls
% [YData,XData,ZData]  = staconvxls;
% Excelに用意したkernel波形（例：STAからBaseLineは差し引いたもの）をExcelに用意したPSTHのタイムスタンプデータに畳み込みする。
% 
% YData   :convolusionしたもの
% XData   :時間(sec)
% ZData   :Raster（0 or 1）
%
% Written by TT





PSTHDir     = getconfig(mfilename,'PSTHDir');
PSTHFile    = getconfig(mfilename,'PSTHFile');
try
    if(~exist(PSTHDir,'dir'))
        PSTHDir = pwd;
    end
catch
    PSTHDir = pwd;
end
try
    if(isempty(PSTHFile))
        PSTHFile = '*.xls';
    end
catch
    PSTHFile = '*.xls';
end

STADir      = getconfig(mfilename,'STADir');
STAFile     = getconfig(mfilename,'STAFile');
try
    if(~exist(STADir,'dir'))
        STADir = PSTHDir;
    end
catch
    STADir = PSTHDir;
end
try
    if(isempty(STAFile))
        STAFile = '*.xls';
    end
catch
    STAFile = '*.xls';
end


% load timestamp data
[PSTHFile,PSTHDir]   = uigetfile(fullfile(PSTHDir,PSTHFile),'Select PSTH file');
if(isequal(PSTHFile,0) || isequal(PSTHDir,0))
    disp('User pressed cancel')
    return;
else
    setconfig(mfilename,'PSTHDir',PSTHDir);
    setconfig(mfilename,'PSTHFile',PSTHFile);
end

[temp,temp,TS.Data] = xlsread(fullfile(PSTHDir,PSTHFile),-1,'Select timestamp data');
[temp,temp,TS.TimeRange1] = xlsread(fullfile(PSTHDir,PSTHFile),-1,'Select WindowStart(sec)');
[temp,temp,TS.TimeRange2] = xlsread(fullfile(PSTHDir,PSTHFile),-1,'Select WindowStop(sec)');

% load STA data
[STAFile,STADir]   = uigetfile(fullfile(STADir,STAFile),'Select STA file');
if(isequal(STAFile,0) || isequal(STADir,0))
    disp('User pressed cancel')
    return;
else
    setconfig(mfilename,'STADir',STADir);
    setconfig(mfilename,'STAFile',STAFile);
end
[temp,temp,STA.YData] = xlsread(fullfile(STADir,STAFile),-1,'Select kernel data (YData)');
[temp,temp,STA.XData] = xlsread(fullfile(STADir,STAFile),-1,'Select kernel time data (XData)');



% cell2mat
if(iscell(TS.Data))
    TS.Data = cell2mat(TS.Data);
end
if(iscell(TS.TimeRange1))
    TS.TimeRange1   = cell2mat(TS.TimeRange1);
end
if(iscell(TS.TimeRange2))
    TS.TimeRange2   = cell2mat(TS.TimeRange2);
end

if(iscell(STA.YData))
    STA.YData   = cell2mat(STA.YData);
end
if(iscell(STA.XData))
    STA.XData   = cell2mat(STA.XData);
end
STA.SampleRate  = 1./(STA.XData(2)-STA.XData(1));



% kernelへの処理
kernel  = zerocenter(STA.YData,STA.XData)';

% 出力データの準備
nTrials = size(TS.Data,2);
XData   = ((((1:round((TS.TimeRange2-TS.TimeRange1)*STA.SampleRate))-1) ./ STA.SampleRate)  + TS.TimeRange1)';
YData   = zeros(round((TS.TimeRange2-TS.TimeRange1)*STA.SampleRate),nTrials);
ZData   = zeros(round((TS.TimeRange2-TS.TimeRange1)*STA.SampleRate),nTrials); % Raster Data

for iTrial=1:nTrials
    % timestampへの処理
%     temp    = cell2mat(TS.Data(:,iTrial));
    temp    = TS.Data(:,iTrial);
    temp    = temp(~isnan(temp));
    if(~isempty(temp))
        temp    = round((temp - TS.TimeRange1) * STA.SampleRate);
        ZData(temp,iTrial)  = 1;
        
        % convolusion
        YData(:,iTrial)  = conv2(ZData(:,iTrial)',kernel,'same')';
    end
end


end

function [Y,X] = zerocenter(y,x)
[y,nshift_y]  = shiftdim(y);
[x,nshift_x]  = shiftdim(x);
nx  = length(x);
ny  = length(y);
d       = x(2) - x(1);

if(x(1) > 0)
    X   = [-x:d:x(end)]';
    
elseif(x(end) < 0)
    X   = [x(1):d:-x(1)]';
else
    X   = [-max(abs(x([1,end]))):d:max(abs(x([1,end])))]';
end

Y   = zeros(size(X));
[temp,ind]  = nearest(X,x(1));
Y(ind:ind+ny-1) = y;


Y   = shiftdim(Y,nshift_y);
X   = shiftdim(X,-nshift_x);


end
