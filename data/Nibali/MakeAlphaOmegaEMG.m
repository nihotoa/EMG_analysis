%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
coded by: Naohito Ota   
[function]
make & save EMG data from recording data of AlphaOmega
extract only the data which is related to EMG analysis and resample EMG 

%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = MakeAlphaOmegaEMG(exp_day, electrode_restrict)
file_location = [pwd '/' num2str(exp_day)];
file_list = dir(fullfile(file_location, 'F*.mat'));
for ii = 1:length(file_list) %number of AlphaOmega files
    switch nargin
        case 1
            SummarizeData(exp_day, ii, file_location, file_list(ii).name)
        case 2
            SummarizeData(exp_day, ii, file_location, file_list(ii).name, electrode_restrict)
    end
end
end

%% set local function
function [] = SummarizeData(exp_day, file_num, file_location, file_name, electrode_restrict)
% load recorded datafile & summarize & resample data & save summarize data
% as .matfile (ex.)Ni20230613-0001.mat
load([file_location '/' file_name])

% Extract only the vaiables to use analysis
variables = whos;
EMGdata_variables = {};
for ii = 1:length(variables)
    switch nargin
        case 4
            if and(strcmp(variables(ii).class, 'int16'), contains(variables(ii).name, 'CSPK'))
                EMGdata_variables{end+1} = variables(ii).name;
            end
        case 5
            if strcmp(variables(ii).class, 'int16') && contains(variables(ii).name, 'CSPK') && contains(variables(ii).name, electrode_restrict)
                EMGdata_variables{end+1} = variables(ii).name;
            end
    end
end

for ii = 1:length(EMGdata_variables) %number of EMGdata
    EMGdata = eval(EMGdata_variables{ii});
    EMGdata = cast(EMGdata, 'double');
    orignal_SR = eval([EMGdata_variables{ii} '_KHz']) * 1000;
    resampled_SR = 1375;
    EMGdata = resample(EMGdata, resampled_SR, orignal_SR);
    eval(['CEMG_' sprintf('%03d', ii) '= EMGdata;']);
    eval(['CEMG_' sprintf('%03d', ii) '_KHz = resampled_SR/1000;']);
    eval(['CEMG_' sprintf('%03d', ii) '_KHz_org = resampled_SR/1000;']);
end
save([file_location '/' 'Ni' num2str(exp_day) '-' sprintf('%04d', file_num)], 'CEMG*')
end