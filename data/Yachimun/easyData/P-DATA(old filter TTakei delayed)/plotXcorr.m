%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
【課題】
・タスク全体からのx_corrの図示のセクションは改善していないので、実行できない(plot_all = 1は実行できない)
　→ これを改善する場合はこの関数を修正する前に,calcXcorr.mのResultXcorr~.matに保存される変数の内容を確認する必要がある
・plot_eachのsubplotのところの汎用性が低い(t = 2:3 (T2,T3)にしか対応していない)
【procedure】
pre : calcXcorr.m
post : plotXcorr_W.m
【caution!!】
AllDays,dayX,visual_synは適宜変更すること
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
%% plot crosscorrelation
Tar = 'Synergy';
switch Tar
   case 'EMG'
      load('ResultXcorr_80.mat');
      load('ResultXcorr_Each_EMG_Range2.mat');      
   case 'Synergy'
%       load('ResultXcorr_80_syn.mat');
%       load('ResultXcorr_Each_syn_Range2.mat');
    %load ResultXcorr
      disp('please select ResultXcorr_~.mat file (which you want to plot x_corr)')
      selected_file = uigetfile('*.mat',...
                     'Select One or More Files', ...
                     'MultiSelect', 'on');
      load(selected_file);
    %load ResultXcorr_Each~
      disp('please select ResultXcorr_Each~.mat file (which you want to plot each x_corr)')
      selected_file = uigetfile('*.mat',...
                     'Select One or More Files', ...
                     'MultiSelect', 'on');
      load(selected_file);    
end
% tEMG = 'FCU';
save_data = 1;
save_fig = 1;
plotFocus = 'off';
plot_all = 0; %if you want to plot x_corr which is extracted from all range of task, please set '1'
plot_each = 1;% if you want to plot x_corr which is extracted from around each timing of task, please set '1'
synergy_combination = 'all'; %dist-dist,dist-prox,prox-dist,prox-prox (procedure is EDC-FDS)
vidual_syn =  [2,4]; %please select the synergy group which you want to plot!!
plot_timing = [1,2];
title_name = {'lever1 on','lever1 off','lever2 on','lever2 off'};
% figure;

switch Tar
   case 'EMG'
      c = jet(12);
      AllDays = datetime([2017,04,05])+caldays(0:177);
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
   case 'Synergy'
      c = lines(4);
%       c = jet(4);
      AllDays = datetime([2017,05,16])+caldays(0:136); %5/16の136日経過 → 9/29
      dayX = {'2017/05/16','2017/05/17','2017/05/24','2017/05/26','2017/06/28',...
              '2017/06/29','2017/06/30','2017/07/03','2017/07/04','2017/07/06',...
              '2017/07/07','2017/07/10','2017/07/11','2017/07/12','2017/07/13',...
              '2017/07/14','2017/07/18','2017/07/19','2017/07/20','2017/07/25',...
              '2017/07/26','2017/08/02','2017/08/03','2017/08/04','2017/08/07',...
              '2017/08/08','2017/08/09','2017/08/10','2017/08/15','2017/08/17',...
              '2017/08/18','2017/08/22','2017/08/23','2017/08/24','2017/08/25',...
              '2017/08/29','2017/08/30','2017/08/31','2017/09/01','2017/09/04',...
              '2017/09/05','2017/09/06','2017/09/07','2017/09/08','2017/09/11',...
              '2017/09/13','2017/09/14','2017/09/25','2017/09/26','2017/09/27','2017/09/29'};%51days

%       dayX = {'2017/05/16','2017/05/17','2017/05/24','2017/05/26','2017/06/28',...
%               '2017/06/29','2017/06/30','2017/07/03','2017/07/04','2017/07/06',...
%               '2017/07/07','2017/07/10','2017/07/11','2017/07/12','2017/07/13',...
%               '2017/07/14','2017/07/18','2017/07/19','2017/07/20','2017/07/25',...
%               '2017/07/26','2017/08/02','2017/08/03','2017/08/04','2017/08/07',...
%               '2017/08/08','2017/08/09','2017/08/10','2017/08/15','2017/08/17',...
%               '2017/08/18','2017/08/22','2017/08/24','2017/08/25',...
%               '2017/08/29','2017/08/30','2017/08/31','2017/09/01','2017/09/04',...
%               '2017/09/05','2017/09/06','2017/09/07','2017/09/08','2017/09/11',...
%               '2017/09/13','2017/09/14','2017/09/25','2017/09/26','2017/09/27','2017/09/29'};%50days(removed 8/23)

%         dayX = {'2017/05/16','2017/05/17','2017/05/24','2017/05/26','2017/06/28',...
%           '2017/06/29','2017/06/30','2017/07/03','2017/07/04','2017/07/06',...
%           '2017/07/07','2017/07/10','2017/07/11','2017/07/12','2017/07/13',...
%           '2017/07/14','2017/07/18','2017/07/19','2017/07/20','2017/07/25',...
%           '2017/07/26','2017/08/02','2017/08/03','2017/08/04','2017/08/07',...
%           '2017/08/08','2017/08/09','2017/08/10','2017/08/15','2017/08/24',...
%           '2017/08/29','2017/08/30','2017/09/01',...
%           '2017/09/05','2017/09/06',...
%           '2017/09/14','2017/09/25'};%37days
%       AllDays = datetime([2017,04,05])+caldays(0:177);
%       dayX = {'2017/04/05','2017/04/10','2017/04/11','2017/04/12','2017/04/13',...
%               '2017/04/19','2017/04/20','2017/04/21','2017/04/24','2017/04/25',...
%               '2017/04/26','2017/05/01','2017/05/09','2017/05/11','2017/05/12',...
%               '2017/05/15','2017/05/16','2017/05/17','2017/05/24','2017/05/26',...
%               '2017/05/29','2017/06/06','2017/06/08','2017/06/12','2017/06/13',...
%               '2017/06/14','2017/06/15','2017/06/16','2017/06/20',...
%               '2017/06/21','2017/06/22','2017/06/23','2017/06/27','2017/06/28',...
%               '2017/06/29','2017/06/30','2017/07/03','2017/07/04','2017/07/06',...
%               '2017/07/07','2017/07/10','2017/07/11','2017/07/12','2017/07/13',...
%               '2017/07/14','2017/07/18','2017/07/19','2017/07/20','2017/07/25',...
%               '2017/07/26','2017/08/02','2017/08/03','2017/08/04','2017/08/07',...
%               '2017/08/08','2017/08/09','2017/08/10','2017/08/15','2017/08/17',...
%               '2017/08/18','2017/08/22','2017/08/23','2017/08/24','2017/08/25',...
%               '2017/08/29','2017/08/30','2017/08/31','2017/09/01','2017/09/04',...
%               '2017/09/05','2017/09/06','2017/09/07','2017/09/08','2017/09/11',...
%               '2017/09/13','2017/09/14','2017/09/25','2017/09/26','2017/09/27','2017/09/29'};%80days
end

AVEPre4Days = {'2017/05/16','2017/05/17','2017/05/24','2017/05/26'};
TaskCompletedDay = {'2017/08/07'};
TTsurgD = datetime([2017,05,30]);                %date of tendon transfer surgery
TTtaskD = datetime([2017,06,28]);                %date monkey started task by himself after surgery & over 100 success trials (he started to work on June.28)
Xpost = zeros(size(AllDays));
Xpre4 = zeros(size(AllDays));
k=1;l=1;
for i=1:length(AllDays)
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
delEMG = [1,1,0,0,1,1,1,1,1,0,0,1];
LEMGs = cell(1,12);
%EMG List {'FDP';'FDSprox';'FDSdist';'FCU';'PL';'FCR';'BRD';'ECR';'EDCprox';'EDCdist';'ED23';'ECU'}
%synergy1 : FDSprox, FDSdist, FCU
%synergy2 : FDP, BRD, ECR, EDCprox
%synergy3 : EDCdist, ED23, ECU
%synergy4 : PL, FCR

%% plot Xcorr All
% if plot_all == 1
%     switch Tar
%        case 'EMG'
%           FCU_A = zeros(4,80);
%           FDSdist_A = zeros(4,80);
%           EDCdist_A = zeros(4,80);
%           ED23_A = zeros(4,80);
%           f = figure('Position',[0 0 2000 1000]);
%           for j=1:12
%                eval(['plotD = cell2mat(Re.' EMGs{j,1} ');']);
%                subplot(3,4,j);
%           %      f = figure;
%                hold on;
%                % area for control data
%                fi1 = fill([xPre4days xPre4days(end:-1:1)],[ones(size(xPre4days)) (-1).*ones(size(xPre4days))],'k');
%                fi1.FaceColor = [0.78 0.78 0.78];       % make the filled area
%                fi1.EdgeColor = 'none';            % remove the line around the filled area
%     % %            % area for disable term
%     % %            fi2 = fill([xnoT xnoT(end:-1:1)],[ones(size(xnoT)) (-1).*ones(size(xnoT))],'k');
%     % %            fi2.FaceColor = [0.5 0.5 0.6];       % make the filled area
%     % %            fi2.EdgeColor = 'none';            % remove the line around the filled area
%                p = cell(12,1);
%                hold off;
%               for i = 1:12
%           %         subplot(12,12,12*(j-1)+i);
%                   hold on;
%                   switch Ptype
%                      case 'RAW'
%                         p{i} = plot(xdays,plotD(:,i),'Color',c(i,:),'LineWidth',1.3);
% 
%                      case 'MMean'
% 
%                   end
%                   if (delEMG(i))
%                       delete(p{i});
%                   end
%               end
%               if j==4
%                  FCU_A = plotD(:,[4 3 10 11]);
%               elseif j==3
%                  FDSdist_A = plotD(:,[4 3 10 11]);
%               elseif j==10
%                  EDCdist_A = plotD(:,[4 3 10 11]);
%               elseif j==11
%                  ED23_A = plotD(:,[4 3 10 11]);
%               end
%               plot([TCD TCD],[-1 1],'k--','LineWidth', 1.3);
%               % area for disable term
%               fi2 = fill([xnoT xnoT(end:-1:1)],[ones(size(xnoT)) (-1).*ones(size(xnoT))],'k','LineWidth',1.3);
%               fi2.FaceColor = [1 1 1];       % make the filled area
%     %           fi2.EdgeColor = 'none';            % remove the line around the filled area
%               hold off;
%     %            if(delSyn(1))
%     %               delete([p{2},p{3},p{4}]);
%     %            end
%     %            if(delSyn(2))
%     %               delete([p{1},p{7},p{8},p{9}]);
%     %            end
%     %            if(delSyn(3))
%     %               delete([p{10},p{11},p{12}]);
%     %            end
%     %            if(delSyn(4))
%     %               delete([p{5},p{6}]);
%     %            end
%               ylim([-1 1]);
%           %     xlim([0 81]);
%               xlim([xPre4days(1) xdays(end)]);
%           %     xlim([xdays(1) xdays(end)]);
%           %     ylabel('Cross-correlation coefficient');
%           %     xlabel('Post tendon transfer [days]');
%               title(EMGs{j,1},'FontSize',25);
%               if j==12
%                   L = legend({'Control','Task Disable','FCU','FDSdist','EDCdist','ED23'},'Location','southwest');
%                   set(L,...
%                       'Position',[0.914849183342953 0.120910384068279 0.0556196623180075 0.0803628093101775],...
%                       'FontSize',14);
%                   ylabel('Cross-correlation coefficient');
%                   xlabel('Post tendon transfer [days]');
%               end
%           %     legend1 = legend(EMGs{:,1});
%           %     set(legend1,...
%           %     'Position',[0.914849183342953 0.120910384068279 0.0776196623180075 0.803628093101775],...
%           %     'FontSize',14);
%               if save_fig == 1
%                  cd TaskAllXcorr_syn1-3
%                  saveas(gcf,[EMGs{j,1} '_Xcorr_TaskAll.epsc']);
%                  saveas(gcf,[EMGs{j,1} '_Xcorr_TaskAll.png']);
%                  saveas(gcf,[EMGs{j,1} '_Xcorr_TaskAll.fig']);
%                  cd ../
%               end
%           end
% 
%        case 'Synergy'
%           TarN = 4;
%           sp=1;                %for subplot
%           order_s = [2 1 4 3];
%           f = figure('Position',[0 0 2000 250]);
%           syn1A = zeros(4,80);
%           syn2A = zeros(4,80);
%           syn3A = zeros(4,80);
%           syn4A = zeros(4,80);
%           for j=order_s%1:TarN
%                eval(['plotD = cell2mat(Re.syn' sprintf('%d',j) ');']);
%                subplot(1,4,sp);
%                sp = sp +1;
%           %      f = figure;
%                hold on;
%                % area for control data
%                fi1 = fill([xPre4days xPre4days(end:-1:1)],[ones(size(xPre4days)) (-1).*ones(size(xPre4days))],'k');
%                fi1.FaceColor = [0.78 0.78 0.78];       % make the filled area
%                fi1.EdgeColor = 'none';            % remove the line around the filled area
%     % %            % area for disable term
%     % %            fi2 = fill([xnoT xnoT(end:-1:1)],[ones(size(xnoT)) (-1).*ones(size(xnoT))],'k');
%     % %            fi2.FaceColor = [0.5 0.5 0.6];       % make the filled area
%     % %            fi2.EdgeColor = 'none';            % remove the line around the filled area
%                p = cell(TarN,1);
%                hold off;
%                spp = 1;
%               for i = order_s%1:TarN
%           %         subplot(TarN,TarN,TarN*(j-1)+i);
%                   hold on;
%                   switch Ptype
%                      case 'RAW'
%                         p{i} = plot(xdays,plotD(:,i),'Color',c(spp,:),'LineWidth',1.3);
%                         if j==2
%                            syn1A(spp,:) = plotD(:,i);
%                         elseif j==1
%                            syn2A(spp,:) = plotD(:,i);
%                         elseif j==4
%                            syn3A(spp,:) = plotD(:,i);
%                         elseif j==3
%                            syn4A(spp,:) = plotD(:,i);
%                         end
%                      case 'MMean'
% 
%                   end
%                   spp = spp +1;
%               end
%               plot([TCD TCD],[-1 1],'k--','LineWidth', 1.3);
%               % area for disable term
%               fi2 = fill([xnoT xnoT(end:-1:1)],[ones(size(xnoT)) (-1).*ones(size(xnoT))],'k','LineWidth',1.3);
%               fi2.FaceColor = [1 1 1];       % make the filled area
%     %           fi2.EdgeColor = 'none';            % remove the line around the filled area
%               hold off;
%                if(delSyn(1))
%                   delete(p{1});
%                end
%                if(delSyn(2))
%                   delete(p{2});
%                end
%                if(delSyn(3))
%                   delete(p{3});
%                end
%                if(delSyn(4))
%                   delete(p{4});
%                end
%               ylim([-1 1]);
%           %     xlim([0 81]);
%               xlim([xPre4days(1) xdays(end)]);
%           %     xlim([xdays(1) xdays(end)]);
%           %     ylabel('Cross-correlation coefficient');
%           %     xlabel('Post tendon transfer [days]');
%               title(['Synergy' sprintf('%d',order_s(j))],'FontSize',25);
%               if j==TarN
%                   L = legend({'Control','Synergy1','Synergy2','Synergy3','Synergy4','Recovered','Task Disable'},'Location','southwest');
%                   set(L,...
%                       'Position',[0.914849183342953 0.120910384068279 0.0556196623180075 0.0803628093101775],...
%                       'FontSize',14);
%                   ylabel('Cross-correlation coefficient');
%                   xlabel('Post tendon transfer [days]');
%               end
%           %     legend1 = legend(EMGs{:,1});
%           %     set(legend1,...
%           %     'Position',[0.914849183342953 0.120910384068279 0.0776196623180075 0.803628093101775],...
%           %     'FontSize',14);
%               if save_fig == 1
%                  cd TaskAllXcorr_syn1-3
%                  saveas(gcf,[EMGs{j,1} '_Xcorr_TaskAll.epsc']);
%                  saveas(gcf,[EMGs{j,1} '_Xcorr_TaskAll.png']);
%                  saveas(gcf,[EMGs{j,1} '_Xcorr_TaskAll.fig']);
%                  cd ../
%               end
%           end
% 
%     end
% end
%% plot Xcorr Each
if plot_each == 1
    switch Tar
       case 'EMG'
          for t = 1:4 %trig loop 
    %       f = figure('Position',[0 0 2000 1000]);
          k = 1;
          switch plotFocus
            case 'off'
               eval(['f' sprintf('%d',k) '= figure(''Position'',[0 0 2000 1000]);']);
               Jloop = 1:12;
            case 'on'
               if t==1
                  fe = figure('Position',[0 0 2000 1000]);
               else
                  figure(fe)
               end
               Jloop = [4 3 10 11];
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
               p = cell(12,1);
              for i = 1:12 %EMG control loop
                 spp =1;
          %         subplot(12,12,12*(j-1)+i);
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
                 if j==4
                    FCU_A = plotDe{j}([4 3 10 11],:);
                 elseif j==3
                    FDSdist_A = plotDe{j}([4 3 10 11],:);
                 elseif j==10
                    EDCdist_A = plotDe{j}([4 3 10 11],:);
                 elseif j==11
                    ED23_A = plotDe{j}([4 3 10 11],:);
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
              if j==12
                  L = legend({'Control','Task Disable','FCU','FDSdist','EDCdist','ED23'},'Location','southwest');
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
          %↓t:T2~T3のプロット(food onとfood off (tim1,tim4は不要なので排除))
          for t = plot_timing(1):plot_timing(2) %1:TarN %trig loop 
        %       f = figure('Position',[0 0 2000 1000]);
              k = 1;
              switch plotFocus
                    case 'off'
                       if t == plot_timing(1) %1回目のループの時 
                            eval(['f' sprintf('%d',k) '= figure(''Position'',[0 0 600 1000]);']);
                       end
                       Jloop = 1:TarN;
                    case 'on'
                       if t==1
                          fe = figure('Position',[0 0 2000 1000]);
                       else
                          figure(fe);
                       end
                       Jloop = [2 1 4 3];
              end
              for j=Jloop % EMG loop
                   eval(['plotDe = ResE.T' sprintf('%d',t) ';']);
                   if j == 1
                       for pp = 1:4
                           eval(['vs_tim' num2str(t) '_synergy' num2str(pp) '= plotDe{' num2str(pp) '};'])
                       end
                   end
                   switch plotFocus
                      case 'off'
                         subplot(TarN,2,(2*j)-(plot_timing(2)-t)); %2と(2*j)はタイミングの数(T2とT3),(plot_timing(2)-t)のplot_timing(2)はtの一番最後の要素の値を示している
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
                  for i = vidual_syn %[2 1 4 3]%1:TarN %EMG control loop
              %         subplot(12,12,12*(j-1)+i);
                      hold on;
              %         p{i} = plot(xdays,plotDe{j}(i,:),'Color',c(i,:),'LineWidth',1.3);
                      switch Ptype
                         case 'RAW'
                            p{i} = plot(xdays,plotDe{j}(i,:),'Color',c(spp,:),'LineWidth',1.3, 'DisplayName',['Synergy' num2str(i)]);
                            %{
                            syn1A~syn4Aが、これ以降のセクションで使用されていないので、コメントアウトした
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
                            %}
                         case 'MMean'
              %               ps{i} = scatter(xdays,plotDe{j}(i,:));
                            p{i} = plot(xdays,conv2(plotDe{j}(i,:),kernel,'same'),'Color',c(spp,:),'LineWidth',1.3);
                      end
                      spp = spp+1;
                  end
                  %plot([TCD TCD],[-1 1],'k--','LineWidth', 1.3);
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
                  if t==plot_timing(1) %timing2の時
                      title([title_name{t} ' Synergy' num2str(j)]);
                  elseif t==plot_timing(2) %timing3の時
                      title([title_name{t} ' Synergy' num2str(j)]);
                  end
                  %title(['vs Syn' num2str(j) '(T' num2str(t) ')'],'FontSize',25);
                  if j == TarN
                      ylabel('Cross-correlation coefficient');
                      xlabel('Post tendon transfer [days]');
                      if t==3
                          if length(vidual_syn) == 2 %シナジー2とシナジー4のみを図示
                             L = legend({'Control','Synergy2','Synergy4','Task Disable'},'Location','southwest');
                          elseif length(vidual_syn) == 4 %全部のシナジーを図示
                             L = legend({'Control','Synergy1','Synergy2','Synergy3','Synergy4','Task Disable'},'Location','southwest');
                          end
                          set(L,...
                              'Position',[0.923 0.120910384068279 0.0556196623180075 0.0803628093101775],...
                              'FontSize',12);
                      end
                  end
              end
          end
          % legend用に使用するlineをまとめる
          count = 1;
          for ii = 1:length(p)
              if ~isempty(p{ii})
                  a(count) = p{ii};
                  count = count+1;
              end
          end
          lgd = legend(a([1:end]));
          lgd.FontSize = 8;
          %save figure
          if save_fig == 1
              save_dir = ['EachPlot/x_corr_result/' synergy_combination];
              if not(exist(save_dir))
                  mkdir(save_dir)
              end
              fig_name = [save_dir '/' num2str(TarN) 'syn_' num2str(length(vidual_syn)) 'plot_2timing'];
              saveas(gcf,[fig_name '.fig']);
              saveas(gcf,[fig_name '.png']);
          end
          close all;
          %save data
          if save_data == 1
              save_dir = ['EachPlot/x_corr_result/' synergy_combination];
              if not(exist(save_dir))
                  mkdir(save_dir)
              end
              save([save_dir '/x_corr_data(temporal).mat'],'vs*','xdays','dayX')
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