function [Result,Allfiles] = MakeDataForPlot_H()
%% make data for corr
monkeyname = 'Se';
Allfiles_S = uigetfile('*.mat',...
                     'Select One or More Files', ...
                     'MultiSelect', 'on');
S = size(Allfiles_S);
Allfiles = strrep(Allfiles_S,'_standard.mat','');
AllDays = strrep(Allfiles,monkeyname,'');
Tsynergy = 4;
c = jet(S(2));

PLOTF = 'off';
save_data = 0;
% Result = cell(S);
allH = cell(S);
cd order_tim_list
OD = load('orderSyn_second.mat');
cd ../
for J =1:S(2)     %session loop
   cd([Allfiles{J} '/' Allfiles{J} '_syn_result_12/' Allfiles{J} '_H/'])
   K = load([Allfiles{J} '_aveH3_4.mat'],'k');
   cd ../../
%    TimSUC = load([Allfiles{J} '_SUC_Timing.mat']);
   synergyData = load([Allfiles{J} '_12_nmf.mat'],'test');
   Hdata = synergyData.test.H;
   Wdata = synergyData.test.W;
   cd ../
  
   altH = [Hdata{Tsynergy,1} Hdata{Tsynergy,2}(K.k(1,:)',:) Hdata{Tsynergy,3}(K.k(2,:)',:) Hdata{Tsynergy,4}(K.k(3,:)',:)];
   altW = (Wdata{Tsynergy,1} + Wdata{Tsynergy,2}(:,K.k(1,:)') + Wdata{Tsynergy,3}(:,K.k(2,:)') + Wdata{Tsynergy,4}(:,K.k(3,:)'))./Tsynergy;
   
   allH{J} = altH(OD.k_arr(:,find(OD.days==str2num(AllDays{J}))),:);
   allW{J} = altW(:,OD.k_arr(:,find(OD.days==str2num(AllDays{J}))));
end

 ResAVE.tData1_AVE = cell(1,Tsynergy);
 ResAVE.tData2_AVE = cell(1,Tsynergy);
 ResAVE.tData3_AVE = cell(1,Tsynergy);

D.obj1_per = [50 50];
D.obj2_per = [50 50];
D.task_per = [25,105];
for SS = 1:S(2) %session loop
   cd(['../../../../NCNPbackup/easyData/' Allfiles{SS}])
   Timing = load([Allfiles{SS} '_EasyData.mat'],'Tp','Tp3','SampleRate');
   cd ../../../MATLAB/data/Yachimun/new_nmf_result
   tim = floor(Timing.Tp./(Timing.SampleRate/100));
   ts = size(tim);
   pre_per = 50; % How long do you want to see the signals before hold_on 1 starts.
   post_per = 50; % How long do you want to see the signals after hold_off 2 starts.
   [alignedData, alignedDataAVE,AllT,Timing_ave,TIME_W] = alignData(allH{SS}, tim, ts(1),pre_per,post_per, Tsynergy);
   taskRange = [-1*pre_per, 100+post_per];
   [Res] = alignDataEX(alignedData, tim, D, pre_per,post_per,TIME_W, Tsynergy);
   D.Ld1 = length(Res.tData1_AVE{1});
   D.Range1 = D.obj1_per;
   D.Ld2 = length(Res.tData2_AVE{1});
   D.Range2 = D.obj2_per;
   D.Ld3 = length(Res.tData3_AVE{1});
   D.Range3 = D.task_per;
   eval(['Result.' Allfiles{SS} ' = Res;'])
   switch PLOTF
       case 'on'
    %    if SS == 1
    %        linspace(taskRange(1),taskRange(2),Pall.AllT_AVE);
           f1 = figure('Position',[0 720 600 400]);
           f2 = figure('Position',[600 720 600 400]);
           f3 = figure('Position',[1200 720 600 400]);
    %        FigA = cell();
    %    end
       figure(f1)
       hold on
       for t = 1:ts
       plot(Res.tData1{1}(t,:),'k')
       end
       plot(mean(Res.tData1{1}),'Color',c(SS,:))
       hold off
       figure(f2)
       hold on
       for t = 1:ts
    %    plot(Res.tData2{1}(t,:),'k')
       end
       plot(mean(Res.tData2{1}),'Color',c(SS,:))
       hold off
       figure(f3)
       hold on
       for t = 1:ts
    %    plot(Res.tData3{1}(t,:),'k')
       end
       plot(mean(Res.tData3{1}),'Color',c(SS,:))
       hold off
       
       case 'off'
           %nothing
   end
   
   % save data
   if save_data == 1
       ResAVE.tData1_AVE = Res.tData1_AVE;
       ResAVE.tData2_AVE = Res.tData2_AVE;
       ResAVE.tData3_AVE = Res.tData3_AVE;
       xpdate = AllDays(SS);
       cd 'synData'
       save([monkeyname 'Syn' AllDays{SS} '_Pdata.mat'], 'monkeyname','xpdate','D',...
                                                         'alignedDataAVE','ResAVE',...
                                                         'AllT','TIME_W','Timing_ave');
       cd ../
   end
end
end
function [alignedData, alignedDataAVE,AllT,Timing_ave,TIME_W] = alignData(Data_in, Timing,s_num,pre_per,post_per, EMG_num)
% this function estimate that Timing is constructed by 6 kinds of timing.
%1:start trial
%2:hold on 1
%3:hold off 1
%4:hold on 2
%5:hold off 2
%6:success
%Please comfirm this construction is correct.  
Data = Data_in;
per1 = pre_per/100;
per2 = post_per/100;
% Timing = cast(Timing,'int32');
TIME_W = round(sum(Timing(:,end)-Timing(:,2) + 1)/s_num);
pre1_TIME = round(per1*sum(Timing(:,end)-Timing(:,2) + 1)/s_num);
post2_TIME = round(per2*sum(Timing(:,end)-Timing(:,2) + 1)/s_num);
trialData = cell(s_num,3);
AllT = pre1_TIME+TIME_W+post2_TIME;
%j:muscle number 
%i:trial number
outData = cell(s_num,EMG_num);
sec = zeros(3,1);
alignedData = cell(1,EMG_num);
alignedDataAVE = cell(1,EMG_num);
for j = 1:EMG_num
    DataA = zeros(s_num,AllT);
    for i = 1:s_num
%         trialData{i,2} = Data(j,Timing(i,2):Timing(i,5));???
         time_w = round(Timing(i,5) - Timing(i,2) +1);
        if time_w == TIME_W
            sec(1,1) = sec(1,1)+1;
            trialData{i,1} = Data(j,floor(Timing(i,2)-time_w*per1):floor(Timing(i,2)-1));
            trialData{i,2} = Data(j,floor(Timing(i,2)):floor(Timing(i,5)));
            trialData{i,3} = Data(j,floor(Timing(i,5)+1):floor(Timing(i,5)+time_w*per2));

        elseif time_w<TIME_W 
            sec(2,1) = sec(2,1)+1;
            trialData{i,1} = interpft(Data(j,floor(Timing(i,2)-time_w*per1):floor(Timing(i,2)-1)),pre1_TIME);
            trialData{i,2} = interpft(Data(j,floor(Timing(i,2)):floor(Timing(i,5))),TIME_W);
            trialData{i,3} = interpft(Data(j,floor(Timing(i,5)+1):floor(Timing(i,5)+time_w*per2)),post2_TIME);
        else
            sec(3,1) = sec(3,1)+1;
            trialData{i,1} = resample(Data(j,floor(Timing(i,2)-time_w*per1):floor(Timing(i,2)-1)),pre1_TIME,round(time_w*per1));
            trialData{i,2} = resample(Data(j,floor(Timing(i,2)):floor(Timing(i,5))),TIME_W,time_w);
            trialData{i,3} = resample(Data(j,floor(Timing(i,5)+1):floor(Timing(i,5)+time_w*per2)),post2_TIME,round(time_w*per2));
        end
        outData{i,j} = [trialData{i,1} trialData{i,2} trialData{i,3}];
        size_out = size(outData{i,j});
        if size_out(2) == AllT
            DataA(i,:) = outData{i,j}(1,:);
        else
            DataA(i,:) = resample(outData{i,j}(1,:),AllT,size_out(2));
            outData{i,j} = resample(outData{i,j}(1,:),AllT,size_out(2));
        end
    end 
    alignedData{1,j} = DataA;
    alignedDataAVE{1,j} = mean(DataA,1);
end
Ti = [Timing(:,2) Timing(:,2) Timing(:,2) Timing(:,2) Timing(:,2) Timing(:,2)];
Timing_ave = mean(Timing - Ti);
% alignedData = cell(1,EMG_num);

% for k = 1:EMG_num
%     SS = outData{:,k};
%     alignedData{1,k} = SS;%cell2mat(SS);
%     alignedDataAVE{1,k} = mean(SS,1);
% end
end

function [Re] = alignDataEX(Data_in,Timing,Da,pre_per,post_per,TIME_W,EMG_num)
% this function estimate that Timing is constructed by 6 kinds of timing.
%1:start trial
%2:hold on 1
%3:hold off 1
%4:hold on 2
%5:hold off 2
%6:success
%Please comfirm this construction is correct.  
D = Data_in;
pre_per = pre_per/100;
% post_per = post_per/100;
per1 = Da.obj1_per/100;
per2 = Da.obj2_per/100;
per3 = Da.task_per/100;
L = length(Timing(:,1));
Ti = [Timing(:,2) Timing(:,2) Timing(:,2) Timing(:,2) Timing(:,2) Timing(:,2)];
Timing = Timing - Ti;
TimingPer = zeros(L,6);
centerP1 = zeros(L,2);
centerP2 = zeros(L,2);
centerP3 = zeros(L,2);
Re.tData1 = cell(1,EMG_num);
Re.tData2 = cell(1,EMG_num);
Re.tData3 = cell(1,EMG_num);
Re.tData1_AVE = cell(1,EMG_num);
Re.tData2_AVE = cell(1,EMG_num);
Re.tData3_AVE = cell(1,EMG_num);
for m = 1:EMG_num
        tD1 = cell(L,1);
        tD2 = cell(L,1);
        tD3 = cell(L,1);
    for i = 1:L%Trial loop
        TimingPer(i,:) = Timing(i,:)./Timing(i,5);
        centerP1(i,:) = [(pre_per+TimingPer(i,3)-per1(1))*TIME_W+1,(pre_per+TimingPer(i,3)+per1(2))*TIME_W];
        centerP2(i,:) = [(pre_per+TimingPer(i,4)-per2(1))*TIME_W+1,(pre_per+TimingPer(i,4)+per2(2))*TIME_W];
        centerP3(i,:) = [(pre_per+TimingPer(i,2)-per3(1))*TIME_W+1,(pre_per+TimingPer(i,2)+per3(2))*TIME_W];
        centerP1 = round(centerP1);
        centerP2 = round(centerP2);
        centerP3 = round(centerP3);
        tD1{i,1} = D{1,m}(i,centerP1(i,1):centerP1(i,2));
        tD2{i,1} = D{1,m}(i,centerP2(i,1):centerP2(i,2));
        tD3{i,1} = D{1,m}(i,centerP3(i,1):centerP3(i,2));
    
       StD1 = size(tD1{i,1});
       StD2 = size(tD2{i,1});
       StD3 = size(tD3{i,1});
       if  StD1(2) ~= TIME_W*sum(per1)
           tD1{i,1} = resample(tD1{i,1},round(TIME_W*sum(per1)),StD1(2));
       end
       if  StD2(2) ~= TIME_W*sum(per2)
           tD2{i,1} = resample(tD2{i,1},round(TIME_W*sum(per2)),StD2(2));
       end
       if  StD3(2) ~= TIME_W*sum(per3)
           tD3{i,1} = resample(tD3{i,1},round(TIME_W*sum(per3)),StD3(2));
       end
    end
    Re.tData1{m} = cell2mat(tD1);
    Re.tData1_AVE{m} = mean(Re.tData1{m});
    Re.tData2{m} = cell2mat(tD2);
    Re.tData2_AVE{m} = mean(Re.tData2{m});
    Re.tData3{m} = cell2mat(tD3);
    Re.tData3_AVE{m} = mean(Re.tData3{m});
end

end