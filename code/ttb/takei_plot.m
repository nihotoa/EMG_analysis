function takei_plot
% takei_plot
% 
% 武井@nipsが作成した実験データを表示する、単純なプログラムです。
% まずは、DVDをDVDドライブに入れた状態（もしくはDVD内のデータをローカルディスクに保存した状態）で
% 
% takei_plot
% 
% を実行してください。
% その後、ファイル選択ダイアログが現れますので、任意のmatファイルを選択してください。
% 新しいfigure上に、データ（デフォルトでは最初の60秒間）が描画されます。

% 28/Nov/2008 T.Takei



% 描画する時間長（秒）
t       = 60;   % in sec

% ファイルの選択
[filename,pathname] = uigetfile('*.mat','開きたいファイルをひとつ選択してください。');
fullfilename        = fullfile(pathname,filename);

% ファイルの読み込み
load(fullfilename);

% 時間軸の設定
XData   = ([0:(length(Data)-1)]./SampleRate) + TimeRange(1);
ind     = 1:SampleRate*t;

% 描画
figure;
plot(XData(ind),Data(ind))
xlabel('Time (Sec)')
ylabel('Amplitude')
title(Name)



