function [Y1,Y2]  = makecontinuous

ch1 = load('L:\tkitom\MDAdata\mat\AobaT00101\smoothed Index Torque(N).mat');
ch2 = load('L:\tkitom\MDAdata\mat\AobaT00101\smoothed Thumb Torque(N).mat');

SampleRate  = 1000;

YData	= ch1.Data + ch2.Data;
YData2  = [0 diff(YData)];

Y1.Name          = 'summed smoothed Torque(N)';
Y1.Class         = 'continuous channel';
Y1.SampleRate    = SampleRate;
Y1.Data          = YData;

Y2.Name          = 'summed smoothed deriv Torque(N)';
Y2.Class         = 'continuous channel';
Y2.SampleRate    = SampleRate;
Y2.Data          = YData;
