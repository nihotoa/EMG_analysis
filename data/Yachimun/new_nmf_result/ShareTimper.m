%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
coded by: Naohito Ohta
how to use
・please move current dir into 'new_nmf_result'

function:
dispNMF_Hで使�?Tim_per.mと�?�?matファイルがどこで作られて�?る�?�かわからな�?ので
既にそ�?�ファイルがあるフォル�?から、�?要な部�?�?けをコピ�?�して保存す�?
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
%% set param
days = [170630 170703 170704];
monkey_name = 'Ya';
%% code section
cd order_tim_list;
load('Ya170405to170929_84/Tim_per.mat') %reference_data
var_list = whos([monkey_name '*']);
for ii = 1:length(var_list)
    pat = digitsPattern;
    var_name = var_list(ii).name;
    exp_day_cel = extract(var_name,pat);
    exp_day = str2double(exp_day_cel{1});
    if ismember(exp_day,days)
    else
        clear([monkey_name num2str(exp_day) '_SUC_tim_per'])
    end
end
mkdir([monkey_name num2str(days(1)) 'to' num2str(days(end)) '_' num2str(length(days))])
save([monkey_name num2str(days(1)) 'to' num2str(days(end)) '_' num2str(length(days)) '/Tim_per.mat'],[monkey_name '*'])
cd ../;