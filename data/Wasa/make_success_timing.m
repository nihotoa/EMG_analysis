%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
[function]


[procedure]
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
%% set param
ref_day_list = [181114, 181207];
monkey_name = 'Wa';

%% code section
disp('Plase select ~EasyData.mat')
[Default_EasyData_name, Default_EasyData_path] = uigetfile(fullfile(pwd, 'easyData', [monkey_name num2str(ref_day_list(1)) '_standard']));
Default_day_part = regexp(Default_EasyData_name, '\d+', 'match');
Default_day = Default_day_part{1};

for ii = 1:length(ref_day_list)
    ref_day = num2str(ref_day_list(ii));
    % change the file name
    EasyData_name = strrep(Default_EasyData_name, Default_day, ref_day);
    EasyData_path = strrep(Default_EasyData_path, Default_day, ref_day);
    

    % load EasyData
    load(fullfile(EasyData_path, EasyData_name), 'SampleRate', 'Tp', 'Tp3');
    
    % load AllTiming,mat (to get sample rate of the data)
    load(fullfile(pwd, 'AllData_fold', ['AllData_' monkey_name ref_day '.mat']), 'CEMG_001_KHz');
    common_sample_rate = CEMG_001_KHz * 1000;
    temp_timing_data = round(Tp * (common_sample_rate / SampleRate));
    temp_timing_data = transpose(temp_timing_data);

    % extract tim1 to tim4 (eliminate task start & task end)
    success_timing_array = temp_timing_data(2:5, :);

    % make table
    row_names = {'home pad on', 'home pad off', 'hold on', 'hold off'};
    col_names = cell(1, length(success_timing_array));
    for jj = 1:length(success_timing_array)
        col_names{jj} = ['trial' num2str(jj)];
    end
    success_timing = array2table(success_timing_array, 'RowNames', row_names, 'VariableNames', col_names);
    
    % save data
    save_fold = fullfile(pwd, [monkey_name num2str(ref_day) '_standard']);
    if not(exist(save_fold))
        mkdir(save_fold)
    end
    save(fullfile(save_fold, 'success_timing.mat'), "success_timing")
end