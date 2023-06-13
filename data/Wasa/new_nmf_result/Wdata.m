%% this code was written for determin te number of synergy by comparing  test.VAF and shuffle.VAF

function [testWm] = VAFdata(fold_name,emg_group)
    % parameter
%     fold_name = 'Wa180928';
%     emg_group = 1;
%     kf = 4;
%     alg = 'r2';
    switch emg_group
        case 1
            %first try
            EMG_num = 12;
            EMGs = {'Biceps';'BRD';'ECR';'ECU';'ED23';'ED45';'EDC';'FCR';'FCU';'FDP';'FDS';'Triceps'};
        case 2
            %only extensor
            EMG_num = 5;
            EMGs = {'ECR';'ECU';'ED23';'ED45';'EDC'};
        case 3
            %only flexor
            EMG_num = 4;
            EMGs = {'FCR';'FCU';'FDP';'FDS'};
        case 4
            %forearm
            EMG_num = 10;
            EMGs = {'BRD';'ECR';'ECU';'ED23';'ED45';'EDC';'FCR';'FCU';'FDP';'FDS'};
        case 5
            %forearm
            EMG_num = 11;
            EMGs = {'BRD';'ECR';'ECU';'ED23';'ED45';'EDC';'FCR';'FCU';'FDP';'FDS';'Triceps'};     
    end

    % set data 
    cd(fold_name)
    load([fold_name '_' sprintf('%02d',EMG_num) '_nmf'])
    % load([fold_name '_' sprintf('%02d',EMG_num) '_nmf'])
    cd ../
    
    testWm = zeros(EMG_num,EMG_num);
    for i = 1:EMG_num
        Wx = [cell2mat(test.W{i,1}) cell2mat(test.W{i,2}) cell2mat(test.W{i,3}) cell2mat(test.W{i,4})];
        testWm(i,:) = mean(Wx,2)';
    end

    
end