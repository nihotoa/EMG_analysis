%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
coded by Naoki Uchida
last modification : 2024. 02.26(by Ohta)
[function]
Check cross-talk between EMGs
(For each trial, find the maximum value between arbitrary EMGs and take their average value.)

[points of improvement(Japanese)]
筋電にしても3階微分値にしても相互相関関数の絶対値の最大値をとっているがいいのか？
(その時の位相は保存されていない & 絶対値だったら-1の可能性もある)
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Yave,Y3ave] = CTcheck(monkeyname, xpdate_num, save_fold, save_CTR, task, real_name)
xpdate = sprintf('%d',xpdate_num);
disp(['START TO MAKE & SAVE ' monkeyname xpdate 'CTcheck Data']);

% get save folder path
save_fold_path = fullfile(pwd, real_name, save_fold, [monkeyname num2str(xpdate), '_', task]);

% load EMG data & tget trial number
S = load(fullfile(save_fold_path, [monkeyname xpdate '_CTcheckData.mat']),'CTcheck');
trial_num = length(S.CTcheck.data0);
[EMG_num, ~] = size(S.CTcheck.data0{1});

% To speed up processing, set the maximum value of iteration to 20.
if trial_num > 20
    trial_num = 20;
end

for k = 1:trial_num
    % load each trial data
    Data = S.CTcheck.data0{:, k};
    dt3 = S.CTcheck.data3{:, k};

    % make empty array for storing data
    if k == 1
        Yave = zeros(EMG_num,EMG_num);
        Y3ave = zeros(EMG_num,EMG_num);
    end

    Y = cell(EMG_num);
    X = cell(EMG_num);
    Ysum = zeros(EMG_num,EMG_num);

    Y3 = cell(EMG_num);
    X3 = cell(EMG_num);
    Y3sum = zeros(EMG_num,EMG_num);

    % Find the cross-correlation function between the i-th EMG and the j-th EMG
    for i = 1:EMG_num
        for j = 1:EMG_num
            % Y: cross-correlation function, X: Phase difference between 2 signals
            [Y{i,j},X{i,j}] = xcorr(Data(i,:) - mean(Data(i,:)), Data(j,:) - mean(Data(j,:)),'coeff');

            % Find the maximum absolute value of the cross-correlation
            Ysum(i,j) = max(abs(Y{i,j}));
            
            % Find the cross-correlation function of the 3rd-order differential value
            [Y3{i,j},X3{i,j}] = xcorr(dt3(i,:)-mean(dt3(i,:)), dt3(j,:)-mean(dt3(j,:)),'coeff');

            % Find the maximum absolute value of the cross-correlation
            Y3sum(i,j) = max(abs(Y3{i,j}));
        end
    end

    % Calculate trial_average
    Yave = (Yave .* (k-1) + Ysum) ./ k;
    Y3ave = (Y3ave .* (k-1) + Y3sum) ./ k;
end

% save data
if save_CTR
    save(fullfile(save_fold_path, [monkeyname xpdate '_CTR.mat']), 'monkeyname', 'xpdate', 'Yave', 'Y3ave');
end

disp(['FINISH TO MAKE & SAVE ' monkeyname xpdate 'CTcheck Data']);
end