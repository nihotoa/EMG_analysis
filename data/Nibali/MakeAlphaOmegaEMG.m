%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
coded by: Naohito Ota   
[function]
make & save EMG data from recording data of AlphaOmega
extract only the data which is related to EMG analysis and resample EMG 

%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = MakeAlphaOmegaEMG(exp_day)
file_location = [pwd '/' num2str(exp_day)];
file_list = dir(fullfile(file_location, 'F*.mat'));
for ii = 1:length(file_list) %number of AlphaOmega files
    SummarizeData(exp_day, ii, file_location, file_list(ii).name)
end
end

%% set local function
function [] = SummarizeData(exp_day, file_num, file_location, file_name)
% load recorded datafile & summarize & resample data & save summarize data
% as .matfile (ex.)Ni20230613-0001.mat
load([file_location '/' file_name])

% Extract only the vaiables to use analysis
variables = whos;
EMGdata_variables = {};
for ii = 1:length(variables)
    if and(strcmp(variables(ii).class, 'int16'), contains(variables(ii).name, 'CSPK'))
        EMGdata_variables{end+1} = variables(ii).name;
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