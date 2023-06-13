function combinescat(XName,XW,XPreProcess,YName,YW,YPreProcess)

% combinescat(XName,XW,XPreProcess,YName,YW,YPreProcess)
%
% combinescat('TargetEMG(MPI-WS)',MPIs,'zscore',[],ones(size(MPIs))/length(MPIs),[])


% STA fileの結合
% 複数のSTAfileを結合します。
% 結合する単位として、それぞれのファイルで平均したものを
% さらに平均する方法（method1='file'）と、全てのファイルに含まれるtirialを
% まとめて平均する方法(method2='trial')が選べます。
% また、平均するのでなく合計したい場合はmethod2に'sum'と入力してください。
% 
% 元のSTA fileにあったTrialsToUseはapplyTrialsToUse(loaddata時に行う)によって
% データに反映された結果削除されます。
% 
% 入力
%   method1 'trial' or 'file'
%   method2 'average' or 'sum'
% 
% 例１　複数のSTAファイルのTrialをまとめて平均したい場合
% combinesta('trial','average');
% を走らせるとエクスプローラが現れるので、平均したいファイルを選択し、
% 右のboxに移動してください。
% すべて選んでOKを押すと、ただちに加算平均を開始します。
% 
% 加算平均が終了すると、出力フォルダと出力ファイルを聞かれるので、
% 上書きに注意して保存してください。
% 
% 結果は、DisplayDataで確認することができます。
% 
% 例２　各STAの平均した波形を、さらに平均したい場合
% combinesta('file','average');
% を走らせて、あとは上記と一緒です。
% 
% 
% see also, sta, sta_btc, displaydata
%
% Written by Takei 2010/09/29

pathname    = getconfig(mfilename,'pathname');
try
    if(~exist(pathname,'dir')) 
        pathname            = pwd;
    end
catch
    pathname            = pwd;
end


fullfilenames   = matexplorer(pathname);

if(isempty(fullfilenames))
    disp('User pressed cancel')
    return;
end

nfiles  = length(fullfilenames);


for ifile=1:nfiles
    fullfilename    = fullfilenames{ifile};
    S               = load(fullfilename);
    
    if(ifile==1)
        XData       = zeros(size(S.XData));
        YData       = zeros(size(S.YData));
        
        if(isempty(XName))
            XName   = S.XName;
        end
        if(isempty(YName))
            YName   = S.YName;
        end
    end
    
    if(~isempty(XPreProcess))
        switch lower(XPreProcess)
            case 'zscore'
                XData = XData + zscore(S.XData).*XW(ifile);
            otherwise
                XData = XData + S.XData.*XW(ifile);
        end
    else
        XData = XData + S.XData.*XW(ifile);
    end
    
    if(~isempty(YPreProcess))
        switch lower(YPreProcess)
            case 'zscore'
                YData = YData + zscore(S.YData).*YW(ifile);
            otherwise
                YData = YData + S.YData.*YW(ifile);
        end
    else
        YData = YData + S.YData.*YW(ifile);
    end
end

S   = [];
method          = 'combinescat';
S.Name          = ['SCAT (',XName,', ',YName,',[',method,'])'];
S.AnalysisType  = 'SCAT';
S.method        = method;
S.XW            = XW;
S.YW            = YW;
S.XPreProcess   = XPreProcess;
S.YPreProcess   = YPreProcess;
S.ReferenceName = fullfilenames;
S.TargetName    = [];
S.XData         = XData;
S.XName         = XName;
S.YData         = YData;
S.YName         = YName;
S.N             = size(XData,1);
S.Xmean         = mean(XData);
S.Xstd          = std(XData);
S.Xmedian       = median(XData);
S.Ymean         = mean(YData);
S.Ystd          = std(YData);
S.Ymedian       = median(YData);




% 相関係数
if(S.N<2)
    S.Pearson.R = 0;
    S.Pearson.P = 1;
    S.Spearman.R    = 0;
    S.Spearman.P    = 1;
    % 線形回帰
    S.a   = nan(1,2);
    S.ahelp = '回帰直線：Y=a(1)*X+a(2)';
else
    [S.Pearson.R,S.Pearson.P]   = corr(S.XData,S.YData,'type','Pearson');
    [S.Spearman.R,S.Spearman.P]   = corr(S.XData,S.YData,'type','Spearman');
    % 線形回帰
    S.a   = polyfit(XData,YData,1);
    S.ahelp = '回帰直線：Y=a(1)*X+a(2)';
end


% Output
pathname    = fileparts(fullfilenames{1});
filename    = S.Name;
pause(0.5)

[filename,pathname] = uiputfile(fullfile(pathname,[filename,'.mat']));
if isequal(filename,0) || isequal(pathname,0)
    disp('User pressed cancel')
else
    setconfig(mfilename,'pathname',pathname)
end


S.Name      = deext(filename);

save(fullfile(pathname,filename),'-struct','S');
disp(fullfile(pathname,filename))
