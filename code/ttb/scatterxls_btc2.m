function scatterxls_btc2

xlsfile             = uigetfullfile('*.xls','Experiment Excelファイルを選択してください。');
xlsload(xlsfile,'XName','XData','YName','YData');
dxdy                = inputdlg({'dx:','dy:' 'nBin'},'scat2histおよびroseのビン幅',1,{'0.05','0.05','36'});
dx                  = str2double(dxdy{1});
dy                  = str2double(dxdy{2});
nBin                = str2double(dxdy{3});


S.Name          = ['SCAT (',XName,', ',YName,')'];
S.AnalysisType  = 'SCAT';
S.XData         = XData;
S.XName         = XName{1};
S.YData         = YData;
S.YName         = YName{1};

% scat2hist
[S.histXData,S.histYData,S.histCData]   = scat2hist(S.XData,S.YData,dx,dy);
% S.histCXData    = sum(S.histCData,1);
% S.histCYData    = sum(S.histCData,2);
S.dx    = dx;
S.dy    = dy;

% 極座標への変換
[S.thData,S.RData]  = cart2pol(S.XData,S.YData);

% 時計ヒスト
thData          = unwrapi(S.thData + pi/(nBin)) - pi/(nBin);
% thData          = unwrapi(S.thData);
thBinData       = 2 * pi * [0:(nBin-1)] / nBin;
% thBinData       = 2 * pi * ([0:(nBin-1)] + 0.5) / nBin;
[S.th_histYData,S.th_histXData]  = hist(thData,thBinData);
S.nBin          = nBin;

[outputfile,outputpath] = uiputfile(fullfile(datapath,'SCAT',[S.Name,'.mat']),'ファイルの保存');

S.Name          = deext(outputfile);

save(fullfile(outputpath,outputfile),'-struct','S');
disp([fullfile(outputpath,outputfile),' was saved.']) 