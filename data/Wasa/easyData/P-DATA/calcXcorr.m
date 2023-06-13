function [Re,ResE] = calcXcorr()
Tar = 'EMG';           %'EMG','Synergy'

switch Tar
   case 'EMG'
      TarN = 14;           %EMG num
      [D,conD,EMGs] = LoadCorrData(Tar);
      Co = cell2mat(conD);
      Sco = size(Co);
      s = 2*Sco(1) - 1;
      for i = 1:TarN
         eval(['Re.' EMGs{i,1} '= cell(1,TarN);']); 
      %    eval(['Re.' EMGs{i,1} '{1,i}= zeros(s,81);']);
         for k = 1:TarN
             eval(['Re.' EMGs{i,1} '{1,k}= zeros(86,1);']);
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
      s_order = [2 1 4 3];
      [D,conD,EMGs] = LoadCorrData(Tar);
      Co = cell2mat(conD);
      Sco = size(Co);
      s = 2*Sco(1) - 1;
      for i = 1:TarN%s_order
         eval(['Re.syn' sprintf('%d',i) '= cell(1,TarN);']); 
      %    eval(['Re.' EMGs{i,1} '{1,i}= zeros(s,81);']);
         for k = 1:TarN%s_order
             eval(['Re.syn' sprintf('%d',i) '{1,k}= zeros(80,1);']);
             for j = 1:80
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
TarN = 14;
switch Tar
   case 'EMG'
      DD = load('AllDataforXcorr_86.mat');
      
      conData = DD.plotData_sel{1,1}';

      S1 = size(conData);
      S2 = size(DD.Allfiles);
      S = [S1(1) S2(2)];

      D.Delt = zeros(S);
      D.Biceps = zeros(S);
      D.Triceps = zeros(S);
      D.BRD = zeros(S);
      D.cuff = zeros(S);
      D.ED23 = zeros(S);
      D.ED45 = zeros(S);
      D.ECR = zeros(S);
      D.ECU = zeros(S);
      D.EDC = zeros(S);
      D.FDS = zeros(S);
      D.FDP = zeros(S);
      D.FCU = zeros(S);
      D.FCR = zeros(S);

      for i = 1:S(2)
         D.Delt(:,i) = DD.plotData_sel{i,1}(1,:)';
         D.Biceps(:,i) = DD.plotData_sel{i,1}(2,:)';
         D.Triceps(:,i) = DD.plotData_sel{i,1}(3,:)';
         D.BRD(:,i) = DD.plotData_sel{i,1}(4,:)';
         D.cuff(:,i) = DD.plotData_sel{i,1}(5,:)';
         D.ED23(:,i) = DD.plotData_sel{i,1}(6,:)';
         D.ED45(:,i) = DD.plotData_sel{i,1}(7,:)';
         D.ECR(:,i) = DD.plotData_sel{i,1}(8,:)';
         D.ECU(:,i) = DD.plotData_sel{i,1}(9,:)';
         D.EDC(:,i) = DD.plotData_sel{i,1}(10,:)';
         D.FDS(:,i) = DD.plotData_sel{i,1}(11,:)';
         D.FDP(:,i) = DD.plotData_sel{i,1}(12,:)';
         D.FCU(:,i) = DD.plotData_sel{i,1}(13,:)';
         D.FCR(:,i) = DD.plotData_sel{i,1}(14,:)';
      end
      conD = cell(1,TarN);
      conD{1} = mean(D.Delt(:,12:15),2);
      conD{2} = mean(D.Biceps(:,12:15),2);
      conD{3} = mean(D.Triceps(:,12:15),2);
      conD{4} = mean(D.BRD(:,12:15),2);
      conD{5} = mean(D.cuff(:,12:15),2);
      conD{6} = mean(D.ED23(:,12:15),2);
      conD{7} = mean(D.ED45(:,12:15),2);
      conD{8} = mean(D.ECR(:,12:15),2);
      conD{9} = mean(D.ECU(:,12:15),2);
      conD{10} = mean(D.EDC(:,12:15),2);
      conD{11} = mean(D.FDS(:,12:15),2);
      conD{12} = mean(D.FDP(:,12:15),2);
      conD{13} = mean(D.FCU(:,12:15),2);
      conD{14} = mean(D.FCR(:,12:15),2);
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
      DD = load('AllDataforXcorr_86_syn.mat');
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
function [Re] = EachXcorr(TarN)
DD = load('DataSetForEachXcorr_86.mat');
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