function uiscatterxls
% uiscatterxls �����Ȃ�


% xlsfile             = uigetfullfile('*.xls','Experiment Excel�t�@�C����I�����Ă��������B');
% xlsload(xlsfile,'XName','XData','YName','YData');
xlsload(-1,'XName','XData','YName','YData');
if(length(XData)~=length(YData))
    error('X��Y�̃f�[�^������v���Ă��܂���B')
end
dxdy                = inputdlg({'dx:','dy:'},'histgram�̃r����',1,{num2str(mindiff(XData)),num2str(mindiff(YData))});
dx                  = str2double(dxdy{1});
dy                  = str2double(dxdy{2});


S.Name          = ['SCAT (',XName,', ',YName,')'];
S.AnalysisType  = 'SCAT';
S.XData         = XData;
S.XName         = XName;
S.YData         = YData;
S.YName         = YName;
S.N             = length(XData);
if(S.N~=0)
S.Xmean         = mean(XData);
S.Xstd          = std(XData);
S.Xmedian       = median(XData);
S.Ymean         = mean(YData);
S.Ystd          = std(YData);
S.Ymedian       = median(YData);

% ���֌W��
[S.Pearson.R,S.Pearson.P] =corr(S.XData,S.YData,'type','Pearson');
[S.Spearman.R,S.Spearman.P] =corr(S.XData,S.YData,'type','Spearman');

% ���`��A
S.a   = polyfit(XData,YData,1);
S.ahelp = '��A�����FY=a(1)*X+a(2)';

% scat2hist
[S.hist.XData,S.hist.YData,S.hist.ZData]   = scat2hist(S.XData,S.YData,dx,dy);
% S.dx    = dx;
% S.dy    = dy;

% % �ɍ��W�ւ̕ϊ�
% [S.thData,S.RData]  = cart2pol(S.XData,S.YData);
% 
% % ���v�q�X�g
% thData          = unwrapi(S.thData + pi/(nBin)) - pi/(nBin);
% % thData          = unwrapi(S.thData);
% thBinData       = 2 * pi * [0:(nBin-1)] / nBin;
% % thBinData       = 2 * pi * ([0:(nBin-1)] + 0.5) / nBin;
% [S.th_histYData,S.th_histXData]  = hist(thData,thBinData);
% S.nBin          = nBin;
else
    S.Xmean         = NaN;
    S.Xstd          = NaN;
    S.Xmedian       = NaN;
    S.Ymean         = NaN;
    S.Ystd          = NaN;
    S.Ymedian       = NaN;
    S.Pearson.R     = NaN;
    S.Pearson.P     = NaN;
    S.Spearman.R    = NaN;
    S.Spearman.P    = NaN;
    S.a             = [NaN NaN];
    S.ahelp = '��A�����FY=a(1)*X+a(2)';
    S.hist.XData    = [-0.5 0.5] * dx;
    S.hist.YData    = [-0.5 0.5] * dy;
    S.hist.ZData    = zeros(2);

end

outputpath  = getconfig(mfilename,'outputpath');
try
    if(~exist(outputpath,'dir'))
        outputpath  = pwd;
    end
catch
    outputpath  = pwd;
end 
[outputfile,outputpath] = uiputfile(fullfile(outputpath,[S.Name,'.mat']),'�t�@�C���̕ۑ�');
if(outputpath==0)
    disp('User pressed cancel.')
    return;
else
    setconfig(mfilename,'outputpath',outputpath);
end

S.Name          = deext(outputfile);

save(fullfile(outputpath,outputfile),'-struct','S');
disp([fullfile(outputpath,outputfile),' was saved.']) 