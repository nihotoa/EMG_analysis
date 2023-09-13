function [ ] = synergyplot_func(fold_name)
% fold_name = 'Ya170914';
emg_group = 8;
plk = 3;%1:each trig, 2:save for correlation
for g = 4
    plotSynergyAll_uchida(fold_name,emg_group,g,plk);
end
close all
end

