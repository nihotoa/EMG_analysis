function [k_arr] = align_W_synergy(use_W, ref_syn_num)
% align W_synergy to plot & create list of each synergy correspondence
loop_num = length(use_W);
align_use_W = use_W; %k_arrの作成用にuse_wを複製する
k_arr = zeros(ref_syn_num,loop_num-1);
for kk = 1:ref_syn_num %初日のシナジー数
    eval(['synergy' num2str(kk) ' = align_use_W{1,1}(:,kk);']) %初日のsynergy1を全体のsynergy1とする
    e_value_sel = zeros(loop_num-1,ref_syn_num);
    
    for ll = 2:loop_num %日付分だけループ(post1, post2 ...)
        for mm = 1:ref_syn_num
            e_value_ind = sum(eval(['abs(align_use_W{ll,1}(:,mm) - synergy' num2str(kk) ')'])); %indはindividualの意味
            e_value_sel(ll-1,mm) = e_value_ind; 
        end
        [~,I] = min(e_value_sel(ll-1,:));
        align_use_W{ll,1}(:,I) = 1000;
        k_arr(kk,ll-1) = I;
    end
end   
end