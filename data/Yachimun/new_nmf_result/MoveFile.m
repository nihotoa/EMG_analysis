%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
太田が作った関数
makeEMGNMFで生成されたファイルが1箇所に保存されている(ex. Yachimun -> new_nmf_result ->dist-dist)ので、それを正しい場所に移す関数
カレントディレクトリをnew_nmf_resultにして使用する
用途がYachimunに限定されているので、もっと汎用性を高めたい場合は新しく変数を作って該当箇所を変数に置き換える(サル名、使用する筋肉の数など)
pre_operate: makeEMGNMF
post_operate:SYNERGYPLOT.m
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
%% set param
reference_dir = 'dist-dist';
dir_group = dir('Ya*');
first_day = 170516;
last_day = 170929;
remove_day = [170403 170510 170529 170605 170606 170607 170608 170612 170613 170614 170615 170616 170619 170620 170621 170622 170623 170627 170705 170801 170816];
muscle_num = 10;


%% code section
count = 1; 
for ii = 1:length(dir_group)
    fold_name = dir_group(ii).name;
    if contains(fold_name,'_standard_filtNO5')
        continue
    else
        experiment_day = str2double(extractAfter(fold_name,2));
        day_list(count,1) = experiment_day; 
        count = count + 1;
    end   
end

day_list = setdiff(day_list,remove_day);
day_list = rmmissing(day_list);
day_list = day_list(and(day_list >= first_day, day_list <= last_day));

% 全てのデータが格納されているフォルダへ移動(makeEMGNMFの保存先ディレクトリ)
cd(reference_dir)
%念の為、データを複製しておく
for ii = 1:length(day_list)
    copyfile(['Ya' num2str(day_list(ii)) '.mat'],['Ya' num2str(day_list(ii)) '_' num2str(muscle_num) '.mat'])
    copyfile(['t_Ya' num2str(day_list(ii)) '.mat'],['Ya' num2str(day_list(ii)) '_' num2str(muscle_num) '_nmf.mat'])
end
%↓データを1階層上に移す
for ii = 1:length(day_list)
    movefile(['Ya' num2str(day_list(ii)) '_' num2str(muscle_num) '.mat'],'../');
    movefile(['Ya' num2str(day_list(ii)) '_' num2str(muscle_num) '_nmf.mat'],'../');
end
cd ../

%データを指定した下の階層に移す
for ii = 1:length(day_list)
    movefile(['Ya' num2str(day_list(ii)) '_' num2str(muscle_num) '.mat'],['Ya' num2str(day_list(ii))]);
    movefile(['Ya' num2str(day_list(ii)) '_' num2str(muscle_num) '_nmf.mat'],['Ya' num2str(day_list(ii))]);
end




