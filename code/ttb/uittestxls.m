function varargout  = uittestxls(mode,alpha,tail,vartype)
% uittestxls(mode,alpha,tail,vartype)
%
% uittestxls('pooled',0.05,'both','unequal')

if(nargin<4)
    vartype = 'equal'; % 'unequal';
elseif(nargin<3)
    vartype = 'equal'; % 'unequal';
    tail    = 'both';
    % 'both'  -- "平均は等しくない" (両側検定)
    % 'right' -- "X の平均は Y の平均よりも大きい" (右側検定)
    % 'left'  -- "X の平均は Y の平均よりも小さい" (左側検定)
elseif(nargin<2)
    vartype = 'equal'; % 'unequal';
    tail    = 'both';
    alpha   = 0.05;
elseif(nargin<1)
    vartype = 'equal'; % 'unequal';
    tail    = 'both';
    alpha   = 0.05;
    mode    = 'paired'; % 'pooled'
end

xlsload(-1,'VarName','XName','XData','YName','YData');


Y.AnalysisType  = 'TTEST';
Y.VarName       = VarName;
Y.gnames        = {XName,YName};
Y.Data          = {XData,YData};
Y.mean          = [mean(XData),mean(YData)];
Y.std           = [std(XData),std(YData)];
Y.n             = [length(XData),length(YData)];
Y.mode          = mode;
Y.alpha         = alpha;
Y.tail          = tail;
Y.vartype       = vartype;

switch mode
    case 'paired'
        [Y.h,Y.p,Y.ci,Y.stats]  = ttest(XData,YData,alpha,tail);
    case 'pooled'
        [Y.h,Y.p,Y.ci,Y.stats]  = ttest2(XData,YData,alpha,tail,vartype);
end


if(nargout==1)
    varargout{1}    = Y;
else
    OutFileName = ['TTEST(',VarName,';',XName,',',YName,',n=',num2str(sum(Y.n)),')'];
    
    
    % OutputDir   = uigetdir(fullfile(datapath,'ANOVA1'),'出力先フォルダを選択してください。');
    [OutFileName,OutputDir]  = uiputfile(fullfile(datapath,'TTEST',[OutFileName,'.mat']),'ファイルの保存');
    
    OutFullfileName     = fullfile(OutputDir,OutFileName);
    
    save(OutFullfileName,'-struct','Y');
    disp(OutFullfileName)
end