%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
�y�⑫�z
�ϐ�synergy_order�ɂ���
�����������ԃV�i�W�[�̐}�Ȃǂ���Apre��post�̃V�i�W�[�̑Ή��֌W�𖾎�����(ex.)pre�̃V�i�W�[�P��post�̃V�i�W�[3�Ɠ�����
(synergy_order�̐ݒ��)
   pre  ->  post
�V�i�W�[1 = �V�i�W�[4
�V�i�W�[2 = �V�i�W�[2
�V�i�W�[3 = �V�i�W�[1
�V�i�W�[4 = �V�i�W�[3
�̏ꍇ�ɂ�
synergy_order = [4 2 1 3];
�Ɛݒ肷��
�V�i�W�[�̏ƍ��̃Z�N�V����(217~230�s�ڂ܂�)��Tim3��������Ȃ��A���̃^�C�~���O�ɂ��K�p����

�y�ۑ�z
�Ecorrcoef��reference_data(�S���̕��σf�[�^)��pre�f�[�^��post�f�[�^�̗������܂܂�Ă��邪�A��őΏ����Ă���̂��H
��corrcoef�̃f�[�^�́A�e�^�C�~���O����̃f�[�^�ł͂Ȃ��^�X�N�S�̂̃f�[�^�ɑ΂��鑊�ݑ��ւł���A�l����D�揇�ʂ��Ⴂ�̂ň�U�ۗ�
�E���[�J���֐���EachXcorr�̏������e�̊m�F
�E��ʂ�ł�������ResE�̒l�����������̂�,�}�����Ċm�F����(���ԃV�i�W�[�̐}�ł͂قƂ�Ǔ����T�`�ɂ�������炸�R���g���[���f�[�^��post�̌���̑��ݑ��ւ̒l���Ⴗ����(�ق�0))
�������炭�Apre�̃V�i�W�[�P��post�̃V�i�W�[1���قȂ��Ă��邱�Ƃ����� �����������Ǝv���镔�����s�b�N�A�b�v���Đ}����,�p���|�̐}�Ɣ�r����
�E�߂���߂���璷�ȕ������Ȍ��ɂ���
�yprocedure�z
pre : plotTarget.m
post : plotXcorr
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Re,ResE] = calcXcorr()
clear;
Tar = 'Synergy';           %'EMG','Synergy'
save_data = 1;
pre_data_num = 4;
%pre��post�̃V�i�W�[�ԍ������킹�����,(��������Ȃ���,x_corr�̒l���������Ă��܂�)
synergy_order = [4 2 1 3];
timing_num = 4; %EachXcorr�Ōv�Z����^�C�~���O�f�[�^�̌�(ex.)�^�C�~���O��T1~T4�܂ł������ꍇ��4�ɂ���


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
                 %���e���̃f�[�^��,�S�̂̕��σf�[�^�Ƃ̑��ݑ���(���ݑ��ւ���Ȃ���,���֌W�������Ǒ��v?)
                 eval([ 'Alt = corrcoef(D.syn' sprintf('%d',i) '(:,j), Co(:,k));']);
                 eval(['Re.syn' sprintf('%d',i) '{1,k}(j,1) = Alt(1,2);']);
      %           eval(['[Re.' EMGs{i,1} '{1,k}(:,j),x] = xcorr(D.' EMGs{i} '(:,j), Co(:,k),''coeff'');']);
             end
         end
      end
      %���^�X�N�S�̂ł͂Ȃ��āA�e�^�C�~���O����̃g���~���O�f�[�^���瑊�֌W�������߂�
      ResE = EachXcorr(4,pre_data_num,synergy_order,timing_num);
      %plotXcorr�p�Ƀf�[�^���Z�[�u
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
      %DD��EMGs��ǉ�����
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
%���e�^�C�~���O�ł́A���ꂼ��̎��ԃV�i�W�[��x_corr���v�Z
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

%pre��post�̃V�i�W�[�����킹�邽�߂̊֐�(��ō��)
function Re = align_syn(TarN,Re,pre_num,synergy_order,timing_num)
    %��T3�����\���̕ϐ������A�����ɐ������l�������čs��
    reference_matrix = ['Re.T' num2str(timing_num)];
    all_data_num = eval(['length(' reference_matrix '{1});']);
    alt_matrix = cell(TarN,1);
    for ii = 1:TarN
        alt_matrix{ii} = NaN(TarN,all_data_num);
    end
    %������\���ɐ������l�������Ă�
    for ii = 1:length(synergy_order)
        alt_matrix{ii}(:,1:pre_num) = eval([reference_matrix '{ii}(:,1:pre_num);']);
        alt_matrix{ii}(:,pre_num+1:end) = eval([reference_matrix '{synergy_order(ii)}(:,pre_num+1:end);']);
    end
    eval([ reference_matrix ' = alt_matrix;'])
end