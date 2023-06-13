clear
%% settings
monkeyname = 'Ya';
mode = 3;
days = [...
%         %pre-surgery
%          170405; ...
%          170406; ...
%          170410; ...
%          170411; ...
%          170412; ...
%          170413; ...
% %          170414; ...
%          170419; ...
%          170420; ...
%          170421; ...
%          170424; ...
%          170425; ...
%          170426; ...
%          170501; ...
%          170502; ...
%          170508; ...
%          170509; ...
% %           170510; ...
%          170511; ...
%          170512; ...
%          170515; ...
%          170516; ...
%          170517; ...
%          170524; ...
%          170526; ...
%          170529; ...
% %         170605	; ...%post-surgery()
%         170606	; ...
% %         170607	; ...
%         170608	; ...
%         170612	; ...
%         170613	; ...
%         170614	; ...
%         170615	; ...
%         170616	; ...
% %         170619	; ...
%         170620	; ...
%         170621	; ...
%         170622	; ...
%         170623	; ...
%         170627	; ...
        170628	; ...
        170629	; ...
        170630	; ...
        170703	; ...
        170704	; ...
% %         170705	; ...
        170706	; ...
        170707	; ...
        170710	; ...
        170711	; ...
        170712	; ...
        170713	; ...
        170714	; ...
        170718	; ...
        170719	; ...
        170720	; ...
        170725	; ...
        170726	; ...
% %         170801	; ...
        170802	; ...
        170803	; ...
        170804	; ...
        170807	; ...
        170808	; ...
        170809	; ...
        170810	; ...
        170815	; ...
% %         170816	; ...
        170817	; ...
        170818	; ...
        170822	; ...
        170823	; ...
        170824	; ...
        170825	; ...
        170829	; ...
        170830	; ...
        170831	; ...
        170901	; ...
        170904	; ...
        170905	; ...
        170906	; ...
        170907	; ...
        170908	; ...
        170911	; ...
        170913	; ...
        170914	; ...
        170925  ;...
        170926  ; ...
        170927  ; ...
        170929  ; ...
         ];

% days = [170711 170720 170802 170830];
%   days = [170517 170524 170526 170529];
% days = [170703 170707 170711 170714 170720 170802 170824 170830 170907 170914 170925];
 group_num = 1;
 syn_num = 4;

 Ld = length(days);
 %% mode1
 if mode ==1
         tRange = 1500;
         synH_Hz = 100;
         t_num = tRange/1000 * synH_Hz;
         EMGgroups = ones(1,Ld).* group_num;
         c = jet(Ld);
         switch group_num
            case 1
                %without 'Deltoid'
                EMG_num = 12;
                EMGs = {'BRD';'ECR';'ECU';'ED23';'EDCdist';'EDCprox';'FCR';'FCU';'FDP';...
                        'FDSdist';'FDSprox';'PL'};
        %     case 2
        %         %only extensor
        %         EMG_num = 5;
        %         EMGs = {'ECR';'ECU';'ED23';'ED45';'EDC'};
        %     case 3
        %         %only flexor
        %         EMG_num = 4;
        %         EMGs = {'FCR';'FCU';'FDP';'FDS'};
        %     case 4
        %         %forearm
        %         EMG_num = 10;
        %         EMGs = {'BRD';'ECR';'ECU';'ED23';'ED45';'EDC';'FCR';'FCU';'FDP';'FDS'};
        %     case 5
        %     %forearm
        %     EMG_num = 11;
        %     EMGs = {'BRD';'ECR';'ECU';'ED23';'ED45';'EDC';'FCR';'FCU';'FDP';'FDS';'Triceps'};     
        end

        % days = [180928 181019];
        % EMGgroups = [1,1];
        % EMG_num = 12;
        save_fig = 1;
        %% load
        Hx =  cell(1,Ld);

        for i = 1:Ld
            cd([monkeyname mat2str(days(i))])
            cd([monkeyname mat2str(days(i)) '_syn_result_' sprintf('%d',EMG_num)])
            cd([monkeyname mat2str(days(i)) '_H'])
                load([monkeyname mat2str(days(i)) '_aveH_' sprintf('%d',syn_num)],'aveH');
                Hx{i} = aveH;
            cd ../../../
        end

        cd order_tim_list
        cd([monkeyname mat2str(days(1)) 'to' mat2str(days(end)) '_' sprintf('%d',Ld)])
            load([monkeyname mat2str(days(1)) 'to' mat2str(days(end)) '_' sprintf('%d',Ld) '_' sprintf('%d',syn_num) '.mat'],'k_arr');
            load Tim_per.mat;
        cd ../../



        Hcom = zeros(syn_num,t_num);
        Ht = cell(1,Ld);
        Ht = Hx;
        Hxs = Hx; 
        aveHt = Ht{1};
        m = zeros(Ld,syn_num);
        sel_pointData = cell(1,syn_num); %zeros(Ld,2);
        for i =  1:syn_num
            for j = 2:Ld
                for l = 1:syn_num
                    Hcom(l,:) = (Hx{1,1}(i,:) - Hx{1,j}(l,:)).^ 2;
                    m(j,l) = sum(Hcom(l,:));
                end
        %         Ht{1,j}(i,:) = Hx{1,j}(find(m(j,:)==min(m(j,:))),:);
        %         Hx{1,j}(find(m(j,:)==min(m(j,:))),:) = ones(1,t_num).*1000;
                Ht{1,j}(i,:) = Hx{1,j}(k_arr(i,j),:);
                Hx{1,j}(k_arr(i,j),:) = ones(1,t_num).*1000;
            end
        end

        AVE = Ht{1,1};
        SD = Ht{1,1};
        SDf = Ht{1,1};
        for i = 2:Ld
            AVE = AVE + Ht{1,i};
        end
        AVE = AVE./Ld;
        for j = 1:syn_num
            for i = 1:Ld
                SDf(i,:) = Ht{1,i}(j,:);
            end
            SD(j,:) = std(SDf,1,1);
        end
        mSD = -SD;
        %% plot
        eval(['All_tim_per = ' monkeyname mat2str(days(1)) '_SUC_tim_per;'])
        for i=1:Ld
            eval(['All_tim_per(i,:) = mean(' monkeyname mat2str(days(i)) '_SUC_tim_per);'])
        % eval(['All_tim_per = [All_tim_per; ' monkeyname mat2str(days(i)) '_SUC_tim_per];'])

        end
        pointData = zeros(Ld,2);
        for i = 1:syn_num 
            for j = 1:Ld
            pointData(j,1) = Ht{1,j}(i,floor(t_num*All_tim_per(j,1)));
            pointData(j,2) = Ht{1,j}(i,floor(t_num*All_tim_per(j,2)));
            end
            sel_pointData{1,i} = pointData; 
        end

        All_tim_per = All_tim_per.*100;
        f1 = figure('Position',[300,0,450,750]);
        x_per = linspace(0,100,t_num);
        for i=1:syn_num 
            subplot(syn_num,1,i);
            yyaxis left;
            h1 = histogram(All_tim_per(:,2),'BinWidth',4,'FaceColor',[0.6 0 0.5]);
            hold on;
        %     tim_per_m = mean(All_tim_per(:,1));
        %     plot([tim_per_m tim_per_m],[0 30],'r');
        %     hold on;
            h2 = histogram(All_tim_per(:,1),'BinWidth',4);
            hold on;
        %     tim_per_m = mean(All_tim_per(:,2));
        %     plot([tim_per_m tim_per_m],[0 30],'r');

            yyaxis right;
            tim_per_m = mean(All_tim_per(:,1));
            plot([tim_per_m tim_per_m],[0 30],'r');
            hold on;
            tim_per_m = mean(All_tim_per(:,2));
            plot([tim_per_m tim_per_m],[0 30],'r');
            hold on;
            for j = 1:Ld
                plot(x_per,Ht{1,j}(i,:),'-','Color',c(j,:),'LineWidth',1.1);
%                 plot(x_per,Ht{1,j}(i,:),'-','k','LineWidth',1.3);
                hold on;
            end
            ylim([0 2]);
            xlabel('obj1 start - obj2 end [%]') % x-axis label
            title([monkeyname mat2str(days(1)) 'to' mat2str(days(end)) ' ' sprintf('%d',Ld) '  Ht ']);
        end
        f2 = figure('Position',[900,0,450,750]);
        % x = 1:1:t_num;                     % create data for the line plot
        for i=1:syn_num 
            sd = SD(i,:);
            y = AVE(i,:);
            xconf = [x_per x_per(end:-1:1)];
            yconf = [y+sd y(end:-1:1)-sd(end:-1:1)];
            subplot(syn_num,1,i);

            fi = fill(xconf,yconf,'k');
            fi.FaceColor = [0.8 0.8 1];       % make the filled area pink
            fi.EdgeColor = 'none';            % remove the line around the filled area
            hold on
            tim_per_m = mean(All_tim_per(:,1));
            plot([tim_per_m tim_per_m],[0 30],'r');
            hold on;
            tim_per_m = mean(All_tim_per(:,2));
            plot([tim_per_m tim_per_m],[0 30],'r');
            hold on;
            plot(x_per, AVE(i,:),'Color','k','LineWidth',1.1);
            ylim([0 2]);
            xlabel('obj1 start - obj2 end [%]') % x-axis label
            title([monkeyname mat2str(days(1)) 'to' mat2str(days(end)) ' ' sprintf('%d',Ld) '  Ht ']);
        end
        HC_rslt = cell(1,syn_num);
        Hcorr = zeros(t_num,Ld);
        for jj = 1:syn_num
            for ii = 1:Ld
                Hcorr(:,ii) = Ht{1,ii}(jj,:)';
            end
            HC_rslt{jj} = xcorr(Hcorr);
        end

        % f3 = figure('Position',[900,0,600,1000]);
        % x = 1:1:t_num;                     % create data for the line plot
        for i=1:syn_num 
            f3 = figure;
            hold on;
            for j = 1:Ld
                scatter(All_tim_per(j,1),sel_pointData{1,i}(j,1),'MarkerEdgeColor',c(j,:),'MarkerFaceColor',c(j,:));
                scatter(All_tim_per(j,2),sel_pointData{1,i}(j,2),'MarkerEdgeColor',c(j,:),'MarkerFaceColor',c(j,:));
            end
            ylim([0 2]);
            xlim([0 100]);
            xlabel('obj1 start - obj2 end [%]') % x-axis label
            title([monkeyname mat2str(days(1)) 'to' mat2str(days(end)) ' ' sprintf('%d',Ld) '  Ht timpoint']);
            saveas(f3,['TimD' sprintf('%d',syn_num) mat2str(days(1)) 'to' mat2str(days(end)) '_' sprintf('%d',Ld) '_' sprintf('%d',syn_num) '-' sprintf('%d',i) '.png']);
        end
        %% save
        if save_fig == 1
             cd syn_figures;
                saveas(f1,['H' sprintf('%d',syn_num) mat2str(days(1)) 'to' mat2str(days(end)) '_' sprintf('%d',Ld) '_hist.png']);
                saveas(f1,['H' sprintf('%d',syn_num) mat2str(days(1)) 'to' mat2str(days(end)) '_' sprintf('%d',Ld) '_hist.pdf']);
                saveas(f1,['H' sprintf('%d',syn_num) mat2str(days(1)) 'to' mat2str(days(end)) '_' sprintf('%d',Ld) '_hist.fig']);
                saveas(f2,['aveH' sprintf('%d',syn_num) mat2str(days(1)) 'to' mat2str(days(end)) '_' sprintf('%d',Ld) '_hist.png']);
                saveas(f2,['aveH' sprintf('%d',syn_num) mat2str(days(1)) 'to' mat2str(days(end)) '_' sprintf('%d',Ld) '_hist.pdf']);
                saveas(f2,['aveH' sprintf('%d',syn_num) mat2str(days(1)) 'to' mat2str(days(end)) '_' sprintf('%d',Ld) '_hist.fig']);
             cd ../;
        end
 end
%% mode3

if mode ==3
%      plot_order = linspace(1,syn_num,syn_num);
%      plot_order = [1,2,3,4];
            tRange = 2500;
         synH_Hz = 100;
         t_num = tRange/1000 * synH_Hz;
         EMGgroups = ones(1,Ld).* group_num;
%          c1 = jet(50);
%          c = c1(1:24,:);
%          c = c1(38:83,:);
%          c = c1(5:50,:);
            c = jet(Ld);
         switch group_num
            case 1
                %without 'Deltoid'
                EMG_num = 12;
                EMGs = {'BRD';'ECR';'ECU';'ED23';'EDCdist';'EDCprox';'FCR';'FCU';'FDP';...
                        'FDSdist';'FDSprox';'PL'};
        %     case 2
        %         %only extensor
        %         EMG_num = 5;
        %         EMGs = {'ECR';'ECU';'ED23';'ED45';'EDC'};
        %     case 3
        %         %only flexor
        %         EMG_num = 4;
        %         EMGs = {'FCR';'FCU';'FDP';'FDS'};
        %     case 4
        %         %forearm
        %         EMG_num = 10;
        %         EMGs = {'BRD';'ECR';'ECU';'ED23';'ED45';'EDC';'FCR';'FCU';'FDP';'FDS'};
        %     case 5
        %     %forearm
        %     EMG_num = 11;
        %     EMGs = {'BRD';'ECR';'ECU';'ED23';'ED45';'EDC';'FCR';'FCU';'FDP';'FDS';'Triceps'};     
         end
         
        save_fig = 0;
        %% load
        Hx =  cell(1,Ld);

        for i = 1:Ld
            cd([monkeyname mat2str(days(i))])
            cd([monkeyname mat2str(days(i)) '_syn_result_' sprintf('%d',EMG_num)])
            cd([monkeyname mat2str(days(i)) '_H'])
                load([monkeyname mat2str(days(i)) '_aveH3_' sprintf('%d',syn_num)],'aveH');
                Hx{i} = aveH;
            cd ../../../
        end

        cd order_tim_list
        cd([monkeyname mat2str(days(1)) 'to' mat2str(days(end)) '_' sprintf('%d',Ld)])
            load([monkeyname mat2str(days(1)) 'to' mat2str(days(end)) '_' sprintf('%d',Ld) '_' sprintf('%d',syn_num) '.mat'],'k_arr');
            load Tim_per.mat;
        cd ../../



        Hcom = zeros(syn_num,t_num);
        Ht = cell(1,Ld);
        Ht = Hx;
        Hxs = Hx; 
        aveHt = Ht{1};
        m = zeros(Ld,syn_num);
        sel_pointData = cell(1,syn_num); %zeros(Ld,2);
        for i =  1:syn_num
            for j = 2:Ld
                for l = 1:syn_num
                    Hcom(l,:) = (Hx{1,1}(i,:) - Hx{1,j}(l,:)).^ 2;
                    m(j,l) = sum(Hcom(l,:));
                end
        %         Ht{1,j}(i,:) = Hx{1,j}(find(m(j,:)==min(m(j,:))),:);
        %         Hx{1,j}(find(m(j,:)==min(m(j,:))),:) = ones(1,t_num).*1000;
                Ht{1,j}(i,:) = Hx{1,j}(k_arr(i,j),:);
                Hx{1,j}(k_arr(i,j),:) = ones(1,t_num).*1000;
            end
        end

        AVE = Ht{1,1};
        SD = Ht{1,1};
        SDf = Ht{1,1};
        for i = 2:Ld
            AVE = AVE + Ht{1,i};
        end
        AVE = AVE./Ld;
        for j = 1:syn_num
            for i = 1:Ld
                SDf(i,:) = Ht{1,i}(j,:);
            end
            SD(j,:) = std(SDf,1,1);
        end
        mSD = -SD;
        %% plot
        cd syn_figures;
             mkdir([monkeyname mat2str(days(1)) 'to' mat2str(days(end)) '_' sprintf('%d',length(days))]);
        cd ../
        
%         eval(['All_tim_per = ' monkeyname mat2str(days(1)) '_SUC_tim_per;'])
        All_tim_per = zeros(Ld,2);
        for i=1:Ld
            eval(['All_tim_per(i,:) = mean(' monkeyname mat2str(days(i)) '_SUC_tim_per);'])
        % eval(['All_tim_per = [All_tim_per; ' monkeyname mat2str(days(i)) '_SUC_tim_per];'])

        end
        pointData = zeros(Ld,2);
        for i = 1:syn_num 
            for j = 1:Ld
            pointData(j,1) = Ht{1,j}(i,50+floor((t_num-50)*All_tim_per(j,2)));
            pointData(j,2) = Ht{1,j}(i,50+floor((t_num-50)*All_tim_per(j,1)));
            end
            sel_pointData{1,i} = pointData; 
        end

        All_tim_per = All_tim_per.*100;
%         f1 = figure('Position',[300,0,450,750]);
        x_per = linspace(-25,100,t_num);
        for i=1:syn_num 
%             subplot(syn_num,1,i);
            f1 = figure('Position',[300,250*i,750,400]); 
            yyaxis left;
            h1 = histogram(All_tim_per(:,2),'BinWidth',3,'FaceColor',[0.6 0 0.5]);
            hold on;
        %     tim_per_m = mean(All_tim_per(:,1));
        %     plot([tim_per_m tim_per_m],[0 30],'r');
        %     hold on;
            h2 = histogram(All_tim_per(:,1),'BinWidth',3);
%             hold on;
        %     tim_per_m = mean(All_tim_per(:,2));
        %     plot([tim_per_m tim_per_m],[0 30],'r');

            yyaxis right;
            tim_per_m = mean(All_tim_per(:,1));
            plot([tim_per_m tim_per_m],[0 30],'r-');
%             hold on;
            tim_per_m = mean(All_tim_per(:,2));
            plot([tim_per_m tim_per_m],[0 30],'r-');
            plot([0 0],[0 30],'r-');
%             hold on;
            ylim([0 2]);
            xlim([-25 100]);
            for j = 1:Ld
                plot(x_per,Ht{1,j}(i,:),'-','Color',c(j,:),'LineWidth',1.3);
%                 plot(x_per,Ht{1,j}(i,:),'k-','LineWidth',1.3);
                hold on;
            end
            xlabel('obj1 start - obj2 end [%]') % x-axis label
%             title([monkeyname mat2str(days(1)) 'to' mat2str(days(end)) ' ' sprintf('%d',Ld) '  Ht ' sprintf('%d',i)]);
            if save_fig == 1
             cd syn_figures;
             cd([monkeyname mat2str(days(1)) 'to' mat2str(days(end)) '_' sprintf('%d',length(days))]);
                saveas(f1,['H' sprintf('%d',syn_num) mat2str(days(1)) 'to' mat2str(days(end)) '_' sprintf('%d',Ld) '_hist3_syn' sprintf('%d',i) '.png']);
                orient(f1,'landscape');
                saveas(f1,['H' sprintf('%d',syn_num) mat2str(days(1)) 'to' mat2str(days(end)) '_' sprintf('%d',Ld) '_hist3_syn' sprintf('%d',i) '.pdf']);
                saveas(f1,['H' sprintf('%d',syn_num) mat2str(days(1)) 'to' mat2str(days(end)) '_' sprintf('%d',Ld) '_hist3_syn' sprintf('%d',i) '.fig']);
             cd ../../;
            end 
        end
%         f2 = figure('Position',[900,0,450,750]);
        % x = 1:1:t_num;                     % create data for the line plot
        for i=1:syn_num 
            sd = SD(i,:);
            y = AVE(i,:);
            xconf = [x_per x_per(end:-1:1)];
            yconf = [y+sd y(end:-1:1)-sd(end:-1:1)];
%             subplot(syn_num,1,i);
            f2 = figure('Position',[900,250*i,750,400]);

            fi = fill(xconf,yconf,'k');
            fi.FaceColor = [0.8 0.8 1];       % make the filled area pink
            fi.EdgeColor = 'none';            % remove the line around the filled area
            hold on
            tim_per_m = mean(All_tim_per(:,1));
            plot([tim_per_m tim_per_m],[0 30],'r');
%             hold on;
            tim_per_m = mean(All_tim_per(:,2));
            plot([tim_per_m tim_per_m],[0 30],'r');
            plot([0 0],[0 30],'r');
%             hold on;
            plot(x_per, AVE(i,:),'Color','k','LineWidth',1.1);
            for j = 1:Ld
                scatter(All_tim_per(j,2),sel_pointData{1,i}(j,1),'MarkerEdgeColor',c(j,:),'MarkerFaceColor',c(j,:));
                scatter(All_tim_per(j,1),sel_pointData{1,i}(j,2),'MarkerEdgeColor',c(j,:),'MarkerFaceColor',c(j,:));
            end
            ylim([0 2]);
            xlim([-25 100]);
            xlabel('obj1 start - obj2 end [%]') % x-axis label
%             title([monkeyname mat2str(days(1)) 'to' mat2str(days(end)) ' ' sprintf('%d',Ld) '  Ht ' sprintf('%d',i)]);
            if save_fig == 1
                 cd syn_figures;
                 cd([monkeyname mat2str(days(1)) 'to' mat2str(days(end)) '_' sprintf('%d',length(days))]);
                    saveas(f2,['aveH' sprintf('%d',syn_num) mat2str(days(1)) 'to' mat2str(days(end)) '_' sprintf('%d',Ld) '_hist3_syn' sprintf('%d',i) '.png']);
                    orient(f2,'landscape');
                    saveas(f2,['aveH' sprintf('%d',syn_num) mat2str(days(1)) 'to' mat2str(days(end)) '_' sprintf('%d',Ld) '_hist3_syn' sprintf('%d',i) '.pdf']);
                    saveas(f2,['aveH' sprintf('%d',syn_num) mat2str(days(1)) 'to' mat2str(days(end)) '_' sprintf('%d',Ld) '_hist3_syn' sprintf('%d',i) '.fig']);
                 cd ../../;
            end 

        end
        HC_rslt = cell(1,syn_num);
        Hcorr = zeros(t_num,Ld);
        for jj = 1:syn_num
            for ii = 1:Ld
                Hcorr(:,ii) = Ht{1,ii}(jj,:)';
            end
            HC_rslt{jj} = xcorr(Hcorr);
        end

        % f3 = figure('Position',[900,0,600,1000]);
        % x = 1:1:t_num;                     % create data for the line plot
        
        %%%%%%%plot pnly scatter%%%%%
%         for i=1:syn_num 
%             f3 = figure;
%             hold on;
%             for j = 1:Ld
%                 scatter(All_tim_per(j,1),sel_pointData{1,i}(j,1),'MarkerEdgeColor',c(j,:),'MarkerFaceColor',c(j,:));
%                 scatter(All_tim_per(j,2),sel_pointData{1,i}(j,2),'MarkerEdgeColor',c(j,:),'MarkerFaceColor',c(j,:));
%             end
%             ylim([0 2]);
%             xlim([-25 100]);
%             xlabel('obj1 start - obj2 end [%]') % x-axis label
%             title([monkeyname mat2str(days(1)) 'to' mat2str(days(end)) ' ' sprintf('%d',Ld) '  Ht timpoint']);
%             saveas(f3,['TimD' sprintf('%d',syn_num) mat2str(days(1)) 'to' mat2str(days(end)) '_' sprintf('%d',Ld) '_' sprintf('%d',syn_num) '-' sprintf('%d',i) '3.png']);
%         end
        
        %% save
%         if save_fig == 1
%              cd syn_figures;
%                 saveas(f1,['H' sprintf('%d',syn_num) mat2str(days(1)) 'to' mat2str(days(end)) '_' sprintf('%d',Ld) '_hist3.png']);
%                 saveas(f1,['H' sprintf('%d',syn_num) mat2str(days(1)) 'to' mat2str(days(end)) '_' sprintf('%d',Ld) '_hist3.pdf']);
%                 saveas(f1,['H' sprintf('%d',syn_num) mat2str(days(1)) 'to' mat2str(days(end)) '_' sprintf('%d',Ld) '_hist3.fig']);
%                 saveas(f2,['aveH' sprintf('%d',syn_num) mat2str(days(1)) 'to' mat2str(days(end)) '_' sprintf('%d',Ld) '_hist3.png']);
%                 saveas(f2,['aveH' sprintf('%d',syn_num) mat2str(days(1)) 'to' mat2str(days(end)) '_' sprintf('%d',Ld) '_hist3.pdf']);
%                 saveas(f2,['aveH' sprintf('%d',syn_num) mat2str(days(1)) 'to' mat2str(days(end)) '_' sprintf('%d',Ld) '_hist3.fig']);
%              cd ../;
%         end 
end
%%
% figure;
% x = 1:1:EMG_num;
% errt = zeros(EMG_num,syn_num);
% for i=1:syn_num
% errt(:,i) = std(Hall(:,(i-1)*Ld+1:i*Ld),1,2);
% subplot(syn_num,1,i);
% bar(x,aveHt(:,i));
% hold on;
% e1 =errorbar(x,aveHt(:,i),errt(:,i));
% ylim([-1 4])
% e1.Color = 'r';
% e1.LineStyle = 'none';
% title([monkeyname mat2str(days) '  aveHt, SD']);
% end
% for i=1:Ld
%     Ht{i} = Hdata([monkeyname mat2str(days(i))],EMGgroups(i));
% end