%file info
monkeyname = 'Wa' ; 
xpdate = '181112'; %testtest(j,3:8) % yymmdd   xpdate='150604' ; %
area = 'M1';
save_fold = 'ECoGData';
tim_fold = 'new_nmf_result';
save_fig = 0;
band_num = 9;

plot_one_array = 1;
CH = 1;
fig_range = [200 100 50 30 30 20 10 5 5];

plot_one_band = 0;
BAND = 1;

cd([monkeyname xpdate])
get_first = 1;
switch area
    case 'M1'
        for i = 1:32;
            load(['CRAW_' sprintf('%03d',i) '(uV)-ds3kHz.mat'])
            if get_first == 1
                DataA = zeros(32,length(Data));
                DataA(1,:) = Data;
                SampleRate_ECoG = SampleRate;
                get_first = 0;
            else
                DataA(i,:) = Data;
            end
        end
    case 'S1'
        for i = 33:64;
            load(['CRAW_' sprintf('%03d',i) '(uV)-ds3kHz.mat'])
            if get_first == 1
                DataA = zeros(32,length(Data));
                DataA(1,:) = Data;
                get_first = 0;
            else
                DataA(i,:) = Data;
            end
        end
end
cd ../

cd ../
cd(tim_fold)
cd([monkeyname xpdate])
load([monkeyname xpdate '_SUC_Timing.mat'])

SUC_Timing_A = floor(SUC_Timing_A./(SampleRate/SampleRate_ECoG));
SampleRate = SampleRate_ECoG;

cd ../
cd ../
cd(save_fold)

filtDatas = cell(band_num,1);
k = 1;
filt_L = {'delta','theta','alpha','beta1','beta2','gamma1','gammma2','high1','high2'};
for i = 1:band_num
% filt data
%do you use these filt? 1/0 means y/n
switch k
    %[1]delta(1.5~4Hz)
    case 1
    filt_t = [1.5 4]; 
    k = 2;
   
    %[2]theta
    case 2
    filt_t = [4 8];
    k = 3;
    
    %[3]alpha
    case 3
    filt_t = [8 14];
    k = 4;

    %[4]data smooth settings
    case 4
    filt_t = [14 20];
    k = 5;

    %[5]downsampling settings
    case 5
    filt_t = [20 30];
    k = 6;

    %[4]data smooth settings
    case 6
    filt_t = [30 50];
    k = 7;

    %[5]downsampling settings
    case 7
    filt_t = [50 90];
    k = 8;
    
    case 8
    filt_t = [110 140];
    k = 9;
    
    case 9
    filt_t = [160 190];
    k = 10;
    
    otherwise
        disp(['end_set(' sprintf('%d',k) ')'])
end
%which data do you use?
filtData = DataA';

[B,A] = butter(2, [filt_t(1) filt_t(2)]/floor(SampleRate_ECoG/2),'bandpass');
    for j = 1:32
        filtData(:,j) = filter(B,A,filtData(:,j));
    end
filtDatas{i,1} = filtData;
end
%%
if plot_one_array == 1
    cd([monkeyname xpdate]) 
    cd figure_ECoG
    for i = 1:band_num
       figure
       ave = zeros(4001,1);
       for j = 3:SUC_num
           plot(filtDatas{i,1}(SUC_Timing_A(j,3)-2000:SUC_Timing_A(j,3)+2000,CH),'Color',[0 0 0]);
           ave = ((ave .* (j-1)) + filtDatas{i,1}(SUC_Timing_A(j,3)-2000:SUC_Timing_A(j,3)+2000,CH)) ./ j;
           hold on;
       end
       plot(ave,'r');
       plot([2001 2001],[-300 300]);
       ylim([-fig_range(i) fig_range(i)])
       xlim([0 4001])
       title([monkeyname xpdate 'ECoG  ' filt_L{i}])

       if save_fig == 1
          saveas(gcf,[save_fold '_ECoG_' sprintf('%02d',CH) filt_L{i} '_band.bmp']);
       end
    end
    cd ../
cd ../
end
%%
if plot_one_band == 1
    cd([monkeyname xpdate]) 
    cd figure_ECoG
    AVE = cell(9);
    pla = [2 4 6 8 ...
          9 11 13 15 ...
           18 20 22 24 ...
          25 27 29 31 ...
           34 36 38 40 ...
          41 43 45 47 ...
           50 52 54 56 ...
          57 59 61 63];
      for BAND = 1:9
          figure('Position',[0,0,1500,1000]);
        for i = 1:32
           subplot(8,8,pla(i));
           ave = zeros(4001,32);
           for j = 3:SUC_num
               plot(filtDatas{BAND,1}(SUC_Timing_A(j,3)-2000:SUC_Timing_A(j,3)+2000,i),'Color',[0 0 0]);
               ave(:,i) = ((ave(:,i) .* (j-1)) + filtDatas{BAND,1}(SUC_Timing_A(j,3)-2000:SUC_Timing_A(j,3)+2000,i)) ./ j;
               hold on;
           end
           plot(ave(:,i),'r');
           plot([2001 2001],[-300 300]);
           ylim([-fig_range(BAND) fig_range(BAND)])
           xlim([0 4001])
           title([monkeyname xpdate 'ECoG  CH' sprintf('%02d',i) filt_L{BAND}])
           
           AVE{BAND} = ave;
        end
        if save_fig == 1
           saveas(gcf,[save_fold '_M1_ECoG_'  filt_L{BAND} '_band.bmp']);
        end
        close all;
      end
    cd ../
cd ../
end