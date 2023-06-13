
clear
%%
base = 'W';
syn_num = 4;

np = 3;%smooth num
kernel = ones(np,1)/np; 

switch base
    case 'H'
        if syn_num == 4
            load('alldaylist_83');
            load('pre4day_Ht3(Ya)_4.mat');
            load('all83day_Ht3(Ya)_4.mat');
            [R,r_pre] = synxcorr_func(allHt,preHt,base);
            S = size(R);
            Ld = S(2);
            S = size(R{2,1});
            Rplot = cell(S(2),1);
            alldaylist_str = cell(Ld,1);
            for ii = 1:Ld
                alldaylist_str{ii,1} = mat2str(alldaylist(ii,1));
                for i = 1:S(1)
                    for j = 1:S(2)
                        Rplot{j,1}(i,ii) = R{2,ii}(i,j);
                    end
                end
            end
%FLEXOR
            f1 = figure('Position',[0,50,1800,700]);
            hold on
            G = gray(6);
            x = [25,26,27,28,29,30,31,32,33,34,35,36];
            y = ones(1,length(x));
            xconf = [x x(end:-1:1)];
            yconf = [y.*(-1) y];
            fi = fill(xconf,yconf,'k');
            fi.FaceColor = G(4,:);       % make the filled area pink
            fi.EdgeColor = 'none';            % remove the line around the filled area
            for p =1:4
%                 Rplot{1,1}(p,:) = conv2(Rplot{1,1}(p,:),kernel','same');
                plot(Rplot{1,1}(p,:),'LineWidth',4);
            end
%                 plot([0 83],[r_pre(1,1) r_pre(1,1)],'k--o');
%                 plot([0 83],[r_pre(2,1) r_pre(2,1)],'k--*');
%                 plot([0 83],[r_pre(3,1) r_pre(3,1)],'k--s');
%                 plot([0 83],[r_pre(4,1) r_pre(4,1)],'k--x');
                plot([57 57],[-1 1],'r--');
            xlim([0 Ld+10])
            ylim([-1 1])
            ylabel('R:correlation')
            xlabel('83days(170606 to 170925)')
            title('Flexor(precision release)');
            legend([],'Flexor(precision release)','BRD(holding)','Extensor(moving time)','PL(grasp pull)','Flexor(precision release)','BRD(holding)','Extensor(moving time)','PL(grasp pull)')
%BRD
            f2 = figure('Position',[0,1000,1800,700]);
            hold on
             G = gray(6);
            x = [25,26,27,28,29,30,31,32,33,34,35,36];
            y = ones(1,length(x));
            xconf = [x x(end:-1:1)];
            yconf = [y.*(-1) y];
            fi = fill(xconf,yconf,'k');
            fi.FaceColor = G(4,:);       % make the filled area pink
            fi.EdgeColor = 'none';    
            for p =1:4
        %         Rplot{2,1}(p,:) = conv2(Rplot{2,1}(p,:),kernel,'same');
                plot(Rplot{2,1}(p,:),'LineWidth',4);
            end
            plot([57 57],[-1 1],'r--');
            xlim([0 Ld+10])
            ylim([-1 1])
            ylabel('R:correlation')
            xlabel('83days(170606 to 170925)')
            title('BRD(holding)');
            legend('Flexor(precision release)','BRD(holding)','Extensor(moving time)','PL(grasp pull)')
%EXTENSOR
            f3 = figure('Position',[0,100,1000,500]);
            hold on
             G = gray(6);
            x = [25,26,27,28,29,30,31,32,33,34,35,36,37,38];
            y = ones(1,length(x));
            xconf = [x x(end:-1:1)];
            yconf = [y.*(-1) y];
            fi = fill(xconf,yconf,'k');
            fi.FaceColor = G(4,:);       % make the filled area pink
            fi.EdgeColor = 'none';
            
%              x = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];
%             y = ones(1,length(x));
%             xconf = [x x(end:-1:1)];
%             yconf = [y.*(-1) y];
%             fi = fill(xconf,yconf,'k');
%             fi.FaceColor = [0.8 0.8 1];      % make the filled area pink
%             fi.EdgeColor = 'none'; 
%             
%              x = [64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83];
%             y = ones(1,length(x));
%             xconf = [x x(end:-1:1)];
%             yconf = [y.*(-1) y];
%             fi = fill(xconf,yconf,'k');
%             fi.FaceColor = [0.8 0.8 1];      % make the filled area pink
%             fi.EdgeColor = 'none';   
            
            for p =1:4
%                 Rplot{3,1}(p,:) = conv2(Rplot{3,1}(p,:),kernel','same');
                plot(Rplot{3,1}(p,:),'LineWidth',4);
            end
%                 plot([0 83],[r_pre(1,3) r_pre(1,3)],'k--o');
%                 plot([0 83],[r_pre(2,3) r_pre(2,3)],'k--*');
%                 plot([0 83],[r_pre(3,3) r_pre(3,3)],'k--s');
%                 plot([0 83],[r_pre(4,3) r_pre(4,3)],'k--x');
                plot([57 57],[-1 1],'r--');
            xlim([0 Ld+10])
            ylim([-1 1])
            ylabel('R:correlation')
            xlabel('83days(170606 to 170925)')
            orient(f3,'landscape');
            saveas(f3,'Xcorr_Wt_4_extensor_all83day_for_slide.pdf');
            title('Extensor(moving time)');
%             legend('Flexor(precision release)','BRD(holding)','Extensor(moving time)','PL(grasp pull)','Flexor(precision release)','BRD(holding)','Extensor(moving time)','PL(grasp pull)')
%PL
            f4 = figure('Position',[0,1000,1800,700]);
            hold on
             G = gray(6);
            x = [25,26,27,28,29,30,31,32,33,34,35,36];
            y = ones(1,length(x));
            xconf = [x x(end:-1:1)];
            yconf = [y.*(-1) y];
            fi = fill(xconf,yconf,'k');
            fi.FaceColor = G(4,:);       % make the filled area pink
            fi.EdgeColor = 'none';    
            for p =1:4
        %         Rplot{4,1}(p,:) = conv2(Rplot{4,1}(p,:),kernel,'same');
                plot(Rplot{4,1}(p,:),'LineWidth',4);
            end
            plot([57 57],[-1 1],'r--');
            xlim([0 Ld+10])
            ylim([-1 1])
            ylabel('R:correlation')
            xlabel('83days(170606 to 170925)')
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
            load('alldaylist_83');
            load('pre4day_Wt(Ya)_4.mat');
            load('all83day_Wt(Ya)_4.mat');
            [R,r_pre] = synxcorr_func(allWt,preWt,'W');
            S = size(R);
            Ld = S(2);
            S = size(R{2,1});
            Rplot = cell(S(2),1);
            alldaylist_str = cell(Ld,1);
            for ii = 1:Ld
                alldaylist_str{ii,1} = mat2str(alldaylist(ii,1));
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
                plot([0 83],[r_pre(1,1) r_pre(1,1)],'k--o');
                plot([0 83],[r_pre(2,1) r_pre(2,1)],'k--*');
                plot([0 83],[r_pre(3,1) r_pre(3,1)],'k--s');
                plot([0 83],[r_pre(4,1) r_pre(4,1)],'k--x');
                plot([57 57],[-1 1],'r--');
            xlim([0 Ld+10])
            ylim([-1 1])
            ylabel('R:correlation')
            xlabel('83days(170606 to 170925)')
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
            xlabel('83days(170606 to 170925)')
            title('BRD(holding)');
            legend('Flexor(precision release)','BRD(holding)','Extensor(moving time)','PL(grasp pull)')

            f3 = figure('Position',[0,100,1800,700]);
            hold on
             G = gray(6);
            x = [25,26,27,28,29,30,31,32,33,34,35,36];
            y = ones(1,length(x));
            xconf = [x x(end:-1:1)];
            yconf = [y.*(-1) y];
            fi = fill(xconf,yconf,'k');
            fi.FaceColor = G(4,:);       % make the filled area pink
            fi.EdgeColor = 'none';    
            
              x = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];
            y = ones(1,length(x));
            xconf = [x x(end:-1:1)];
            yconf = [y.*(-1) y];
            fi = fill(xconf,yconf,'k');
            fi.FaceColor = [0.8 0.8 1];      % make the filled area pink
            fi.EdgeColor = 'none'; 
            
             x = [64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83];
            y = ones(1,length(x));
            xconf = [x x(end:-1:1)];
            yconf = [y.*(-1) y];
            fi = fill(xconf,yconf,'k');
            fi.FaceColor = [0.8 0.8 1];      % make the filled area pink
            fi.EdgeColor = 'none';   
            for p =1:4
        %         Rplot{3,1}(p,:) = conv2(Rplot{3,1}(p,:),kernel,'same');
                plot(Rplot{3,1}(p,:),'LineWidth',4);
            end
%                 plot([0 83],[r_pre(1,3) r_pre(1,3)],'k--o');
%                 plot([0 83],[r_pre(2,3) r_pre(2,3)],'k--*');
%                 plot([0 83],[r_pre(3,3) r_pre(3,3)],'k--s');
%                 plot([0 83],[r_pre(4,3) r_pre(4,3)],'k--x');
            plot([57 57],[-1 1],'r--');
            xlim([0 Ld+10])
            ylim([-1 1])
            ylabel('R:correlation')
            xlabel('83days(170606 to 170925)')

            title('Extensor(moving time)');
%             legend('Flexor(precision release)','BRD(holding)','Extensor(moving time)','PL(grasp pull)','Flexor(precision release)','BRD(holding)','Extensor(moving time)','PL(grasp pull)')

            f4 = figure('Position',[0,1000,1800,700]);
            hold on
            for p =1:4
        %         Rplot{4,1}(p,:) = conv2(Rplot{4,1}(p,:),kernel,'same');
                plot(Rplot{4,1}(p,:),'LineWidth',4);
            end
            xlim([0 Ld+10])
            ylim([-1 1])
            ylabel('R:correlation')
            xlabel('83days(170606 to 170925)')
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