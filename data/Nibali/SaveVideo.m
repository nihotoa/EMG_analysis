function [] = SaveVideo(sel_frames,EMG_num,stack_save_dir,video_framerate)
%SAVEVIDEO ���̊֐��̊T�v�������ɋL�q
%description: this function is used in EMG_correlation
% this was defined to generate movie from combined graphic data and save
% specific directly        
    extensor_frames = horzcat(sel_frames{1:(2 * (EMG_num/2)),1}); %�����߂���߂���厖
    flexor_frames = horzcat(sel_frames{(2 * (EMG_num / 2)) + 1:2 * EMG_num,1});
    % make save dir
    if not(exist(stack_save_dir))
        mkdir(stack_save_dir)
    end
    %video edit & generate movie
    for ii = 1:2 %extensor��flexor��2��
        if ii == 1
            file_name = 'EMG_tracking(extensor)';
            frames = extensor_frames;
        elseif ii == 2
            file_name = 'EMG_tracking(flexor)';
            frames = flexor_frames;
        end
        video = VideoWriter([stack_save_dir '/' file_name '.mp4'], 'MPEG-4'); % �t�@�C������o�͌`���Ȃǂ�ݒ�
        video.FrameRate = video_framerate; %�Đ��t���[�����[�g�̒���
        open(video); % �������ރt�@�C�����J��
        writeVideo(video, frames); % �t�@�C���ɏ�������
        close(video); % �������ރt�@�C�������
    end
end

