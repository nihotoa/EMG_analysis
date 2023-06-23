%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
Coded by: Naohito Ohta
last modification : 2022.12.14
how to use
please set current dir as 'MATLAB -> data -> Nibali'
[function]
Use another function with using loop
[procedure]
pre: none
post: please refer the text of 'untitled.m'
[caution!!!]
if you conduct ' Copy_of_sample_data_walkthrough.m', please remove the path of 'MATLAB' → 'Code' and set the path of 'MATLAB' → 'Nibali'
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% set param
exp_days = [20230613];
conduct_Copy_of = 1;
EMG_recording_type = 'AlphaOmega'; %which device you used to record EMG ('Ripple'/'AlphaOmega')
conduct_CombineMatfile = 1;
process_type = 'normal'; % 'normal' / 'task_define' (基本normal, 新しいタスクの探索のために，タスク定義を従来のものと変更する必要があったので，task_defineを作った)
conduct_untitled = 1;
%% code section
% conduct Copy_of_sample_data_walkthrough.m with using 'exp_days'
if conduct_Copy_of
    switch EMG_recording_type
        case 'Ripple'
            for exp_day = exp_days
                Copy_of_sample_data_walkthrough(exp_day);
            end
        case 'AlphaOmega'
            for exp_day = exp_days
                MakeAlphaOmegaEMG(exp_day)        
            end
    end
end

% conduct CombineMatfile.m with using 'exp_days'
if conduct_CombineMatfile
    for exp_day = exp_days
        disp(['conduct CombineMatfile (' num2str(exp_day) ')']);
        temp = num2str(exp_day);
        real_name_day = str2double(extractAfter(temp,2));
        if strcmp(process_type, 'normal')
            CombineMatfile(exp_day,real_name_day)
        elseif strcmp(process_type, 'task_define')
            CombineMatfile2(exp_day,real_name_day)
        end
    end
end

% conduct ntitled.m with using 'exp_days'
if conduct_untitled
    for exp_day = exp_days
        disp(['conduct untitled.m (' num2str(exp_day) ')']);
        exp_day = num2str(exp_day);
        untitled(exp_day)
    end
end

