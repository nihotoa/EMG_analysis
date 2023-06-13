function uihistxls(XData,method,distname)


%uihistxls(method)
% uihistxls(XData,method,distname)
% method  = 'xo';　binの右端は含まれる(default)
% method  = 'ox';　binの右端が含まれる

if(nargin<1)
    XData   = [];
    method  = 'xo';
    distname    = [];
elseif(nargin<2)
    method  = 'xo';
    distname    = [];
elseif(nargin<3)
    distname    = [];
end

if(isempty(method))
    method  = 'xo';
end

% xlsfile = uigetfullfile('*.xls','Experiment Excelファイルを選択してください。');
% xlsload(xlsfile,'Name','Data');
xlsload(-1,'VarName','Data');


S.Name          = ['HIST (',VarName,')'];
S.AnalysisType  = 'HIST';
S.Data          = Data;
S.VarName       = VarName;

if(iscell(Data))
    XLabel  = sortxls(unique(Data));
    
    tempXLabel  = '{';
    for iLabel=1:length(XLabel)
        tempXLabel  = [tempXLabel,' ''',XLabel{iLabel},''''];
    end
    tempXLabel  = [tempXLabel,' }'];
    
    temp    = inputdlg({'XLabel:'},'Xのラベル',1,{tempXLabel});
    S.XLabel  = eval([temp{1},';']);
    nXData  = length(S.XLabel);
    S.XData = 1:nXData;
    S.YData   = zeros(size(S.XData));
    
    for iX=1:nXData
        S.YData(iX)   = sum(strcmp(Data,S.XLabel(iX)));
    end
    
    S.N     = sum(S.YData);
    S.mean  = nan;
    S.std   = nan;
    S.median= nan;
    
    
    
else
    if(isempty(XData))
    dx  = inputdlg({'dx'},'Bin幅',1,{num2str(mindiff(Data))});
    dx  = str2double(dx{1});
    % ヒストグラム
    if(~isempty(Data))
        [S.YData,S.XData]   = private_hist(Data,dx,method);
        S.N     = sum(S.YData);
        S.mean  = mean(S.Data);
        S.std   = std(S.Data);
        S.median    = median(S.Data);
    else
        S.YData = [0 0];
        S.XData = [-0.5 0.5] * dx;
        S.N     = 0;
        S.mean  = NaN;
        S.std   = NaN;
        S.median    = NaN;
        
    end
    else
        [S.YData,S.XData]   = hist(S.Data,XData);
        S.N     = sum(S.YData);
        S.mean  = mean(S.Data);
        S.mean  = mean(S.Data);
        S.std   = std(S.Data);
        S.median    = median(S.Data);
    end
end

if(~isempty(distname))
    S.PD    = fitdist(Data,distname);
end


outputpath  = getconfig(mfilename,'outputpath');
try
if(~exist(outputpath,'dir'))
    outputpath  = pwd;
end
catch
    outputpath  = pwd;
end

[outputfile,outputpath] = uiputfile(fullfile(outputpath,[S.Name,'.mat']),'ファイルの保存');

if(outputpath==0)
    disp('User pressed cancel.')
else
    setconfig(mfilename,'outputpath',outputpath)
end

S.Name          = deext(outputfile);

save(fullfile(outputpath,outputfile),'-struct','S');
disp([fullfile(outputpath,outputfile),' was saved.'])

end

function [n,bin]    = private_hist(x,bw,method)

switch method
    case 'xo';
        xind    = ceil(x./bw);
    case 'ox'
        xind    = floor(x./bw)+1;
end

binind  = min(xind):max(xind);
if(numel(binind)<2)
    binind  = binind:(binind+1);
end
bin     = binind * bw - bw/2;

nbin    = length(bin);
n       = zeros(1,nbin);

for ibin=1:nbin
    n(ibin) = sum(xind==binind(ibin));
end

end

