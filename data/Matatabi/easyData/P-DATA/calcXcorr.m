function [Re,ResE] = calcXcorr()
Tar = 'EMG';           %'EMG','Synergy'

switch Tar
   case 'EMG'
      TarN = 8;           %EMG num
      [D,conD,EMGs] = LoadCorrData(Tar);
      Co = cell2mat(conD);
      Sco = size(Co);
      s = 2*Sco(1) - 1;
      for i = 1:TarN
         eval(['Re.' EMGs{i,1} '= cell(1,TarN);']); 
      %    eval(['Re.' EMGs{i,1} '{1,i}= zeros(s,81);']);
         for k = 1:TarN
             eval(['Re.' EMGs{i,1} '{1,k}= zeros(57,1);']);
             for j = 1:57
                 eval([ 'Alt = corrcoef(D.' EMGs{i} '(:,j), Co(:,k));']);
                     eval(['Re.' EMGs{i,1} '{1,k}(j) = Alt(1,2);']);
      %           eval(['[Re.' EMGs{i,1} '{1,k}(:,j),x] = xcorr(D.' EMGs{i} '(:,j), Co(:,k),''coeff'');']);
             end
         end
      end
      ResE = EachXcorr(TarN);
   case 'Synergy'
      TarN = 4;            %Synergy num
      s_order = [2 1 4 3];
      [D,conD,EMGs] = LoadCorrData(Tar);
      Co = cell2mat(conD);
      Sco = size(Co);
      s = 2*Sco(1) - 1;
      for i = 1:TarN%s_order
         eval(['Re.syn' sprintf('%d',i) '= cell(1,TarN);']); 
      %    eval(['Re.' EMGs{i,1} '{1,i}= zeros(s,81);']);
         for k = 1:TarN%s_order
             eval(['Re.syn' sprintf('%d',i) '{1,k}= zeros(28,1);']);
             for j = 1:28
                 eval([ 'Alt = corrcoef(D.syn' sprintf('%d',i) '(:,j), Co(:,k));']);
                     eval(['Re.syn' sprintf('%d',i) '{1,k}(j,1) = Alt(1,2);']);
      %           eval(['[Re.' EMGs{i,1} '{1,k}(:,j),x] = xcorr(D.' EMGs{i} '(:,j), Co(:,k),''coeff'');']);
             end
         end
      end
      ResE = EachXcorr(4);
end

end
function [D,conD,E] = LoadCorrData(Tar)
switch Tar
   case 'EMG'
%load data are made in 'plotTarget.m'. variables are 
%'Allfiles','AllT_AVE'(in 'Pall'), 'EMGs', 'realname', 'taskRange',...
%'plotData_sel'(in 'Pall'), 'trigData_sel'(in 'Pall')
      DD = load('AllDataforXcorr_57_EMG.mat');% trigData_sel is only in 'AllDataforXcorr_28.mat_plusTrial'
      conData = DD.plotData_sel{1,1}';

      S1 = size(conData);
      S2 = size(DD.Allfiles);
      S = [S1(1) S2(2)];

      D.EDC = zeros(S);
      D.ECR = zeros(S);
      D.BRD_1 = zeros(S);
      D.FCU = zeros(S);
      D.FCR = zeros(S);
      D.BRD_2 = zeros(S);
      D.FDPr = zeros(S);
      D.FDPu = zeros(S);

      for i = 1:S(2)
         D.EDC(:,i) = DD.plotData_sel{i,1}(1,:)';
         D.ECR(:,i) = DD.plotData_sel{i,1}(2,:)';
         D.BRD_1(:,i) = DD.plotData_sel{i,1}(3,:)';
         D.FCU(:,i) = DD.plotData_sel{i,1}(4,:)';
         D.FCR(:,i) = DD.plotData_sel{i,1}(5,:)';
         D.BRD_2(:,i) = DD.plotData_sel{i,1}(6,:)';
         D.FDPr(:,i) = DD.plotData_sel{i,1}(7,:)';
         D.FDPu(:,i) = DD.plotData_sel{i,1}(8,:)';
      end
      conD = cell(1,12);
      PreSurgDays = 3;
      conD{1} = mean(D.EDC(:,1:PreSurgDays),2);
      conD{2} = mean(D.ECR(:,1:PreSurgDays),2);
      conD{3} = mean(D.BRD_1(:,1:PreSurgDays),2);
      conD{4} = mean(D.FCU(:,1:PreSurgDays),2);
      conD{5} = mean(D.FCR(:,1:PreSurgDays),2);
      conD{6} = mean(D.BRD_2(:,1:PreSurgDays),2);
      conD{7} = mean(D.FDPr(:,1:PreSurgDays),2);
      conD{8} = mean(D.FDPu(:,1:PreSurgDays),2);
      E = DD.EMGs;
      
   case 'Synergy'
      DD = load('AllDataforXcorr_28_syn.mat');
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
      PreSurgDays = 3;
      
      conD{1} = mean(D.syn1(:,1:PreSurgDays),2);
      conD{2} = mean(D.syn2(:,1:PreSurgDays),2);
      conD{3} = mean(D.syn3(:,1:PreSurgDays),2);
      conD{4} = mean(D.syn4(:,1:PreSurgDays),2);
      E = DD.EMGs;
end
end
function [Re] = EachXcorr(TarN)
% DD = load('DataSetForEachXcorr.mat');
DD = load('DataSetForEachXcorr_57_EMG.mat');
Re.T1 = calEXcorr(DD.TrigData_Each.T1,TarN);
Re.T2 = calEXcorr(DD.TrigData_Each.T2,TarN);
Re.T3 = calEXcorr(DD.TrigData_Each.T3,TarN);
Re.T4 = calEXcorr(DD.TrigData_Each.T4,TarN);
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