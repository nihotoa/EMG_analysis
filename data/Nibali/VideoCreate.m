%% function to draw & create movie
function [frames] = VideoCreate(date_type,pre_frame,reference_term,EMG_Data,ii,EMGs,save_movie) %【超重要!!!この変数のEMG_Dataに入る入力引数はpre_EMG_Data/post_EMG_Dataのどちらか%reference_term : pre/post, data_type : post_date/pre_date
        load(['devide_info/all_day_trial'])
        [~,I] = sort(trial_data(:,1));
        trial_data = trial_data(I,:);

        count = 1;
        for jj = 1:length(trial_data)
            if ismember(trial_data(jj,1),date_type) %date_type:pre_date/post_date
                trial_num(count,1) = trial_data(jj,2); %trial_num:Number of trials per day
                count = count + 1;
            end
        end

        for jj = 1:length(date_type)
            if strcmp(reference_term,'post')
                p_color = ((40+((215/length(date_type))*jj)) / 255) - 0.00001;
                plot(EMG_Data{jj,1}{ii,:},'color',[0,1 - p_color,1],'LineWidth',1.2); 
            elseif strcmp(reference_term,'pre')
                p_color = ((40+((215/length(date_type))*jj)) / 255) - 0.00001;
                plot(EMG_Data{jj,1}{ii,:},'color',[p_color,0,0],'LineWidth',1.2);
            end
            %subplotに注釈を加える
            if jj==1
                ylim([0 2])
                grid on;
                xline(pre_frame,'red','Color',[186 85 211]/255,'LineWidth',1.2);
                title(EMGs{ii,1},'FontSize',25)
            end
            %↓動画ファイルとして保存するための処理
            if save_movie == 1
                txt = {['exp-day:' num2str(date_type(jj))],['trilal:' num2str(trial_num(jj))]};
                dim = [.03 .1 .1 .87];
                t = annotation('textbox',dim,'String',txt,'FitBoxToText','on');
                t.FontSize = 21;

                %動画生成のための変数にスナップショットを記録する
                % step 2
                fig = gcf; % Figure オブジェクトの生成
                % 図を描画するコード(軸ラベルや範囲など)をここに書く
                if not(exist('frames'))
                    frames(length(date_type)) = struct('cdata', [], 'colormap', []); % 各フレームの画像データを格納する配列
                end              
                drawnow; % 描画を確実に実行させる
                frames(jj) = getframe(fig); % 図を画像データとして得る

                %テキストボックスの削除
                delete(t)
            else
                frames = '~'; %elseの場合がframes不要だが、出力引数として便宜上必要なので~を代入しておく(出力引数を臨機応変に変更できるやり方があるはずなので、改善策を探す)
            end
        end
end