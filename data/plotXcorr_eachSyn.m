%%
% this code was written for some figures put on paper(tendon transfer)
% finish these analysis below 
% >whole data Muscle Synergy analysis : 'SAVE4NMF.m', 'filtBat_SynNMFPre.m','makeEMGNMF_btcOya.m' or 'makeEMGNMF_btcUchida.m'
% >EMG analysis : 'runnningEasyfunc.m', 'plotTarget.m', 'calcXcorr.m', 'plotXcorr.m'
% >new Muscle Synergy analysis(with trigged data in specific time range) : 'SynergyAnalysis_Each.m', 'testWplot.m'
%15th, Oct, 2020, Naoki Uchida (Funato lab, UEC Tokyo) 
% please move 'data' directory to use this function
clear all;
%cd 'X:\document\Uchida\data'
%%
%%%% set monkey name %%%%
realname = 'Yachimun';
% realname = 'SesekiL';
FIX = 'W';
PLOT = 'H';
synDirectionXcorr = 'Synergy'; %Synergy:synergy vs synergy %EMG: 
filtNO5 = 1;
synNum = 4;
synStr = sprintf('%d',synNum);
trig = 2;
%%%%%%%%%%%%%%%%%%%%%%%%%

cd([realname '/easyData/P-DATA(NDfilt)']) %P-DATA

Pre = load(['XcorrData_eachSyn' synStr '_FIX' FIX 'pre_trig' sprintf('%d',trig) '.mat']);
Post = load(['XcorrData_eachSyn' synStr '_FIX' FIX 'post_trig' sprintf('%d',trig) '.mat']);

% CorrCombination = 'self';
CorrCombination = 'select';

plotStyle = 'Select'; %All/Select
LW = 1.3;%Line Width
FS = 14;%Font Size

switch realname
    case 'Yachimun'
        EMGs = {'FDP';'FDSprox';'FDSdist';'FCU';'PL';'FCR';'BRD';'ECR';'EDCprox';'EDCdist';'ED23';'ECU'};
        useddays = [17,18,19,20,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80];
        AVEPre4 = (Pre.Have4xcorr{1} + Pre.Have4xcorr{2} + Pre.Have4xcorr{3})./3;% + Pre.Have4xcorr{4})./4;
        if filtNO5 == 1
           %'DataSetForEachXcorr--.mat' contains the triggered data for cross-correlation analysis in each task timing
           load('DataSetForEachXcorr_80_EMG_Range2_NDfilt.mat','TrigData_Each');
           eval(['xEMG = TrigData_Each.T' sprintf('%d',trig) ';']); 
   %         load('ResultXcorr_Each_EMG_Range1.mat');
           %muscle synergy extracted with triggered data in target task timing(photocell on) trial by trial

              switch FIX
                 case 'W'
                    Pre.trialData = load(['synplot_results_syn' synStr '_pre_FIXW_trig' sprintf('%d',trig) '.mat'],'Wall','Hall');
                    Post.trialData = load(['synplot_results_syn' synStr '_post_FIXW_trig' sprintf('%d',trig) '.mat'],'Wall','Hall');
                    selectSyn.pre = ['syn4';'syn2';'syn1'; 'syn3'];% [extensor synergy; flexor synergy; BRD; others]
                    selectSyn.post = ['syn4';'syn2';'syn1'; 'syn3'];% [extensor synergy; flexor synergy]
                 case 'H'
                    Pre.trialData = load(['synplot_results_syn' synStr '_pre_FIXH_trig' sprintf('%d',trig) '.mat'],'Wall','Hall','Wt');
                    Post.trialData = load(['synplot_results_syn' synStr '_post_FIXH_trig' sprintf('%d',trig) '.mat'],'Wall','Hall','Wt');
                    Pre.FIXW = load(['synplot_results_syn' synStr '_pre_FIXW_trig' sprintf('%d',trig) '.mat'],'Wt');
                    Post.FIXW = load(['synplot_results_syn' synStr '_post_FIXW_trig' sprintf('%d',trig) '.mat'],'Wt');
                    selectSyn.pre = ['syn4';'syn2';'syn1'; 'syn3'];% [extensor synergy; flexor synergy]
                    selectSyn.post = ['syn4';'syn2';'syn1'; 'syn3'];% [extensor synergy; flexor synergy]
                 case 'Nday'
                    Pre.trialData = load(['synplot_results_syn' synStr '_pre_FIXNday_trig' sprintf('%d',trig) '.mat'],'Wall','Hall');
                    Post.trialData = load(['synplot_results_syn' synStr '_post_FIXNday_trig' sprintf('%d',trig) '.mat'],'Wall','Hall');
                    selectSyn.pre = ['syn4';'syn2';'syn3'; 'syn1'];% [extensor synergy; flexor synergy]
                    selectSyn.post = ['syn2';'syn1';'syn3'; 'syn4'];% [extensor synergy; flexor synergy]
                 case 'N'
                    Pre.trialData = load(['synplot_results_syn' synStr '_pre_FIXN_trig' sprintf('%d',trig) '.mat'],'Wall','Hall');
                    Post.trialData = load(['synplot_results_syn' synStr '_post_FIXN_trig' sprintf('%d',trig) '.mat'],'Wall','Hall');
                    selectSyn.pre = ['syn4';'syn2'];% [extensor synergy; flexor synergy]
                    selectSyn.post = ['syn1';'syn2'];% [extensor synergy; flexor synergy]
              end
           else
   %         synNum = 4;
           load('DataSetForEachXcorr_80_EMG_Range2_plusTrial.mat','TrigData_Each');
           eval(['xEMG = TrigData_Each.T' sprintf('%d',trig) ';']); 
   %         load('ResultXcorr_Each_EMG_Range2.mat');
           switch FIX
              case 'W'
                 Pre.trialData = load(['WHtrialAll_syn' synStr '_pre_nnmffunc_prenormalizedcon_FIXWnorm.mat']);
                 Post.trialData = load(['WHtrialAll_syn' synStr '_post_nnmffunc_prenormalizedcon_FIXW47norm.mat']);
              case 'H'
                 Pre.trialData = load(['synplot_results_syn' synStr '_pre_nnmffunc_prenormalizedcon_FIXHrev2.mat'],'Wall','Hall');
                 Post.trialData = load(['synplot_results_syn' synStr '_post_nnmffunc_prenormalizedcon_FIXH47rev2.mat'],'Wall','Hall');
                 Pre.FIXW = load(['synplot_results_syn' synStr '_pre_nnmffunc_prenormalizedcon_FIXW.mat'],'Wt');
                 Post.FIXW = load(['synplot_results_syn' synStr '_post_nnmffunc_prenormalizedcon_FIXW47.mat'],'Wt');
              case 'N'
                 Pre.trialData = load(['synplot_results_syn' synStr '_pre_nnmffunc_prenormalizedcon_FIXHrev2.mat'],'Wall','Hall');
                 Post.trialData = load(['synplot_results_syn' synStr '_post_nnmffunc_prenormalizedcon_FIXH47rev2.mat'],'Wall','Hall');
           end
        end
        L.pre = 3;% 4;
%         selectSyn = ['syn4';'syn2'];% [extensor synergy; flexor synergy]
        selectEMGe = {'EDCdist';'ED23';'ECU'};%extensors synergy (syn3)
        selectEMGf = {'FDSdist';'FDSprox';'FCU'};%flexors synergy (syn)
%         selectEMGe = {'BRD';'ECR';'EDCprox'};%pulling synergy (syn)
%         selectEMGf = {'FCR';'PL'};%wrist flexors synergy (syn4)
        catEMGe=categorical(selectEMGe);
        catEMGf=categorical(selectEMGf);
    case 'SesekiL'
        EMGs = {'EDC';'ED23';'ED45';'ECU';'ECR';'Deltoid';'FDS';'FDP';'FCR';'FCU';'PL';'BRD'};
        AVEPre4 = (Pre.Have4xcorr{1} + Pre.Have4xcorr{2} + Pre.Have4xcorr{3})./3;
        trig = 3;
        if filtNO5 == 1
        %'DataSetForEachXcorr--.mat' contains the triggered data for cross-correlation analysis in each task timing
        load('DataSetForEachXcorr_28_EMG_Range1_NDfilt.mat','TrigData_Each');
        eval(['xEMG = TrigData_Each.T' sprintf('%d',trig) ';']); 
%         load('ResultXcorr_Each_EMG_Range1.mat');
        %muscle synergy extracted with triggered data in target task timing(photocell on) trial by trial
        
           switch FIX
              case 'W'
                 Pre.trialData = load(['synplot_results_syn' synStr '_pre_FIXW_trig' sprintf('%d',trig) '.mat'],'Wall','Hall');
                 Post.trialData = load(['synplot_results_syn' synStr '_post25_FIXW_trig' sprintf('%d',trig) '.mat'],'Wall','Hall');
                 switch synNum
                    case 3
                       selectSyn.pre = ['syn1';'syn3';'syn2'];% [extensor synergy; flexor synergy]
                       selectSyn.post = ['syn1';'syn3';'syn2'];% [extensor synergy; flexor synergy]
                    case 4
                       selectSyn.pre = ['syn2';'syn1';'syn3';'syn4'];% [extensor synergy; flexor synergy]
                       selectSyn.post = ['syn2';'syn1';'syn3';'syn4'];% [extensor synergy; flexor synergy]
                 end
              case 'H'
                 Pre.trialData = load(['synplot_results_syn' synStr '_pre_FIXH_trig' sprintf('%d',trig) '.mat'],'Wall','Hall','Wt');
                 Post.trialData = load(['synplot_results_syn' synStr '_post25_FIXH_trig' sprintf('%d',trig) '.mat'],'Wall','Hall','Wt');
                 Pre.FIXW = load(['synplot_results_syn' synStr '_pre_FIXW_trig' sprintf('%d',trig) '.mat'],'Wt');
                 Post.FIXW = load(['synplot_results_syn' synStr '_post25_FIXW_trig' sprintf('%d',trig) '.mat'],'Wt');
                 switch synNum
                    case 3
                       selectSyn.pre = ['syn1';'syn3';'syn2'];% [extensor synergy; flexor synergy]
                       selectSyn.post = ['syn1';'syn3';'syn2'];% [extensor synergy; flexor synergy]
                    case 4
                       selectSyn.pre = ['syn2';'syn1';'syn3';'syn4'];% [extensor synergy; flexor synergy]
                       selectSyn.post = ['syn2';'syn1';'syn3';'syn4'];% [extensor synergy; flexor synergy]
                 end
              case 'Nday'
                 Pre.trialData = load(['synplot_results_syn' synStr '_pre_FIXNday_trig' sprintf('%d',trig) '.mat'],'Wall','Hall');
                 Post.trialData = load(['synplot_results_syn' synStr '_post25_FIXNday_trig' sprintf('%d',trig) '.mat'],'Wall','Hall');
                 switch synNum
                    case 3
                       selectSyn.pre = ['syn3';'syn2';'syn1'];% [extensor synergy; flexor synergy]
                       selectSyn.post = ['syn1';'syn2';'syn3'];% [extensor synergy; flexor synergy]
                    case 4
                       selectSyn.pre = ['syn2';'syn1';'syn3';'syn4'];% [extensor synergy; flexor synergy]
                       selectSyn.post = ['syn1';'syn2';'syn3';'syn4'];% [extensor synergy; flexor synergy]
                 end
              case 'N'
                 Pre.trialData = load(['synplot_results_syn' synStr '_pre_FIXN_trig' sprintf('%d',trig) '.mat'],'Wall','Hall');
                 Post.trialData = load(['synplot_results_syn' synStr '_post25_FIXN_trig' sprintf('%d',trig) '.mat'],'Wall','Hall');
                 switch synNum
                    case 3
                       selectSyn.pre = ['syn3';'syn2'];% [extensor synergy; flexor synergy]
                       selectSyn.post = ['syn1';'syn2'];% [extensor synergy; flexor synergy]
                    case 4
                       selectSyn.pre = ['syn2';'syn1'];% [extensor synergy; flexor synergy]
                       selectSyn.post = ['syn1';'syn2'];% [extensor synergy; flexor synergy]
                 end
           end
        else
           %'DataSetForEachXcorr--.mat' contains the triggered data for cross-correlation analysis in each task timing
           load('DataSetForEachXcorr_28_EMG_Range1_plusTrial.mat','TrigData_Each');
           eval(['xEMG = TrigData_Each.T' sprintf('%d',trig) ';']); 
           switch FIX
              case 'W'
                 Pre.trialData = load(['WHtrialAll_syn' synStr '_pre_nnmffunc_prenormalizedcon_filt2_FIXWnorm.mat']);
                 Post.trialData = load(['WHtrialAll_syn' synStr '_post14_nnmffunc_prenormalizedcon_filt2_FIXWnorm.mat']);
              case 'H'
                 Pre.trialData = load(['synplot_results_syn' synStr '_pre_nnmffunc_prenormalizedcon_filt2_FIXHrev2.mat'],'Wall','Hall','Wt');
                 Post.trialData = load(['synplot_results_syn' synStr '_post25_nnmffunc_prenormalizedcon_filt2_FIXHrev2.mat'],'Wall','Hall','Wt');
                 Pre.FIXW = load(['synplot_results_syn' synStr '_pre_nnmffunc_prenormalizedcon_filt2_FIXW.mat'],'Wt');
                 Post.FIXW = load(['synplot_results_syn' synStr '_post25_nnmffunc_prenormalizedcon_filt2_FIXW.mat'],'Wt');
           end
        end
        L.pre = length(Pre.Have4xcorr);
%         selectSyn = ['syn1';'syn3'];% [extensor synergy; flexor synergy] for plot
%         selectEMGe = {'EDC';'ED23';'ED45'};%extensor synergies
        selectEMGe = {'EDC';'ED23';'ED45'};
        selectEMGf = {'PL';'FDP'};
        catEMGe=categorical(selectEMGe);
        catEMGf=categorical(selectEMGf);
end
emgNum = length(xEMG.AVEPre4(:,1));
tSyn.pre = str2num(selectSyn.pre(:,4))';
tSyn.post = str2num(selectSyn.post(:,4))';
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%% calculate Xcorr with 'Each trigged Synergy' data %%%%%%%%%%%%%%%%%%%%%%%%%%%
%synergy Pre & Post 
L.post = length(Post.Have4xcorr);
ResultH.pre = cell(synNum,1); 
ResultH.post = cell(synNum,1); 
ResultH.pre_trial = cell(synNum,1); 
ResultH.post_trial = cell(synNum,1); 
Rh.pre = zeros(synNum,L.pre);
Rh.post = zeros(synNum,L.post);
Rh.pre_trial = cell(1,L.pre);
Rh.post_trial = cell(1,L.post);
ResultH.pre_std = cell(synNum,1); 
ResultH.post_std = cell(synNum,1); 
Rh.pre_std = zeros(synNum,L.pre);
Rh.post_std = zeros(synNum,L.post);

%pre transfer data
for S = 1:synNum %synergy loop 
   for d = 1:L.pre %session loop
      Rh.pre_trial{d} = zeros(synNum,length(Pre.trialData.Hall{d}{1}(:,1)));
      for s = 1:synNum %synergy loop(control)
%          AltE = corrcoef(Pre.Have4xcorr{d}(M,:)', AVEPre4(m,:)');
%          R.pre(m,d) = AltE(1,2);
         AltE = corrcoef([AVEPre4(tSyn.pre(s),:)' resample(Pre.trialData.Hall{d}{tSyn.pre(S)}',length(AVEPre4(tSyn.pre(s),:)),length(Pre.trialData.Hall{d}{tSyn.pre(S)}(1,:)))]);
         Rh.pre(tSyn.pre(s),d) = mean(AltE(1,2:end));
         Rh.pre_std(tSyn.pre(s),d) = std(AltE(1,2:end));
         Rh.pre_trial{d}(tSyn.pre(s),:) = AltE(1,2:end);
      end   
   end
   ResultH.pre{tSyn.pre(S)} = Rh.pre;
   ResultH.pre_std{tSyn.pre(S)} = Rh.pre_std;
   ResultH.pre_trial{tSyn.pre(S)} = Rh.pre_trial;
end
%post transfer data
for S = 1:synNum %synergy loop (post synergy)
   for d = 1:L.post %session loop
      Rh.post_trial{d} = zeros(synNum,length(Post.trialData.Hall{d}{1}(:,1)));
      for s = 1:synNum %synergy loop(control)
%          AltE = corrcoef(Post.Have4xcorr{d}(M,:)', AVEPre4(m,:)');
%          R.post(m,d) = AltE(1,2);
         AltE = corrcoef([AVEPre4(tSyn.pre(s),:)' resample(Post.trialData.Hall{d}{tSyn.post(S)}',length(AVEPre4(tSyn.pre(s),:)),length(Post.trialData.Hall{d}{tSyn.post(S)}(1,:)))]);
         Rh.post(tSyn.pre(s),d) = mean(AltE(1,2:end));
         Rh.post_std(tSyn.pre(s),d) = std(AltE(1,2:end));
         Rh.post_trial{d}(tSyn.pre(s),:) = AltE(1,2:end);
      end   
   end
   ResultH.post{tSyn.post(S)} = Rh.post;
   ResultH.post_std{tSyn.post(S)} = Rh.post_std;
   ResultH.post_trial{tSyn.post(S)} = Rh.post_trial;
end

% % %plot ALL trials ALL sessions Cross-correlation (synergy)
% % for S = 1:synNum
% %    figure;
% %    for s = 1:synNum
% %       subplot(1,synNum,s)
% %       xLs = 1;
% %       xLe = 0;
% %       for d = 1:L.pre
% %       xLe = xLe + length(ResultH.pre_trial{S}{d}(s,:));
% %       plot(xLs:xLe,ResultH.pre_trial{S}{d}(s,:))
% %       hold on
% %       xLs = xLs + length(ResultH.pre_trial{S}{d}(s,:));
% %       end
% %       plot([xLe xLe],[0 1],'k', 'LineWidth',1.3)
% %       for d = 1:L.post
% %       xLe = xLe + length(ResultH.post_trial{S}{d}(s,:));
% %       plot(xLs:xLe,ResultH.post_trial{S}{d}(s,:))
% %       hold on
% %       xLs = xLs + length(ResultH.post_trial{S}{d}(s,:));
% %       end
% %       ylim([-1 1])
% %       xlim([0 xLe])
% %       title(['control Synergy' sprintf('%d',s) ' vs pre & post Synergy' sprintf('%d',S)])
% %    end
% %    ylabel('Cross-correlation coefficient')
% %    xlabel('ALL TRIALS')
% %    xlabel('ALL TRIALS (ALL SESSIONS)')
% %    title([realname ' Pre and Post FIX' FIX ' (eachTrial Synergy, synNum = ' synStr ')'])
% % end
xxdays_post = Post.xdays(end-L.post+1:end);
% tSyn.pre = str2num(selectSyn.pre(:,4))';
% tSyn.post = str2num(selectSyn.post(:,4))';

switch FIX
   case {'H', 'Nday', 'N'}
      ResultW.pre = cell(synNum,1); 
      ResultW.post = cell(synNum,1); 
      Rw.pre = zeros(synNum,L.pre);
      Rw.post = zeros(synNum,L.post);
      ResultW.pre_std = cell(synNum,1); 
      ResultW.post_std = cell(synNum,1); 
      Rw.pre_std = zeros(synNum,L.pre);
      Rw.post_std = zeros(synNum,L.post);
      AltW = zeros(Pre.EMGn,synNum,L.pre);
      for d = 1:L.pre
         AltW(:,:,d)= Pre.Wave{d};
      end
      controlW = mean(AltW,3);
      %pre transfer data
      for S = 1:synNum %synergy loop 
         for d = 1:L.pre %session loop
            for s = 1:synNum %synergy loop(control)
   %             AltE = corrcoef([Pre.FIXW.Wt(:,s) Pre.trialData.Wall{d}{S}']);
               AltE = corrcoef([controlW(:,tSyn.pre(s)) Pre.trialData.Wall{d}{tSyn.pre(S)}']);
               Rw.pre(tSyn.pre(s),d) = mean(AltE(1,2:end));
               Rw.pre_std(tSyn.pre(s),d) = std(AltE(1,2:end));
            end   
         end
         ResultW.pre{tSyn.pre(S)} = Rw.pre;
         ResultW.pre_std{tSyn.pre(S)} = Rw.pre_std;
      end
      %post transfer data
      for S = 1:synNum %synergy loop (post synergy)
         for d = 1:L.post %session loop
            for s = 1:synNum %synergy loop(control)
   %             AltE = corrcoef([Post.FIXW.Wt(:,s) Post.trialData.Wall{d}{S}']);
               AltE = corrcoef([controlW(:,tSyn.pre(s)) Post.trialData.Wall{d}{tSyn.post(S)}']);
               Rw.post(tSyn.pre(s),d) = mean(AltE(1,2:end));
               Rw.post_std(tSyn.pre(s),d) = std(AltE(1,2:end));
            end   
         end
         ResultW.post{tSyn.post(S)} = Rw.post;
         ResultW.post_std{tSyn.post(S)} = Rw.post_std;
      end
   otherwise
      
end
%%%%%%%% calc different direction cross-correlation about spatial synergy %%%%%%%%
switch FIX
   case {'H', 'Nday', 'N'}
      ResultWdirec.pre = cell(Pre.EMGn,1); 
      ResultWdirec.post = cell(Pre.EMGn,1); 
      RwDirec.pre = zeros(Pre.EMGn,L.pre);
      RwDirec.post = zeros(Pre.EMGn,L.post);
      ResultWdirec.pre_std = cell(Pre.EMGn,1); 
      ResultWdirec.post_std = cell(Pre.EMGn,1); 
      RwDirec.pre_std = zeros(Pre.EMGn,L.pre);
      RwDirec.post_std = zeros(Pre.EMGn,L.post);
      AltW = zeros(Pre.EMGn,synNum,L.pre);
      for d = 1:L.pre
         AltW(:,:,d)= Pre.Wave{d};
      end
      controlW = mean(AltW,3);
      %pre transfer data
      Pre.trialData.WallDirec = cell(L.pre,1);
      switch synNum
         case 3
            for d = 1:L.pre
               Pre.trialData.WallDirec{d} = cell(Pre.EMGn,1);
               [ans1,ans2,ans3] = Pre.trialData.Wall{d}{:};
               for m = 1:Pre.EMGn
                  Pre.trialData.WallDirec{d}{m} = [ans1(:,m) ans2(:,m) ans3(:,m)]';
               end
            end
         case 4
            for d = 1:L.pre
               Pre.trialData.WallDirec{d} = cell(Pre.EMGn,1);
               [ans1,ans2,ans3,ans4] = Pre.trialData.Wall{d}{:};
               for m = 1:Pre.EMGn
                  Pre.trialData.WallDirec{d}{m} = [ans1(:,m) ans2(:,m) ans3(:,m) ans4(:,m)]';
               end
            end
      end
      for M = 1:Pre.EMGn %synergy loop 
         for d = 1:L.pre %session loop
            for m = 1:Pre.EMGn %synergy loop(control)
               AltE = corrcoef([controlW(m,:)' Pre.trialData.WallDirec{d}{M}]);
               RwDirec.pre(m,d) = mean(AltE(1,2:end));
               RwDirec.pre_std(m,d) = std(AltE(1,2:end));
            end   
         end
         ResultWdirec.pre{M} = RwDirec.pre;
         ResultWdirec.pre_std{M} = RwDirec.pre_std;
      end
      %post transfer data
      Post.trialData.WallDirec = cell(L.pre,1);
      switch synNum
         case 3
            for d = 1:L.post
               Post.trialData.WallDirec{d} = cell(Pre.EMGn,1);
               [ans1,ans2,ans3] = Post.trialData.Wall{d}{:};
               for m = 1:Pre.EMGn
                  Post.trialData.WallDirec{d}{m} = [ans1(:,m) ans2(:,m) ans3(:,m)]';
               end
            end
         case 4
            for d = 1:L.post
               Post.trialData.WallDirec{d} = cell(Pre.EMGn,1);
               [ans1,ans2,ans3,ans4] = Post.trialData.Wall{d}{:};
               for m = 1:Pre.EMGn
                  Post.trialData.WallDirec{d}{m} = [ans1(:,m) ans2(:,m) ans3(:,m) ans4(:,m)]';
               end
            end
      end
      for M = 1:Pre.EMGn %synergy loop 
         for d = 1:L.post %session loop
            for m = 1:Pre.EMGn %synergy loop(control)
               AltE = corrcoef([controlW(m,:)' Post.trialData.WallDirec{d}{M}]);
               RwDirec.post(m,d) = mean(AltE(1,2:end));
               RwDirec.post_std(m,d) = std(AltE(1,2:end));
            end   
         end
         ResultWdirec.post{M} = RwDirec.post;
         ResultWdirec.post_std{M} = RwDirec.post_std;
      end
   otherwise
      
end

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%% calculate Xcorr with 'Each trigged EMG' data %%%%%%%%%%%%%%%%%%%%%%%%%%%

% emgNum = length(xEMG.AVEPre4(:,1));
L.allEMG = length(xEMG.data);
ResultH.allEMG = cell(emgNum,1); 
ResultH.allEMG_trial = cell(emgNum,1); 
Rh.allEMG = zeros(emgNum,L.allEMG);
Rh.allEMG_trial = cell(emgNum,L.allEMG);
ResultH.allEMG_std = cell(emgNum,1); 
Rh.allEMG_std = zeros(emgNum,L.allEMG);

for M = 1:emgNum %EMG loop (post EMG)
   for d = 1:L.allEMG %session loop
      for m = 1:emgNum %EMG loop(control)
%          AltE = corrcoef(xEMG.AVEPre4(m,:)',xEMG.data{d}(M,:)');
%          R.post(m,d) = AltE(1,2);
         AltE = corrcoef([xEMG.AVEPre4(m,:)' xEMG.trialdata{d}{M}']);
         Rh.allEMG(m,d) = mean(AltE(1,2:end));
         Rh.allEMG_std(m,d) = std(AltE(1,2:end));
         Rh.allEMG_trial{m,d} = AltE(1,2:end);
      end   
   end
   ResultH.allEMG{M} = Rh.allEMG;
   ResultH.allEMG_std{M} = Rh.allEMG_std;
   ResultH.allEMG_trial{M} = Rh.allEMG_trial;
end

%plot ALL trials ALL sessions Cross-correlation (EMG)
for M = 1:emgNum
   figure;
   for m = 1:emgNum
      subplot(3,emgNum/3,m)
      xLs = 1;
      xLe = 0;
      for d = 1:L.allEMG
         xLe = xLe + length(ResultH.allEMG_trial{M}{m,d});
         plot(xLs:xLe,ResultH.allEMG_trial{M}{m,d});
         hold on
         xLs = xLs + length(ResultH.allEMG_trial{M}{m,d});
      end
%       plot([xLe xLe],[0 1],'k', 'LineWidth',1.3)
%       for d = 1:L.post
%       xLe = xLe + length(ResultH.allEMG_trial{M}{m,d});
%       plot(xLs:xLe,ResultH.allEMG_trial{M}{m,d}(s,:))
%       hold on
%       xLs = xLs + length(ResultH.allEMG_trial{M}{m,d});
%       end
      ylim([-1 1])
      xlim([0 xLe])
      title(['control' EMGs{m} ' vs pre & post ' EMGs{M}])
   end
   ylabel('Cross-correlation coefficient')
   xlabel('ALL TRIALS')
   xlabel('ALL TRIALS (ALL SESSIONS)')
   title([realname ' Pre and Post FIX' EMGs{M} ' (eachTrial EMG, emgNum = ' sprintf('%d',emgNum) ')'])
end

%%
%%%%%%%%%%%%%%calculate the cross-correlation value between EMG and reconstructed EMG by muscle synergy %%%%%%%%%%%%%%%%%
%averaged data
%extensors
for se = 1:length(selectEMGe)
    Mnumall = find(Post.catXall==catEMGe(se));
    Mnum = find(Post.catX==catEMGe(se));
    for d = 1:L.pre+L.post
        if d<=L.pre
            day = find(Pre.xdays == Pre.xPre4days(d));
            AltE = corrcoef(resample(xEMG.data{day}(Mnumall,:)',length(Pre.reconEMG{d}(Mnum,:)),length(xEMG.data{day}(Mnumall,:))), Pre.reconEMG{d}(Mnum,:)');
            R.reconex(se,d) = AltE(1,2);
        else
            day = find(Post.xdays == xxdays_post(d-L.pre));
            AltE = corrcoef(resample(xEMG.data{day}(Mnumall,:)',length(Post.reconEMG{d-L.pre}(Mnum,:)),length(xEMG.data{day}(Mnumall,:))), Post.reconEMG{d-L.pre}(Mnum,:)');
            R.reconex(se,d) = AltE(1,2);
        end
    end
    R.reconex_sub(se,:) = R.reconex(se,:) - mean(R.reconex(se,1:L.pre));
end
% flexors
for se = 1:length(selectEMGf)
    Mnumall = find(Post.catXall==catEMGf(se));
    Mnum = find(Post.catX==catEMGf(se));
    for d = 1:L.pre+L.post
        if d<=L.pre
            day = find(Pre.xdays == Pre.xPre4days(d));
            AltE = corrcoef(resample(xEMG.data{day}(Mnumall,:)',length(Pre.reconEMG{d}(Mnum,:)),length(xEMG.data{day}(Mnumall,:))), Pre.reconEMG{d}(Mnum,:)');
            R.reconfx(se,d) = AltE(1,2);
        else
            day = find(Post.xdays == xxdays_post(d-L.pre));
            AltE = corrcoef(resample(xEMG.data{day}(Mnumall,:)',length(Post.reconEMG{d-L.pre}(Mnum,:)),length(xEMG.data{day}(Mnumall,:))), Post.reconEMG{d-L.pre}(Mnum,:)');
            R.reconfx(se,d) = AltE(1,2);
        end
    end
    R.reconfx_sub(se,:) = R.reconfx(se,:) - mean(R.reconfx(se,1:L.pre));
end

% trial data
%extensors
for se = 1:length(selectEMGe)
    Mnumall = find(Post.catXall==catEMGe(se));
    Mnum = find(Post.catX==catEMGe(se));
    for d = 1:L.pre+L.post
        if d<=L.pre
            day = find(Pre.xdays == Pre.xPre4days(d));
            AltE = corrcoef([resample(xEMG.trialdata{day}{Mnumall}',length(Pre.reconEMGall{d}{Mnum}(1,:)),length(xEMG.trialdata{day}{Mnumall}(1,:))) Pre.reconEMGall{d}{Mnum}']);
            AltAltE = diag(AltE(:,length(Pre.reconEMGall{d}{Mnum,:}(:,1))+1:end));
            R.reconexTrial(se,d) = mean(AltAltE);
            R.reconexTrial_std(se,d) = std(AltAltE);
        else
            day = find(Post.xdays == xxdays_post(d-L.pre));
            AltE = corrcoef([resample(xEMG.trialdata{day}{Mnumall}',length(Post.reconEMGall{d-L.pre}{Mnum}(1,:)),length(xEMG.trialdata{day}{Mnumall}(1,:))) Post.reconEMGall{d-L.pre}{Mnum}']);
            AltAltE = diag(AltE(:,length(Post.reconEMGall{d-L.pre}{Mnum,:}(:,1))+1:end));
            R.reconexTrial(se,d) = mean(AltAltE);
            R.reconexTrial_std(se,d) = std(AltAltE);
        end
    end
    R.reconexTrial_sub(se,:) = R.reconexTrial(se,:);% - mean(R.reconexTrial(se,1:L.pre));
end
% flexors
for se = 1:length(selectEMGf)
    Mnumall = find(Post.catXall==catEMGf(se));
    Mnum = find(Post.catX==catEMGf(se));
    for d = 1:L.pre+L.post
        if d<=L.pre
            day = find(Pre.xdays == Pre.xPre4days(d));
            AltE = corrcoef([resample(xEMG.trialdata{day}{Mnumall}',length(Pre.reconEMGall{d}{Mnum}(1,:)),length(xEMG.trialdata{day}{Mnumall}(1,:))) Pre.reconEMGall{d}{Mnum}']);
            AltAltE = diag(AltE(:,length(Pre.reconEMGall{d}{Mnum,:}(:,1))+1:end));
            R.reconfxTrial(se,d) = mean(AltAltE);
            R.reconfxTrial_std(se,d) = std(AltAltE);
        else
            day = find(Post.xdays == xxdays_post(d-L.pre));
            AltE = corrcoef([resample(xEMG.trialdata{day}{Mnumall}',length(Post.reconEMGall{d-L.pre}{Mnum}(1,:)),length(xEMG.trialdata{day}{Mnumall}(1,:))) Post.reconEMGall{d-L.pre}{Mnum}']);
            AltAltE = diag(AltE(:,length(Post.reconEMGall{d-L.pre}{Mnum,:}(:,1))+1:end));
            R.reconfxTrial(se,d) = mean(AltAltE);
            R.reconfxTrial_std(se,d) = std(AltAltE);
        end
    end
    R.reconfxTrial_sub(se,:) = R.reconfxTrial(se,:);% - mean(R.reconfxTrial(se,1:L.pre));
end

%% make plot figures
%%%%%%%%%%%%%%%%%%%%%%%%%
FILcon = cell(1,synNum); % cell variable for putting 'fill' object(pre transfer and task disable). when this program make legend, this will  works
FILdis = cell(1,synNum); 
PLT = cell(emgNum,synNum);% cell variable for putting 'plot' object. when this program make legend, this will works
Pos1 = [660 420 650 530];
Pos2 = [1500 420 650 530];
count = 1;
sEMGname = [selectEMGe,selectEMGe];
for s = tSyn.pre(1:2)
   eval(['f' sprintf('%d',s) ' = figure(''Position'',Pos' sprintf('%d',count) ');'])
   eval(['ax' sprintf('%d',s) ' = axes;'])
   FILcon{1,s} = fill([Post.xPre4days Post.xPre4days(end:-1:1)],[ones(size(Post.xPre4days)) (-1).*ones(size(Post.xPre4days))],'k');
   FILcon{1,s}.FaceColor = [0.78 0.78 0.78];       % make the filled area
   FILcon{1,s}.EdgeColor = 'none'; 
%    for se = 1:length(selectEMGe)
%       eval(cell2mat(['f' sprintf('%d',s) sEMGname(se,count) ' = figure(''Position'',Pos' sprintf('%d',count) ');']))
%       eval(['ax' sprintf('%d',s) ' = axes;'])
%       FILcon{se,s} = fill([Post.xPre4days Post.xPre4days(end:-1:1)],[ones(size(Post.xPre4days)) (-1).*ones(size(Post.xPre4days))],'k');
%       FILcon{se,s}.FaceColor = [0.78 0.78 0.78];       % make the filled area
%       FILcon{se,s}.EdgeColor = 'none'; 
%    end
   count = count + 1;
end
%% plot EMG results
%%%%%%%%%%%%%%%%%%%%%%%%%%%

resEMGe = zeros(length(selectEMGe),length(ResultH.allEMG{1}(1,:)));
resEMGf = zeros(length(selectEMGf),length(ResultH.allEMG{1}(1,:)));
resEMGe_std = zeros(length(selectEMGe),length(ResultH.allEMG{1}(1,:)));
resEMGf_std = zeros(length(selectEMGf),length(ResultH.allEMG{1}(1,:)));

c = [0 0 1;1 0 0];
count = 1;
for s = tSyn.pre(1:2)
    eval(['figure(f' sprintf('%d',s) ');'])
    ylim([-1 1])
    xlim([Post.xPre4days(1) Post.xdays(end)])
    hold on;
    switch realname 
        case 'Yachimun'
            switch count
                case 1 %finger extensors
                    for se = 1:length(selectEMGe)
%                         eval(cell2mat(['figure(f' sprintf('%d',s) sEMGname(se,count) ');']))
%                         ylim([-1 1])
%                         xlim([Post.xPre4days(1) Post.xdays(end)])
                        Mnum = find(Post.catXall==catEMGe(se));
%                         eval(['resEMGe(se,:) = ResE.T' sprintf('%d',trig) '{Mnum}(Mnum,:);'])%AVERAGE DATA
                        resEMGe(se,:) = ResultH.allEMG{Mnum}(Mnum,:);%Ave(control) vs Trial(Pre+Post)
                        resEMGe_std(se,:) = ResultH.allEMG_std{Mnum}(Mnum,:);%Ave(control) vs Trial(Pre+Post)
                        fi = fill([Post.xdays Post.xdays(end:-1:1)],[resEMGe(se,:)-resEMGe_std(se,:) resEMGe(se,end:-1:1)+resEMGe_std(se,end:-1:1)],'k');
                        fi.FaceColor = c(1,:)+[0 (1/length(selectEMGe))*se 0];       % make the filled area
                        fi.FaceAlpha = 0.2;
                        fi.EdgeColor = 'none'; 
                        hold on;
                        PLT{se,s} = plot(Post.xdays,resEMGe(se,:),'LineWidth',LW,'Color', c(1,:)+[0 (1/length(selectEMGe))*se 0]);
                        title('extensors and synergy','FontSize',FS)
                    end
                case 2 % finger flexors
                    for se = 1:length(selectEMGf)
%                         eval(cell2mat(['figure(f' sprintf('%d',s) sEMGname(se,count) ');']))
%                         ylim([-1 1])
%                         xlim([Post.xPre4days(1) Post.xdays(end)])
                        Mnum = find(Post.catXall==catEMGf(se));
%                         eval(['resEMGf(se,:) = ResE.T' sprintf('%d',trig) '{Mnum}(Mnum,:);'])%AVERAGE DATA
                        resEMGf(se,:) = ResultH.allEMG{Mnum}(Mnum,:);%Ave(control) vs Trial(Pre+Post)
                        resEMGf_std(se,:) = ResultH.allEMG_std{Mnum}(Mnum,:);%Ave(control) vs Trial(Pre+Post)
                        fi = fill([Post.xdays Post.xdays(end:-1:1)],[resEMGf(se,:)-resEMGf_std(se,:) resEMGf(se,end:-1:1)+resEMGf_std(se,end:-1:1)],'k');
                        fi.FaceColor = c(2,:)+[0 (1/length(selectEMGe))*se 0];       % make the filled area
                        fi.FaceAlpha = 0.2;
                        fi.EdgeColor = 'none'; 
                        hold on;
                        PLT{se,s} = plot(Post.xdays,resEMGf(se,:),'LineWidth',LW,'Color',c(2,:)+[0 (1/length(selectEMGe))*se 0]);
                        title('flexors and synergy','FontSize',FS)
                    end
            end
        case 'SesekiL'
            switch count
                case 1 %finger extensors
                    for se = 1:length(selectEMGe)
%                         eval(cell2mat(['figure(f' sprintf('%d',s) sEMGname(se,count) ');']))
%                         ylim([-1 1])
%                         xlim([Post.xPre4days(1) Post.xdays(end)])
                        Mnum = find(Post.catXall==catEMGe(se));
                        eval(['resEMGe(se,:) = ResE.T' sprintf('%d',trig) '{Mnum}(Mnum,:);'])%AVERAGE DATA
%                         resEMGe(se,:) = ResultH.allEMG{Mnum}(Mnum,:);%Ave(control) vs Trial(Pre+Post)
                        resEMGe_std(se,:) = ResultH.allEMG_std{Mnum}(Mnum,:);%Ave(control) vs Trial(Pre+Post)
                        fi = fill([Post.xdays Post.xdays(end:-1:1)],[resEMGe(se,:)-resEMGe_std(se,:) resEMGe(se,end:-1:1)+resEMGe_std(se,end:-1:1)],'k');
                        fi.FaceColor = c(1,:)+[0 (1/length(selectEMGe))*se 0];       % make the filled area
                        fi.FaceAlpha = 0.2;
                        fi.EdgeColor = 'none'; 
                        hold on;
                        PLT{se,s} = plot(Post.xdays,resEMGe(se,:),'LineWidth',LW,'Color', c(1,:)+[0 (1/length(selectEMGe))*se 0]);
%                         plot(Post.xPre4days,resEMGe(se,1:L.pre),'LineWidth',LW,'Color', c(1,:)+[0 (1/length(selectEMGe))*se 0])
%                         plot(xxdays_post,resEMGe(se,end-L.post+1:end),'LineWidth',LW,'Color', c(1,:)+[0 (1/length(selectEMGe))*se 0])
                        title('extensors and synergy','FontSize',FS)
                    end
                case 2 % finger flexors
                    for se = 1:length(selectEMGf)
%                         eval(cell2mat(['figure(f' sprintf('%d',s) sEMGname(se,count) ');']))
%                         ylim([-1 1])
%                         xlim([Post.xPre4days(1) Post.xdays(end)])
                        Mnum = find(Post.catXall==catEMGf(se));
%                         eval(['resEMGf(se,:) = ResE.T' sprintf('%d',trig) '{Mnum}(Mnum,:);'])%AVERAGE DATA
                        resEMGf(se,:) = ResultH.allEMG{Mnum}(Mnum,:);%Ave(control) vs Trial(Pre+Post)
                        resEMGf_std(se,:) = ResultH.allEMG_std{Mnum}(Mnum,:);%Ave(control) vs Trial(Pre+Post)
                        fi = fill([Post.xdays Post.xdays(end:-1:1)],[resEMGf(se,:)-resEMGf_std(se,:) resEMGf(se,end:-1:1)+resEMGf_std(se,end:-1:1)],'k');
                        fi.FaceColor = c(2,:)+[0 (1/length(selectEMGe))*se 0];       % make the filled area
                        fi.FaceAlpha = 0.2;
                        fi.EdgeColor = 'none'; 
                        hold on;
                        PLT{se,s} = plot(Post.xdays,resEMGf(se,:),'LineWidth',LW,'Color', c(2,:)+[0 (1/length(selectEMGe))*se 0]);
                        title('flexors and synergy','FontSize',FS)
                    end
            end
    end
    count = count + 1;
end

%delete the cell boxes to put plot lines (non-selected EMGs)
empP = cellfun('isempty',PLT);
PLT(empP) = [];
%% plot synergy results
%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Post.xnoT = [-1 Post.xnoT Post.xnoT(end)+1];
Len = length(tSyn.pre(1:2));
switch PLOT
   case 'H'
      resSYN = zeros(Len,length(ResultH.pre{1}(1,:))+length(ResultH.post{1}(1,:)));
      resSYN_std = zeros(Len,length(ResultH.pre{1}(1,:))+length(ResultH.post{1}(1,:)));
      for s = 1:Len
          resSYN(s,:) = [ResultH.pre{tSyn.pre(s)}(tSyn.pre(s),:) ResultH.post{tSyn.post(s)}(tSyn.pre(s),:)];
          resSYN_std(s,:) = [ResultH.pre_std{tSyn.pre(s)}(tSyn.pre(s),:) ResultH.post_std{tSyn.post(s)}(tSyn.pre(s),:)];
      end
      sPLT = cell(size(tSyn));
      for s = 1:Len
          eval(['figure(f' sprintf('%d',tSyn.pre(s)) ');'])
          hold on;
      %     plot(xxdays_post,Result.post{s}(s,:),'LineWidth',LW,'Color',c(s,:))
          fi = fill([Post.xPre4days xxdays_post xxdays_post(end:-1:1) Post.xPre4days(end:-1:1)],[resSYN(s,:)-resSYN_std(s,:) resSYN(s,end:-1:1)+resSYN_std(s,end:-1:1)],'k');
          fi.FaceColor = c(s,:);       % make the filled area
          fi.FaceAlpha = 0.2;
          fi.EdgeColor = 'none'; 
          sPLT{s} = plot([Post.xPre4days xxdays_post],resSYN(s,:),'--','LineWidth',LW,'Color',c(s,:));
          FILdis{1,tSyn.pre(s)} = fill([Post.xnoT Post.xnoT(end:-1:1)],[ones(size(Post.xnoT)) (-1).*ones(size(Post.xnoT))],'k','LineWidth',1.2);
          FILdis{1,tSyn.pre(s)}.FaceColor = [1 1 1];       % make the filled area
          switch realname
             case 'Yachimun'
                Lg = legend([FILcon{1,tSyn.pre(s)} PLT{5+(-2)*s} PLT{6+(-2)*s} sPLT{s} FILdis{1,tSyn.pre(s)}],{'Control','EMG1','EMG2','Synergy','Task Disable'},'Location','southwest');
                set(Lg,...
                   'Position',[0.66 0.128 0.231 0.192],...
                   'FontSize',14);
             case 'SesekiL'
                Lg = legend([FILcon{1,tSyn.pre(s)} PLT{2*s-1} PLT{2*s} sPLT{s} FILdis{1,tSyn.pre(s)}],{'Control','EMG1','EMG2','Synergy','Task Disable'},'Location','southwest');
                set(Lg,...
                   'Position',[0.66 0.128 0.231 0.192],...
                   'FontSize',14);
          end
          ylabel('Cross-correlation coefficient','FontSize',18);
          xlabel('Post tendon transfer [days]','FontSize',18);
          eval(['ax' sprintf('%d',tSyn.pre(s)) '.FontSize = ' sprintf('%d',FS) ';'])
      end
   case 'W'
      switch synDirectionXcorr
         case 'Synergy'
            resSYN = zeros(Len,length(ResultW.pre{1}(1,:))+length(ResultW.post{1}(1,:)));
            resSYN_std = zeros(Len,length(ResultW.pre{1}(1,:))+length(ResultW.post{1}(1,:)));
            for s = 1:Len
                resSYN(s,:) = [ResultW.pre{tSyn.pre(s)}(tSyn.pre(s),:) ResultW.post{tSyn.post(s)}(tSyn.pre(s),:)];
                resSYN_std(s,:) = [ResultW.pre_std{tSyn.pre(s)}(tSyn.pre(s),:) ResultW.post_std{tSyn.post(s)}(tSyn.pre(s),:)];
            end
            sPLT = cell(size(tSyn));
            for s = 1:Len
                eval(['figure(f' sprintf('%d',tSyn.pre(s)) ');'])
                hold on;
            %     plot(xxdays_post,Result.post{s}(s,:),'LineWidth',LW,'Color',c(s,:))
                fi = fill([Post.xPre4days xxdays_post xxdays_post(end:-1:1) Post.xPre4days(end:-1:1)],[resSYN(s,:)-resSYN_std(s,:) resSYN(s,end:-1:1)+resSYN_std(s,end:-1:1)],'k');
                fi.FaceColor = c(s,:);       % make the filled area
                fi.FaceAlpha = 0.2;
                fi.EdgeColor = 'none'; 
                sPLT{s} = plot([Post.xPre4days xxdays_post],resSYN(s,:),'--','LineWidth',LW,'Color',c(s,:));
                FILdis{1,tSyn.pre(s)} = fill([Post.xnoT Post.xnoT(end:-1:1)],[ones(size(Post.xnoT)) (-1).*ones(size(Post.xnoT))],'k','LineWidth',1.2);
                FILdis{1,tSyn.pre(s)}.FaceColor = [1 1 1];       % make the filled area
                switch realname
                   case 'Yachimun'
                      Lg = legend([FILcon{1,tSyn.pre(s)} PLT{5+(-2)*s} PLT{6+(-2)*s} sPLT{s} FILdis{1,tSyn.pre(s)}],{'Control','EMG1','EMG2','Synergy','Task Disable'},'Location','southwest');
                      set(Lg,...
                         'Position',[0.66 0.128 0.231 0.192],...
                         'FontSize',14);
                   case 'SesekiL'
                      Lg = legend([FILcon{1,tSyn.pre(s)} PLT{2*s-1} PLT{2*s} sPLT{s} FILdis{1,tSyn.pre(s)}],{'Control','EMG1','EMG2','Synergy','Task Disable'},'Location','southwest');
                      set(Lg,...
                         'Position',[0.66 0.128 0.231 0.192],...
                         'FontSize',14);
                end
                ylabel('Cross-correlation coefficient','FontSize',18);
                xlabel('Post tendon transfer [days]','FontSize',18);
                eval(['ax' sprintf('%d',tSyn.pre(s)) '.FontSize = ' sprintf('%d',FS) ';'])
            end
         case 'EMG'
            %extensor
            eval(['figure(f' sprintf('%d',tSyn.pre(1)) ');'])
            resSYN.e = zeros(Len,length(ResultWdirec.pre{1}(1,:))+length(ResultWdirec.post{1}(1,:)));
            resSYN_std.e = zeros(Len,length(ResultWdirec.pre{1}(1,:))+length(ResultWdirec.post{1}(1,:)));
            for s = 1:length(selectEMGe)
                Mnum = find(Post.catX==catEMGe(s));
                resSYN.e(s,:) = [ResultWdirec.pre{Mnum}(Mnum,:) ResultWdirec.post{Mnum}(Mnum,:)];
                resSYN_std.e(s,:) = [ResultWdirec.pre_std{Mnum}(Mnum,:) ResultWdirec.post_std{Mnum}(Mnum,:)];
            end
            sPLT = cell(size(tSyn));
            for s = 1:length(selectEMGe)
                hold on;
            %     plot(xxdays_post,Result.post{s}(s,:),'LineWidth',LW,'Color',c(s,:))
                fi = fill([Post.xPre4days xxdays_post xxdays_post(end:-1:1) Post.xPre4days(end:-1:1)],[resSYN.e(s,:)-resSYN_std.e(s,:) resSYN.e(s,end:-1:1)+resSYN_std.e(s,end:-1:1)],'k');
                fi.FaceColor = c(1,:)+[0 (1/length(selectEMGe))*s 0];       % make the filled area
                fi.FaceAlpha = 0.2;
                fi.EdgeColor = 'none'; 
                sPLT{s} = plot([Post.xPre4days xxdays_post],resSYN.e(s,:),'--','LineWidth',LW,'Color',c(1,:)+[0 (1/length(selectEMGe))*s 0]);
                FILdis{1,Mnum} = fill([Post.xnoT Post.xnoT(end:-1:1)],[ones(size(Post.xnoT)) (-1).*ones(size(Post.xnoT))],'k','LineWidth',1.2);
                FILdis{1,Mnum}.FaceColor = [1 1 1];       % make the filled area
%                 switch realname
%                    case 'Yachimun'
%                       Lg = legend([FILcon{1,Mnum} PLT{5+(-2)*s} PLT{6+(-2)*s} sPLT{s} FILdis{1,Mnum}],{'Control','EMG1','EMG2','Synergy','Task Disable'},'Location','southwest');
%                       set(Lg,...
%                          'Position',[0.66 0.128 0.231 0.192],...
%                          'FontSize',14);
%                    case 'SesekiL'
%                       Lg = legend([FILcon{1,Mnum} PLT{2*s-1} PLT{2*s} sPLT{s} FILdis{1,Mnum}],{'Control','EMG1','EMG2','Synergy','Task Disable'},'Location','southwest');
%                       set(Lg,...
%                          'Position',[0.66 0.128 0.231 0.192],...
%                          'FontSize',14);
%                 end
                ylabel('Cross-correlation coefficient','FontSize',18);
                xlabel('Post tendon transfer [days]','FontSize',18);
                eval(['ax' sprintf('%d',tSyn.pre(s)) '.FontSize = ' sprintf('%d',FS) ';'])
            end
            %flexor
            eval(['figure(f' sprintf('%d',tSyn.pre(2)) ');'])
            resSYN.f = zeros(Len,length(ResultWdirec.pre{1}(1,:))+length(ResultWdirec.post{1}(1,:)));
            resSYN_std.f = zeros(Len,length(ResultWdirec.pre{1}(1,:))+length(ResultWdirec.post{1}(1,:)));
            for s = 1:length(selectEMGf)
                Mnum = find(Post.catX==catEMGf(s));
                resSYN.f(s,:) = [ResultWdirec.pre{Mnum}(Mnum,:) ResultWdirec.post{Mnum}(Mnum,:)];
                resSYN_std.f(s,:) = [ResultWdirec.pre_std{Mnum}(Mnum,:) ResultWdirec.post_std{Mnum}(Mnum,:)];
            end
            sPLT = cell(size(tSyn));
            for s = 1:length(selectEMGf)
                hold on;
            %     plot(xxdays_post,Result.post{s}(s,:),'LineWidth',LW,'Color',c(s,:))
                fi = fill([Post.xPre4days xxdays_post xxdays_post(end:-1:1) Post.xPre4days(end:-1:1)],[resSYN.f(s,:)-resSYN_std.f(s,:) resSYN.f(s,end:-1:1)+resSYN_std.f(s,end:-1:1)],'k');
                fi.FaceColor = c(2,:)+[0 (1/length(selectEMGf))*s 0];       % make the filled area
                fi.FaceAlpha = 0.2;
                fi.EdgeColor = 'none'; 
                sPLT{s} = plot([Post.xPre4days xxdays_post],resSYN.f(s,:),'--','LineWidth',LW,'Color',c(2,:)+[0 (1/length(selectEMGf))*s 0]);
                FILdis{1,Mnum} = fill([Post.xnoT Post.xnoT(end:-1:1)],[ones(size(Post.xnoT)) (-1).*ones(size(Post.xnoT))],'k','LineWidth',1.2);
                FILdis{1,Mnum}.FaceColor = [1 1 1];       % make the filled area
%                 switch realname
%                    case 'Yachimun'
%                       Lg = legend([FILcon{1,Mnum} PLT{5+(-2)*s} PLT{6+(-2)*s} sPLT{s} FILdis{1,Mnum}],{'Control','EMG1','EMG2','Synergy','Task Disable'},'Location','southwest');
%                       set(Lg,...
%                          'Position',[0.66 0.128 0.231 0.192],...
%                          'FontSize',14);
%                    case 'SesekiL'
%                       Lg = legend([FILcon{1,Mnum} PLT{2*s-1} PLT{2*s} sPLT{s} FILdis{1,Mnum}],{'Control','EMG1','EMG2','Synergy','Task Disable'},'Location','southwest');
%                       set(Lg,...
%                          'Position',[0.66 0.128 0.231 0.192],...
%                          'FontSize',14);
%                 end
                ylabel('Cross-correlation coefficient','FontSize',18);
                xlabel('Post tendon transfer [days]','FontSize',18);
                eval(['ax' sprintf('%d',tSyn.pre(s)) '.FontSize = ' sprintf('%d',FS) ';'])
            end
      end
      
end
%% check the cross-correlation with reconstructed EMG by muscle synergy 
%%%%%%%%%%%%%%%%%%%%%%%%%%%


%make fig
Pos1 = [660 420 650 530];
Pos2 = [1500 420 650 530];
count = 1;
for s = tSyn.pre(1:2)
    eval(['f' sprintf('%d',s+100) ' = figure(''Position'',Pos' sprintf('%d',count) ');'])
    eval(['ax' sprintf('%d',s+100) ' = axes;'])
    fi1 = fill([Post.xPre4days Post.xPre4days(end:-1:1)],[ones(size(Post.xPre4days)) (-1).*ones(size(Post.xPre4days))],'k');
    fi1.FaceColor = [0.78 0.78 0.78];       % make the filled area
    fi1.EdgeColor = 'none'; 
    count = count + 1;
end

%
count = 1;
for s = tSyn.pre(1:2)
    eval(['figure(f' sprintf('%d',s+100) ');'])
    ylim([-0.3 0.3])
    xlim([Post.xPre4days(1) Post.xdays(end)])
    hold on;
    switch realname 
        case 'Yachimun'
            switch count
                case 1 %finger extensors
                    for se = 1:length(selectEMGe)
                        fi = fill([Post.xPre4days xxdays_post xxdays_post(end:-1:1) Post.xPre4days(end:-1:1)],[R.reconexTrial_sub(se,:)-R.reconexTrial_std(se,:) R.reconexTrial_sub(se,end:-1:1)+R.reconexTrial_std(se,end:-1:1)],'k');
                        fi.FaceColor = c(1,:)+[0 (1/length(selectEMGe))*se 0];       % make the filled area
                        fi.FaceAlpha = 0.2;
                        fi.EdgeColor = 'none'; 
                        plot([Post.xPre4days xxdays_post],R.reconexTrial_sub(se,:),'LineWidth',LW,'Color', c(1,:)+[0 (1/length(selectEMGe))*se 0])
                        title('EMG and Reconstructed EMG','FontSize',FS)
                    end
                case 2 % finger flexors
                    for se = 1:length(selectEMGf)
                        fi = fill([Post.xPre4days xxdays_post xxdays_post(end:-1:1) Post.xPre4days(end:-1:1)],[R.reconfxTrial_sub(se,:)-R.reconfxTrial_std(se,:) R.reconfxTrial_sub(se,end:-1:1)+R.reconfxTrial_std(se,end:-1:1)],'k');
                        fi.FaceColor = c(2,:)+[0 (1/length(selectEMGf))*se 0];       % make the filled area
                        fi.FaceAlpha = 0.2;
                        fi.EdgeColor = 'none'; 
                        plot([Post.xPre4days xxdays_post],R.reconfxTrial_sub(se,:),'LineWidth',LW,'Color', c(2,:)+[0 (1/length(selectEMGf))*se 0])
                        title('EMG and Reconstructed EMG','FontSize',FS)
                    end
            end
        case 'SesekiL'
            switch count
                case 1 %finger extensors
                    for se = 1:length(selectEMGe)
                        fi = fill([Post.xdays Post.xdays(end:-1:1)],[R.reconexTrial_sub(se,:)-R.reconexTrial_std(se,:) R.reconexTrial_sub(se,end:-1:1)+R.reconexTrial_std(se,end:-1:1)],'k');
                        fi.FaceColor = c(1,:)+[0 (1/length(selectEMGe))*se 0];       % make the filled area
                        fi.FaceAlpha = 0.2;
                        fi.EdgeColor = 'none'; 
                        plot([Post.xPre4days xxdays_post],R.reconexTrial_sub(se,:),'LineWidth',LW,'Color', c(1,:)+[0 (1/length(selectEMGe))*se 0])
                        title('EMG and Reconstructed EMG','FontSize',FS)
                    end
                case 2 % finger flexors
                    for se = 1:length(selectEMGf)
                        fi = fill([Post.xdays Post.xdays(end:-1:1)],[R.reconfxTrial_sub(se,:)-R.reconfxTrial_std(se,:) R.reconfxTrial_sub(se,end:-1:1)+R.reconfxTrial_std(se,end:-1:1)],'k');
                        fi.FaceColor = c(2,:)+[0 (1/length(selectEMGf))*se 0];       % make the filled area
                        fi.FaceAlpha = 0.2;
                        fi.EdgeColor = 'none'; 
                        plot([Post.xPre4days xxdays_post],R.reconfxTrial_sub(se,:),'LineWidth',LW,'Color', c(2,:)+[0 (1/length(selectEMGf))*se 0])
                        title('EMG and Reconstructed EMG','FontSize',FS)
                    end
            end
    end
    count = count + 1;
end
count = 1;
for s = tSyn.pre(1:2)
    eval(['figure(f' sprintf('%d',s+100) ');'])
    hold on;
    fi2 = fill([Post.xnoT Post.xnoT(end:-1:1)],[ones(size(Post.xnoT)) (-1).*ones(size(Post.xnoT))],'k','LineWidth',1.2);
    fi2.FaceColor = [1 1 1];       % make the filled area
    Lg = legend({'Control','EMG1','EMG2','Task Disable'},'Location','southwest');
    set(Lg,...
      'Position',[0.66 0.71 0.231 0.192],...
      'FontSize',14);
    ylabel('Change of Cross-correlation coefficient','FontSize',18);
    xlabel('Post tendon transfer [days]','FontSize',18);
    eval(['ax' sprintf('%d',s+100) '.FontSize = ' sprintf('%d',FS) ';'])
end
%% different direction cross-correlation
%%%%%%%%%%%%%%%%%%%%%%%%%%%% calculate Xcorr with 'Each trigged Synergy' data %%%%%%%%%%%%%%%%%%%%%%%%%%%
%synergy Pre & Post 
switch FIX
   case {'H', 'Nday', 'N'}
      ResultWdirec.pre = cell(Pre.EMGn,1); 
      ResultWdirec.post = cell(Pre.EMGn,1); 
      RwDirec.pre = zeros(Pre.EMGn,L.pre);
      RwDirec.post = zeros(Pre.EMGn,L.post);
      ResultWdirec.pre_std = cell(Pre.EMGn,1); 
      ResultWdirec.post_std = cell(Pre.EMGn,1); 
      RwDirec.pre_std = zeros(Pre.EMGn,L.pre);
      RwDirec.post_std = zeros(Pre.EMGn,L.post);
      AltW = zeros(Pre.EMGn,synNum,L.pre);
      for d = 1:L.pre
         AltW(:,:,d)= Pre.Wave{d};
      end
      controlW = mean(AltW,3);
      %pre transfer data
      Mnum = find(Pre.catXall==catEMGe(se));
      Pre.trialData.WallDirec = cell(L.pre,1);
      switch synNum
         case 3
            for d = 1:L.pre
               Pre.trialData.WallDirec{d} = cell(Pre.EMGn,1);
               [ans1,ans2,ans3] = Pre.trialData.Wall{d}{:};
               for m = 1:Pre.EMGn
                  Pre.trialData.WallDirec{d}{m} = [ans1(:,m) ans2(:,m) ans3(:,m)]';
               end
            end
         case 4
            for d = 1:L.pre
               Pre.trialData.WallDirec{d} = cell(Pre.EMGn,1);
               [ans1,ans2,ans3,ans4] = Pre.trialData.Wall{d}{:};
               for m = 1:Pre.EMGn
                  Pre.trialData.WallDirec{d}{m} = [ans1(:,m) ans2(:,m) ans3(:,m) ans4(:,m)]';
               end
            end
      end
      for M = 1:Pre.EMGn %synergy loop 
         for d = 1:L.pre %session loop
            for m = 1:Pre.EMGn %synergy loop(control)
               AltE = corrcoef([controlW(m,:)' Pre.trialData.WallDirec{d}{M}]);
               RwDirec.pre(m,d) = mean(AltE(1,2:end));
               RwDirec.pre_std(m,d) = std(AltE(1,2:end));
            end   
         end
         ResultWdirec.pre{M} = RwDirec.pre;
         ResultWdirec.pre_std{M} = RwDirec.pre_std;
      end
      %post transfer data
      Post.trialData.WallDirec = cell(L.pre,1);
      switch synNum
         case 3
            for d = 1:L.post
               Post.trialData.WallDirec{d} = cell(Pre.EMGn,1);
               [ans1,ans2,ans3] = Post.trialData.Wall{d}{:};
               for m = 1:Pre.EMGn
                  Post.trialData.WallDirec{d}{m} = [ans1(:,m) ans2(:,m) ans3(:,m)]';
               end
            end
         case 4
            for d = 1:L.post
               Post.trialData.WallDirec{d} = cell(Pre.EMGn,1);
               [ans1,ans2,ans3,ans4] = Post.trialData.Wall{d}{:};
               for m = 1:Pre.EMGn
                  Post.trialData.WallDirec{d}{m} = [ans1(:,m) ans2(:,m) ans3(:,m) ans4(:,m)]';
               end
            end
      end
      for M = 1:Pre.EMGn %synergy loop 
         for d = 1:L.post %session loop
            for m = 1:Pre.EMGn %synergy loop(control)
               AltE = corrcoef([controlW(m,:)' Post.trialData.WallDirec{d}{M}]);
               RwDirec.post(m,d) = mean(AltE(1,2:end));
               RwDirec.post_std(m,d) = std(AltE(1,2:end));
            end   
         end
         ResultWdirec.post{M} = RwDirec.post;
         ResultWdirec.post_std{M} = RwDirec.post_std;
      end
   otherwise
      
end

%% check trials %%%%%%%
% % % load('eachSyncontrols_synN4_nnmffunc_normalizedPre_FIXWvaf.mat')
% % % figure;
% % % xLs = 1;
% % % xLe = 0;
% % % for d = 1:3
% % % xLe = xLe + length(Yall{d}.VAF);
% % % plot(xLs:xLe,cell2mat(Yall{d}.VAF))
% % % hold on
% % % xLs = xLs + length(Yall{d}.VAF);
% % % end
% % % load('eachSynPosts_synN4_nnmffunc_normalizedPre_FIXWvaf.mat')
% % % for d = 1:25
% % % xLe = xLe + length(Yall{d}.VAF);
% % % plot(xLs:xLe,cell2mat(Yall{d}.VAF))
% % % hold on
% % % xLs = xLs + length(Yall{d}.VAF);
% % % end
% % % ylim([0 1])
% % % plot([405 405],[0 1],'k', 'LineWidth',1.3)
% % % ylabel('Cross-correlation coefficient')
% % % xlabel('ALL TRIALS')
% % % xlabel('ALL TRIALS (ALL SESSIONS)')
% % % title('SesekiL Pre and Post VAF (eachTrial Synergy, synNum = 4)')
