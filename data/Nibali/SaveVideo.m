function [] = SaveVideo(sel_frames,EMG_num,stack_save_dir,video_framerate)
%SAVEVIDEO この関数の概要をここに記述
%description: this function is used in EMG_correlation
% this was defined to generate movie from combined graphic data and save
% specific directly        
    extensor_frames = horzcat(sel_frames{1:(2 * (EMG_num/2)),1}); %ここめちゃめちゃ大事
    flexor_frames = horzcat(sel_frames{(2 * (EMG_num / 2)) + 1:2 * EMG_num,1});
    % make save dir
    if not(exist(stack_save_dir))
        mkdir(stack_save_dir)
    end
    %video edit & generate movie
    for ii = 1:2 %extensorとflexorの2回分
        if ii == 1
            file_name = 'EMG_tracking(extensor)';
            frames = extensor_frames;
        elseif ii == 2
            file_name = 'EMG_tracking(flexor)';
            frames = flexor_frames;
        end
        video = VideoWriter([stack_save_dir '/' file_name '.mp4'], 'MPEG-4'); % ファイル名や出力形式などを設定
        video.FrameRate = video_framerate; %再生フレームレートの調整
        open(video); % 書き込むファイルを開く
        writeVideo(video, frames); % ファイルに書き込む
        close(video); % 書き込むファイルを閉じる
    end
end

