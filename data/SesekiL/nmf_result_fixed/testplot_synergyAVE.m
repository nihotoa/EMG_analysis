f = figure('Position',[900,1000,800,1300]);
days = [117 119 120];
task = 'standard_mat';
c = jet(length(days));
count = 0;
for i = days
   count = count+1;
    fold_name = ['Se200' sprintf('%02d',i)];
    cd([fold_name '_' task])
    cd([fold_name '_syn_result_09'])
    cd([fold_name '_H'])
    load([fold_name '_aveH3_4.mat'])
    cd ../../../
    
    for s = 1:4
        figure(f);
        subplot(4,1,k_arr(s,count));
        hold on;
%         figure
        plot(aveH(s,:),'Color',c(count,:))
    end
    
end