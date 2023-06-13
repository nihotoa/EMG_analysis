%% settings
realname = 'SesekiL';
% avetrial = 'subEMG';
avetrial = 'EMGenergy';
switch realname 
   case 'SesekiL'
      synN     = 4;
      preDaysN = 3;
      EMGsyn   = {'BRD';'Deltoid';'ECR';'ECU';'ED23';'ED45';'EDC';'FDP';'PL'};
      EMGemg   = {'EDC';'ED23';'ED45';'ECU';'ECR';'Deltoid';'FDS';'FDP';'FCR';'FCU';'PL';'BRD'};

      combEMG  = [1, 12;%BRD
                  2,  6;%Deltoid
                  3,  5;%ECR
                  4,  4;%ECU
                  5,  2;%ED23
                  6,  3;%ED45
                  7,  1;%EDC
                  8,  8;%FDP
                  9, 11];%PL
      EMGselect = [5 6 7 8 9];
      Col = load('YaSeColData', 'SeCol');
      c = [zeros(3,3); Col.SeCol;];
      % %% load EMG data
      cd([realname '/easyData/P-DATA'])
      origPath = pwd;
      % EMG set for x-correlation
      EMGdataset = load('DataSetForEachXcorr_28_EMG_Range1_plusTrial.mat');
      % %% load trial temporal synergy data
      SYNdataset = load('DataSetForEachXcorr_28_syn_Range1_plusTrial.mat');
      % %% load spatial synergy data
      synWt = load('DataSetForEachXcorr_28_syn_Wt.mat','Wt');
      
   case 'Yachimun'
      synN     = 4;
      preDaysN = 4;
      EMGsyn   = {'BRD';'ECR';'ECU';'ED23';'EDCdist';'EDCprox';'FCR';'FCU';'FDP';'FDSdist';'FDSprox';'PL'};
      EMGemg   = {'FDP';'FDSprox';'FDSdist';'FCU';'PL';'FCR';'BRD';'ECR';'EDCprox';'EDCdist';'ED23';'ECU'};
      combEMG  = [1,  7;%BRD
                  2,  8;%ECR
                  3, 12;%ECU
                  4, 11;%ED23
                  5, 10;%EDCdist
                  6,  9;%EDCprox
                  7,  6;%FCR
                  8,  4;%FCU
                  9,  1;%FDP
                  10, 3;%FDSdist
                  11, 2;%FDSprox
                  12, 5];%PL
      EMGselect  = [4 5 9 10];
      Col = load('YaSeColData', 'YaCol');
      c = [zeros(4,3); Col.YaCol;];
      cd([realname '/easyData/P-DATA'])
      origPath   = pwd;
      EMGdataset = load('DataSetForEachXcorr_51_EMG_Range2_plusTrial.mat');
      SYNdataset = load('DataSetForEachXcorr_51_syn_Range2_plusTrial.mat');
      synWt      = load('DataSetForEachXcorr_51_syn_Wt.mat','Wt');
      
end
%% get data
switch avetrial
   case 'trial'
      cd(origPath)
      % EMG
      % EMGtrig1 = EMGdataset.TrigData_Each.T1.trialdata;
      EMGtrig2 = EMGdataset.TrigData_Each.T2.trialdata;
      EMGtrig3 = EMGdataset.TrigData_Each.T3.trialdata;
      % EMGtrig4 = EMGdataset.TrigData_Each.T4.trialdata;

      % synergy
      % SYNtrig1 = SYNdataset.TrigData_Each.T1.trialdata;
      SYNtrig2 = SYNdataset.TrigData_Each.T2.trialdata;
      SYNtrig3 = SYNdataset.TrigData_Each.T3.trialdata;
      % SYNtrig4 = SYNdataset.TrigData_Each.T4.trialdata;
      R2 = zeros(length(EMGsyn),length(EMGsyn),length(synWt.Wt));
      R3 = zeros(length(EMGsyn),length(EMGsyn),length(synWt.Wt));
      for tar = 1:length(synWt.Wt)
         conEMG2   = EMGtrig2{tar};
         conEMG3   = EMGtrig3{tar};
         ReconEMG2 = cell(length(SYNtrig2{tar}{1}(:,1)),1);
         ReconEMG3 = cell(length(SYNtrig2{tar}{1}(:,1)),1);
         RALT2 = zeros(length(EMGsyn),length(EMGsyn),length(SYNtrig2{tar}{1}(:,1)));
         RALT3 = zeros(length(EMGsyn),length(EMGsyn),length(SYNtrig2{tar}{1}(:,1)));
         for trl = 1:length(SYNtrig2{tar}{1}(:,1))
            %synEMG
            synALT2 = synWt.Wt{tar}*[SYNtrig2{tar}{1}(trl,:);SYNtrig2{tar}{2}(trl,:);SYNtrig2{tar}{3}(trl,:);SYNtrig2{tar}{4}(trl,:)];
            synALT3 = synWt.Wt{tar}*[SYNtrig3{tar}{1}(trl,:);SYNtrig3{tar}{2}(trl,:);SYNtrig3{tar}{3}(trl,:);SYNtrig3{tar}{4}(trl,:)];
            %conEMG
            alt2 = cell(length(EMGsyn),1);
            alt3 = cell(length(EMGsyn),1);
            for m = 1:length(EMGsyn)
               alt2{m} = conEMG2{combEMG(m,2)}(trl,:);
               alt3{m} = conEMG3{combEMG(m,2)}(trl,:);
            end
            conALT2 = cell2mat(alt2);
            Ralt2 = corrcoef([conALT2' synALT2']);
            RALT2(:,:,trl) = Ralt2(1:length(EMGsyn),end-length(EMGsyn)+1:end);
            conALT3 = cell2mat(alt3);
            Ralt3 = corrcoef([conALT3' synALT3']);
            RALT3(:,:,trl) = Ralt3(1:length(EMGsyn),end-length(EMGsyn)+1:end);
         end
         R2(:,:,tar) = mean(RALT2,3);
         R3(:,:,tar) = mean(RALT3,3);
      end
%       %% plot result
      % trig2
      c = jet(length(EMGsyn));
      figure; 
      for ES = EMGselect
         avePreR = mean(permute(R2(ES,ES,1:preDaysN),[3 2 1]));
         plot(permute(R2(ES,ES,:),[3 2 1])-avePreR,'Color',c(ES,:),'LineWidth',1.3)
         hold on
      end
      figure; 
      for ES = EMGselect
         avePreR = mean(permute(R3(ES,ES,1:preDaysN),[3 2 1]));
         plot(permute(R3(ES,ES,:),[3 2 1])-avePreR,'Color',c(ES,:),'LineWidth',1.3)
         hold on
      end
      
   case 'ave'
      cd(origPath)
      % EMG
      % EMGtrig1 = EMGdataset.TrigData_Each.T1.data;
      EMGtrig2 = EMGdataset.TrigData_Each.T2.data;
      EMGtrig3 = EMGdataset.TrigData_Each.T3.data;
      % EMGtrig4 = EMGdataset.TrigData_Each.T4.data;
      % synergy
      % SYNtrig1 = SYNdataset.TrigData_Each.T1.data;
      SYNtrig2 = SYNdataset.TrigData_Each.T2.data;
      SYNtrig3 = SYNdataset.TrigData_Each.T3.data;
      % SYNtrig4 = SYNdataset.TrigData_Each.T4.data;
      R2 = zeros(length(EMGsyn),length(EMGsyn),length(synWt.Wt));
      R3 = zeros(length(EMGsyn),length(EMGsyn),length(synWt.Wt));
      for tar = 1:length(synWt.Wt)
         conEMG2   = EMGtrig2{tar}(combEMG(:,2),:);
         conEMG3   = EMGtrig3{tar}(combEMG(:,2),:);
         ReconEMG2 = synWt.Wt{tar}*SYNtrig2{tar};
         ReconEMG3 = synWt.Wt{tar}*SYNtrig3{tar};
         Ralt2 = corrcoef([conEMG2' ReconEMG2']);
         R2(:,:,tar) = Ralt2(1:length(EMGsyn),end-length(EMGsyn)+1:end);
         Ralt3 = corrcoef([conEMG3' ReconEMG3']);
         R3(:,:,tar) = Ralt3(1:length(EMGsyn),end-length(EMGsyn)+1:end);
      end
      c = jet(length(EMGsyn));
      figure; 
      for ES = EMGselect
         avePreR = 0;%mean(permute(R2(ES,ES,1:preDaysN),[3 2 1]));
         plot(x,permute(R2(ES,ES,:),[3 2 1])-avePreR,'Color',c(ES,:),'LineWidth',1.3)
         hold on
      end
      figure; 
      for ES = EMGselect
         avePreR = 0;%mean(permute(R3(ES,ES,1:preDaysN),[3 2 1]));
         plot(x,permute(R3(ES,ES,:),[3 2 1])-avePreR,'Color',c(ES,:),'LineWidth',1.3)
         hold on
      end
      
   case 'subEMG'
      cd(origPath)
      EMGall2 = cell(1,length(synWt.Wt));
      EMGall3 = cell(1,length(synWt.Wt));
      % EMG
      % EMGtrig1 = EMGdataset.TrigData_Each.T1.trialdata;
      EMGtrig2 = EMGdataset.TrigData_Each.T2.trialdata;
      EMGtrig3 = EMGdataset.TrigData_Each.T3.trialdata;
      % EMGtrig4 = EMGdataset.TrigData_Each.T4.trialdata;

      % synergy
      % SYNtrig1 = SYNdataset.TrigData_Each.T1.trialdata;
      SYNtrig2 = SYNdataset.TrigData_Each.T2.trialdata;
      SYNtrig3 = SYNdataset.TrigData_Each.T3.trialdata;
      % SYNtrig4 = SYNdataset.TrigData_Each.T4.trialdata;
      R2 = zeros(length(EMGsyn),length(EMGtrig2{1}{1}(1,:)),length(synWt.Wt));
      R3 = zeros(length(EMGsyn),length(EMGtrig3{1}{1}(1,:)),length(synWt.Wt));
      for tar = 1:length(synWt.Wt)
         conEMG2   = EMGtrig2{tar};
         conEMG3   = EMGtrig3{tar};
         ReconEMG2 = cell(length(SYNtrig2{tar}{1}(:,1)),1);
         ReconEMG3 = cell(length(SYNtrig2{tar}{1}(:,1)),1);
         RALT2 = zeros(length(EMGsyn),length(SYNtrig2{tar}{1}(1,:)),length(SYNtrig2{tar}{1}(:,1)));
         RALT3 = zeros(length(EMGsyn),length(SYNtrig3{tar}{1}(1,:)),length(SYNtrig2{tar}{1}(:,1)));
         for trl = 1:length(SYNtrig2{tar}{1}(:,1))
            %synEMG
            synALT2 = synWt.Wt{tar}*[SYNtrig2{tar}{1}(trl,:);SYNtrig2{tar}{2}(trl,:);SYNtrig2{tar}{3}(trl,:);SYNtrig2{tar}{4}(trl,:)];
            synALT3 = synWt.Wt{tar}*[SYNtrig3{tar}{1}(trl,:);SYNtrig3{tar}{2}(trl,:);SYNtrig3{tar}{3}(trl,:);SYNtrig3{tar}{4}(trl,:)];
            %conEMG
            alt2 = cell(length(EMGsyn),1);
            alt3 = cell(length(EMGsyn),1);
            for m = 1:length(EMGsyn)
               alt2{m} = conEMG2{combEMG(m,2)}(trl,:);
               alt3{m} = conEMG3{combEMG(m,2)}(trl,:);
            end
            conALT2 = cell2mat(alt2);
            Ralt2 = conALT2 - synALT2;
            RALT2(:,:,trl) = Ralt2;
            conALT3 = cell2mat(alt3);
            Ralt3 = conALT3 - synALT3;
            RALT3(:,:,trl) = Ralt3;
         end
         R2(:,:,tar) = mean(RALT2,3);
         R3(:,:,tar) = mean(RALT3,3);
         EMGall2{tar} = RALT2;
         EMGall3{tar} = RALT3;
      end
      %  plot result
      % trig2
      c = jet(length(synWt.Wt)-preDaysN);
      
      for ES = EMGselect
         figure('Position',[0 720 600 400])
         title(['trig2 ' EMGsyn{EMGselect} 'pre'])
         E2_ave = mean(permute(R2(ES,:,1:preDaysN),[3 2 1]));
         E2_std =  std(permute(R2(ES,:,1:preDaysN),[3 2 1]));
         plot(E2_ave,'Color',c(ES,:),'LineWidth',1.3);
         figure('Position',[600 720 600 400])
         title(['trig2 ' EMGsyn{EMGselect} 'post'])
         E2_post = permute(R2(ES,:,:),[3 2 1]);
         for tar = preDaysN+1:length(synWt.Wt)-preDaysN
            plot(E2_post(tar,:),'Color',c(tar,:),'LineWidth',1.3)
            hold on
         end
      end
%       figure;
      for ES = EMGselect
         figure('Position',[0 720 600 400])
         title(['trig3 ' EMGsyn{EMGselect} 'pre'])
         E3_ave = mean(permute(R3(ES,:,1:preDaysN),[3 2 1]));
         E3_std =  std(permute(R3(ES,:,1:preDaysN),[3 2 1]));
         plot(E3_ave,'Color',c(ES,:),'LineWidth',1.3);
         figure('Position',[600 720 600 400])
         title(['trig3 ' EMGsyn{EMGselect} 'post'])
         E3_post = permute(R3(ES,:,:),[3 2 1]);
         for tar = preDaysN+1:length(synWt.Wt)-preDaysN
            plot(E3_post(tar,:),'Color',c(tar,:),'LineWidth',1.3)
            hold on
         end
      end
      
    case 'EMGenergy'
        cd(origPath)
      EMGall2 = cell(1,length(synWt.Wt));
      EMGall3 = cell(1,length(synWt.Wt));
      % EMG
      % EMGtrig1 = EMGdataset.TrigData_Each.T1.trialdata;
      EMGtrig2 = EMGdataset.TrigData_Each.T2.trialdata;
      EMGtrig3 = EMGdataset.TrigData_Each.T3.trialdata;
      % EMGtrig4 = EMGdataset.TrigData_Each.T4.trialdata;

      % synergy
      % SYNtrig1 = SYNdataset.TrigData_Each.T1.trialdata;
      SYNtrig2 = SYNdataset.TrigData_Each.T2.trialdata;
      SYNtrig3 = SYNdataset.TrigData_Each.T3.trialdata;
      % SYNtrig4 = SYNdataset.TrigData_Each.T4.trialdata;
      R2 = zeros(length(EMGsyn),length(EMGtrig2{1}{1}(1,:)),length(synWt.Wt));
      R3 = zeros(length(EMGsyn),length(EMGtrig3{1}{1}(1,:)),length(synWt.Wt));
      for tar = 1:length(synWt.Wt)
         conEMG2   = EMGtrig2{tar};
         conEMG3   = EMGtrig3{tar};
         ReconEMG2 = cell(length(SYNtrig2{tar}{1}(:,1)),1);
         ReconEMG3 = cell(length(SYNtrig2{tar}{1}(:,1)),1);
         RALT2 = zeros(length(EMGsyn),length(SYNtrig2{tar}{1}(1,:)),length(SYNtrig2{tar}{1}(:,1)));
         RALT3 = zeros(length(EMGsyn),length(SYNtrig3{tar}{1}(1,:)),length(SYNtrig2{tar}{1}(:,1)));
         for trl = 1:length(SYNtrig2{tar}{1}(:,1))
            %synEMG
            synALT2 = synWt.Wt{tar}*[SYNtrig2{tar}{1}(trl,:);SYNtrig2{tar}{2}(trl,:);SYNtrig2{tar}{3}(trl,:);SYNtrig2{tar}{4}(trl,:)];
            synALT3 = synWt.Wt{tar}*[SYNtrig3{tar}{1}(trl,:);SYNtrig3{tar}{2}(trl,:);SYNtrig3{tar}{3}(trl,:);SYNtrig3{tar}{4}(trl,:)];
            %conEMG
            alt2 = cell(length(EMGsyn),1);
            alt3 = cell(length(EMGsyn),1);
            for m = 1:length(EMGsyn)
               alt2{m} = conEMG2{combEMG(m,2)}(trl,:);
               alt3{m} = conEMG3{combEMG(m,2)}(trl,:);
            end
            conALT2 = cell2mat(alt2);
%             Ralt2 = conALT2 - synALT2;
            RALT2(:,:,trl) = conALT2;
            conALT3 = cell2mat(alt3);
%             Ralt3 = conALT3 - synALT3;
            RALT3(:,:,trl) = conALT3;
         end
         R2(:,:,tar) = mean(RALT2,3);
         R3(:,:,tar) = mean(RALT3,3);
         EMGall2{tar} = RALT2;
         EMGall3{tar} = RALT3;
      end
      %  plot result
      % trig2
        SUM2energy = cell(length(EMGall2),1);
        SUM2energy_ave = cell(length(EMGall2),1);
        SUM2energy_std = cell(length(EMGall2),1);
        for tar = 1:length(EMGall2)
            SUM2energy{tar}     = permute(sum(EMGall2{tar}(:,:,:)),[3,2,1]);
            SUM2energy_ave{tar} = mean(SUM2energy{tar});
            SUM2energy_std{tar} = std(SUM2energy{tar});
        end
        controlEMG = SUM2energy_ave{1};
        for pdN = 2:preDaysN
           controlEMG = controlEMG + SUM2energy_ave{pdN};
        end
        controlEMG = controlEMG./preDaysN;
        figure
%         c = Col;
%         c = zeros(122,3);
%         c(:,1) = ones(Sp,1).*linspace(0.3,1,Sp)';
        c = jet(length(SUM2energy));
        x_per = linspace(-15,15,length(SUM2energy_ave{1}));
        for tar = preDaysN+1:length(SUM2energy)
%             plot(SUM2energy_ave{tar},'Color',c(tar,:))
%             plot(x_per, SUM2energy_ave{tar}-controlEMG,'Color',c(tar,:), 'LineWidth', 1.3)
            plot(x_per, SUM2energy_ave{tar},'Color',c(tar,:), 'LineWidth', 1.3)
            hold on
        end
        xlabel('Task Range[%]')
        ylabel('Sum of Amplitude [uV]')
        a = gca;
        a.FontSize = 20;
        a.FontWeight = 'bold';
        a.FontName = 'Arial';
%       figure;
        SUM3energy = cell(length(EMGall2),1);
        SUM3energy_ave = cell(length(EMGall3),1);
        SUM3energy_std = cell(length(EMGall3),1);
        for tar = 1:length(EMGall3)
            SUM3energy{tar}     = permute(sum(EMGall3{tar}(:,:,:)),[3,2,1]);
            SUM3energy_ave{tar} = mean(SUM3energy{tar});
            SUM3energy_std{tar} = std(SUM3energy{tar});
        end
        controlEMG = SUM3energy_ave{1};
        for pdN = 2:preDaysN
           controlEMG = controlEMG + SUM3energy_ave{pdN};
        end
        controlEMG = controlEMG./preDaysN;
        figure
        c = jet(length(SUM3energy));
        x_per = linspace(-15,15,length(SUM3energy_ave{1}));
        for tar = preDaysN+1:length(SUM3energy)
%             plot(SUM3energy_ave{tar},'Color',c(tar,:))
%             plot(x_per, SUM3energy_ave{tar}-controlEMG,'Color',c(tar,:), 'LineWidth', 1.3)
            plot(x_per, SUM3energy_ave{tar},'Color',c(tar,:), 'LineWidth', 1.3)
            hold on
        end
        xlabel('Task Range[%]')
        ylabel('Sum of Amplitude [uV]')
        a = gca;
        a.FontSize = 20;
        a.FontWeight = 'bold';
        a.FontName = 'Arial';
end
   