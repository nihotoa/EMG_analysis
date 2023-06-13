function [AveAll]=testplot()
% triger
%    TRIG = 'leverOn';
%    TRIG = 'leverOff';
%    TRIG = 'photoOn';
%    TRIG = 'photoOff';
   TRIG_ALL = {'leverOn', 'leverOff', 'photoOn', 'photoOff'};
   task = 'standard';
   % set plot range
   plot_switch = 1;
   save_AveData = 0;
   PlotRange = 2300000:2400000;
%    x = 0:1/5000:PlotRange(end)/5000;
   % set monkey information
   global Monkey
%    %%%%%%%%%%%%%%%%%%%%%%%%%Yachimun%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Monkey.realname = 'Yachimun';
%    Monkey.name = 'Ya';
%    Monkey.EMGs = {'FDP','FDSprox','FDSdist','FCU','PL','FCR','BRD','ECR','EDCprox','EDCdist','ED45','ECU'};
%    %%%%%%%%%%%%%%%%%%%%%%%%%Suruku%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Monkey.realname = 'Suruku';
%    Monkey.name = 'Su';
%    Monkey.EMGs = {'FDS','FDP','FCR','FCU','PL','BRD','EDC','ED23','ED45','ECU','ECR','Deltoid'};
%    YLIM = [100 20 5 100 20 30 100 80 30 30 30 100];
%    %%%%%%%%%%%%%%%%%%%%%%%Seseki(RightArm)%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Monkey.realname = 'SesekiR';
%    Monkey.name = 'Se';
%    Monkey.EMGs = {'EDC','ED23','ED45','ECU','ECR','Deltoid','FDS','FDP','FCR','FCU','PL','BRD'};
%    YLIM = [40 80 40 40 100 30 100 100 40 30 30 200];
%    Monkey.EMGnum = length(Monkey.EMGs);
   %%%%%%%%%%%%%%%%%%%%%%%Seseki(LefttArm)%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   Monkey.realname = 'SesekiL';
   Monkey.name = 'Se';
   Monkey.EMGs = {'EDC','ED23','ED45','ECU','ECR','Deltoid','FDS','FDP','FCR','FCU','PL','BRD'};
   YLIM = [100 100 100 200 60 60 100 100 100 100 20 100];
   Monkey.EMGnum = length(Monkey.EMGs);
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
   FilterSettings.order = {'BPF','minusAVE','rectify','LPF','smooth','downsample'};
%    FilterSettings.order = {'BPF','minusAVE','rectify','LPF','smooth','downsample','normalize'};
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
   AllSessions = strrep(TarSessions,['_' task '.mat'],'');
%    if exist('arm')
%        AllSessions = strrep(AllSessions,arm,'');
%    end
   %% start main process
   AveAll = cell(12, session_num);
   alignedALL = cell(12, session_num);
for trigname = TRIG_ALL
    TRIG = cell2mat(trigname);
   for session = 1:session_num
      cd easyData
      cd([AllSessions{session} '_' task])
      if exist('arm')
          load([cell2mat(strrep(AllSessions,arm,'')) '_EasyData.mat'],'Tp')
      else
         switch Monkey.name 
            case {'Su','Se'}
               load([AllSessions{session} '_EasyData.mat'],'Tp','TTLd','TTLu')
            otherwise
               load([AllSessions{session} '_EasyData.mat'],'Tp')
         end
      end
      cd(ParentDir)
      cd([AllSessions{session} '_' task])
      
      %% load EMG data from nmf direcrory %%%%%%%%%%%%%%%%%%%%%%%%
      [Data,info]=loadEMG(Monkey);
      info.x_msec = PlotRange(1)*1000/info.SampleRate:1000/info.SampleRate:PlotRange(end)*1000/info.SampleRate;
      info.x_msec = info.x_msec - info.x_msec(1);
      
      %% callculate power spectrum %%%%%%%%%%%%%%%%%%%%%%%%
%       [f,power] = powerSpec(Data,info);
%       f_spec = figure;
%       for sub = 1:Monkey.EMGnum
%          subplot(3,4,sub)
%          plot(f,power(sub,:))
%          xlabel('Frequency')
%          ylabel('Power')
%       end
%    
%       f_raw = figure;
%       for m = 1:Monkey.EMGnum
%          subplot(Monkey.EMGnum/2,2,m);
%          plot(info.x_msec,Data(m,PlotRange))
% %          ylim([-400 400]);
%          title(Monkey.EMGs{m})
%       end
%       
      %% filter EMG data  %%%%%%%%%%%%%%%%%%%%%%%%
      [filteredData,info] = filtEMG(Monkey,Data,info,FilterSettings,[]);
%       
%       f_filtered = figure;
%       for m = 1:Monkey.EMGnum
%          subplot(Monkey.EMGnum/2,2,m);
% %          plot(filteredData(m,:))
%          plot(info.x_msec,filteredData(m,PlotRange(1)/50:PlotRange(end)/50))
%          ylim([0 15]);
%          title(Monkey.EMGs{m})
%       end
      
      %% callculate power spectrum %%%%%%%%%%%%%%%%%%%%%%%%
%       [f,power] = powerSpec(filteredData,info);
%       f_spec2 = figure;
%       for sub = 1:Monkey.EMGnum
%          subplot(3,4,sub)
%          plot(f,power(sub,:))
%          xlabel('Frequency')
%          ylabel('Power')
%       end
      
       %% trigger plot  %%%%%%%%%%%%%%%%%%%%%%%%
       f_triggered = figure('Position',[200 1000 800 1200]);
      cd(ParentDir)
      cd([AllSessions{session} '_' task])

   switch TRIG 
      case 'leverOn'
         Event = Tp;
         trig = 2;
      case 'leverOff'
         Event = Tp;
         trig = 3;
      case 'photoOn'
         Event = TTLd';
         trig = 1;
      case 'photoOff'
         Event = TTLu';
         trig = 1;
   end
   
      if 15==(sum(AllSessions{session}=='Se200111') + sum(Monkey.realname == 'SesekiL'))%session == 1111 %%SesekiL 20200111 (peanuts, potato)
          EventL = length(Event(1:100));
          for m = 1:Monkey.EMGnum
    %          f = figure;
             subplot(Monkey.EMGnum/2,2,m);
             hold on;
             alinedDatafortest=cell(EventL,1);
             for t = 1:87
                 alinedDatafortest{t} = filteredData(m,round((Event(100+t,trig)-5000)/50):round((Event(100+t,trig)+5000)/50));
                 plot(alinedDatafortest{t},'k')
             end
             AveAll{m,session} = mean(cell2mat(alinedDatafortest));
             plot(AveAll{m,session},'r','LineWidth',1.3)
             plot([101 101],[0 400],'y');
             hold off;
%              ylim([0 100])
             ylim([0 6])
             xlim([0 200])
             title(Monkey.EMGs{m})
             title([AllSessions{session} '  ' Monkey.EMGs{m}])
    %          SaveFig(f,[AllSessions{session} '_' Monkey.EMGs{m}])
          end
      else
          EventL = length(Event);
          for m = 1:Monkey.EMGnum
    %          f = figure;
             subplot(Monkey.EMGnum/2,2,m);
             hold on;
             alinedDatafortest=cell(EventL,1);
             for t = 1:EventL-1
                 alinedDatafortest{t} = filteredData(m,round((Event(t,trig)-5000)/50):round((Event(t,trig)+5000)/50));
                 plot(alinedDatafortest{t},'k')
             end
             AveAll{m,session} = mean(cell2mat(alinedDatafortest));
             alignedALL{m,session} = cell2mat(alinedDatafortest);
             plot(AveAll{m,session},'r','LineWidth',1.3)
             plot([101 101],[0 400],'y');
             hold off;
             ylim([0 100])
%              ylim([0 6])
             xlim([0 200])
             title(Monkey.EMGs{m})
             title([AllSessions{session} '  ' Monkey.EMGs{m}])
    %          SaveFig(f,[AllSessions{session} '_' Monkey.EMGs{m}])
          end
      end
%       SaveFig(f_triggered,[AllSessions{session} '_' task '_' TRIG])
      close
      cd(ParentDir)
      cd ../
 if save_AveData == 1
    save([Monkey.realname '_' task '_' sprintf('%d',session_num) '_' TRIG '_AveAll.mat'], 'AveAll');
 end
   end
   if plot_switch == 1
         fi = figure('Position',[200 1000 800 1200]);
         c = jet(session_num);
      %    c_a = jet(session_num+1);
      %    c = c_a(2:end, :);
         for m = 1:Monkey.EMGnum
      %          f = figure;
               subplot(Monkey.EMGnum/2,2,m);
               hold on;
            for session = 1:session_num
      %          if session == 1 || session == 2 || session == 3
      % %              plot(AveAll{m,session},'Color',[0.7 0.7 0.7],'LineWidth',1.3)
      %              plot(AveAll{m,session},'Color',c(session,:),'LineWidth',1.3)
      %          else
                   plot(AveAll{m,session},'Color',c(session,:),'LineWidth',1.3)
      %          end
               hold on;
      %          AveAll{m,session} = mean(cell2mat(alinedDatafortest));
               plot([101 101],[0 400],'k');
            end
               hold off;
      %          ylim([0 100])
               ylim([0 YLIM(m)])
      %          ylim([0 6])
               xlim([0 200])
               title(Monkey.EMGs{m})
         end
%          SaveFig(fi,[Monkey.realname '_all_' task '_' TRIG])

      % control plot 
      control_plot = 1;
      if control_plot == 1 && session_num == 3
         fcon = figure('Position',[200 1000 800 1200]);
            for m = 1:Monkey.EMGnum      
               subplot(Monkey.EMGnum/2,2,m);
               AVE4sd = [alignedALL{m,1}; alignedALL{m,2}; alignedALL{m,3};];
               astd = std(AVE4sd);
      %          fill([0:1:200 200:-1:0], [astd -astd(end:-1:1)],'Color',[0.7 0.7 0.7])
      %          plot(mean(AVE4sd),'LineWidth',1.3) 
               for session = 1:3
                  plot(AveAll{m,session},'Color',[0.7 0.7 0.7],'LineWidth',1.3)
                  hold on
               end
               plot([101 101],[0 400],'k');
               hold off;
      %          ylim([0 100])
               ylim([0 YLIM(m)])
      %          ylim([0 6])
               xlim([0 200])
               title(Monkey.EMGs{m})
            end
            if save_AveData == 1
               save([Monkey.realname '_control' sprintf('%d',session_num) '_' TRIG '_AveAll.mat'], 'AveAll');
            end
%             SaveFig(fcon,[Monkey.realname '_control_' task '_' TRIG])
      end

      close all
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
function SaveFig(fig, filename)
%
% SaveFig(fig, filename)
%
% ????fig???w????????figure??filename?????O??png,pdf?t?@?C?????????????B
% filename???g???q???????????B
%
% ???FSaveFig(figure(1),'example')

% ?I???????????`?????????????????I????????
drawnow;

% ?????T?C?Y?????????B
temp.figunit = fig.Units;
fig.Units = 'centimeters';
pos = fig.Position;
fig.PaperPositionMode = 'Auto';
temp.figpaperunit = fig.PaperUnits;
fig.PaperUnits = 'centimeters';
temp.figsize = fig.PaperSize;
fig.PaperSize = [pos(3), pos(4)];

% ?????????B
print(fig,'-painters',filename,'-dpdf','-bestfit')
print(fig,filename,'-depsc')
print(fig,filename,'-dpng','-r300')

% ???????????????B
fig.PaperSize = temp.figsize;
fig.Units = temp.figunit;
fig.PaperUnits = temp.figpaperunit;

end
function [Result] = calXcorr(control, post, days,trig)
controlAVE = mean(control,2);
S = size(T.data);
Result = cell(TarN,1); 
R = zeros(TarN,S(2));

for M = 1:TarN
   for d = 1:S(2)
      for m = 1:TarN
         AltE = corrcoef(controlAVE,post{m});
         R(m,d) = AltE(1,2);
      end   
   end
   Result{M} = R;
end
end