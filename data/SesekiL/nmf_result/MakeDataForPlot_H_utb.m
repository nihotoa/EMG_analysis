%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
�J�����g�f�B���N�g����new_nmf_result�ɂ��Ď��s���邱��    
�yfunction�z
save data which is related in displaying temporal synergy
saved location is new_nmf_result -> synData -> (ex.)YaSyn4170630_Pdata.mat
�yprocedure�z
pre_operate: dispNMF_W.m
post_operate: plotTarget.m
�ycaution!!!!�z
please change group_num!!!!!!!
(�ϐ�group_num�̒l��K�X�ύX����!!!!)
�y���厖!!!!!!!�z
resample��toolbox�����Ă��Ȃ��ƃG���[�f���̂Œ���(signal processing toolbox���Ă��)
code��path�ʂ��ĂȂ��ƃG���[�f��
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Result,Allfiles] = MakeDataForPlot_H_utb()
%% set param
monkeyname = 'Se';
synergy_type = 'post'; %'pre' / 'post'
group_num = 2;
Tsynergy = 4;

%% code section
data_folders = dir(pwd);
folderList = {data_folders([data_folders.isdir]).name};
Allfiles_S = folderList(startsWith(folderList, monkeyname));
switch synergy_type
    case 'pre'
        Allfiles_S = Allfiles_S(1:3);
    case 'post'
        Allfiles_S = Allfiles_S(4:end);
end

S = size(Allfiles_S);
Allfiles = strrep(Allfiles_S,'_standard','');
AllDays = strrep(Allfiles,monkeyname,'');



switch group_num
   case 1%control (FDP)
        EMG_num = 12;
%         EMGs = {'BRD_1';'BRD_2';'ECR';'EDC';'FCR';'FCU';'FDPr'};
    case 2
        EMG_num = 9;
        EMGs = {'BRD';'Deltoid';'ECR';'ECU';'ED23';'ED45';'EDC';'FDP';'PL'};
end

c = jet(S(2));

PLOTF = 'of'; %�����v���b�g���邾��(�m�F�p���Ǝv���.�Z�[�u�͂��Ȃ�)
save_data = 1; %data���Z�[�u����Ƃ���1�ɂ���
% Result = cell(S);

%% code section
allH = cell(S);
cd order_tim_list
disp('please select the file which was created in dispNMF_W.m(Yachimun -> new_nmf_result -> order_tim_list)')
[fName,pat] = uigetfile(['*_' sprintf('%d',Tsynergy) '.mat']); %����MAT�t�@�C���̒��g�͕ϐ�OD�Ɋi�[�����(���ԃV�i�W�[�̐���̂��߂̃f�[�^�����̃t�@�C���̒��ɂ���)
cd(pat)
OD = load(fName);
cd ../../
for J =1:S(2)     %session loop
   cd([Allfiles{J} '_standard' '/' Allfiles{J} '_syn_result_' sprintf('%02d',EMG_num) '/' Allfiles{J} '_H/'])
   K = load([Allfiles{J} '_aveH3_' sprintf('%d',Tsynergy) '.mat'],'k');
   cd ../../
%    TimSUC = load([Allfiles{J} '_SUC_Timing.mat']);
   synergyData = load([Allfiles{J} '_standard_' sprintf('%02d',EMG_num) '_nmf.mat'],'test');
   Hdata = synergyData.test.H; %�e�V�i�W�[���ł�H�f�[�^(4����)
   Wdata = synergyData.test.W; %�e�V�i�W�[���ł�W�f�[�^(4����)
   cd ../
   %��4�̃e�X�g�f�[�^���m��A��������(���Ԃ����킹�邽�߂�,K���g�p����)�C��ԋK��Ɋւ��ẮC4�̃e�X�g�f�[�^�̕��ς��g�p����
   altH = [Hdata{Tsynergy,1} Hdata{Tsynergy,2}(K.k(1,:)',:) Hdata{Tsynergy,3}(K.k(2,:)',:) Hdata{Tsynergy,4}(K.k(3,:)',:)];
   altW = (Wdata{Tsynergy,1} + Wdata{Tsynergy,2}(:,K.k(1,:)') + Wdata{Tsynergy,3}(:,K.k(2,:)') + Wdata{Tsynergy,4}(:,K.k(3,:)'))./Tsynergy;
   %��test�f�[�^����쐬���������̃V�i�W�[�𑵂��Ď��[����
   allH{J} = altH(OD.k_arr(:,find(OD.days==str2num(AllDays{J}))),:);
   allW{J} = altW(:,OD.k_arr(:,find(OD.days==str2num(AllDays{J}))));
end

 ResAVE.tData1_AVE = cell(1,Tsynergy);
 ResAVE.tData2_AVE = cell(1,Tsynergy);
 ResAVE.tData3_AVE = cell(1,Tsynergy);
 ResAVE.tData4_AVE = cell(1,Tsynergy);
 ResAVE.tDataTask_AVE = cell(1,Tsynergy);

D.trig1_per = [50 50];
D.trig2_per = [50 50];
D.trig3_per = [50 50];
D.trig4_per = [50 50];
D.task_per = [25,105];
for SS = 1:S(2) %session loop
   if not(exist(fullfile(pwd, ['../easyData/' Allfiles{SS} '_standard'])))
       mkdir(['../easyData/' Allfiles{SS} '_standard'])
   end
   cd(['../easyData/' Allfiles{SS} '_standard'])
   Timing = load([Allfiles{SS} '_EasyData.mat'],'Tp','Tp3','SampleRate');
   cd ../../nmf_result
   tim = floor(Timing.Tp./(Timing.SampleRate/100)); %floor:�؂�̂�,�^�C�~���O�M����100Hz�Ƀ_�E���T���v�����O
   ts = size(tim);
   pre_per = 50; % How long do you want to see the signals before hold_on 1 starts.
   post_per = 50; % How long do you want to see the signals after hold_off 2 starts.
   
   try
       %��alignedData:�^�X�N���Ƃ́A���Ԑ��K���������ԃV�i�W�[  alignedDataAVE:���Ԑ��K���������ԃV�i�W�[�̕��� All_T:�g���~���O�����T���v����(���K���ς�)
       [alignedData, alignedDataAVE,AllT,Timing_ave,TIME_W] = alignData(allH{SS}',[], tim, ts(1),pre_per,post_per, Tsynergy);
   catch
       continue
   end
   taskRange = [-1*pre_per, 100+post_per];
    %�����ԃV�i�W�[���g���~���O���āA�ۑ�����(3�̃^�C�~���O�t�߂Ńg���~���O���Ă���(task�J�n,?,?)),�e���̃g���~���O�f�[�^�ƁA�S���̕��σf�[�^���A���ꂼ��̃^�C�~���O�������ۑ�����Ă���
   [Res] = alignDataEX(alignedData, tim, D, pre_per,post_per,TIME_W, Tsynergy);
   D.Ld1 = length(Res.tData1_AVE{1});
   D.Range1 = D.trig1_per;
   D.Ld2 = length(Res.tData2_AVE{1});
   D.Range2 = D.trig2_per;
   D.Ld3 = length(Res.tData3_AVE{1});
   D.Range3 = D.trig3_per;
   D.Ld4 = length(Res.tData4_AVE{1});
   D.Range4 = D.trig4_per;
   D.LdTask = length(Res.tDataTask_AVE{1});
   D.RangeTask = D.task_per;
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
           plot(Res.tData2{1}(t,:),'k')
       end
       plot(mean(Res.tData2{1}),'Color',c(SS,:))
       hold off
       figure(f3)
       hold on
       for t = 1:ts
           plot(Res.tData3{1}(t,:),'k')
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
       ResAVE.tData4_AVE = Res.tData4_AVE;
       ResAVE.tDataTask_AVE = Res.tDataTask_AVE;
       xpdate = AllDays(SS);
       mkdir 'synData';
       cd 'synData'
       save([monkeyname 'Syn' sprintf('%d',Tsynergy) AllDays{SS} '_Pdata.mat'], 'monkeyname','xpdate','D',...
                                                         'alignedDataAVE','ResAVE',...
                                                         'AllT','TIME_W','Timing_ave','taskRange');
       cd ../
   end
   close all;
end
end

function [alignedData, alignedDataAVE,AllT,Timing_ave,TIME_W] = alignData(Data_in, SR, Timing,s_num,pre_per,post_per, synergy_num)
% this function estimate that Timing is constructed by 6 kinds of timing.
%1:start trial
%2:hold on 1
%3:hold off 1
%4:hold on 2
%5:hold off 2
%6:success
%Please comfirm this construction is correct.  
Data = Data_in';
per1 = pre_per/100;
per2 = post_per/100;
% Timing = cast(Timing,'int32');
TIME_W = round(sum(Timing(:,5)-Timing(:,2) + 1)/s_num);
pre1_TIME = round(per1*sum(Timing(:,5)-Timing(:,2) + 1)/s_num);
post2_TIME = round(per2*sum(Timing(:,5)-Timing(:,2) + 1)/s_num);
trialData = cell(s_num,3);
AllT = pre1_TIME+TIME_W+post2_TIME;
%j:muscle number 
%i:trial number
outData = cell(s_num,synergy_num);
sec = zeros(3,1);
alignedData = cell(1,synergy_num);
alignedDataAVE = cell(1,synergy_num);
%���ؓd���Ƃɏ������s��
for j = 1:synergy_num
    DataA = zeros(s_num,AllT);
    for i = 1:s_num
%         trialData{i,2} = Data(j,Timing(i,2):Timing(i,5));???
         time_w = round(Timing(i,5) - Timing(i,2) +1);
        %��interpft���g���āC�f�[�^�̐؂�o����TIME_W(�^�X�N�ɂ����鎞�Ԃ̕���)�̃X�P�[����Data�����킹��(�^�X�N�̐؂�o�� + TimeNormalization)
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
% alignedData = cell(1,synergy_num);

% for k = 1:synergy_num
%     SS = outData{:,k};
%     alignedData{1,k} = SS;%cell2mat(SS);
%     alignedDataAVE{1,k} = mean(SS,1);
% end
end

function [Re] = alignDataEX(Data_in,Timing,Da,pre_per,post_per,TIME_W,synergy_num)
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
per1 = Da.trig1_per/100;
per2 = Da.trig2_per/100;
per3 = Da.trig3_per/100;
per4 = Da.trig4_per/100;
pertask = Da.task_per/100;
L = length(Timing(:,1));
Ti = [Timing(:,2) Timing(:,2) Timing(:,2) Timing(:,2) Timing(:,2) Timing(:,2)];
Timing = Timing - Ti;
TimingPer = zeros(L,6);
centerP1 = zeros(L,2);
centerP2 = zeros(L,2);
centerP3 = zeros(L,2);
centerP4 = zeros(L,2);
centerPTask = zeros(L,2);
Re.tData1 = cell(1,synergy_num);
Re.tData2 = cell(1,synergy_num);
Re.tData3 = cell(1,synergy_num);
Re.tData4 = cell(1,synergy_num);
Re.tDataTask = cell(1,synergy_num);
Re.tData1_AVE = cell(1,synergy_num);
Re.tData2_AVE = cell(1,synergy_num);
Re.tData3_AVE = cell(1,synergy_num);
Re.tData4_AVE = cell(1,synergy_num);
Re.tDataTask_AVE = cell(1,synergy_num);
for m = 1:synergy_num
        tD1 = cell(L,1);
        tD2 = cell(L,1);
        tD3 = cell(L,1);
        tD4 = cell(L,1);
        tDTask = cell(L,1);
    for i = 1:L%Trial loop
        TimingPer(i,:) = Timing(i,:)./Timing(i,5);
        centerP1(i,:) = [round((pre_per+TimingPer(i,2)-per1(1))*TIME_W+1),floor((pre_per+TimingPer(i,2)+per1(2))*TIME_W-1)];
        centerP2(i,:) = [round((pre_per+TimingPer(i,3)-per2(1))*TIME_W+1),floor((pre_per+TimingPer(i,3)+per2(2))*TIME_W-1)];
        centerP3(i,:) = [round((pre_per+TimingPer(i,4)-per3(1))*TIME_W+1),floor((pre_per+TimingPer(i,4)+per3(2))*TIME_W-1)];
        centerP4(i,:) = [round((pre_per+TimingPer(i,5)-per4(1))*TIME_W+1),floor((pre_per+TimingPer(i,5)+per4(2))*TIME_W-1)];
        centerPTask(i,:) = [round((pre_per+TimingPer(i,2)-pertask(1))*TIME_W+1),floor((pre_per+TimingPer(i,2)+pertask(2))*TIME_W-1)];
        tD1{i,1} = D{1,m}(i,centerP1(i,1):centerP1(i,2));
        tD2{i,1} = D{1,m}(i,centerP2(i,1):centerP2(i,2));
        tD3{i,1} = D{1,m}(i,centerP3(i,1):centerP3(i,2));
        tD4{i,1} = D{1,m}(i,centerP4(i,1):centerP4(i,2));
        tDTask{i,1} = D{1,m}(i,centerPTask(i,1):centerPTask(i,2));
%         StD1 = size(tD1{i,1});
%         StD2 = size(tD2{i,1});
%         StD3 = size(tD3{i,1});
%         StD4 = size(tD4{i,1});
%         StDtask = size(tDTask{i,1});
%        if  StD1(2) ~= TIME_W*sum(per1)
%            [tD1{i,1}, slct]=AlignDatasets(tD1{i,1},round(TIME_W*sum(per1)),'row');
%            tD1{i,1} = resample(tD1{i,1},round(TIME_W*sum(per1)),StD1(2));
%        end
%        if  StD2(2) ~= TIME_W*sum(per2)
%            tD2{i,1} = resample(tD2{i,1},round(TIME_W*sum(per2)),StD2(2));
%        end
%        if  StD3(2) ~= TIME_W*sum(per3)
%            tD3{i,1} = resample(tD3{i,1},round(TIME_W*sum(per3)),StD3(2));
%        end
    end
    Re.slct = cell(5,1);
    [tD1, Re.slct{1}]=AlignDatasets(tD1,round(TIME_W*sum(per1)),'row');
    [tD2, Re.slct{2}]=AlignDatasets(tD2,round(TIME_W*sum(per2)),'row');
    [tD3, Re.slct{3}]=AlignDatasets(tD3,round(TIME_W*sum(per3)),'row');
    [tD4, Re.slct{4}]=AlignDatasets(tD4,round(TIME_W*sum(per4)),'row');
    [tDTask, Re.slct{5}]=AlignDatasets(tDTask,round(TIME_W*sum(pertask)),'row');
    Re.tData1{m} = cell2mat(tD1);
    Re.tData1_AVE{m} = mean(Re.tData1{m});
    Re.tData2{m} = cell2mat(tD2);
    Re.tData2_AVE{m} = mean(Re.tData2{m});
    Re.tData3{m} = cell2mat(tD3);
    Re.tData3_AVE{m} = mean(Re.tData3{m});
    Re.tData4{m} = cell2mat(tD4);
    Re.tData4_AVE{m} = mean(Re.tData4{m});
    Re.tDataTask{m} = cell2mat(tDTask);
    Re.tDataTask_AVE{m} = mean(Re.tDataTask{m});
end

end