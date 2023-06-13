clear all
%% plot crosscorrelation
realname = 'Matatabi';
Tar = 'EMG';
switch Tar
   case 'EMG'
      load('ResultXcorr_57.mat');
      load('ResultXcorr_Each_EMG.mat');      
   case 'Synergy'
      load('ResultXcorr_28_syn.mat');
      load('ResultXcorr_Each_syn_Range1.mat');
end
tEMG = 'FCU';
save_fig = 0;
plotFocus = 'on';
% figure;

switch Tar
   case 'EMG'
       switch realname 
           case 'Yachimun'
              c = jet(12);
              Nd = 178;
              AllDays = datetime([2017,04,05])+caldays(0:Nd-1);
              dayX = {'2017/04/05','2017/04/10','2017/04/11','2017/04/12','2017/04/13',...
                      '2017/04/19','2017/04/20','2017/04/21','2017/04/24','2017/04/25',...
                      '2017/04/26','2017/05/01','2017/05/09','2017/05/11','2017/05/12',...
                      '2017/05/15','2017/05/16','2017/05/17','2017/05/24','2017/05/26',...
                      '2017/05/29','2017/06/06','2017/06/08','2017/06/12','2017/06/13',...
                      '2017/06/14','2017/06/15','2017/06/16',...'2017/06/19',
                      '2017/06/20',...
                      '2017/06/21','2017/06/22','2017/06/23','2017/06/27','2017/06/28',...
                      '2017/06/29','2017/06/30','2017/07/03','2017/07/04','2017/07/06',...
                      '2017/07/07','2017/07/10','2017/07/11','2017/07/12','2017/07/13',...
                      '2017/07/14','2017/07/18','2017/07/19','2017/07/20','2017/07/25',...
                      '2017/07/26','2017/08/02','2017/08/03','2017/08/04','2017/08/07',...
                      '2017/08/08','2017/08/09','2017/08/10','2017/08/15','2017/08/17',...
                      '2017/08/18','2017/08/22','2017/08/23','2017/08/24','2017/08/25',...
                      '2017/08/29','2017/08/30','2017/08/31','2017/09/01','2017/09/04',...
                      '2017/09/05','2017/09/06','2017/09/07','2017/09/08','2017/09/11',...
                      '2017/09/13','2017/09/14','2017/09/25','2017/09/26','2017/09/27','2017/09/29'};%81days
           case 'SesekiL'
              c = jet(12);
              Nd = 74;
              AllDays = datetime([2020,01,17])+caldays(0:Nd-1);
               dayX = {'2020/1/17', '2020/1/19', '2020/1/20',...
                       '2020/2/10', '2020/2/12', '2020/2/13', '2020/2/14', '2020/2/17',...
                       '2020/2/18', '2020/2/19', '2020/2/20', '2020/2/21', '2020/02/26',...
                       '2020/3/3', '2020/3/4', '2020/3/5', '2020/3/6', ...
                       '2020/3/9', '2020/3/10', '2020/3/16', '2020/3/17', ...
                       '2020/3/18', '2020/3/19', '2020/3/23', '2020/3/24', '2020/3/25',...
                       '2020/3/26', '2020/3/30'};
               AVEPre4Days = {'2020/01/17', '2020/01/19', '2020/01/20'};
               TaskCompletedDay = {'2020/02/10'};
               TTsurgD = datetime([2020,01,21]);                %date of tendon transfer surgery
               TTtaskD = datetime([2020,02,10]);                %date monkey started task by himself after surgery 
            case 'Matatabi'
              EMGn = 8;
              c = jet(EMGn);
              Nd = 200;
              AllDays = datetime([2017,03,27])+caldays(0:Nd-1);
               dayX = {'2017/03/27','2017/03/28','2017/03/29',...
                       '2017/06/12','2017/06/14','2017/06/21','2017/06/22','2017/06/23',...
                       '2017/06/27','2017/06/28','2017/06/29','2017/06/30','2017/07/03',...
                       '2017/07/04','2017/07/05','2017/07/06','2017/07/07','2017/07/10',...
                       '2017/07/11','2017/07/12','2017/07/14','2017/07/18',...
                       '2017/07/19','2017/07/20','2017/07/25','2017/07/26','2017/08/01',...
                       '2017/08/03','2017/08/04','2017/08/07','2017/08/08','2017/08/09',...
                       '2017/08/10','2017/08/15','2017/08/16','2017/08/17','2017/08/18',...
                       '2017/08/22','2017/08/23','2017/08/29','2017/08/31',...
                       '2017/09/01','2017/09/04','2017/09/05','2017/09/06','2017/09/08',...
                       '2017/09/11','2017/09/13','2017/09/14','2017/09/26','2017/09/27',...
                       '2017/09/29','2017/10/03','2017/10/04','2017/10/05',...
                       '2017/10/11','2017/10/12'};
               AVEPre4Days = {'2017/03/27','2017/03/28','2017/03/29'};
               TaskCompletedDay = {'2017/06/12'};
               TTsurgD = datetime([2017,04,18]);                %date of tendon transfer surgery
               TTtaskD = datetime([2017,06,12]);                %date monkey started task by himself after surgery 
       end
       
   case 'Synergy'
       switch realname
           case 'Yachimun'
               c = lines(4);
               Nd = 178;
    %       c = jet(4);
               AllDays = datetime([2017,04,05])+caldays(0:Nd-1);
               dayX = {'2017/04/05','2017/04/10','2017/04/11','2017/04/12','2017/04/13',...
                       '2017/04/19','2017/04/20','2017/04/21','2017/04/24','2017/04/25',...
                       '2017/04/26','2017/05/01','2017/05/09','2017/05/11','2017/05/12',...
                       '2017/05/15','2017/05/16','2017/05/17','2017/05/24','2017/05/26',...
                       '2017/05/29','2017/06/06','2017/06/08','2017/06/12','2017/06/13',...
                       '2017/06/14','2017/06/15','2017/06/16','2017/06/20',...
                       '2017/06/21','2017/06/22','2017/06/23','2017/06/27','2017/06/28',...
                       '2017/06/29','2017/06/30','2017/07/03','2017/07/04','2017/07/06',...
                       '2017/07/07','2017/07/10','2017/07/11','2017/07/12','2017/07/13',...
                       '2017/07/14','2017/07/18','2017/07/19','2017/07/20','2017/07/25',...
                       '2017/07/26','2017/08/02','2017/08/03','2017/08/04','2017/08/07',...
                       '2017/08/08','2017/08/09','2017/08/10','2017/08/15','2017/08/17',...
                       '2017/08/18','2017/08/22','2017/08/23','2017/08/24','2017/08/25',...
                       '2017/08/29','2017/08/30','2017/08/31','2017/09/01','2017/09/04',...
                       '2017/09/05','2017/09/06','2017/09/07','2017/09/08','2017/09/11',...
                       '2017/09/13','2017/09/14','2017/09/25','2017/09/26','2017/09/27','2017/09/29'};%80days
               AVEPre4Days = {'2017/05/16','2017/05/17','2017/05/24','2017/05/26'};
               TaskCompletedDay = {'2017/08/07'};
               TTsurgD = datetime([2017,05,30]);                %date of tendon transfer surgery
               TTtaskD = datetime([2017,06,28]);                %date monkey started task by himself after surgery & over 100 success trials (he started to work on June.28)
           case 'SesekiL'
               c = jet(12);
               Nd = 74;
               AllDays = datetime([2020,01,17])+caldays(0:Nd-1);
               dayX = {'2020/01/17', '2020/01/19', '2020/01/20',...
                       '2020/02/10', '2020/02/12', '2020/02/13', '2020/02/14', '2020/02/17',...
                       '2020/02/18', '2020/02/19', '2020/02/20', '2020/02/21', '2020/02/26', ...
                       '2020/03/03', '2020/03/04', '2020/03/05', '2020/03/06', ...
                       '2020/03/09', '2020/03/10', '2020/03/16', '2020/03/17', ...
                       '2020/03/18', '2020/03/19', '2020/03/23', '2020/03/24', '2020/03/25',...
                       '2020/03/26', '2020/03/30'};
               AVEPre4Days = {'2020/01/17', '2020/01/19', '2020/01/20'};
               TaskCompletedDay = {'2020/02/10'};
               TTsurgD = datetime([2020,01,21]);                %date of tendon transfer surgery
               TTtaskD = datetime([2020,02,10]);                %date monkey started task by himself after surgery
       end
end

Xpost = zeros(size(AllDays));
Xpre4 = zeros(size(AllDays));
k=1;l=1;
for i=1:Nd
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
delEMG = [1,1,0,1,0,0,0,1];
LEMGs = cell(1,EMGn);
plotD_list = [1 3 5 6];
%Yachimun
%EMG List {'FDP';'FDSprox';'FDSdist';'FCU';'PL';'FCR';'BRD';'ECR';'EDCprox';'EDCdist';'ED23';'ECU'}
%synergy1 : FDSprox, FDSdist, FCU
%synergy2 : FDP, BRD, ECR, EDCprox
%synergy3 : EDCdist, ED23, ECU
%synergy4 : PL, FCR
%SesekiL
%EMG List {'EDC';'ED23';'ED45';'ECU';'ECR';'Deltoid';'FDS';'FDP';'FCR';'FCU';'PL';'BRD'}
%synergy1 : 
%synergy2 : 
%synergy3 : 
%synergy4 : 
%Matatabi
%EMG List {'EDC','ECR','BRD_1','FCU','FCR','BRD_2','FDPr','FDPu'}
%synergy1 : FDSprox, FDSdist, FCU
%synergy2 : FDP, BRD, ECR, EDCprox
%synergy3 : EDCdist, ED23, ECU
%synergy4 : PL, FCR
%% plot Xcorr All

switch Tar
   case 'EMG'
      EMG1_A = zeros(4,30);
      EMG2_A = zeros(4,30);
      EMG3_A = zeros(4,30);
      EMG4_A = zeros(4,30);
      f = figure('Position',[0 0 2000 1000]);
      for j=1:EMGn
           eval(['plotD = cell2mat(Re.' EMGs{j,1} ');']);
           subplot(3,4,j);
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
           p = cell(EMGn,1);
           hold off;
          for i = 1:EMGn
      %         subplot(EMGn,EMGn,EMGn*(j-1)+i);
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
          if j==plotD_list(1)
             EMG1_A = plotD(:,plotD_list);
          elseif j==plotD_list(2)
             EMG2_A = plotD(:,plotD_list);
          elseif j==plotD_list(3)
             EMG3_A = plotD(:,plotD_list);
          elseif j==plotD_list(4)
             EMG4_A = plotD(:,plotD_list);
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
%               delete([p{10},p{11},p{EMGn}]);
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
          if j==plotD_list(end)
              L = legend({'Control','EDC','ED23','PL','FDP'},'Location','southwest');
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
      order_s = [4 1 3 2];
      f = figure('Position',[0 0 2000 250]);
      syn1A = zeros(4,28);
      syn2A = zeros(4,28);
      syn3A = zeros(4,28);
      syn4A = zeros(4,28);
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
                    if j==4
                       syn1A(spp,:) = plotD(:,i);
                    elseif j==1
                       syn2A(spp,:) = plotD(:,i);
                    elseif j==3
                       syn3A(spp,:) = plotD(:,i);
                    elseif j==2
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
tarDay = [];
switch Tar
   case 'EMG'
      for t = 1:4 %trig loop 
%       f = figure('Position',[0 0 2000 1000]);
      k = 1;
      switch plotFocus
        case 'off'
           eval(['f' sprintf('%d',k) '= figure(''Position'',[0 0 2000 1000]);']);
           Jloop = 1:EMGn;
        case 'on'
           if t==1
              fe = figure('Position',[0 0 2000 1000]);
           else
              figure(fe)
           end
           Jloop = plotD_list;
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
           p = cell(EMGn,1);
          for i = 1:EMGn %EMG control loop
             spp =1;
      %         subplot(EMGn,EMGn,EMGn*(j-1)+i);
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
             if j==plotD_list(1)
                EMG1_A = plotDe{j}(plotD_list,:);
             elseif j==plotD_list(2)
                EMG2_A = plotDe{j}(plotD_list,:);
             elseif j==plotD_list(3)
                EMG3_A = plotDe{j}(plotD_list,:);
             elseif j==plotD_list(4)
                EMG4_A = plotDe{j}(plotD_list,:);
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
          title(EMGs{j,1},'FontSize',25);
          if j==plotD_list(end)
              L = legend({'Control','EDC','ED23','PL','FDP'},'Location','southwest');
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
           Jloop = [4 1 3 2];
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
           c = lines(4);
          for i = [4 1 3 2]%1:TarN %EMG control loop
      %         subplot(EMGn,EMGn,EMGn*(j-1)+i);
              hold on;
      %         p{i} = plot(xdays,plotDe{j}(i,:),'Color',c(i,:),'LineWidth',1.3);
              switch Ptype
                 case 'RAW'
                    p{i} = plot(xdays,plotDe{j}(i,:),'Color',c(spp,:),'LineWidth',1.3);
                    if t == 1
                       if j==4
                          syn1A(spp,:) = plotDe{j}(i,:);
                       elseif j==1
                          syn2A(spp,:) = plotDe{j}(i,:);
                       elseif j==3
                          syn3A(spp,:) = plotDe{j}(i,:);
                       elseif j==2
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
          title('hold_','FontSize',25);
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