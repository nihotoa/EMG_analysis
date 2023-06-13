%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
coded by: Naohito Ota
last modification: 2023/05/24
入力した離散時間データのパワースペクトルを求める
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function PowerSpectrumAnalyze(data,SR,f)
%POWERSPECTOR data:f(t) SR:SamplingRate f:求める周波数の上限
% to analyze power spector from f(t)
%動作確認済み
%【注意!!】横軸は角周波数(rad/s)ではなくて，周波数(Hz)
%フーリエ変換
fftData = fft(data);
powerSpectrum = abs(fftData).^2;

%周波数軸の設定
Fs = SR;
N = length(data);
powerSpectrum = powerSpectrum(1,1:f+1); %ナイキスト周波数までのパワースペクトルに限定

plot(powerSpectrum)

%decorate
%save(figure & data)

close all;
end

