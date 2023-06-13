
%% plot crosscorrelation

Tar = 'Each';

switch Tar
   case 'All'
      load('XcorrSyn_80_190731analyzed.mat');
%       load('XcorrFingerM_80_190731analyzed.mat');
   case 'Each'
%       load('XcorrSyn_80_190731analyzed_trig2.mat');
%       load('XcorrFingerM_80_190731analyzed_trig2.mat');
      load('XcorrSyn_80_Range2_trig2.mat');
      load('XcorrFingerM_80_Range2_trig2.mat');
end
fingerM = {'FDP','FDSdist','EDCdist','ED23'};
SYN = {'syn1','syn2','syn3','syn4'};

save_fig = 0;
% figure;
c1 = jet(12);
c2 = lines(4);
%       c = jet(4);
AllDays = datetime([2017,04,05])+caldays(0:177);
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
Xpost = zeros(size(AllDays));
Xpre4 = zeros(size(AllDays));
k=1;l=1;
for i=1:178
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
delEMG = [0,1,0,1,1,1,1,1,1,0,0,1];
LEMGs = cell(1,12);
%EMG List {'FDP';'FDSprox';'FDSdist';'FCU';'PL';'FCR';'BRD';'ECR';'EDCprox';'EDCdist';'ED23';'ECU'}
%synergy1 : FDSprox, FDSdist, FCU
%synergy2 : FDP, BRD, ECR, EDCprox
%synergy3 : EDCdist, ED23, ECU
%synergy4 : PL, FCR
%% 
% f = figure('Position',[0 0 2000 1000]);
      for j=1:2
%            eval(['plotD = cell2mat(Re.' EMGs{j,1} ');']);
%            subplot(3,4,j);
           f = figure;
           hold on;
           % area for control data
           fi1 = fill([xPre4days xPre4days(end:-1:1)],[ones(size(xPre4days)) (-1).*ones(size(xPre4days))],'k');
%            fi1.FaceColor = [0.8 0.8 1];       % make the filled area
           fi1.FaceColor = [0.78 0.78 0.78];       % make the filled area
           fi1.EdgeColor = 'none';            % remove the line around the filled area
           % area for disable term
%            fi2 = fill([xnoT xnoT(end:-1:1)],[ones(size(xnoT)) (-1).*ones(size(xnoT))],'k');
%            fi2.FaceColor = [0.5 0.5 0.6];       % make the filled area
%            fi2.EdgeColor = 'k';            % remove the line around the filled area
           p = cell(12,1);

           switch Ptype
              case 'RAW'
                 switch Tar
                    case 'All'
                       if j==1
                          plot(xdays,ED23_A(:,4),'-','Color',c1(11,:),'LineWidth',1.5);
                          plot(xdays,EDCdist_A(:,3),'-','Color',c1(9,:),'LineWidth',1.5);
                          plot(xdays,syn3A(3,:),'--','Color',c2(3,:),'LineWidth',1.5);
                       elseif j==2
                          plot(xdays,FDP_A(:,1),'Color',c1(1,:),'LineWidth',1.5);
                          plot(xdays,FDSdist_A(:,2),'Color',c1(3,:),'LineWidth',1.5);
                          plot(xdays,syn1A(1,:),'Color',c2(1,:),'LineWidth',1.5);
                       end
                    case 'Each'
                       if j==1
                          ED23_A = ED23_A';
                          EDCdist_A = EDCdist_A';
%                           plot(xdays,[ED23_A(1:28,4); ED23_A(30:81,4)],'x-','Color',c1(11,:),'LineWidth',1.3);
%                           plot(xdays,[EDCdist_A(1:28,3); EDCdist_A(30:81,3)],'o-','Color',c1(9,:),'LineWidth',1.3);
                          plot(xdays,ED23_A(:,4),'-','Color',c1(11,:),'LineWidth',1.5);
                          plot(xdays,EDCdist_A(:,3),'-','Color',c1(9,:),'LineWidth',1.5);
                          plot(xdays,syn3A(3,:),'--','Color',c2(1,:),'LineWidth',1.5);
                       elseif j==2
                          FDP_A =FDP_A';
                          FDSdist_A= FDSdist_A';
%                           plot(xdays,[FDP_A(1:28,1); FDP_A(30:81,1)],'Color',c1(1,:),'LineWidth',1.3);
%                           plot(xdays,[FDSdist_A(1:28,2); FDSdist_A(30:81,2)],'Color',c1(3,:),'LineWidth',1.3);
                          plot(xdays,FDP_A(:,1),'Color',c1(1,:),'LineWidth',1.5);
                          plot(xdays,FDSdist_A(:,2),'Color',c1(1,:),'LineWidth',1.5);

                          plot(xdays,syn1A(1,:),'Color',c2(1,:),'LineWidth',1.5);
                       end
                 end
              case 'MMean'

           end
           fi2 = fill([xnoT xnoT(end:-1:1)],[ones(size(xnoT)) (-1).*ones(size(xnoT))],'k','LineWidth',1.5);
           fi2.FaceColor = [1 1 1];       % make the filled area
%            fi2.EdgeColor = 'k';            % remove the line around the filled area
          plot([TCD TCD],[-1 1],'k--','LineWidth', 1.3);
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
      Title = {'Extensor','Flexor'};
          title(Title{j},'FontSize',25);
          if j==1
             L = legend({'Control','ED23','EDCdist','Synergy3','Task Disable'},'Location','southwest');
          elseif j==2
             L = legend({'Control','FDP','FDSdist','Synergy1','Task Disable'},'Location','southwest');
          end
           set(L,...
               'Position',[0.914849183342953 0.120910384068279 0.0556196623180075 0.0803628093101775],...
               'FontSize',14);
           ylabel('Cross-correlation coefficient');
           xlabel('Post tendon transfer [days]');
      %     legend1 = legend(EMGs{:,1});
      %     set(legend1,...
      %     'Position',[0.914849183342953 0.120910384068279 0.0776196623180075 0.803628093101775],...
      %     'FontSize',14);
         
      end