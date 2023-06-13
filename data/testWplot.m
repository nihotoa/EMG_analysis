%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
current dir:data
[caution!!]
testWplotだから、図を保存する機能は持ち合わせていない
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = testWplot()

realname = 'Yachimun';
% realname = 'Yachimun';
FIX = 'N';
prepost = 'pre';
synNum = 4;
synOrder = [2 3 4 1];
% synOrder = [1 2 3 4];
plotType = 'ALL';
plotCon = 1;
% Hlen = 100;
save_fig = 0; %基本的に0にしておく
trig = 3;
trial_plot = 1;
Yh = 2;
plotPRE = 1;
JETplot = 0;
saveFIX = 1;
Lw = 2.5;
cd([realname '/easyData/P-DATA'])

switch realname 
    case 'Yachimun'
       trig = 1;
       RNG = [-15 15];
       catX = categorical({'FDP';'FDSprox';'FDSdist';'FCU';'PL';'FCR';'BRD';'ECR';'EDCprox';'EDCdist';'ED23';'ECU'});
       catXall = categorical({'FDP';'FDSprox';'FDSdist';'FCU';'PL';'FCR';'BRD';'ECR';'EDCprox';'EDCdist';'ED23';'ECU'});
       EMGn = length(catX);
       Nd = 178;
       Col = jet(Nd);
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
               '2017/09/13','2017/09/14','2017/09/25','2017/09/26','2017/09/27','2017/09/29'};%80days
           AVEPre4Days = {'2017/05/16','2017/05/17','2017/05/24','2017/05/26'};
           TaskCompletedDay = {'2017/08/07'};
           TTsurgD = datetime([2017,05,30]);                %date of tendon transfer surgery
           TTtaskD = datetime([2017,06,28]);                %date monkey started task by himself after surgery & over 100 success trials (he started to work on June.28)
   case 'SesekiL'
       RNG = [-15 15];
      catX = categorical({'EDC';'ED23';'ED45';'ECU';'ECR';'Deltoid';'FDP';'PL';'BRD'});
      catXall = categorical({'EDC';'ED23';'ED45';'ECU';'ECR';'Deltoid';'FDS';'FDP';'FCR';'FCU';'PL';'BRD'});
      EMGn = length(catX);
      Nd = 74;
      Col = jet(Nd);
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
      catX = categorical({'EDC';'ECR';'BRD_1';'FCU';'FCR';'BRD_2'});
      catXall = categorical({'EDC';'ECR';'BRD_1';'FCU';'FCR';'BRD_2'});
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
cdays = find(Xpost) - find(AllDays==TTtaskD)+1;
xPre4days = find(Xpre4) - find(AllDays==TTsurgD);
TCD = tcd - find(AllDays==TTsurgD);
xnoT = 0:(find(AllDays==TTtaskD)-1- find(AllDays==TTsurgD));

cpostdays = xdays(find(xdays>0));
ctaskdays = xdays(find(cdays>0));
cval = cpostdays./cpostdays(end);
% cSingle_e = cval(end-length(ctaskdays)+1:end)';
cSingle_e = linspace(0.3,1,cpostdays(end))';
% czero = zeros(length(cSingle_e),1);
czero = zeros(cpostdays(end),1);
cJetall = jet(xdays(end));
cJet = cJetall(cpostdays,:);
if JETplot==1
    cSinlgeC = cJet;
else
    switch realname 
        case 'Yachimun'
            cSingleC = [cSingle_e czero czero];
        case 'SesekiL'
            cSingleC = [czero cSingle_e czero];
    end 
end
% load('eachSyncontrols_synN3.mat')
% load('eachSynPosts_synN3_nnmffunc.mat')
switch FIX
   case 'W'
      switch prepost
          case 'pre'
              switch realname
                  case 'SesekiL'
                      load(['eachSyncontrols_synN' sprintf('%d',synNum) '_normalizedPre_FIXW.mat'])
                  case 'Yachimun'
%                       load(['eachSyncontrols_synN' sprintf('%d',synNum) '_nnmffunc_normalizedPre_FIXW.mat']) %Yachimun fix W as spatial synergy never change from control results(whole data synergy analysis)
                      load(['eachSyncontrols_synN' sprintf('%d',synNum) '_normalizedPre_FIXW_trig' sprintf('%d',trig) '.mat'])
              end
          case 'post'
              switch realname
                  case 'SesekiL'
%                       load(['eachSynPosts_synN' sprintf('%d',synNum) '_nnmffunc_normalizedPre_filt2_FIXW.mat']) %SesekiL fix W as spatial synergy never change from control results(whole data synergy analysis)
%                       load(['eachSynPosts_synN' sprintf('%d',synNum) '_nnmffunc_normalizedPre_filt2_FIXWvafConvMat.mat']) 
                      load(['eachSynPosts_synN' sprintf('%d',synNum) '_normalizedPre_FIXW.mat'])
                  case 'Yachimun'
%                       load(['eachSynPosts_synN' sprintf('%d',synNum) '_nnmffunc_normalizedPre_FIXW47.mat']) %Yachimun fix W as spatial synergy never change from control results(whole data synergy analysis)
%                       load(['eachSynPosts_synN' sprintf('%d',synNum) '_nnmffunc_normalizedPre_FIXWvafConvMat.mat'])
                      load(['eachSynPosts_synN' sprintf('%d',synNum) '_normalizedPre_FIXW_trig' sprintf('%d',trig) '.mat'])
              end
      end
   case 'H'
      switch prepost
          case 'pre'
              switch realname
                  case 'SesekiL'
%                       load(['eachSyncontrols_synN' sprintf('%d',synNum) '_nnmffunc_normalizedPre_filt2_FIXHrev2.mat'])
                      load(['eachSyncontrols_synN' sprintf('%d',synNum) '_normalizedPre_FIXH_trig' sprintf('%d',trig) '.mat']) 
                  case 'Yachimun'
%                       load(['eachSyncontrols_synN' sprintf('%d',synNum) '_nnmffunc_normalizedPre_FIXHrev2.mat']) %Yachimun fix W as spatial synergy never change from control results(whole data synergy analysis)
                      load(['eachSyncontrols_synN' sprintf('%d',synNum) '_normalizedPre_FIXH_trig' sprintf('%d',trig) '.mat']) 
              end
          case 'post'
              switch realname
                  case 'SesekiL'
%                       load(['eachSynPosts_synN' sprintf('%d',synNum) '_nnmffunc_normalizedPre_filt2_FIXHrev2.mat']) %SesekiL fix W as spatial synergy never change from control results(whole data synergy analysis)
                      load(['eachSynPosts_synN' sprintf('%d',synNum) '_normalizedPre_FIXH_trig' sprintf('%d',trig) '.mat']) 
                  case 'Yachimun'
%                       load(['eachSynPosts_synN' sprintf('%d',synNum) '_nnmffunc_normalizedPre_FIXH47rev2.mat']) %Yachimun fix W as spatial synergy never change from control results(whole data synergy analysis)
                      load(['eachSynPosts_synN' sprintf('%d',synNum) '_normalizedPre_FIXH_trig' sprintf('%d',trig) '.mat'])
              end
      end  
   case 'Nday'
      switch prepost
          case 'pre'
              switch realname
                  case 'SesekiL'
%                       load(['eachSyncontrols_synN' sprintf('%d',synNum) '_nnmffunc_normalizedPre_filt2_FIXHrev2.mat'])
                      load(['eachSyncontrols_synN' sprintf('%d',synNum) '_normalizedDay_FIXNday.mat']) 
                  case 'Yachimun'
%                       load(['eachSyncontrols_synN' sprintf('%d',synNum) '_nnmffunc_normalizedPre_FIXHrev2.mat']) %Yachimun fix W as spatial synergy never change from control results(whole data synergy analysis)
                      load(['eachSyncontrols_synN' sprintf('%d',synNum) '_normalizedDay_FIXNday.mat']) 
              end
          case 'post'
              switch realname
                  case 'SesekiL'
%                       load(['eachSynPosts_synN' sprintf('%d',synNum) '_nnmffunc_normalizedPre_filt2_FIXHrev2.mat']) %SesekiL fix W as spatial synergy never change from control results(whole data synergy analysis)
                      load(['eachSynPosts_synN' sprintf('%d',synNum) '_normalizedDay_FIXNday.mat'])
                  case 'Yachimun'
%                       load(['eachSynPosts_synN' sprintf('%d',synNum) '_nnmffunc_normalizedPre_FIXH47rev2.mat']) %Yachimun fix W as spatial synergy never change from control results(whole data synergy analysis)
                      load(['eachSynPosts_synN' sprintf('%d',synNum) '_normalizedDay_FIXNday.mat'])
              end
      end
   case 'N'
      switch prepost
          case 'pre'
              switch realname
                  case 'SesekiL'
%                       load(['eachSyncontrols_synN' sprintf('%d',synNum) '_nnmffunc_normalizedPre_filt2_FIXHrev2.mat'])
                      load(['eachSyncontrols_synN' sprintf('%d',synNum) '_normalizedPre_FIXN.mat']) 
                  case 'Yachimun'
%                       load(['eachSyncontrols_synN' sprintf('%d',synNum) '_nnmffunc_normalizedPre_FIXHrev2.mat']) %Yachimun fix W as spatial synergy never change from control results(whole data synergy analysis)
                      load(['eachSyncontrols_synN' sprintf('%d',synNum) '_FIXN_trig' sprintf('%d',trig) '.mat']) 
              end
          case 'post'
              switch realname
                  case 'SesekiL'
%                       load(['eachSynPosts_synN' sprintf('%d',synNum) '_nnmffunc_normalizedPre_filt2_FIXHrev2.mat']) %SesekiL fix W as spatial synergy never change from control results(whole data synergy analysis)
                      load(['eachSynPosts_synN' sprintf('%d',synNum) '_normalizedPre_FIXN.mat'])
                  case 'Yachimun'
%                       load(['eachSynPosts_synN' sprintf('%d',synNum) '_nnmffunc_normalizedPre_FIXH47rev2.mat']) %Yachimun fix W as spatial synergy never change from control results(whole data synergy analysis)
                      load(['eachSynPosts_synN' sprintf('%d',synNum) '_normalizedPre_FIXN.mat'])
              end
      end
   otherwise
      switch prepost
          case 'pre'
              switch realname
                  case 'SesekiL'
%                       load(['eachSyncontrols_synN' sprintf('%d',synNum) '_nnmffunc_normalizedPre_vaf.mat'])
                      load(['eachSyncontrols_synN' sprintf('%d',synNum) '_normalizedPre.mat']) %SesekiL fix W as spatial synergy never change from control results(whole data synergy analysis)
                  case 'Yachimun'
                      load(['eachSyncontrols_synN' sprintf('%d',synNum) '_nnmffunc_normalizedPre_vaf.mat']) %Yachimun fix W as spatial synergy never change from control results(whole data synergy analysis)
              end
          case 'post'
              switch realname
                  case 'SesekiL'
%                       load(['eachSynPosts_synN' sprintf('%d',synNum) '_nnmffunc_normalizedPre_vaf.mat']) %SesekiL fix W as spatial synergy never change from control results(whole data synergy analysis)
                      load(['eachSynposts_synN' sprintf('%d',synNum) '_normalizedPre.mat']) 
                  case 'Yachimun'
                      load(['eachSynPosts_synN' sprintf('%d',synNum) '_nnmffunc_normalizedPre_vaf.mat']) %Yachimun fix W as spatial synergy never change from control results(whole data synergy analysis)
              end
      end   
end

load(['eachSyn' sprintf('%d',synNum) 'con_AVE.mat'])
switch FIX
    case {'Nday','N'}
       load([realname 'controlWt_filtNO5.mat'])
       switch prepost
          case 'pre'
%              eval(['Wcon = aveWt_synN' sprintf('%d',synNum) ';'])
             Wcon = Yall{1}.W{1};
%              Wcon_select = 1;
          case 'post'
             Wcon = Yall{1}.W{1};
%              Wcon_select = 1;
       end
    case 'W'
        Wcon = Wt;
   case 'H'
        Wcon = [];
    otherwise
        Wcon = zeros(size(Wave_con{1}));
        Wa = zeros(size(Wave_con{1}));
        for n = 1:synNum
            for m = 1:synNum
              Wa(:,m) = Wave_con{m}(:,n);
            end
           Wcon(:,n) = mean(Wa,2);
        end
end

% load('eachSyncontrols_synN4.mat')
Sxy = size(Yall);
Wave = cell(Sxy(1),1);
Wstd = cell(Sxy(1),1);
Wall = cell(Sxy(1),1);
Have = cell(Sxy(1),1);
Hstd = cell(Sxy(1),1);
Hall = cell(Sxy(1),1);
SUC_trial_sel = cell(Sxy(1),1);
ORDERS = cell(Sxy(1),1);
if trial_plot == 1
%    eval(['Wconconcon = aveWt_synN' sprintf('%d',synNum) ';'])
%    [Wconcon,order] = orderchange(Wconconcon,Yall{1}.W{1},synNum);
%    disp(order);
    %PLOT loooop
    for TarN = 1:Sxy(1)
%        if Wcon_select == 1
%           [Wcon,order] = orderchange(Wconcon,Yall{TarN,1}.W{1},synNum);
%           disp(order);
%        end
        [Wave{TarN}, Wstd{TarN},Have{TarN},Hstd{TarN},SUC_trial_sel{TarN},Wall{TarN},Hall{TarN},ORDERS{TarN}] = synplot(TarN, Yall, Wcon, synNum, plotType, catX, save_fig);
%         [Wave{TarN}, Wstd{TarN},Have{TarN},Hstd{TarN},SUC_trial_sel{TarN},Wall{TarN},Hall{TarN}] = synplot(TarN, Yall, Yall{1}.W{1}, synNum, plotType, catX, save_fig);
        if save_fig == 1
            if not(exist('eachWfig'))
                mkdir eachWfig
            end
            cd eachWfig
            SaveFig(f,['eachW_PostDay' sprintf('%03d',t)])
            cd ../
        end
        close all
    end
else
    %plot by saved data
    switch prepost
        case 'pre'
            switch realname
                case 'SesekiL'
                    load(['synplot_results_syn4_pre_FIXH_trig3.mat'])%SesekiL fix W as spatial synergy never change from control results(whole data synergy analysis)
                case 'Yachimun'
                    load(['synplot_results_syn4_pre_FIXH_trig2.mat']) %Yachimun fix W as spatial synergy never change from control results(whole data synergy analysis)
            end
        case 'post'
            switch realname
                case 'SesekiL'
                    load(['synplot_results_syn4_post25_FIXH_trig3.mat'])%SesekiL fix W as spatial synergy never change from control results(whole data synergy analysis)
                case 'Yachimun'
                    load(['synplot_results_syn' sprintf('%d',synNum) '_post_nnmffunc_prenormalizedcon_FIXW47.mat']) %Yachimun fix W as spatial synergy never change from control results(whole data synergy analysis)
            end
    end
end
    ave_timeWs = zeros(Sxy(1),1);
    for TarN = 1:Sxy(1)
       ave_timeWs(TarN,1) = length(Have{TarN}(1,:));
    end
    TIMEW = round(mean(ave_timeWs));
    Hlen = TIMEW;%Hlen will be saved 
       %plot PRE days 
       c_use = find(Xpost);
%        c = Col(find(Xpost(abs(xPre4days(1))+1:end)),:);
%        Csp = cSingleC(find(Xpost(find(AllDays==TTtaskD):end)),:);
       col = lines(synNum);
       xHplot = linspace(RNG(1),RNG(2),TIMEW);
if plotCon == 1
   fcon1 = figure('Position',[0 0 1200 800]);
   Wave_conAVE = zeros(EMGn,synNum);
   Wave_conSTD = zeros(EMGn,synNum);
   Have_conAVE = zeros(synNum,TIMEW);
   Have_conSTD = zeros(synNum,TIMEW);
   for s=1:synNum
       Wcon4plot = zeros(EMGn,length(Wave));
       for TarN = 1:length(Wave)
           Wcon4plot(:,TarN) = Wave{TarN}(:,s);
       end
       %plot W
       Wave_conAVE(:,s) = mean(Wcon4plot,2);
       Wave_conSTD(:,s) = std(Wcon4plot,0,2);
       subplot(synNum,2,2*s-1)
       bar(catX,Wcon4plot,'FaceColor',col(s,:))
       ylim([0 Yh])
       %plot H
       subplot(synNum,2,2*s)
       Hnormlized_con = zeros(length(Wave),TIMEW);
%         for TarN = 1:Sxy(1)
       for TarN = 1:length(Wave)
           Hnormlized_con(TarN,:) = normalizeH(Have{TarN}(s,:),TIMEW);
           plot(xHplot,Hnormlized_con(TarN,:),'k','LineWidth',Lw)
           hold on
       end
       Have_conAVE(s,:) = mean(Hnormlized_con,1);
       Have_conSTD(s,:) = std(Hnormlized_con,0,1);
       plot([0 0],[0 Yh],'r','LineWidth',Lw)
       ylim([0 Yh])
   end
   fcon2 = figure('Position',[0 0 1200 800]);
   for s=1:synNum
       %plot W
       subplot(synNum,2,2*s-1)
       hold on
       bar(catX,Wave_conAVE(:,s),'FaceColor',col(s,:))
%         er = errorbar(1:EMGn,Wave_conAVE(:,s),Wave_conSTD(:,s),Wave_conSTD(:,s));    
       errval = ones(1,EMGn).*0.1;
       er = errorbar(catX,Wave_conAVE(:,s),errval,errval);    
       er.Color = [0 0 0];                            
       er.LineStyle = 'none';  
       ylim([0 Yh])
       %plot H
       subplot(synNum,2,2*s)
       hold on
       fi = fill([xHplot xHplot(end:-1:1)],[Have_conAVE(s,:)-Have_conSTD(s,:) Have_conAVE(s,end:-1:1)+Have_conSTD(s,end:-1:1)],'g');
       fi.FaceColor = col(s,:);
       fi.FaceAlpha = 0.3;
       plot(xHplot,Have_conAVE(s,:),'k','LineWidth',Lw)
       plot([0 0],[0 Yh],'k','LineWidth',Lw)
       ylim([0 Yh])
   end
end
    %plot POST days 
    f = figure('Position',[0 0 1200 800]);
    Have4xcorr = cell(size(Have));
    for TarN = 1:Sxy(1)
        Have4xcorr{TarN} = zeros(synNum,TIMEW);
    end
    for s=1:synNum
        W4plot = zeros(EMGn,Sxy(1));
        for TarN = 1:Sxy(1)
%         for TarN = [1 2 3 6 7 8 9 10 12 13 14 15 16 17 18 23 24 25]
            W4plot(:,TarN) = Wave{TarN}(:,synOrder(s));
        end
        %plot W
        subplot(synNum,2,2*s-1)
        bar(catX,W4plot,'FaceColor','b')
%         bar(catX,W4plot,'FaceColor',col(s,:))
        ylim([0 Yh])
        %plot H
        subplot(synNum,2,2*s)
        for TarN = 1:Sxy(1)
            Have4xcorr{TarN}(s,:) = normalizeH(Have{TarN}(synOrder(s),:),TIMEW);
%         for TarN = [1 2 3 6 7 8 9 10 12 13 14 15 16 17 18 23 24 25]
%             plot(xHplot,interpft(Have{TarN}(s,:),TIMEW),'Color',c(TarN,:),'LineWidth',Lw)
%             plot(xHplot,normalizeH(Have{TarN}(s,:),TIMEW),'Color',cSingleC(TarN,:),'LineWidth',Lw)
            plot(xHplot,normalizeH(Have{TarN}(s,:),TIMEW),'Color',cSingleC(ctaskdays(TarN),:),'LineWidth',Lw)
            hold on
        end
        plot([0 0],[0 Yh],'k','LineWidth',Lw)
        ylim([0 Yh])
    end
    %normalize H length
    for TarN = 1:Sxy(1)
       Have{TarN} = normalizeH(Have{TarN},TIMEW);
       for s = 1:synNum
          Hall{TarN}{s} = normalizeH(Hall{TarN}{s},TIMEW);
       end
    end
    %calc. reconstructed EMG
    reconEMG = cell(Sxy(1),1);
    reconEMGall = cell(Sxy(1),1);
    for TarN = 1:Sxy(1)
       switch realname
          case 'SesekiL'
              reconEMG{TarN} = Wave{TarN}*Have4xcorr{TarN};
              reconEMGall{TarN} = cell(EMGn,1);
              for m=1:EMGn
                 reconEMGall{TarN}{m} = zeros(size(Hall{TarN}{1}));
              end
              for tr = 1:length(Wall{TarN}{1}(:,1))
                 AltE = [Wall{TarN}{1}(tr,:);Wall{TarN}{2}(tr,:);Wall{TarN}{3}(tr,:)]'*[Hall{TarN}{1}(tr,:);Hall{TarN}{2}(tr,:);Hall{TarN}{3}(tr,:)];
                 for m = 1:EMGn
                    reconEMGall{TarN}{m}(tr,:) = AltE(m,:);
                 end
              end
          case 'Yachimun'
              reconEMG{TarN} = Wave{TarN}*Have4xcorr{TarN};
              reconEMGall{TarN} = cell(EMGn,1);
              for m=1:EMGn
                 reconEMGall{TarN}{m} = zeros(size(Hall{TarN}{1}));
              end
              for tr = 1:length(Wall{TarN}{1}(:,1))
                 AltE = [Wall{TarN}{1}(tr,:);Wall{TarN}{2}(tr,:);Wall{TarN}{3}(tr,:);Wall{TarN}{4}(tr,:)]'*[Hall{TarN}{1}(tr,:);Hall{TarN}{2}(tr,:);Hall{TarN}{3}(tr,:);Hall{TarN}{4}(tr,:)];
                 for m = 1:EMGn
                    reconEMGall{TarN}{m}(tr,:) = AltE(m,:);
                 end
              end
       end
    end
    
    if saveFIX ==1
        save(['XcorrData_eachSyn' sprintf('%d',synNum) '_FIX' FIX prepost '_trig' sprintf('%d',trig) '.mat'],'xdays', 'xPre4days','xnoT', ...
                                                       'Have4xcorr', 'Hlen', 'Wave', ...
                                                       'catX','catXall', 'cSingleC','cJet',...
                                                       'AllDays', 'Allfiles', ...
                                                       'EMGn', 'EMGselect', 'meanPre_val',...
                                                       'reconEMG','reconEMGall');
    end
 end
function [Wave, Wstd, Have,Hstd,SUC_trial_common,Wall,Hall,ORDERS] = synplot(TarN, Yall, Wcon, synNum, plotType, catX, save_fig)
Strial = size(Yall{TarN}.W);
col = lines(synNum);

W = cell(Strial(1),1);
H = cell(Strial(1),1);

suc_trial = zeros(synNum,Strial(1));
order_sel = cell(Strial(1),1);
if ~isempty(Wcon)
   for t=1:Strial(1)
       %change order
   %     [newW,order] = orderchange(allW{1,1},Yall{1,1}.W{t},synNum);
       [newW,order] = orderchange(Wcon,Yall{TarN,1}.W{t},synNum);
       order_sel{t} = order;
       W{t} = newW;
       H{t} = Yall{TarN,1}.H{t}(order',:);
   end
else 
   W = Yall{TarN,1}.W;
   H = Yall{TarN,1}.H;
end
ORDERS = cell2mat(order_sel);
switch plotType
    case 'EACH'
        for t = 1:Strial(1)
            f = figure('Position',[0 0 1200 800]);
            for s=1:synNum
                %plot W
                subplot(synNum,2,2*s-1)
                bar(catX,W{t}(:,s))
                ylim([0 2])
                %plot H
                subplot(synNum,2,2*s)
                plot(H{t}(s,:),'LineWidth',1.5)
                hold on
                plot([34.5 34.5],[0 10])
                ylim([0 2])
                hold off
            end
            close(f)
            if save_fig == 1
                cd eachWfig
                SaveFig(f,['eachW_trial' sprintf('%03d',t)])
                close all
                cd ../
            end
        end

    case 'ALL'
        W4plot = cell(synNum,1);
        Walt = zeros(length(W{1}(:,1)),Strial(1));
        for s = 1:synNum
            for t = 1:Strial(1)
%                 if 50 > max(abs(H{t}(s,:)))
                    Walt(:,t) = W{t}(:,s);
                    suc_trial(s,t) = t;
%                 end
            end
            W4plot{s} = Walt(:,find(any(Walt,1)));
        end
        SUC_trial_sel = cell(synNum,1);
        SUC_trial_common = find(prod(suc_trial(s,t)));
        for s = 1:synNum
            SUC_trial_sel{s} = find(suc_trial(s,:));
        end
        f = figure('Position',[0 0 1200 800]);
        Wave = zeros(length(W{1}(:,1)),synNum);
        Wstd = zeros(length(W{1}(:,1)),synNum);
        Wall = cell(1,synNum);
        Have = zeros(synNum,length(H{1}(1,:)));
        Hstd = zeros(synNum,length(H{1}(1,:)));
        Hall = cell(synNum,1);
        for s = 1:synNum
            %plot W
%             subplot(synNum,2,2*s-1)
%             bar(catX,W4plot{s},'FaceColor',col(s,:))
%             ylim([0 2])
            %plot H
%             subplot(synNum,2,2*s)
%             ylim([0 2])
            A4AVEalt_W = cell(length(SUC_trial_sel{s}),1);
            A4AVEalt_H = cell(length(SUC_trial_sel{s}),1);
            for t = 1:length(SUC_trial_sel{s})
%                 plot(H{t}(s,:),'Color',col(s,:),'LineWidth',1.5)
                A4AVEalt_W{t} = W{SUC_trial_sel{s}(t)}(:,s)';
                A4AVEalt_H{t} = H{SUC_trial_sel{s}(t)}(s,:);
                hold on
            end
            Wave(:,s) = mean(cell2mat(A4AVEalt_W)',2);
            Wstd(:,s) = std(cell2mat(A4AVEalt_W)',0,2);
            Wall{s} = cell2mat(A4AVEalt_W);
            Have(s,:) = mean(cell2mat(A4AVEalt_H));
            Hstd(s,:) = std(cell2mat(A4AVEalt_H),0,1);
            Hall{s} = cell2mat(A4AVEalt_H);
%             fi = fill([1:length(H{1}(1,:)) length(H{1}(1,:)):(-1):1],[Have(s,:)-Hstd(s,:) Have(s,end:(-1):1)+Hstd(s,end:(-1):1)],'g');
%             fi.FaceColor = col(s,:);
%             fi.FaceAlpha = 0.3;
%             plot(Have(s,:),'k','LineWidth',1.5)
%             plot([length(H{1}(1,:))/2 length(H{1}(1,:))/2],[0 10],'g','LineWidth',1.5)
%             ylim([0 2])
%             hold off
        end
end

end
function [R] = calXcorr(Con,Tar)
% Scon = size(Con);
% Star = size(Tar);
% M = Scon(1);
% TarN = Star(2);
AltE = corrcoef([Con Tar]);
R = AltE(1,2:end);
      
end
function [newW,norder] = orderchange(conW,tarW,synN)
Result = zeros(synN,synN);
norder = zeros(1,synN);
for s = 1:synN
    Result(s,:) = calXcorr(conW(:,s),tarW);
    Res1to4 = sort(Result(s,:),'descend');
    norder(s) = find(Result(s,:)==Res1to4(1));
    for l=1:synN-1
        if s>1 & find(norder(1:s-1)==norder(s))
            norder(s) = find(Result(s,:)==Res1to4(l+1));
        else 
            break;
        end
    end
end
newW = tarW(:,norder);
end
function [newH]=normalizeH(H, baseTime)
%H : temporal synergy,(size should be (trials,time))
Hsize = size(H);
  if Hsize(2) == baseTime
      newH = H;
  elseif Hsize(2)<baseTime 
      newH = interpft(H,baseTime,2);
  else
      newH = resample(H',baseTime,Hsize(2))';
  end
end