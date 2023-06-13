function [] = AveregeEMG(pre_EMG_Data,post_EMG_Data,EMG_num,EMGs,pre_frame,line_wide,EMG_save_dir)
%description: This function is used in EMG_correlation.m
%fucntion contents: extract & plot average EMG from the selected day data       
%課題点：devide_termのIF文が冗長だから他の関数にまとめる。TITLEの文字の大きさを変える,
%図の保存場所をしっかり指定する

    h = figure('Position', [0 0 1280 720]);
    h.WindowState = 'maximized';
    for ii = 1:EMG_num
        for devide_term = 1:2 %pre/post
            clear reference_sel
            if devide_term == 1 
                for jj = 1:length(pre_EMG_Data)
                    reference_sel{jj,1} = pre_EMG_Data{jj,1}{ii,:}; %全日分の、ある筋肉からのデータを一つにまとめる
                end
                EMG_mean = mean(cell2mat(reference_sel));
                EMG_std = std(cell2mat(reference_sel));
                subplot(4,4,ii)
                hold on;
                grid on;
                plot(EMG_mean,'r','LineWidth',2);
                title(EMGs{ii,1},'FontSize',22);
                ar1=area(transpose([EMG_mean-EMG_std;EMG_std+EMG_std]));
                set(ar1(1),'FaceColor','None','LineStyle',':','EdgeColor','r')
                set(ar1(2),'FaceColor','r','FaceAlpha',0.2,'LineStyle',':','EdgeColor','r') 
                ylim([0 2])
                xline(pre_frame,'red','Color',[186 85 211]/255,'LineWidth',line_wide);
            elseif devide_term == 2
                for jj = 1:length(post_EMG_Data)
                    reference_sel{jj,1} = post_EMG_Data{jj,1}{ii,:}; %全日分の、ある筋肉からのデータを一つにまとめる
                end
                EMG_mean = mean(cell2mat(reference_sel));
                EMG_std = std(cell2mat(reference_sel));
                plot(EMG_mean,'b','LineWidth',2);
                ar1=area(transpose([EMG_mean-EMG_std;EMG_std+EMG_std]));
                set(ar1(1),'FaceColor','None','LineStyle',':','EdgeColor','b')
                set(ar1(2),'FaceColor','b','FaceAlpha',0.2,'LineStyle',':','EdgeColor','b') 
            end
        end
        hold off;
    end   
    %save figure & data
    average_save_dir = [EMG_save_dir '/average'];
    if not(exist(average_save_dir))
        mkdir(average_save_dir);
    end
    saveas(gcf,[average_save_dir '/average_EMG.png']);
    saveas(gcf,[average_save_dir '/average_EMG.fig']);
    close all;        
end

