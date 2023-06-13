%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
【補足】
変数synergy_orderについて
生成した時間シナジーの図などから、preとpostのシナジーの対応関係を明示する(ex.)preのシナジー１はpostのシナジー3と等しい
(synergy_orderの設定例)
   pre  ->  post
シナジー1 = シナジー4
シナジー2 = シナジー2
シナジー3 = シナジー1
シナジー4 = シナジー3
の場合には
synergy_order = [4 2 1 3];
と設定する
シナジーの照合のセクション(217~230行目まで)をTim3だけじゃなく、他のタイミングにも適用する

【課題】
・corrcoefのreference_data(全日の平均データ)にpreデータとpostデータの両方が含まれているが、後で対処しているのか？
→corrcoefのデータは、各タイミング周りのデータではなくタスク全体のデータに対する相互相関であり、考える優先順位が低いので一旦保留
・ローカル関数のEachXcorrの処理内容の確認
・一通りできたけどResEの値がおかしいので,図示して確認する(時間シナジーの図ではほとんど同じ概形にもかかわらずコントロールデータとpostの後期の相互相関の値が低すぎる(ほぼ0))
→おそらく、preのシナジー１とpostのシナジー1が異なっていることが原因 →おかしいと思われる部分をピックアップして図示し,パワポの図と比較する
・めちゃめちゃ冗長な部分を簡潔にする
【procedure】
pre : plotTarget.m
post : plotXcorr
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Re,ResE] = calcXcorr()
clear;
Tar = 'Synergy';           %'EMG','Synergy'
save_data = 1;
pre_data_num = 4;
%preとpostのシナジー番号を合わせるもの,(これをしないと,x_corrの値が混じってしまう)
synergy_order = [4 2 1 3];
timing_num = 4; %EachXcorrで計算するタイミングデータの個数(ex.)タイミングがT1~T4まであった場合は4にする


switch Tar
   case 'EMG'
      TarN = 12;           %EMG num
      [D,conD,EMGs] = LoadCorrData(Tar);
      Co = cell2mat(conD);
      Sco = size(Co);
      s = 2*Sco(1) - 1;
      for i = 1:12
         eval(['Re.' EMGs{i,1} '= cell(1,12);']); 
      %    eval(['Re.' EMGs{i,1} '{1,i}= zeros(s,81);']);
         for k = 1:12
             eval(['Re.' EMGs{i,1} '{1,k}= zeros(81,1);']);
             for j = 1:81
                 eval([ 'Alt = corrcoef(D.' EMGs{i} '(:,j), Co(:,k));']);
                     eval(['Re.' EMGs{i,1} '{1,k}(j) = Alt(1,2);']);
      %           eval(['[Re.' EMGs{i,1} '{1,k}(:,j),x] = xcorr(D.' EMGs{i} '(:,j), Co(:,k),''coeff'');']);
             end
         end
      end
      ResE = EachXcorr(TarN);
   case 'Synergy'
      TarN = 4;            %Synergy num
      used_muscle = {'FDP';'FDSdist';'FCU';'PL';'FCR';'BRD';'ECR';'EDCdist';'ED23';'ECU'};
%       s_order = [2 1 4 3];
      [D,conD,EMGs] = LoadCorrData(Tar,used_muscle);
      [~,selected_day_num] = size(D.syn1);
      Co = cell2mat(conD);
      Sco = size(Co);
      s = 2*Sco(1) - 1;
      for i = 1:TarN%s_order
         eval(['Re.syn' sprintf('%d',i) '= cell(1,TarN);']); 
      %    eval(['Re.' EMGs{i,1} '{1,i}= zeros(s,81);']);
         for k = 1:TarN%s_order
             eval(['Re.syn' sprintf('%d',i) '{1,k}= zeros(' num2str(selected_day_num) ',1);']);
             for j = 1:selected_day_num
                 %↓各日のデータと,全体の平均データとの相互相関(相互相関じゃなくて,相関係数だけど大丈夫?)
                 eval([ 'Alt = corrcoef(D.syn' sprintf('%d',i) '(:,j), Co(:,k));']);
                 eval(['Re.syn' sprintf('%d',i) '{1,k}(j,1) = Alt(1,2);']);
      %           eval(['[Re.' EMGs{i,1} '{1,k}(:,j),x] = xcorr(D.' EMGs{i} '(:,j), Co(:,k),''coeff'');']);
             end
         end
      end
      %↓タスク全体ではなくて、各タイミング周りのトリミングデータから相関係数を求める
      ResE = EachXcorr(4,pre_data_num,synergy_order,timing_num);
      %plotXcorr用にデータをセーブ
      if save_data == 1
          save(['ResultXcorr_' num2str(selected_day_num) '_syn' num2str(TarN) '.mat'],'D','Sco','EMGs','Re','Tar');
          save(['ResultXcorr_each_' num2str(selected_day_num) '_syn' num2str(TarN) '.mat'],'ResE');
      end
end


end
function [D,conD,E] = LoadCorrData(Tar,used_muscle)
switch Tar
   case 'EMG'
      DD = load('AllDataforXcorr_80.mat');
      conData = DD.plotData_sel{1,1}';

      S1 = size(conData);
      S2 = size(DD.Allfiles);
      S = [S1(1) S2(2)];

      D.FDP = zeros(S);
      D.FDSprox = zeros(S);
      D.FDSdist = zeros(S);
      D.FCU = zeros(S);
      D.PL = zeros(S);
      D.FCR = zeros(S);
      D.BRD = zeros(S);
      D.ECR = zeros(S);
      D.EDCprox = zeros(S);
      D.EDCdist = zeros(S);
      D.ED23 = zeros(S);
      D.ECU = zeros(S);

      for i = 1:S(2)
         D.FDP(:,i) = DD.plotData_sel{i,1}(1,:)';
         D.FDSprox(:,i) = DD.plotData_sel{i,1}(2,:)';
         D.FDSdist(:,i) = DD.plotData_sel{i,1}(3,:)';
         D.FCU(:,i) = DD.plotData_sel{i,1}(4,:)';
         D.PL(:,i) = DD.plotData_sel{i,1}(5,:)';
         D.FCR(:,i) = DD.plotData_sel{i,1}(6,:)';
         D.BRD(:,i) = DD.plotData_sel{i,1}(7,:)';
         D.ECR(:,i) = DD.plotData_sel{i,1}(8,:)';
         D.EDCprox(:,i) = DD.plotData_sel{i,1}(9,:)';
         D.EDCdist(:,i) = DD.plotData_sel{i,1}(10,:)';
         D.ED23(:,i) = DD.plotData_sel{i,1}(11,:)';
         D.ECU(:,i) = DD.plotData_sel{i,1}(12,:)';
      end
      conD = cell(1,12);
      conD{1} = mean(D.FDP(:,1:21),2);
      conD{2} = mean(D.FDSprox(:,1:21),2);
      conD{3} = mean(D.FDSdist(:,1:21),2);
      conD{4} = mean(D.FCU(:,1:21),2);
      conD{5} = mean(D.PL(:,1:21),2);
      conD{6} = mean(D.FCR(:,1:21),2);
      conD{7} = mean(D.BRD(:,1:21),2);
      conD{8} = mean(D.ECR(:,1:21),2);
      conD{9} = mean(D.EDCprox(:,1:21),2);
      conD{10} = mean(D.EDCdist(:,1:21),2);
      conD{11} = mean(D.ED23(:,1:21),2);
      conD{12} = mean(D.ECU(:,1:21),2);
      % conD.FDP = mean(D.FDP(:,1:21),2);
      % conD.FDSprox = mean(D.FDSprox(:,1:21),2);
      % conD.FDSdist = mean(D.FDSdist(:,1:21),2);
      % conD.FCU = mean(D.FCU(:,1:21),2);
      % conD.PL = mean(D.PL(:,1:21),2);
      % conD.FCR = mean(D.FCR(:,1:21),2);
      % conD.BRD = mean(D.BRD(:,1:21),2);
      % conD.ECR = mean(D.ECR(:,1:21),2);
      % conD.EDCprox = mean(D.EDCprox(:,1:21),2);
      % conD.EDCdist = mean(D.EDCdist(:,1:21),2);
      % conD.ED23 = mean(D.ED23(:,1:21),2);
      % conD.ECU = mean(D.ECU(:,1:21),2);
      E = DD.EMGs;
      
   case 'Synergy'
      disp('please select AllDataforXcorr_~.mat file (which you want to calcurate x_corr)')
      selected_file = uigetfile('*.mat',...
                     'Select One or More Files', ...
                     'MultiSelect', 'on');
      DD = load(selected_file);
      %DD = load('AllDataforXcorr_80_syn.mat');
      %DDにEMGsを追加する
      DD.EMGs = used_muscle;
      conData = DD.plotData_sel{1,1}';

      S1 = size(conData);
      S2 = size(DD.Allfiles);
      S = [S1(1) S2(2)];

      D.syn1 = zeros(S);
      D.syn2 = zeros(S);
      D.syn3 = zeros(S);
      D.syn4 = zeros(S);

      for i = 1:S(2)
         D.syn1(:,i) = DD.plotData_sel{i,1}(1,:)';
         D.syn2(:,i) = DD.plotData_sel{i,1}(2,:)';
         D.syn3(:,i) = DD.plotData_sel{i,1}(3,:)';
         D.syn4(:,i) = DD.plotData_sel{i,1}(4,:)';
      end
      conD = cell(1,4);
      conD{1} = mean(D.syn1(:,1:21),2);
      conD{2} = mean(D.syn2(:,1:21),2);
      conD{3} = mean(D.syn3(:,1:21),2);
      conD{4} = mean(D.syn4(:,1:21),2);
      E = DD.EMGs;
end
end
function [Re] = EachXcorr(TarN,pre_num,synergy_order,timing_num)
% DD = load('DataSetForEachXcorr_80_syn_Range2.mat');
disp('please select DataSetforEachXcorr_~.mat file (which you want to calcurate x_corr)')
selected_file = uigetfile('*.mat',...
             'Select One or More Files', ...
             'MultiSelect', 'on');
DD = load(selected_file);
%↓各タイミングでの、それぞれの時間シナジーのx_corrを計算
for ii = 1:timing_num
    eval(['Re.T' num2str(ii) ' = calEXcorr(DD.TrigData_Each.T' num2str(ii) ',TarN);']) %Re.T3 = calEXcorr(DD.TrigData_Each.T3,TarN);
    Re = align_syn(TarN,Re,pre_num,synergy_order,ii);
end

end

function [Result] = calEXcorr(T,TarN)
S = size(T.data);
Result = cell(TarN,1); 
R = zeros(TarN,S(2));

for M = 1:TarN
   for d = 1:S(2)
      for m = 1:TarN
         AltE = corrcoef(T.data{1,d}(M,:)',T.AVEPre4(m,:)');
         R(m,d) = AltE(1,2);
      end   
   end
   Result{M} = R;
end
end

%preとpostのシナジーを合わせるための関数(後で作る)
function Re = align_syn(TarN,Re,pre_num,synergy_order,timing_num)
    %↓T3同じ構造の変数を作り、そこに正しい値を代入して行く
    reference_matrix = ['Re.T' num2str(timing_num)];
    all_data_num = eval(['length(' reference_matrix '{1});']);
    alt_matrix = cell(TarN,1);
    for ii = 1:TarN
        alt_matrix{ii} = NaN(TarN,all_data_num);
    end
    %作った構造に正しい値を代入してく
    for ii = 1:length(synergy_order)
        alt_matrix{ii}(:,1:pre_num) = eval([reference_matrix '{ii}(:,1:pre_num);']);
        alt_matrix{ii}(:,pre_num+1:end) = eval([reference_matrix '{synergy_order(ii)}(:,pre_num+1:end);']);
    end
    eval([ reference_matrix ' = alt_matrix;'])
end