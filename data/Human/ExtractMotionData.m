%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
Coded by: Naohito Ohta
Last Modification:2023.05.11
【procedure】
pre:SuccessTiming_func.m
post:nothing
【function】
・得られた.matファイルから個々のモーションデータを抽出して動画として保存(保存場所はday -> taskの種類 ->Motion の中)
※保存するのは動画だけで，データは保存していない
【課題点】
命名規則のための変数名の変更は，起こったエラーに対して継ぎ足しで条件設定しているので，新たな問題が発生したときは
それに対応できるように継ぎ足すこと．
min_valueが0より大きい時，max_valueが０未満の時の軸の設定について考える
複数のマーカーが得られたので，それぞれをプロットしてskeltonを作成する
GUIでskelton作成できるようにする
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
%% set param
patient_name = 'patientB';
use_val.FrameRate = 100; %再生するときのフレームレート(100だと当倍速)
use_val.line_width_size = 1.5;
% ↓pre1, pre2の時
use_val.marker_point = {'wrist', 'MPH', 'PIP', 'DIP'};

%↓post2の時
% use_val.marker_point = {'Ulnar', 'MPH3', 'RAD' ,'PIP3', 'DIP3', 'DIP4'};
%% code section
disp('【Please select _Traj.mat (patient -> day)】')
[fileNames,use_val.pathName] = selectGUI(patient_name, 'Marker');

%↓選んだファイルが1個だと，char型になってしまうので変換する
if ischar(fileNames)
    temp = fileNames;
    clear fileNames;
    fileNames{1} = temp;
end

%↓タスクの種類ごとに動画を保存してく
for ii = 1:length(fileNames)
    use_val.fileName = fileNames{ii};
    [data,use_val] = calcMovie(use_val); %必要なフォルダの作成
    success_timing_file_name = strrep(fileNames{ii}, 'Traj', 'timing');
    load([use_val.pathName success_timing_file_name], 'all_timing_data');
    use_val.all_timing_data = all_timing_data;
    plotPackage(data, use_val)
    VideoPackage(data, use_val) %プロットして図を作成して保存
end

%% define internal function
%% フォルダの作成や，タスクごとのループなどの階層構造の部分
function [data,use_val] = calcMovie(use_val)
use_val.fold_name = strrep(use_val.fileName,'_Traj.mat','');
%↓フォルダの作成
use_val.file_save_dir = [use_val.pathName use_val.fold_name '/' 'Motion'];
if not(exist(use_val.file_save_dir,'dir'))
    mkdir([use_val.file_save_dir])
end
%データをタスクの種類ごとに分ける
load([use_val.pathName use_val.fileName],'data'); %データの読み込み
end

%% 動作データをプロットして図示するための関数
function [] = plotPackage(data, use_val)
%追加したい機能:軌道の重ね合わせと，平均値を，Motionフォルダにセーブしたい → 平均値+stdは作っていない
%トリミングしないで,それぞれのmarker_pointごとに軌道をプロットしてセーブ
for ii = 1:length(use_val.marker_point)
    figure('position', [100, 100, 1200, 800]);
    hold on
    ref_col = 1 + 3 * (ii-1); %対象のマーカーポイントのxのcol数
    for jj = 1:3 %x,y,z
        subplot(3,1,jj);
        plot(data(:,ref_col),'LineWidth', use_val.line_width_size);
        grid on;
        if jj==1
            title([use_val.marker_point{ii} '-x'],'FontSize',25)
        elseif jj==2
            title([use_val.marker_point{ii} '-y'],'FontSize',25)
        elseif jj==3 
            title([use_val.marker_point{ii} '-z'],'FontSize',25)
        end
        ref_col = ref_col + 1;
    end
    %save section
    if not(exist(use_val.file_save_dir))
        mkdir(use_val.file_save_dir)
    end
    saveas(gcf, [use_val.file_save_dir '/' use_val.marker_point{ii}  '_all_traj.png'])
    saveas(gcf, [use_val.file_save_dir '/' use_val.marker_point{ii}  '_all_traj.fig'])
    close all;
end

% タスクごとに切り出してプロット4*3のsubplot
figure('position', [100, 100, 1200, 800]);
for ii = 1:length(use_val.marker_point)
    hold on;
    ref_col = 1 + 3 * (ii-1); %対象のマーカーポイントのxのcol数
    for jj = 1:3 %x,y,z
        subplot(length(use_val.marker_point), 3, ref_col);
        ref_data = data(:,ref_col);
        for kk = 1:length(use_val.all_timing_data) %タスク数分
            trimmed_data = ref_data(use_val.all_timing_data(1, kk):use_val.all_timing_data(2, kk));
            x = linspace(0, 1, length(trimmed_data));
            plot(x, trimmed_data, 'LineWidth',use_val.line_width_size);
            hold on;
        end
        %decoration
        grid on;
        if jj==1
            title([use_val.marker_point{ii} '-x'],'FontSize',25)
        elseif jj==2
            title([use_val.marker_point{ii} '-y'],'FontSize',25)
        elseif jj==3 
            title([use_val.marker_point{ii} '-z'],'FontSize',25)
        end
        ref_col = ref_col + 1;
    end
end
%save section
saveas(gcf, [use_val.file_save_dir '/' use_val.marker_point{ii}  '_task_traj(stack).png'])
saveas(gcf, [use_val.file_save_dir '/' use_val.marker_point{ii}  '_task_traj(stack).fig'])
close all;
end

%% 動作データをmovieにするための関数
function [] = VideoPackage(data, use_val)
% 3. 動画を作成するオブジェクトを作成する
movie_path = [use_val.file_save_dir '/' 'Motion_trajectory.mp4'];
if not(exist(movie_path))
    vidObj = VideoWriter([use_val.file_save_dir '/' 'Motion_trajectory.mp4'], 'MPEG-4');
    vidObj.FrameRate = use_val.FrameRate;
    open(vidObj);
    %軸範囲の設定
    max_value = 0;
    min_value = 0;
    [~,col] = size(data);
    for j = 1:col %x.y.z軸
        max_candidate = max(data(:,j));
        min_candidate = min(data(:,j));
        if max_candidate > max_value
            max_value = max_candidate;
        end
        if min_candidate < min_value
            min_value = min_candidate;
        end
    end
    upper_lim = ceil(max_value/10)*10;%一の位で繰り上げ
    lower_lim = floor(min_value/10)*10; %一の位で繰り下げ
    
    %各軸の描画のための変数定義
    axis_length = (upper_lim - lower_lim) * 1/3;
    axis_vector = [axis_length,0 0; 0 axis_length 0; 0 0 axis_length];
    point = [0;0;0];
    
    figure('Position',[100 100 1280 720]);
    % 4. 各フレームの画像を作成して、動画に書き込む
    marker_num = col / 3; %3は次元(x,,y,z)の数
    marker_point = use_val.marker_point;
    
    for i = 1:size(data, 1)
        % 3Dプロットを更新する
        for j = 1:marker_num
            x_value(j) = data(i, (3*j)-2);
            y_value(j) = data(i, (3*j)-1);
            z_value(j) = data(i, 3*j);
            plot3(data(i, (3*j)-2), data(i, (3*j)-1), data(i, 3*j), 'o', 'MarkerFaceColor', 'red');
            hold on;
        end

        %skeltonの作成
        for j = 1:(marker_num-1)
            switch marker_num
                case 4 %ulnar, radialにマーカーがない時
                    plot3([x_value(j),x_value(j+1)],[y_value(j),y_value(j+1)],[z_value(j),z_value(j+1)],'r','LineWidth',2);

                case 6 %ここを頑張って書いていく(skeltonを作成する)(冗長だけどこれでいい)
                    if j == 1
                        for k = [2,3]
                            %繋ぐ
                            plot3([x_value(j),x_value(k)],[y_value(j),y_value(k)],[z_value(j),z_value(k)],'r','LineWidth',2);
                        end
                    elseif j == 2
                        for k = [3,4,6]
                            %繋ぐ
                            plot3([x_value(j),x_value(k)],[y_value(j),y_value(k)],[z_value(j),z_value(k)],'r','LineWidth',2);
                        end
                    elseif j == 4
                        plot3([x_value(j),x_value(5)],[y_value(j),y_value(5)],[z_value(j),z_value(5)],'r','LineWidth',2);
                    end
            end
            
        end
        %図の装飾
        grid on;
        xlim([lower_lim upper_lim]);
        xlabel('X-axis[mm]','FontSize',30)
        ylim([lower_lim upper_lim]);
        ylabel('Y-axis[mm]','FontSize',30)
        zlim([lower_lim upper_lim]);
        zlabel('Z-axis[mm]','FontSize',30)
        quiver3(point,point,point, axis_vector(:,1), axis_vector(:,2), axis_vector(:,3),0)
        view(45,30) %plot3のアングルの変更
        title(use_val.fold_name,'FontSize',25)
        hold off;
        
        drawnow;
        % フレームを取得して、動画に書き込む
        frame = getframe(gcf);
        writeVideo(vidObj, frame);
    end
    
    % 5. 動画を保存して終了する
    close(vidObj);
    close all; %プロットしたfigファイルを消す
end
end
