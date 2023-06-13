%% function to draw & create movie
function [frames] = VideoCreate(date_type,pre_frame,reference_term,EMG_Data,ii,EMGs,save_movie) %�y���d�v!!!���̕ϐ���EMG_Data�ɓ�����͈�����pre_EMG_Data/post_EMG_Data�̂ǂ��炩%reference_term : pre/post, data_type : post_date/pre_date
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
            %subplot�ɒ��߂�������
            if jj==1
                ylim([0 2])
                grid on;
                xline(pre_frame,'red','Color',[186 85 211]/255,'LineWidth',1.2);
                title(EMGs{ii,1},'FontSize',25)
            end
            %������t�@�C���Ƃ��ĕۑ����邽�߂̏���
            if save_movie == 1
                txt = {['exp-day:' num2str(date_type(jj))],['trilal:' num2str(trial_num(jj))]};
                dim = [.03 .1 .1 .87];
                t = annotation('textbox',dim,'String',txt,'FitBoxToText','on');
                t.FontSize = 21;

                %���搶���̂��߂̕ϐ��ɃX�i�b�v�V���b�g���L�^����
                % step 2
                fig = gcf; % Figure �I�u�W�F�N�g�̐���
                % �}��`�悷��R�[�h(�����x����͈͂Ȃ�)�������ɏ���
                if not(exist('frames'))
                    frames(length(date_type)) = struct('cdata', [], 'colormap', []); % �e�t���[���̉摜�f�[�^���i�[����z��
                end              
                drawnow; % �`����m���Ɏ��s������
                frames(jj) = getframe(fig); % �}���摜�f�[�^�Ƃ��ē���

                %�e�L�X�g�{�b�N�X�̍폜
                delete(t)
            else
                frames = '~'; %else�̏ꍇ��frames�s�v�����A�o�͈����Ƃ��ĕ֋X��K�v�Ȃ̂�~�������Ă���(�o�͈�����Ջ@���ςɕύX�ł������������͂��Ȃ̂ŁA���P���T��)
            end
        end
end