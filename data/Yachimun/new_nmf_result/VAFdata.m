%% this code was written for determin te number of synergy by comparing  test.VAF and shuffle.VAF

function [testVAFm,shuffleVAFm,th] = VAFdata(fold_name,emg_group,alg)
    % parameter
%     fold_name = 'Wa180928';
%     emg_group = 1;
%     kf = 4;
%     alg = 'r2';
    switch emg_group
        case 1%without 'Deltoid'
        EMG_num = 12;
        EMGs = {'BRD';'ECR';'ECU';'ED23';'EDCdist';'EDCprox';'FCR';'FCU';'FDP';...
                'FDSdist';'FDSprox';'PL'};
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
    load([fold_name '_' sprintf('%02d',EMG_num)])
    % load([fold_name '_' sprintf('%02d',EMG_num) '_nmf'])
    cd ../

    testVAF = test.r2;
    shuffleVAF = shuffle.r2;
    testVAFm = mean(testVAF,2);
    shuffleVAFm = mean(shuffleVAF,2);
    [m,n] = size(testVAF);
    thre = zeros(m,n);

    %check
    switch alg
        case 'r2'
            th_080 = find(testVAFm >= 0.8);
            th_085 = find(testVAFm >= 0.85);
            th_090 = find(testVAFm >= 0.9);
            th_095 = find(testVAFm >= 0.95);
%             th = [th_080(1) th_085(1) th_090(1) th_095(1)];
th = 1;
        case 'ori_shuff_075'
        case' curve3'
        case 'LinReg'
        case 't_test'
        case 'rev'
        otherwise
            disp fail!!
    end
end