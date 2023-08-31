%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
Coded by: Naohito Ota   
[function]
load multi figure files(.fig) and combine these figure as one figure
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
%% set param

%% code section
plot_figures = dir([pwd '/' '*.fig']);
fnew = figure;
fig_list = cell(length(plot_figures));
for ii = 1:length(plot_figures)
    fig_list{ii} = openfig(plot_figures(ii).name);
    eval(['ax' num2str(ii) ' = gca;'])
    eval(['ax' num2str(ii) '_copy = copyobj(ax' num2str(ii) ', fnew);']);
    ref_figure = eval(['ax' num2str(ii) '_copy']);
    subplot(length(plot_figures),1,ii,ref_figure)
    hold on
end
% save_figures
saveas(gcf, 'sample.png')
close all;