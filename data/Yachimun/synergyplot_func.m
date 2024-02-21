
function [ ] = synergyplot_func(fold_name, emg_group, plk, synergy_num_list)
% emg_group = 4;
% plk = 3;%1:each trig, 2:save for correlation
for ii = 1:length(synergy_num_list)
    synergy_num = synergy_num_list(ii);
    plotSynergyAll_uchida(fold_name, emg_group, synergy_num, plk);
end
close all
end

