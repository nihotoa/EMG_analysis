%% download and add  chronux_2_10 to the path
%% FFT of aligned data at the timing of some signal
clear all
% aligned_data; channel x time series x trial

% parameter of FFT
        movingwin=[0.2 0.005];  %0.2s window, 0.005s step
        params.Fs=1350;         %sampling frequency
        params.fpass=[1 200];   %FFT frequency
        
% Filter 
PreprocessECoG.fFilter = 1;% ƒtƒBƒ‹ƒ^‚ðŠ|‚¯‚é‚È‚ç1?A‚©‚¯‚È‚¢‚È‚ç0
PreprocessECoG.FilterN = 2;% Š|‚¯‚éƒtƒBƒ‹ƒ^‚ÌŽŸ?”
PreprocessECoG.FilterWn = [10 240];%ƒJƒbƒgƒIƒtŽü”g?”
PreprocessECoG.FilterType = 'bandpass';%ƒtƒBƒ‹ƒ^‚ÌŽí—Þ
PreprocessECoG.SampFreq = 1350 ;% Œ³‚Ì?M?†‚ÌƒTƒ“ƒvƒŠƒ“ƒOŽü”g?”

        
% load your file and variable        
load('Wasa_Wa180926_holdonset_M1');
% load('Wasa_Wa180815_4_homePad_release_S1');

aligned_data = aligned_M1(:,:,:);   
% aligned_data = aligned_S1(:,:,:);   

[Ch, Time_series, Trial] = size(aligned_data);

    for iCh = 1:Ch
            for itrial = 1:Trial  
                [oB,oA] = butter(PreprocessECoG.FilterN,PreprocessECoG.FilterWn/PreprocessECoG.SampFreq*2, PreprocessECoG.FilterType);
                ECoG2(iCh, :, itrial) = filtfilt(oB,oA,aligned_data(iCh, :, itrial));
            end
    end
    
    
    
%for S1 analysis
%      ECoG2=ECoG2(33:64,:,:); 
 
  %%S1  
%     map=[2,7,13,19,25,3,26,20,8,9,14,32,33,27,21,15,16,22,28,34,35,17,10,11,23,29,4,30,24,18,12,5];
    
%for M1 analysis

    map = [2,4,6,8,9,11,13,15,18,20,22,24,25,27,29,31,34,36,38,40,41,43,45,47,50,52,54,56,57,59,61,63]; 


    
%     map = [11,15,20,24,27,31,36,40,43,47,52,56,59,63,61,57,54,50,45,41,38,34,29,25,22,18,13,9,6,59,61,63]; %Roland
%     
for k = 1:32 %
    data = [];
    data = reshape(ECoG2(k,:,:), Time_series, Trial);
    
    for i=1:Trial 

    [S,t,f] = mtspecgramc(data(:,i), movingwin, params);
    S = S';
    [S_tate S_yoko] = size(S);                          %P_tate ... freq?¬•ª, P_yoko ... time?¬•ª
           
    normalized_S = S./(ones([S_yoko,1])*mean(S'))';     %normalization of power at each frequency
    deltaS = 10*log10(normalized_S);
    S_move = deltaS;
 
    FFT_signal(:,:,i,k) = S_move;
    end
    
 %FFT_signal(:,:,[27,33,34],:) = [];
    figure(1)
    %subplot(8,8,i)
    
    
    subplot(8,8,map(k)) % for M1
    
%        subplot(6,6,map(k)) % for S1
       
       
    %subplot(8,4,k)                                         %dependent on channel number
    %gcf = surf(t-1, f, mean(FFT_signal(:,:,i,1), 3),'edgecolor','none');
 gcf = surf(t-1, f, mean(FFT_signal(:,:,:,k), 3),'edgecolor','none');
 axis tight; view(0,90);
 ylim([0 200]);                                         %frequency of display
 xlim([-1 1]);                                           %time of display (second)
 caxis([-2 4]);                                         %z axis of image [-2 4] % [-5 5]
 colormap jet
hold on
set(gca,'linewidth',1.5, 'YTick', [0:50:200],'XTick', [-2:1:4],'TickDir','out','Layer','top');
set(gca, 'TickDir', 'out');
set(gca, 'Linewidth', 1);
set(gca, 'Layer', 'bottom');
set(gca, 'Layer', 'top');
set(gca, 'GridLineStyle', 'none');
set(gca,'fontsize',7)
end


% title('Wasa S1 180711, aligned on object hold')
title('Wasa Wa180926 hold onset M1')
xlabel('time')
ylabel('frequency')





