function acorr_btc

list    = getchanname;
plot_flag  =0;
print_flag  =0;
alpha      = 0.05;
% tcorr(list, 100, 1, 10, [30 90], 'matrix',       plot_flag, print_flag, 0.05)
tcorr(list, 100, 1, 10, [30 90], 'd3x matrix',   plot_flag, print_flag, 0.05)


% acorr(list,20,0.2,10)
