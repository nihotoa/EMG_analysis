function []=testplot()
   % set plot range
   PlotRange = 2300000:2400000;
%    x = 0:1/5000:PlotRange(end)/5000;
   % set monkey information
   global Monkey
   Monkey.realname = 'Yachimun';
   Monkey.name = 'Ya';
   Monkey.EMGs = {'FDP','FDSprox','FDSdist','FCU','PL','FCR','BRD','ECR','EDCprox','EDCdist','ED45','ECU'};
   Monkey.EMGnum = length(Monkey.EMGs);
%    arm = 'L';
   if exist('arm')
      for m = 1:12
         Monkey.EMGs{m}=[Monkey.EMGs{m} '_' arm];
      end
   end
   cd(Monkey.realname)
   % set signal preprocessing information
   global FilterSettings;
%    FilterSettings.order = {'HPF'};
%    FilterSettings.order = {'BPF','minusAVE'};
%    FilterSettings.order = {'HPF','minusAVE','rectify'};
%    FilterSettings.order = {'HPF','minusAVE','rectify','LPF'};
%    FilterSettings.order = {'HPF','minusAVE','rectify','LPF','smooth'};
%    FilterSettings.order = {'BPF','minusAVE','rectify','LPF','smooth','downsample'};
   FilterSettings.order = {'BPF','minusAVE','rectify','LPF','smooth','downsample','normalize'};
   FilterSettings.HPF = {'butter',6,50};
   FilterSettings.LPF = {'butter',6,20};
   FilterSettings.BPF = {'butter',6,50,1000};
   FilterSettings.smooth_num = 100;
   FilterSettings.downdata_to = 100;
%    FilterSettings.winter = [6,0;
%                             10,1000;
%                             30,1000;
%                             50,1000;
%                             100,1000;
%                             200,1000;
%                             300,1000;
%                             400,1000;
%                             10,30;
%                             10,50;
%                             10,100;
%                             10,200;
%                             10,400];

   % set which session would you analyze
   ParentDir = uigetdir(['Macintosh HD/Users/uchida/Documents/MATLAB/data/' Monkey.realname '/']);
   TarSessions = uigetfile('*.mat',...
                     'Select One or More Files', ...
                     'MultiSelect', 'on');
   if iscell(TarSessions)
      S = size(TarSessions);
      elseif ischar(TarSessions)
         S = [1,1];
         TarSessions = cellstr(TarSessions);
   end
   session_num = S(2);
   AllSessions = strrep(TarSessions,'_standard.mat','');
%    if exist('arm')
%        AllSessions = strrep(AllSessions,arm,'');
%    end
   % start main process
   
   for session = 1:session_num
      cd easyData
      cd(AllSessions{session})
      load([cell2mat(AllSessions) '_EasyData.mat'],'Tp')
      cd(ParentDir)
      cd(AllSessions{session})
      
      % load EMG data from nmf direcrory
      [Data,info]=loadEMG(Monkey);
      info.x_msec = PlotRange(1)*1000/info.SampleRate:1000/info.SampleRate:PlotRange(end)*1000/info.SampleRate;
      info.x_msec = info.x_msec - info.x_msec(1);
      
      % callculate power spectrum
      [f,power] = powerSpec(Data,info);
      f_spec = figure;
      for sub = 1:Monkey.EMGnum
         subplot(3,4,sub)
         plot(f,power(sub,:))
         xlabel('Frequency')
         ylabel('Power')
      end
   
      f_raw = figure;
      for m = 1:Monkey.EMGnum
         subplot(Monkey.EMGnum/2,2,m);
         plot(info.x_msec,Data(m,PlotRange))
%          ylim([-400 400]);
         title(Monkey.EMGs{m})
      end
%       
      % filter EMG data as Takei-san paper (T.Takei K.Seki, PNAS,2017)
      [filteredData,info] = filtEMG(Monkey,Data,info,FilterSettings,[]);
      
      f_filtered = figure;
      for m = 1:Monkey.EMGnum
         subplot(Monkey.EMGnum/2,2,m);
%          plot(filteredData(m,:))
         plot(info.x_msec,filteredData(m,PlotRange(1)/50:PlotRange(end)/50))
         ylim([0 15]);
         title(Monkey.EMGs{m})
      end
      
      % callculate power spectrum
      [f,power] = powerSpec(filteredData,info);
      f_spec2 = figure;
      for sub = 1:Monkey.EMGnum
         subplot(3,4,sub)
         plot(f,power(sub,:))
         xlabel('Frequency')
         ylabel('Power')
      end
      
       % trigger plot 
       f_triggered = figure;
      for m = 1:Monkey.EMGnum
         subplot(Monkey.EMGnum/2,2,m);
         hold on;
         alinedDatafortest=cell(length(Tp),1);
         for t = 1:length(Tp)
             alinedDatafortest{t} = filteredData(m,round((Tp(t,3)-5000)/50):round((Tp(t,3)+5000)/50));
             plot(alinedDatafortest{t},'k')
         end
         plot(mean(cell2mat(alinedDatafortest)),'r')
         plot([101 101],[0 400],'y');
         hold off;
         ylim([0 15])
         xlim([0 200])
         title(Monkey.EMGs{m})
      end
      
   end
end

function [Data,info]=loadEMG(Monkey)
   DataCell = cell(Monkey.EMGnum,1);
   for m = 1:Monkey.EMGnum
      target = load([Monkey.EMGs{m} '(uV).mat']);
      DataCell{m,1} = target.Data;
   end
   Data = cell2mat(DataCell);
   info.SampleRate = target.SampleRate;
   info.TimeRange = target.TimeRange;
end

function [f,power] = powerSpec(Data,info)
   fs = info.SampleRate;   % sample frequency (Hz)
%    t = info.TimeRange(1):1/fs:info.TimeRange(2);
%    t = t - t(1);
   y = fft(Data,[],2);     % horizontal
   n = length(Data);       % number of samples
   f = (0:n-1)*(fs/n);     % frequency range
   power = abs(y).^2/n;    % power of the DFT
end

function [filteredData,info] = filtEMG(Monkey,Data,info,FilterSettings,varargin)
   filteredData = Data;
   processN = length(FilterSettings.order);
   process = FilterSettings.order;
   for p = 1:processN
      switch process{p}
         case 'BPF'
            [B,A] = butter(FilterSettings.BPF{2}, (FilterSettings.BPF{3} .* 2) ./ info.SampleRate, 'high');
            filteredData = filter(B,A,filteredData,[],2);
%             for m = 1:Monkey.EMGnum
%                 filteredData(m,:) = filter(B,A,filteredData(m,:));
%             end
            [B,A] = butter(FilterSettings.BPF{2}, (FilterSettings.BPF{4} .* 2) ./ info.SampleRate, 'low');
            filteredData = filter(B,A,filteredData,[],2);
%             for m = 1:Monkey.EMGnum
%                 filteredData(m,:) = filter(B,A,filteredData(m,:));
%             end
         
         case 'HPF'
            disp('start HPF')
            [B,A] = butter(FilterSettings.HPF{2}, (FilterSettings.HPF{3} .* 2) ./ info.SampleRate, 'high');
            for m = 1:Monkey.EMGnum
                filteredData(m,:) = filter(B,A,filteredData(m,:));
            end
%             break;
            
         case 'LPF'
            disp('start LPF')
            [B,A] = butter(FilterSettings.LPF{2}, (FilterSettings.LPF{3} .* 2) ./ info.SampleRate, 'low');
            for m = 1:Monkey.EMGnum
                filteredData(m,:) = filter(B,A,filteredData(m,:));
            end
%             break;
            
         case 'minusAVE'
            disp('start minusAVE')
            for m = 1:Monkey.EMGnum
               filteredData(m,:) = filteredData(m,:) - mean(filteredData(m,:));
            end
%             break;
         
         case 'rectify'
            disp('start rectify')
            filteredData = abs(filteredData);
%             break;
         
         case 'smooth'
            disp('start smooth')
            kernel  = ones(1,FilterSettings.smooth_num)/FilterSettings.smooth_num;
%             kernel = 1/FilterSettings.smooth_num;
            for m = 1:Monkey.EMGnum
                filteredData(m,:) = conv2(filteredData(m,:),kernel,'same');
            end
%             break;
            
         case 'downsample'
            disp('start downsample')
            filteredData = (resample(filteredData',FilterSettings.downdata_to,info.SampleRate))';
            info.x_msec = info.x_msec(1):1000/FilterSettings.downdata_to:info.x_msec(end);
%             break;

          case 'normalize'
            disp('start normalize')
            for m=1:12
                filteredData(m,:) = filteredData(m,:)./mean(filteredData(m,:),2);
            end
            
      end
   end
   
end