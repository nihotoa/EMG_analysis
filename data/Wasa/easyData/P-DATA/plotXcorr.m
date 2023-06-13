clear all
%% plot crosscorrelation
Tar = 'EMG';
switch Tar
   case 'EMG'
      load('ResultXcorr_86_EMG.mat');
      load('ResultXcorr_each_86_EMG.mat');      
   case 'Synergy'
      load('ResultXcorr_86_syn.mat');
      load('ResultXcorr_Each_syn_Range2.mat');
end
save_fig = 0;
plotFocus = 'on';
% figure;

switch Tar
   case 'EMG'
      c = jet(14);
      AllDays = datetime([2018,11,08])+caldays(0:295);
      
      dayX = {'2018/11/08','2018/11/09','2018/11/12','2018/11/14','2018/11/15',...
              '2018/11/21','2018/11/22','2018/11/26','2018/11/27','2018/11/30',...
              '2018/12/03','2018/12/07','2018/12/12','2018/12/20','2018/12/21',...
              '2018/12/26','2018/12/27','2018/12/28','2019/01/07','2019/01/08',...
              '2019/01/09','2019/01/15','2019/01/16','2019/01/17','2019/01/18',...
              '2019/01/21','2019/03/05','2019/03/06','2019/03/07','2019/03/11',...
              '2019/03/12','2019/03/13','2019/03/15','2019/03/18','2019/03/19',...
              '2019/03/20','2019/03/22','2019/03/25','2019/03/26','2019/03/27',...
              '2019/03/28','2019/03/29','2019/04/01','2019/04/02','2019/04/03',...
              '2019/04/04','2019/04/05','2019/04/08','2019/04/09','2019/04/10',...
              '2019/04/11','2019/04/12','2019/04/15','2019/04/17','2019/04/23',...
              '2019/04/24','2019/04/25','2019/04/26','2019/05/07','2019/05/08',...
              '2019/05/15','2019/05/17','2019/05/20','2019/05/22','2019/05/23',...
              '2019/05/28','2019/05/29','2019/05/30','2019/06/03','2019/06/05',...
              '2019/06/07','2019/06/10','2019/06/12','2019/06/14','2019/06/18',...
              '2019/06/20','2019/06/24','2019/07/10','2019/07/17','2019/07/19',...
              '2019/07/24','2019/07/31','2019/08/02','2019/08/14','2019/08/16',...
              '2019/08/28'};%86days
   case 'Synergy'
      c = lines(4);
%       c = jet(4);
      AllDays = datetime([2018,11,08])+caldays(0:295);
      dayX = {'2018/11/08','2018/11/09','2018/11/12','2018/11/14','2018/11/15',...
              '2018/11/21','2018/11/22','2018/11/26','2018/11/27','2018/11/30',...
              '2018/12/03','2018/12/07','2018/12/12','2018/12/20','2018/12/21',...
              '2018/12/26','2018/12/27','2018/12/28','2019/01/07','2019/01/08',...
              '2019/01/09','2019/01/15','2019/01/16','2019/01/17','2019/01/18',...
              '2019/01/21','2019/03/05','2019/03/06','2019/03/07','2019/03/11',...
              '2019/03/12','2019/03/13','2019/03/15','2019/03/18','2019/03/19',...
              '2019/03/20','2019/03/22','2019/03/25','2019/03/26','2019/03/27',...
              '2019/03/28','2019/03/29','2019/04/01','2019/04/02','2019/04/03',...
              '2019/04/04','2019/04/05','2019/04/08','2019/04/09','2019/04/10',...
              '2019/04/11','2019/04/12','2019/04/15','2019/04/17','2019/04/23',...
              '2019/04/24','2019/04/25','2019/04/26','2019/05/07','2019/05/08',...
              '2019/05/15','2019/05/17','2019/05/20','2019/05/22','2019/05/23',...
              '2019/05/28','2019/05/29','2019/05/30','2019/06/03','2019/06/05',...
              '2019/06/07','2019/06/10','2019/06/12','2019/06/14','2019/06/18',...
              '2019/06/20','2019/06/24','2019/07/10','2019/07/17','2019/07/19',...
              '2019/07/24','2019/07/31','2019/08/02','2019/08/14','2019/08/16',...
              '2019/08/28'};%86days
end

AVEPre4Days = {'2018/12/07','2018/12/12','2018/12/20','2018/12/21'};
TaskCompletedDay = {'2019/03/15'};
TTsurgD = datetime([2019,01,22]);                %date of tendon transfer surgery
TTtaskD = datetime([2019,03,05]);                %date monkey started task by himself after surgery & over 100 success trials (he started to work on June.28)
Xpost = zeros(size(AllDays));
Xpre4 = zeros(size(AllDays));
k=1;l=1;
for i=1:295
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
EMGselect = [6 10 11 12];
delSyn = [0,0,0,0];%delete plots which synergy belongs to
delEMG = [1,1,1,1,1,0,1,1,1,0,0,0,1,1];
LEMGs = cell(1,14);

%% plot Xcorr All

switch Tar
   case 'EMG'
      EMG1 = zeros(4,86);
      EMG2 = zeros(4,86);
      EMG3 = zeros(4,86);
      EMG4 = zeros(4,86);
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
          if j==EMGselect(1)
             EMG1 = plotD(:,EMGselect);
          elseif j==EMGselect(2)
             EMG2 = plotD(:,EMGselect);
          elseif j==EMGselect(3)
             EMG3 = plotD(:,EMGselect);
          elseif j==EMGselect(4)
             EMG4 = plotD(:,EMGselect);
          end
          plot([TCD TCD],[-1 1],'k--','LineWidth', 1.3);
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
      %     xlim([0 81]);
          xlim([xPre4days(1) xdays(end)]);
      %     xlim([xdays(1) xdays(end)]);
      %     ylabel('Cross-correlation coefficient');
      %     xlabel('Post tendon transfer [days]');
          title(EMGs{j,1},'FontSize',25);
          if j==14
              L = legend({'Control','ED23','EDC','FDS','FDP'},'Location','southwest');
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
      syn1A = zeros(4,86);
      syn2A = zeros(4,86);
      syn3A = zeros(4,86);
      syn4A = zeros(4,86);
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
      %     xlim([0 81]);
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
           Jloop = EMGselect;
      end
      for j=Jloop % EMG loop
           eval(['plotDe = ResE.T' sprintf('%d',t) ';']);
           switch plotFocus
              case 'off'
                 subplot(3,4,j);
              case 'on'
                 subplot(4,4,4*(k-1)+t);
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
          if t ==1    %%%%%%%%%%%%%%%%%%%% trigger %%%%%%%%%%%%%%%%%
             if j==EMGselect(1)
                EMG1 = plotDe{j}(EMGselect,:);
             elseif j==EMGselect(2)
                EMG2 = plotDe{j}(EMGselect,:);
             elseif j==EMGselect(3)
                EMG3 = plotDe{j}(EMGselect,:);
             elseif j==EMGselect(4)
                EMG4 = plotDe{j}(EMGselect,:);
             end
          end
          spp = spp+1;
          plot([TCD TCD],[-1 1],'k--','LineWidth', 1.3);
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
      %     xlim([0 81]);
%           title(EMGs{j,1},'FontSize',25);
          title(['trig' sprintf('%d',t) ' ' EMGs{j,1}],'FontSize',20);
          aa = gca;
          aa.FontSize = 14;
          aa.FontWeight = 'bold';
          aa.FontName = 'Arial';
          if j==Jloop(end)
              L = legend({'Control','ED23','EDC','FDS','FDP'},'Location','southwest');
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
              figure(fe);
           end
%            Jloop = [2 1 4 3];
           Jloop = [1 2 3 4];
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
          for i = Jloop%1:TarN %EMG control loop
      %         subplot(14,14,14*(j-1)+i);
              hold on;
      %         p{i} = plot(xdays,plotDe{j}(i,:),'Color',c(i,:),'LineWidth',1.3);
              switch Ptype
                 case 'RAW'
                    p{i} = plot(xdays,plotDe{j}(i,:),'Color',c(spp,:),'LineWidth',1.3);
                    if t == 1
                       if j==Jloop(1)
                          syn1A(spp,:) = plotDe{j}(i,:);
                       elseif j==Jloop(2)
                          syn2A(spp,:) = plotDe{j}(i,:);
                       elseif j==Jloop(3)
                          syn3A(spp,:) = plotDe{j}(i,:);
                       elseif j==Jloop(4)
                          syn4A(spp,:) = plotDe{j}(i,:);
                       end
                    end
                 case 'MMean'
      %               ps{i} = scatter(xdays,plotDe{j}(i,:));
                    p{i} = plot(xdays,conv2(plotDe{j}(i,:),kernel,'same'),'Color',c(spp,:),'LineWidth',1.3);
              end
              spp = spp+1;
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
          xlim([xPre4days(1) xdays(end)]);
      %     xlim([xdays(1) xdays(end)]);
      %     xlim([0 81]);
%           title('hold_','FontSize',25);
          title(['trig' sprintf('%d',t) ' Synergy' sprintf('%d',j)] ,'FontSize',20);
          aa = gca;
          aa.FontSize = 14;
          aa.FontWeight = 'bold';
          aa.FontName = 'Arial';
          if j==TarN
              L = legend({'Control','Synergy1','Synergy2','Synergy3','Synergy4','Recovered','Task Disable'},'Location','southwest');
      %         legend1 = legend(axes1,'show');
              set(L,...
                  'Position',[0.914849183342953 0.120910384068279 0.0556196623180075 0.0803628093101775],...
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
% %  MATLAB ????????????????: 20-Jun-2019 12:49:20
% 
% % legend ??????
% legend1 = legend(axes1,'show');
% set(legend1,...
%     'Position',[0.914849183342953 0.120910384068279 0.0776196623180075 0.803628093101775],...
%     'FontSize',14);
% end