clear all
%% plot crosscorrelation
Tar = 'EMG';
switch Tar
   case 'EMG'
      load('ResultXcorr_68.mat');
      load('ResultXcorr_68_Each_EMG_Range2.mat');      
   case 'Synergy'
      load('ResultXcorr_80_syn.mat');
      load('ResultXcorr_Each_syn_Range2.mat');
end
tEMG = 'FDP';
save_fig = 0;
plotFocus = 'on';
% figure;

switch Tar
   case 'EMG'
      c = jet(14);
%       AllDays = datetime([2019,01,23])+caldays(0:240); %PostALL
      days = 233;
      AllDays = datetime([2019,01,07])+caldays(0:days); % 1 month Pre
      dayX = {'2019/01/07','2019/01/08','2019/01/09','2019/01/15', '2019/01/16',...
               '2019/01/17','2019/01/18','2019/01/21','2019/03/05', '2019/03/06',...
               '2019/03/07','2019/03/11','2019/03/12','2019/03/13','2019/03/15',...
               '2019/03/18','2019/03/19','2019/03/20','2019/03/22','2019/03/25',...
               '2019/03/26','2019/03/27','2019/03/28','2019/03/29','2019/04/01',...
               '2019/04/02','2019/04/03','2019/04/04','2019/04/05','2019/04/08',...
               '2019/04/09','2019/04/10','2019/04/11','2019/04/12','2019/04/15',...
               '2019/04/17','2019/04/23','2019/04/24','2019/04/25','2019/04/26',...
               '2019/05/07','2019/05/08','2019/05/15','2019/05/17','2019/05/20',...
               '2019/05/22','2019/05/23','2019/05/28','2019/05/29','2019/05/30',...
               '2019/06/03','2019/06/05','2019/06/07','2019/06/10','2019/06/12',...
               '2019/06/14','2019/06/18','2019/06/20','2019/06/24','2019/07/10',...
               '2019/07/17','2019/07/19','2019/07/24','2019/07/31','2019/08/02',...
               '2019/08/14','2019/08/16','2019/08/28'};%68days
   case 'Synergy'
      c = lines(4);
%       c = jet(4);
      AllDays = datetime([2017,04,05])+caldays(0:177);
      dayX = {'2017/04/05','2017/04/10','2017/04/11','2017/04/14','2017/04/13',...
              '2017/04/19','2017/04/20','2017/04/21','2017/04/24','2017/04/25',...
              '2017/04/26','2017/05/01','2017/05/09','2017/05/11','2017/05/14',...
              '2017/05/15','2017/05/16','2017/05/17','2017/05/24','2017/05/26',...
              '2017/05/29','2017/06/06','2017/06/08','2017/06/12','2017/06/13',...
              '2017/06/14','2017/06/15','2017/06/16','2017/06/20','2017/06/21',...
              '2017/06/22','2017/06/23','2017/06/27','2017/06/28','2017/06/29',...
              '2017/06/30','2017/07/03','2017/07/04','2017/07/06','2017/07/07',...
              '2017/07/10','2017/07/11','2017/07/12','2017/07/13','2017/07/14',...
              '2017/07/18','2017/07/19','2017/07/20','2017/07/25','2017/07/26',...
              '2017/08/02','2017/08/03','2017/08/04','2017/08/07','2017/08/08',...
              '2017/08/09','2017/08/10','2017/08/15','2017/08/17','2017/08/18',...
              '2017/08/22','2017/08/23','2017/08/24','2017/08/25','2017/08/29',...
              '2017/08/30','2017/08/31','2017/09/01','2017/09/04','2017/09/05',...
              '2017/09/06','2017/09/07','2017/09/08','2017/09/11','2017/09/13',...
              '2017/09/14','2017/09/25','2017/09/26','2017/09/27','2017/09/29'};%80days
end
AVEPre4Days = {'2019/01/16','2019/01/17','2019/01/18','2019/01/21'};
TaskCompletedDay = {'2019/08/02'};
TTsurgD = datetime([2019,01,22]);                %date of tendon transfer surgery
TTtaskD = datetime([2019,03,05]);                %date monkey started task by himself after surgery & over 100 success trials (he started to work on June.28)
Xpost = zeros(size(AllDays));
Xpre4 = zeros(size(AllDays));
k=1;l=1;
for i=1:days +1
   if k>length(dayX)
   elseif AllDays(i)==dayX(k)
   Xpost(1,i) = i;
   k=k+1;
   end
   if l>length(AVEPre4Days)
   elseif AllDays(i)==AVEPre4Days(l)
   Xpre4(1,i) = i;
   l=l+1;
   end
   if AllDays(i)==TaskCompletedDay
      tcd = i;
   end
end
xdays = find(Xpost) - find(AllDays==TTsurgD);
xPre4days = find(Xpre4) - find(AllDays==TTsurgD);
TCD = tcd - find(AllDays==TTsurgD);
xnoT = 0:(find(AllDays==TTtaskD)-1- find(AllDays==TTsurgD));
Ptype = 'RAW';                                     %Plot Type : 'RAW' or 'MMean'( move mean )
np = 3;                                            %smooth num
kernel = ones(np,1)/np; 
delSyn = [0,0,0,0];%delete plots which synergy belongs to
delEMG = [1,1,1,1,1,1,1,1,1,0,0,0,1,1];
LEMGs = cell(1,14);
%EMG List {'FDP';'FDSprox';'FDS';'FCU';'PL';'FCR';'BRD';'ECR';'EDCprox';'EDC';'ED23';'ECU'}

%% plot Xcorr All

switch Tar
   case 'EMG'
      FDP_A = zeros(3,68);
      FDS_A = zeros(3,68);
      EDC_A = zeros(3,68);
%       ED23_A = zeros(4,68);
      f = figure('Position',[0 0 2000 1000]);
      for j=1:14
           eval(['plotD = cell2mat(Re.' EMGs{j,1} ');']);
           subplot(4,4,j);
      %      f = figure;
           hold on;
           % area for control data
           fi1 = fill([xPre4days xPre4days(end:-1:1)],[ones(size(xPre4days)) (-1).*ones(size(xPre4days))],'k');
           fi1.FaceColor = [0.78 0.78 0.78];       % make the filled area
           fi1.EdgeColor = 'none';            % remove the line around the filled area
% %            % area for disable term
% %            fi2 = fill([xnoT xnoT(end:-1:1)],[ones(size(xnoT)) (-1).*ones(size(xnoT))],'k');
% %            fi2.FaceColor = [0.5 0.5 0.6];       % make the filled area
% %            fi2.EdgeColor = 'none';            % remove the line around the filled area
           p = cell(14,1);
           hold off;
          for i = 1:14
      %         subplot(14,14,14*(j-1)+i);
              hold on;
              switch Ptype
                 case 'RAW'
                    p{i} = plot(xdays,plotD(:,i),'Color',c(i,:),'LineWidth',1.3);
                    
                 case 'MMean'

              end
              if (delEMG(i))
                  delete(p{i});
              end
          end
          if j==10
             FDP_A = plotD(:,[10 11 12]);
          elseif j==11
             EDC_A = plotD(:,[10 11 12]);
          elseif j==12
             ED23_A = plotD(:,[10 11 12]);
          end
%           plot([TCD TCD],[-1 1],'k--','LineWidth', 1.3);
          % area for disable term
          fi2 = fill([xnoT xnoT(end:-1:1)],[ones(size(xnoT)) (-1).*ones(size(xnoT))],'k','LineWidth',1.3);
          fi2.FaceColor = [1 1 1];       % make the filled area
%           fi2.EdgeColor = 'none';            % remove the line around the filled area
          hold off;
%            if(delSyn(1))
%               delete([p{2},p{3},p{4}]);
%            end
%            if(delSyn(2))
%               delete([p{1},p{7},p{8},p{9}]);
%            end
%            if(delSyn(3))
%               delete([p{10},p{11},p{12}]);
%            end
%            if(delSyn(4))
%               delete([p{5},p{6}]);
%            end
          ylim([-1 1]);
      %     xlim([0 68]);
          xlim([xPre4days(1) xdays(end)]);
      %     xlim([xdays(1) xdays(end)]);
      %     ylabel('Cross-correlation coefficient');
      %     xlabel('Post tendon transfer [days]');
          title(EMGs{j,1},'FontSize',25);
          if j==14
              L = legend({'Control','EDC','FDS','FDP','Task Disable'},'Location','southwest');
              set(L,...
                  'Position',[0.914849183342953 0.120910384068279 0.0556196623180075 0.0803628093101775],...
                  'FontSize',14);
              ylabel('Cross-correlation coefficient');
              xlabel('Post tendon transfer [days]');
          end
      %     legend1 = legend(EMGs{:,1});
      %     set(legend1,...
      %     'Position',[0.914849183342953 0.120910384068279 0.0776196623180075 0.803628093101775],...
      %     'FontSize',14);
          if save_fig == 1
             cd TaskAllXcorr_syn1-3
             saveas(gcf,[EMGs{j,1} '_Xcorr_TaskAll.epsc']);
             saveas(gcf,[EMGs{j,1} '_Xcorr_TaskAll.png']);
             saveas(gcf,[EMGs{j,1} '_Xcorr_TaskAll.fig']);
             cd ../
          end
      end
      
   case 'Synergy'
      TarN = 4;
      sp=1;                %for subplot
      order_s = [2 1 4 3];
      f = figure('Position',[0 0 2000 250]);
      syn1A = zeros(4,68);
      syn2A = zeros(4,68);
      syn3A = zeros(4,68);
      syn4A = zeros(4,68);
      for j=order_s%1:TarN
           eval(['plotD = cell2mat(Re.syn' sprintf('%d',j) ');']);
           subplot(1,4,sp);
           sp = sp +1;
      %      f = figure;
           hold on;
           % area for control data
           fi1 = fill([xPre4days xPre4days(end:-1:1)],[ones(size(xPre4days)) (-1).*ones(size(xPre4days))],'k');
           fi1.FaceColor = [0.78 0.78 0.78];       % make the filled area
           fi1.EdgeColor = 'none';            % remove the line around the filled area
% %            % area for disable term
% %            fi2 = fill([xnoT xnoT(end:-1:1)],[ones(size(xnoT)) (-1).*ones(size(xnoT))],'k');
% %            fi2.FaceColor = [0.5 0.5 0.6];       % make the filled area
% %            fi2.EdgeColor = 'none';            % remove the line around the filled area
           p = cell(TarN,1);
           hold off;
           spp = 1;
          for i = order_s%1:TarN
      %         subplot(TarN,TarN,TarN*(j-1)+i);
              hold on;
              switch Ptype
                 case 'RAW'
                    p{i} = plot(xdays,plotD(:,i),'Color',c(spp,:),'LineWidth',1.3);
                    if j==2
                       syn1A(spp,:) = plotD(:,i);
                    elseif j==1
                       syn2A(spp,:) = plotD(:,i);
                    elseif j==4
                       syn3A(spp,:) = plotD(:,i);
                    elseif j==3
                       syn4A(spp,:) = plotD(:,i);
                    end
                 case 'MMean'

              end
              spp = spp +1;
          end
          plot([TCD TCD],[-1 1],'k--','LineWidth', 1.3);
          % area for disable term
          fi2 = fill([xnoT xnoT(end:-1:1)],[ones(size(xnoT)) (-1).*ones(size(xnoT))],'k','LineWidth',1.3);
          fi2.FaceColor = [1 1 1];       % make the filled area
%           fi2.EdgeColor = 'none';            % remove the line around the filled area
          hold off;
           if(delSyn(1))
              delete(p{1});
           end
           if(delSyn(2))
              delete(p{2});
           end
           if(delSyn(3))
              delete(p{3});
           end
           if(delSyn(4))
              delete(p{4});
           end
          ylim([-1 1]);
      %     xlim([0 68]);
          xlim([xPre4days(1) xdays(end)]);
      %     xlim([xdays(1) xdays(end)]);
      %     ylabel('Cross-correlation coefficient');
      %     xlabel('Post tendon transfer [days]');
          title(['Synergy' sprintf('%d',order_s(j))],'FontSize',25);
          if j==TarN
              L = legend({'Control','Synergy1','Synergy2','Synergy3','Synergy4','Recovered','Task Disable'},'Location','southwest');
              set(L,...
                  'Position',[0.914849183342953 0.120910384068279 0.0556196623180075 0.0803628093101775],...
                  'FontSize',14);
              ylabel('Cross-correlation coefficient');
              xlabel('Post tendon transfer [days]');
          end
      %     legend1 = legend(EMGs{:,1});
      %     set(legend1,...
      %     'Position',[0.914849183342953 0.120910384068279 0.0776196623180075 0.803628093101775],...
      %     'FontSize',14);
          if save_fig == 1
             cd TaskAllXcorr_syn1-3
             saveas(gcf,[EMGs{j,1} '_Xcorr_TaskAll.epsc']);
             saveas(gcf,[EMGs{j,1} '_Xcorr_TaskAll.png']);
             saveas(gcf,[EMGs{j,1} '_Xcorr_TaskAll.fig']);
             cd ../
          end
      end
      
end
%% plot Xcorr Each

switch Tar
   case 'EMG'
      for t = 1:4 %trig loop 
%       f = figure('Position',[0 0 2000 1000]);
      k = 1;
      switch plotFocus
        case 'off'
           eval(['f' sprintf('%d',k) '= figure(''Position'',[0 0 2000 1000]);']);
           Jloop = 1:14;
        case 'on'
           if t==1
              fe = figure('Position',[0 0 2000 1000]);
           else
              figure(fe)
           end
           Jloop = [10 11 12];
      end
      for j=Jloop % EMG loop
           eval(['plotDe = ResE.T' sprintf('%d',t) ';']);
           switch plotFocus
              case 'off'
                 subplot(4,4,j);
              case 'on'
                 subplot(3,4,4*(k-1)+t);
                 k = k+1;
           end

      %      f = figure;
           hold on;
           % area for control data
           fi1 = fill([xPre4days xPre4days(end:-1:1)],[ones(size(xPre4days)) (-1).*ones(size(xPre4days))],'k');
           fi1.FaceColor = [0.78 0.78 0.78];       % make the filled area
           fi1.EdgeColor = 'none';            % remove the line around the filled area
% %            % area for disable term
% %            fi2 = fill([xnoT xnoT(end:-1:1)],[ones(size(xnoT)) (-1).*ones(size(xnoT))],'k');
% %            fi2.FaceColor = [0.5 0.5 0.6];       % make the filled area
% %            fi2.EdgeColor = 'none';            % remove the line around the filled area
           hold off;
           p = cell(14,1);
          for i = 1:14 %EMG control loop
             spp =1;
      %         subplot(14,14,14*(j-1)+i);
              hold on;
      %         p{i} = plot(xdays,plotDe{j}(i,:),'Color',c(i,:),'LineWidth',1.3);
              switch Ptype
                 case 'RAW'
                    p{i} = plot(xdays,plotDe{j}(i,:),'Color',c(i,:),'LineWidth',1.3);
                 case 'MMean'
      %               ps{i} = scatter(xdays,plotDe{j}(i,:));
                    p{i} = plot(xdays,conv2(plotDe{j}(i,:),kernel,'same'),'Color',c(i,:),'LineWidth',1.3);
              end
              if (delEMG(i))
                  delete(p{i});
              end
          end
          if t ==1
             if j==10
                FDP_A = plotDe{j}([10 11 12],:);
             elseif j==11
                EDC_A = plotDe{j}([10 11 12],:);
             elseif j==12
                ED23_A = plotDe{j}([10 11 12],:);
             end
          end
          spp = spp+1;
%           plot([TCD TCD],[-1 1],'k--','LineWidth', 1.3);
           % area for disable term
          fi2 = fill([xnoT xnoT(end:-1:1)],[ones(size(xnoT)) (-1).*ones(size(xnoT))],'k','LineWidth',1.3);
          fi2.FaceColor = [1 1 1];       % make the filled area
%           fi2.EdgeColor = 'none';            % remove the line around the filled area
          hold off;
           if(delSyn(1))
              delete([p{2},p{3},p{4}]);
           end
           if(delSyn(2))
              delete([p{1},p{7},p{8},p{9}]);
           end
           if(delSyn(3))
              delete([p{10},p{11},p{12}]);
           end
           if(delSyn(4))
              delete([p{5},p{6}]);
           end
          ylim([-1 1]);
          xlim([xPre4days(1) xdays(end)]);
      %     xlim([xdays(1) xdays(end)]);
      %     xlim([0 68]);
          title(EMGs{j,1},'FontSize',25);
          if j==14
              L = legend({'Control','EDC','FDS','FDP','Task Disable'},'Location','southwest');
      %         legend1 = legend(axes1,'show');
              set(L,...
                  'Position',[0.914849183342953 0.120910384068279 0.0556196623180075 0.0803628093101775],...
                  'FontSize',14);
              ylabel('Cross-correlation coefficient');
              xlabel('Post tendon transfer [days]');
          end
      %     legend1 = legend(EMGs{:,1});
      %     set(legend1,...
      %     'Position',[0.914849183342953 0.120910384068279 0.0776196623180075 0.803628093101775],...
      %     'FontSize',14);
          if save_fig == 1
             cd TaskAllXcorr_syn1-3
             saveas(gcf,[EMGs{j,1} '_Xcorr_TaskAll.epsc']);
             saveas(gcf,[EMGs{j,1} '_Xcorr_TaskAll.png']);
             saveas(gcf,[EMGs{j,1} '_Xcorr_TaskAll.fig']);
             cd ../
          end
      end
      end
      
   case 'Synergy'
      TarN =4;
      for t = 1:TarN %trig loop 
%       f = figure('Position',[0 0 2000 1000]);
      k = 1;
      switch plotFocus
        case 'off'
           eval(['f' sprintf('%d',k) '= figure(''Position'',[0 0 2000 1000]);']);
           Jloop = 1:TarN;
        case 'on'
           if t==1
              fe = figure('Position',[0 0 2000 1000]);
           else
              figure(fe)
           end
           Jloop = [2 1 4 3];
      end
      for j=Jloop % EMG loop
           eval(['plotDe = ResE.T' sprintf('%d',t) ';']);
           switch plotFocus
              case 'off'
                 subplot(1,4,j);
              case 'on'
                 subplot(TarN,4,4*(k-1)+t);
                 k = k+1;
           end

      %      f = figure;
           hold on;
           % area for control data
           fi1 = fill([xPre4days xPre4days(end:-1:1)],[ones(size(xPre4days)) (-1).*ones(size(xPre4days))],'k');
           fi1.FaceColor = [0.78 0.78 0.78];       % make the filled area
           fi1.EdgeColor = 'none';            % remove the line around the filled area
% %            % area for disable term
% %            fi2 = fill([xnoT xnoT(end:-1:1)],[ones(size(xnoT)) (-1).*ones(size(xnoT))],'k');
% %            fi2.FaceColor = [0.5 0.5 0.6];       % make the filled area
% %            fi2.EdgeColor = 'none';            % remove the line around the filled area
           hold off;
           p = cell(TarN,1);
           spp = 1;
          for i = [2 1 4 3]%1:TarN %EMG control loop
      %         subplot(14,14,14*(j-1)+i);
              hold on;
      %         p{i} = plot(xdays,plotDe{j}(i,:),'Color',c(i,:),'LineWidth',1.3);
              switch Ptype
                 case 'RAW'
                    p{i} = plot(xdays,plotDe{j}(i,:),'Color',c(spp,:),'LineWidth',1.3);
                    if t == 1
                       if j==2
                          syn1A(spp,:) = plotDe{j}(i,:);
                       elseif j==1
                          syn2A(spp,:) = plotDe{j}(i,:);
                       elseif j==4
                          syn3A(spp,:) = plotDe{j}(i,:);
                       elseif j==3
                          syn4A(spp,:) = plotDe{j}(i,:);
                       end
                    end
                 case 'MMean'
      %               ps{i} = scatter(xdays,plotDe{j}(i,:));
                    p{i} = plot(xdays,conv2(plotDe{j}(i,:),kernel,'same'),'Color',c(spp,:),'LineWidth',1.3);
              end
              spp = spp+1;
          end
%           plot([TCD TCD],[-1 1],'k--','LineWidth', 1.3);
           % area for disable term
          fi2 = fill([xnoT xnoT(end:-1:1)],[ones(size(xnoT)) (-1).*ones(size(xnoT))],'k','LineWidth',1.3);
          fi2.FaceColor = [1 1 1];       % make the filled area
%           fi2.EdgeColor = 'none';            % remove the line around the filled area

          hold off;
          if(delSyn(1))
             delete(p{1});
          end
          if(delSyn(2))
             delete(p{2});
          end
          if(delSyn(3))
             delete(p{3});
          end
          if(delSyn(4))
             delete(p{4});
          end
          ylim([-1 1]);
          xlim([xPre4days(1) xdays(end)]);
      %     xlim([xdays(1) xdays(end)]);
      %     xlim([0 68]);
          title('hold_','FontSize',25);
          if j==TarN
              L = legend({'Control','Synergy1','Synergy2','Synergy3','Synergy4','Recovered','Task Disable'},'Location','southwest');
      %         legend1 = legend(axes1,'show');
              set(L,...
                  'Position',[0.914849183342953 0.140910384068279 0.0556196623180075 0.0803628093101775],...
                  'FontSize',14);
              ylabel('Cross-correlation coefficient');
              xlabel('Post tendon transfer [days]');
          end
      end
      end
end
% function createlegend(axes1)
% %CREATELEGEND(axes1)
% %  AXES1:  legend axes
% 
% %  MATLAB ????????????????: 20-Jun-2019 14:49:20
% 
% % legend ??????
% legend1 = legend(axes1,'show');
% set(legend1,...
%     'Position',[0.914849183342953 0.140910384068279 0.0776196623180075 0.803628093101775],...
%     'FontSize',14);
% end