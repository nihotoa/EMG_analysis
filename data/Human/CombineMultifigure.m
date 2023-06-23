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
a = 1;
for ii = 1:length(plot_figures)
    fig = openfig(plot_figures(ii).name);
    ax1 = gca;
    fnew = figure;
    ax1_copy = copyobj(ax1, fnew);
    subplot(length(plot_figures),1,ii,ax1_copy)
    hold on
    %object指向でのfigの保存
    % x = np.linspace(-3,3,100)
    % for ii in range(10):
    %     fig, axes = plt.subplots()
    %     axes.plot(x, x**ii)
    %     axes.set_title(f'x^{ii}')
    %     pdf.savefig(fig)
    % pdf.close()
end