function [ ] = synergyplot_func(fold_name,monkey_name,exp_day,analysis_type,trim_package)
% fold_name = 'Ya170914';
    emg_group = 1;%�g�p����EMG�̃O���[�v�̑I��
    plk = 3;%1:each trig, 2:save for correlation(��^���̐}�̕ۑ����@�̐ݒ�)
    for g=2 %���̃V�i�W�[�̉�͌��ʂ��o���H
        %plotSynergyAll_uchida(fold_name,emg_group,g,plk,monkey_name,exp_day);
        switch analysis_type
            case 'all_data'
                plotSynergyAll_ohta(fold_name,emg_group,g,plk,monkey_name,exp_day,trim_package)
            case 'trimmed'
                plotSynergyAll_uchida(fold_name,emg_group,g,plk,monkey_name,exp_day)
        end
    end
    close all
end

