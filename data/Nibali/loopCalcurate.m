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
post: please refer the text of 'untitled.m' or 'SensorCenteredEMG.m'
[caution!!!]
if you conduct ' Copy_of_sample_data_walkthrough.m', please remove the path of 'MATLAB' �� 'Code' and set the path of 'MATLAB' �� 'Nibali'
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% set param
%exp_days = [20230707 20230710 20230711 20230712 20230714 20230718 20230719 20230720 20230721 20230724 20230726];
exp_days = [20220001,20220002,20220003,20220004,20220005];
conduct_Copy_of = 0;
EMG_recording_type = 'Ripple'; %which device you used to record EMG ('Ripple'/'AlphaOmega')
conduct_CombineMatfile = 1;
process_type = 'normal'; % 'normal' / 'no_sensor'(��{normal, �V�����^�X�N�̒T���̂��߂ɁC�^�X�N��`���]���̂��̂ƕύX����K�v���������̂ŁCtask_define�������)
signal_type = 'no_CAI';  
electrode_restrict = {'020','021','022'}; %(if EMG_recording_type=="AlphaOmega")the number of the electrode which is used to record EMG(no need to change)
conduct_untitled = 0;
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
                MakeAlphaOmegaEMG(exp_day, electrode_restrict)        
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
        elseif strcmp(process_type, 'no_sensor')
            CombineMatfile2(exp_day,real_name_day)
        end
    end
end

% conduct ntitled.m with using 'exp_days'
if conduct_untitled
    for exp_day = exp_days
        disp(['conduct untitled.m (' num2str(exp_day) ')']);
        exp_day = num2str(exp_day);
        if strcmp(signal_type, 'no_CAI')
            SensorCenteredEMG(exp_day)
        else
            untitled(exp_day)
        end
    end
end

