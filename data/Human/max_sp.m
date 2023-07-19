%input1:data input2:num
% this function return input2 largetst values from input1 data
function max_amplitude_list = max_sp(data, file_path)
timing_file_path = strrep(file_path, '.mat', '_timing.mat');
load(timing_file_path, 'all_timing_data');
[~, trial_num] = size(all_timing_data);
[~, muscle_num] = size(data);
all_timing_data = all_timing_data*(1000/100);
max_amplitude_list = zeros(muscle_num, 1);
for ii = 1:muscle_num
    max_amplitude_list_sel = zeros(trial_num, 1);
    use_data = data(:,ii)';
    for jj = 1:trial_num
        max_amplitude_list_sel(jj) = max(use_data(1,all_timing_data(1,jj):all_timing_data(2,jj)));
    end
    max_amplitude_value = median(max_amplitude_list_sel);
    max_amplitude_list(ii) = max_amplitude_value;
end
end

