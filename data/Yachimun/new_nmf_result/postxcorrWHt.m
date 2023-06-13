
clear
%%
base = 'H';
syn_num = 4;

np = 3;%smooth num
kernel = ones(np,1)/np; 

switch base
    case 'H'
        if syn_num == 4
            load('postdaylist_56');
            load('pre4day_Ht(Ya)_4.mat');
            load('post56day_Ht(Ya)_4.mat');
            [R,r_pre] = synxcorr_func(postHt,preHt,base);
            S = size(R);
            Ld = S(2);
            S = size(R{2,1});
            Rplot = cell(S(2),1);
            postdaylist_str = cell(Ld,1);
            for ii = 1:Ld
                postdaylist_str{ii,1} = mat2str(postdaylist(ii,1));
                for i = 1:S(1)
                    for j = 1:S(2)
                        Rplot{j,1}(i,ii) = R{2,ii}(i,j);
                    end
                end
            end

            f1 = figure('Position',[0,1000,1800,700]);
            hold on
            for p =1:4
        %         Rplot{1,1}(p,:) = conv2(Rplot{1,1}(p,:),kernel,'same');
                plot(Rplot{1,1}(p,:),'LineWidth',4);
            end
                plot([0 56],[r_pre(1,1) r_pre(1,1)],'k--o');
                plot([0 56],[r_pre(2,1) r_pre(2,1)],'k--*');
                plot([0 56],[r_pre(3,1) r_pre(3,1)],'k--s');
                plot([0 56],[r_pre(4,1) r_pre(4,1)],'k--x');
            xlim([0 Ld+10])
            ylim([-1 1])
            ylabel('R:correlation')
            xlabel('56days(170606 to 170925)')
            title('Flexor(precision release)');
            legend('Flexor(precision release)','BRD(holding)','Extensor(moving time)','PL(grasp pull)','Flexor(precision release)','BRD(holding)','Extensor(moving time)','PL(grasp pull)')

            f2 = figure('Position',[0,1000,1800,700]);
            hold on
            for p =1:4
        %         Rplot{2,1}(p,:) = conv2(Rplot{2,1}(p,:),kernel,'same');
                plot(Rplot{2,1}(p,:),'LineWidth',4);
            end
            xlim([0 Ld+10])
            ylim([-1 1])
            ylabel('R:correlation')
            xlabel('56days(170606 to 170925)')
            title('BRD(holding)');
            legend('Flexor(precision release)','BRD(holding)','Extensor(moving time)','PL(grasp pull)')

            f3 = figure('Position',[0,1000,1800,700]);
            hold on
            for p =1:4
        %         Rplot{3,1}(p,:) = conv2(Rplot{3,1}(p,:),kernel,'same');
                plot(Rplot{3,1}(p,:),'LineWidth',4);
            end
                plot([0 56],[r_pre(1,3) r_pre(1,3)],'k--o');
                plot([0 56],[r_pre(2,3) r_pre(2,3)],'k--*');
                plot([0 56],[r_pre(3,3) r_pre(3,3)],'k--s');
                plot([0 56],[r_pre(4,3) r_pre(4,3)],'k--x');
            xlim([0 Ld+10])
            ylim([-1 1])
            ylabel('R:correlation')
            xlabel('56days(170606 to 170925)')

            title('Extensor(moving time)');
            legend('Flexor(precision release)','BRD(holding)','Extensor(moving time)','PL(grasp pull)','Flexor(precision release)','BRD(holding)','Extensor(moving time)','PL(grasp pull)')

            f4 = figure('Position',[0,1000,1800,700]);
            hold on
            for p =1:4
        %         Rplot{4,1}(p,:) = conv2(Rplot{4,1}(p,:),kernel,'same');
                plot(Rplot{4,1}(p,:),'LineWidth',4);
            end
            xlim([0 Ld+10])
            ylim([-1 1])
            ylabel('R:correlation')
            xlabel('56days(170606 to 170925)')
            title('PL(grasp pull)');
            legend('Flexor(precision release)','BRD(holding)','Extensor(moving time)','PL(grasp pull)')

        %     for p = 1:4
        %         f5 = figure('Position',[0,1000,1800,700]);
        %         hold on;
        %         for p = 1:4
        %             plot([r_pre(p,j) r_pre(p,j)],[0 10]);
        %         end
        %         xlim([0 10])
        %         ylim([-1 1])
        %     end
        end

        
    case 'W'
        if syn_num == 4
            load('postdaylist_56');
            load('pre4day_Wt(Ya)_4.mat');
            load('post56day_Wt(Ya)_4.mat');
            [R,r_pre] = synxcorr_func(postWt,preWt,'W');
            S = size(R);
            Ld = S(2);
            S = size(R{2,1});
            Rplot = cell(S(2),1);
            postdaylist_str = cell(Ld,1);
            for ii = 1:Ld
                postdaylist_str{ii,1} = mat2str(postdaylist(ii,1));
                for i = 1:S(1)
                    for j = 1:S(2)
                        Rplot{j,1}(i,ii) = R{2,ii}(i,j);
                    end
                end
            end

            f1 = figure('Position',[0,1000,1800,700]);
            hold on
            for p =1:4
        %         Rplot{1,1}(p,:) = conv2(Rplot{1,1}(p,:),kernel,'same');
                plot(Rplot{1,1}(p,:),'LineWidth',4);
            end
                plot([0 56],[r_pre(1,1) r_pre(1,1)],'k--o');
                plot([0 56],[r_pre(2,1) r_pre(2,1)],'k--*');
                plot([0 56],[r_pre(3,1) r_pre(3,1)],'k--s');
                plot([0 56],[r_pre(4,1) r_pre(4,1)],'k--x');
            xlim([0 Ld+10])
            ylim([-1 1])
            ylabel('R:correlation')
            xlabel('56days(170606 to 170925)')
            title('Flexor(precision release)');
            legend('Flexor(precision release)','BRD(holding)','Extensor(moving time)','PL(grasp pull)','Flexor(precision release)','BRD(holding)','Extensor(moving time)','PL(grasp pull)')

            f2 = figure('Position',[0,1000,1800,700]);
            hold on
            for p =1:4
        %         Rplot{2,1}(p,:) = conv2(Rplot{2,1}(p,:),kernel,'same');
                plot(Rplot{2,1}(p,:),'LineWidth',4);
            end
            xlim([0 Ld+10])
            ylim([-1 1])
            ylabel('R:correlation')
            xlabel('56days(170606 to 170925)')
            title('BRD(holding)');
            legend('Flexor(precision release)','BRD(holding)','Extensor(moving time)','PL(grasp pull)')

            f3 = figure('Position',[0,1000,1800,700]);
            hold on
            for p =1:4
        %         Rplot{3,1}(p,:) = conv2(Rplot{3,1}(p,:),kernel,'same');
                plot(Rplot{3,1}(p,:),'LineWidth',4);
            end
                plot([0 56],[r_pre(1,3) r_pre(1,3)],'k--o');
                plot([0 56],[r_pre(2,3) r_pre(2,3)],'k--*');
                plot([0 56],[r_pre(3,3) r_pre(3,3)],'k--s');
                plot([0 56],[r_pre(4,3) r_pre(4,3)],'k--x');
            xlim([0 Ld+10])
            ylim([-1 1])
            ylabel('R:correlation')
            xlabel('56days(170606 to 170925)')

            title('Extensor(moving time)');
            legend('Flexor(precision release)','BRD(holding)','Extensor(moving time)','PL(grasp pull)','Flexor(precision release)','BRD(holding)','Extensor(moving time)','PL(grasp pull)')

            f4 = figure('Position',[0,1000,1800,700]);
            hold on
            for p =1:4
        %         Rplot{4,1}(p,:) = conv2(Rplot{4,1}(p,:),kernel,'same');
                plot(Rplot{4,1}(p,:),'LineWidth',4);
            end
            xlim([0 Ld+10])
            ylim([-1 1])
            ylabel('R:correlation')
            xlabel('56days(170606 to 170925)')
            title('PL(grasp pull)');
            legend('Flexor(precision release)','BRD(holding)','Extensor(moving time)','PL(grasp pull)')

        %     for p = 1:4
        %         f5 = figure('Position',[0,1000,1800,700]);
        %         hold on;
        %         for p = 1:4
        %             plot([r_pre(p,j) r_pre(p,j)],[0 10]);
        %         end
        %         xlim([0 10])
        %         ylim([-1 1])
        %     end
        end
end