%% download and add  chronux_2_10 to the path
%% FFT of continuous data

% data; channel x time series

% parameter of FFT
        movingwin = [0.2 0.005];  %0.2s window, 0.005s step
        params.Fs = 2000;         %sampling frequency
        params.fpass = [1 200];   %FFT frequency
        
        time1 = XX;               %begining of the analyzing data (sec)
        time2 = YY;               %end of the analyzing data (sec)
        
% load your file and variable        
load('Wasa_180613_Homerelease_aligned_M1');
continuous_data = variable;   

data = continuous_data(time1*params.Fs:time2*params.Fs);

[S,t,f]=mtspecgramc(data,movingwin,params);
S=S';
[S_tate S_yoko]=size(S);%P_tate ... freq?¬•ª, P_yoko ... time?¬•ª
           
 normalized_S=S./(ones([S_yoko,1])*mean(S'))';
 deltaS=10*log10(normalized_S);
 S_move=deltaS;

gcf=surf(t, f, S_move,'edgecolor','none');
axis tight; view(0,90);
ylim([0 200]);                                         %frequency of display
xlim([0 time2-time1]);                     %time of display (second)
caxis([-3 2]);                                         %z axis of image
colormap jet

set(gca,'linewidth',1.5, 'YTick', [0:50:200],'XTick', [0:round((time2-time1)/5):time2-time1],'TickDir','out','Layer','top');
set(gca, 'TickDir', 'out');
set(gca, 'Linewidth', 1);
set(gca, 'Layer', 'bottom');
set(gca, 'Layer', 'top');
set(gca, 'GridLineStyle', 'none');
set(gca,'fontsize',7)
 