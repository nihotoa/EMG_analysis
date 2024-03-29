%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
【課題】
・タスク全体からのx_corrの図示のセクションは改善していないので、実行できない(plot_all = 1は実行できない)
　→ これを改善する場合はこの関数を修正する前に,calcXcorr.mのResultXcorr~.matに保存される変数の内容を確認する必要がある
・plot_eachのsubplotのところの汎用性が低い(t = 2:3 (T2,T3)にしか対応していない)Y
【procedure】
pre : create_elapsed_days.m
post : plotXcorr_W.m
【caution!!】
AllDays,dayX,visual_synは適宜変更すること
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
%% plot crosscorrelation
Tar = 'EMG';

switch Tar
   case 'EMG'
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
plot_each = 1;% if you want to plot x_corr which is extracted from around each timing of task, please set '1'
synergy_combination = 'dist-dist'; %dist-dist,dist-prox,prox-dist,prox-prox (procedure is EDC-FDS)
vidual_syn =  [1, 4]; %please select the synergy group which you want to plot!!
plot_timing = [1,2,3,4];
title_name = {'lever1 on','lever1 off','photo on','photo off'};
% figure;

switch Tar
   case 'EMG'
      c = jet(12);
      AllDays = datetime([2020,01,17])+caldays(0:73); %1/17の73日経過 -> 3/30
      dayX = {'2020/01/17','2020/01/19','2020/01/20','2020/02/10','2020/02/12',...
      '2020/02/13','2020/02/14','2020/02/17','2020/02/18','2020/02/19',...
      '2020/02/20','2020/02/21','2020/02/26','2020/03/03','2020/03/04',...
      '2020/03/05','2020/03/06','2020/03/09','2020/03/10','2020/03/16',...
      '2020/03/17','2020/03/18','2020/03/19','2020/03/23','2020/03/24',...
      '2020/03/25','2020/03/26','2020/03/30'}; %28days

   case 'Synergy'
      c = lines(4);
      AllDays = datetime([2020,01,17])+caldays(0:73); %5/16の133日経過 → 9/29
    dayX = {'2020/01/17','2020/01/19','2020/01/20','2020/02/10','2020/02/12',...
      '2020/02/13','2020/02/17','2020/02/17','2020/02/18','2020/02/19',...
      '2020/02/20','2020/02/21','2020/02/26','2020/03/03','2020/03/04',...
      '2020/03/05','2020/03/06','2020/03/09','2020/03/10','2020/03/16',...
      '2020/03/17','2020/03/18','2020/03/19','2020/03/23','2020/03/24',...
      '2020/03/25','2020/03/26','2020/03/30'}; %28days
end

% AVEPre4Days = {'2020/01/17','2020/01/19','2020/01/20'};
% TaskCompletedDay = {'2020/02/10'};
% TTsurgD = datetime([2020,01,21]);                %date of tendon transfer surgery
% TTtaskD = datetime([2020,02,10]);                %date monkey started task by himself after surgery & over 100 success trials (he started to work on June.28)
% Xpost = zeros(size(AllDays));
% Xpre4 = zeros(size(AllDays));
% % 
% k=1;l=1;
% for i=1:length(AllDays)
%    if k>length(dayX)
%    elseif AllDays(i)==dayX(k)
%        Xpost(1,i) = i;
%        k=k+1;
%    end
%    if l>length(AVEPre4Days)
%    elseif AllDays(i)==AVEPre4Days(l)
%        Xpre4(1,i) = i;
%        l=l+1;
%    end
%    if AllDays(i)==TaskCompletedDay
%       tcd = i;
%    end
% end
% xdays = find(Xpost) - find(AllDays==TTsurgD);
% pre_days = find(Xpre4) - find(AllDays==TTsurgD);
% TCD = tcd - find(AllDays==TTsurgD);
% xnoT = 0:(find(AllDays==TTtaskD)-1- find(AllDays==TTsurgD));

Ptype = 'RAW';                                     %Plot Type : 'RAW' or 'MMean'( move mean )

% xdaysとpre_daysを計算する
disp('Please select days list data')
[file_name, path_name] = uigetfile();
load(fullfile(path_name, file_name), 'elapsed_days_list');
xdays = elapsed_days_list;
pre_days = xdays(xdays < 0)';
post_days = xdays(xdays > 0)';
TCD = post_days(1);
xnoT = [0:post_days(1)-1];

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

%% plot Xcorr Each
if plot_each == 1
    switch Tar
       case 'EMG'
          % 図の構造体の作成
           figure_str = struct;
           [EMG_num, ~] = size(EMGs);
           figure_num = ceil(EMG_num/4);  % 作成する図の数 
           for ii = 1:figure_num
                eval(['figure_str.f' sprintf('%d',ii) '= figure(''Position'',[0 0 ' num2str(300 * length(plot_timing)) ' 1000]);']);
           end
           
           for t = plot_timing %タイミングごとにloop
        %       f = figure('Position',[0 0 2000 1000]);
              k = 1;  % 使い道が謎ではあるが,重要そう
              switch plotFocus
                case 'off'
%                        % 図の構造体の作成
%                        figure_str = struct;
%                        [EMG_num, ~] = size(EMGs);
%                        figure_num = ceil(EMG_num/4);  % 作成する図の数 
%                        for ii = 1:figure_num
%                             eval(['figure_str.f' sprintf('%d',ii) '= figure(''Position'',[0 0 ' num2str(300 * length(plot_timing)) ' 1000]);']);
%                        end
                       Jloop = 1:EMG_num;   %筋肉の, プロットする順番
                    case 'on'
                       if t==1
                          fe = figure('Position',[0 0 2000 1000]);
                       else
                          figure(fe)
                       end
                       Jloop = [4 3 10 11];
               end
              for j=Jloop % 順番に各筋肉のx_corrをプロットしていく 
                   eval(['plotDe = ResE.T' sprintf('%d',t) ';']);  % タイミングtのデータを取り出す
                   switch plotFocus
                      case 'off'
                            page_num = ceil(j/4);  %何枚目の図にプロット?
                            eval(['figure(figure_str.f'  num2str(page_num) ')']) %図をgcfにする
                            height_num = j - (page_num-1) * 4;  %上から何番目にプロット?
                            location_num = length(plot_timing) * (height_num-1) + find(t==plot_timing);
                            subplot(4, length(plot_timing), location_num)
                      case 'on'
                         subplot(4,4,4*(k-1)+t);
                         k = k+1;
                   end
    
              %      f = figure;
                   hold on;
                   % area for control data %コントロールデータのエリアを灰色に染める
                   fi1 = fill([pre_days pre_days(end:-1:1)],[ones(size(pre_days)) (-1).*ones(size(pre_days))],'k'); %よくわからないけど重要
                   fi1.FaceColor = [0.78 0.78 0.78];       % make the filled area
                   fi1.EdgeColor = 'none';            % remove the line around the filled area
                   hold off;
                   p = cell(12,1);
                  for i = j %1:12 %control vs each_dayのeach_dayの方の筋肉(今回は同じ筋肉同士のみが見たいので,i = j)
                     spp =1;
                      hold on;
                      switch Ptype
                         case 'RAW'
                            p{i} = plot(xdays,plotDe{j}(i,:),'LineWidth',1.3);
                         case 'MMean'
                            p{i} = plot(xdays,conv2(plotDe{j}(i,:),kernel,'same'),'Color',c(i,:),'LineWidth',1.3);
                      end
%                       if (delEMG(i))  % よくわからない(plotしたものを消す?)
%                           delete(p{i});
%                       end
                  end
                  spp = spp+1;
                  plot([TCD TCD],[-1 1],'k--','LineWidth', 1.3);
                  % 計測不能の部分を白boxで囲む
                  fi2 = fill([xnoT xnoT(end:-1:1)],[ones(size(xnoT)) (-1).*ones(size(xnoT))],'k','LineWidth',1.3); 
                  fi2.FaceColor = [1 1 1];       % make the filled area
        %           fi2.EdgeColor = 'none';            % remove the line around the filled area
                  hold off;
                  % decoration
                  ylim([-1 1]);
                  xlim([pre_days(1) xdays(end)]);
                  title([EMGs{j,1} ' ' title_name{t}],'FontSize',15);
              end
           end
           % 図の保存
           if save_fig == 1
               %save_foldの作成
               save_fold = 'EachPlot/x_corr_result/EMG';
               save_fold_path = fullfile(pwd, save_fold);
               if not(exist(save_fold_path))
                   mkdir(save_fold_path)
               end
               %図を一枚ずつ保存
               for ii = 1:figure_num
                    eval(['figure(figure_str.f'  num2str(ii) ')'])
                    saveas(gcf, [save_fold_path '/' 'EMG_xcorr(' num2str(EMG_num) 'muscle)_page' num2str(ii) '.fig'])
                    saveas(gcf, [save_fold_path '/' 'EMG_xcorr(' num2str(EMG_num) 'muscle)_page' num2str(ii) '.png'])
               end
           end
           close all
       %% case of synergy analysis
       case 'Synergy'
          TarN =4; %シナジー数
          %↓t:T2~T3のプロット(food onとfood off (tim1,tim4は不要なので排除))
          for t = plot_timing %1:TarN %trig loop 
        %       f = figure('Position',[0 0 2000 1000]);
              k = 1;
              switch plotFocus
                    case 'off'
                       if t == plot_timing(1) %1回目のループの時,figureを作成 
                            eval(['f' sprintf('%d',k) '= figure(''Position'',[0 0 ' num2str(300 * length(plot_timing)) ' 1000]);']);
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
              for j=Jloop %jは「シナジーjのコントロールに対する」を表している
                   eval(['plotDe = ResE.T' sprintf('%d',t) ';']);
                   if j == 1
                       for pp = 1:4
                           eval(['vs_tim' num2str(t) '_synergy' num2str(pp) '= plotDe{' num2str(pp) '};'])
                       end
                   end
                   switch plotFocus
                      case 'off'
%                          subplot(TarN,2,(2*j)-(plot_timing(2)-t)); %2と(2*j)はタイミングの数(T2とT3),(plot_timing(2)-t)のplot_timing(2)はtの一番最後の要素の値を示している
                           timing_num = length(plot_timing);
                           subplot(TarN,length(plot_timing), timing_num*(j-1) + find(t == plot_timing)); %2と(2*j)はタイミングの数(T2とT3),(plot_timing(2)-t)のplot_timing(2)はtの一番最後の要素の値を示している
                      case 'on'
                         subplot(TarN,4,4*(k-1)+t);
                         k = k+1;
                   end

              %      f = figure;
                   hold on;
                   % area for control data
                   fi1 = fill([pre_days pre_days(end:-1:1)],[ones(size(pre_days)) (-1).*ones(size(pre_days))],'k');
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
                  xlim([pre_days(1) xdays(end)]);
              %     xlim([xdays(1) xdays(end)]);
              %     xlim([0 81]);
                  title([title_name{t} ' Synergy' num2str(j)]);
                  %title(['vs Syn' num2str(j) '(T' num2str(t) ')'],'FontSize',25);
                  if j == TarN
                      ylabel('Cross-correlation coefficient');
                      xlabel('Post tendon transfer [days]');
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
%               save_dir = ['EachPlot/x_corr_result/' synergy_combination];
              save_dir = fullfile(pwd, 'EachPlot', 'x_corr_result', synergy_combination);
              if not(exist(save_dir))
                  mkdir(save_dir)
              end
              fig_name = [save_dir '/' num2str(TarN) 'syn_' num2str(length(vidual_syn)) 'plot_' num2str(length(plot_timing)) 'timing'];
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