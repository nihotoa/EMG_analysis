function scatterxls_btc

xlsfile             = uigetfullfile('*.xls','Experiment Excelファイルを選択してください。');
xlsload(xlsfile,'XName','XData','YName','YData');
parsexls('XName','XData','YName','YData');
% [temp1,temp2,list]  = xlsread(xlsfile,-1);
% [XName,XNameind]    = uiselect(list(1,:),1,'X座標に用いる変数を選択して下さい。');
% [YName,YNameind]    = uiselect(list(1,:),1,'Y座標に用いる変数を選択して下さい。');
% [CName,CNameind]    = uiselect(list(1,:),1,'ラベルに用いる変数を選択して下さい。(中身が0のセルは排除されます)');
dxdy                = inputdlg({'dx:','dy:' 'nBin'},'scat2histおよびroseのビン幅',1,{'0.05','0.05','36'});
dx                  = str2double(dxdy{1});
dy                  = str2double(dxdy{2});
nBin                = str2double(dxdy{3});

% % CNameind            = strmatch(CName,list(1,:),'exact');
% CData               = [list{2:end,CNameind}];
% ind                 = [false, CData>0];
% CData               = [list{ind,CNameind}];
% 
% % XNameind            = strmatch(XName,list(1,:),'exact');
% XData               = [list{ind,XNameind}];
% 
% % YNameind            = strmatch(YName,list(1,:),'exact');
% YData               = [list{ind,YNameind}];
keyboard
label    = sort(unique(CData));
nlabel  = length(label);
labelstr    = num2cell(label);
for ilabel=1:nlabel
    if(~ischar(labelstr{ilabel}))
        labelstr{ilabel}   = [CName{1},': ',num2str(labelstr{ilabel})];
    end
end

labelname   = inputdlg(labelstr,'LabelNameの入力',1,labelstr);


S.Name          = ['SCAT (',XName{1},', ',YName{1},')'];
S.AnalysisType  = 'SCAT';
S.XData         = XData;
S.XName         = XName{1};
S.YData         = YData;
S.YName         = YName{1};
S.CData         = CData;
S.CTick         = label;
S.CTickLabel    = labelname;

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

% keyboard
% 
% figure;
% subplot(2,2,1)
% imagesc(S.histXData,S.histYData,S.histCData);
% axis('xy')
% 
% subplot(2,2,2)
% imagesc(S.histXData,S.histYData,S.histCData);
% axis('xy')
% hold on
% plot(S.XData,S.YData,'w.')
% 
% subplot(2,2,3)
% polarbar(gca,S.th_histXData,S.th_histYData)
% 
% subplot(2,2,4)
% bar([S.th_histXData - 2*pi,S.th_histXData],[S.th_histYData,S.th_histYData],1)
% 

 