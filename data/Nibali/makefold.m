%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LastModification 23/03/16 
% Coded by: Naohito Ohta
% how to use: Nibaliをカレントディレクトリにして使う。NMFbtcOyaを実行して、NMFデータを作った後に実行する
% monkeyname,xpdate,EMG_numlistを指定して実行すると日付フォルダ → nmf_resultにfiltNO5フォルダを作ってくれる
% filtNO5にはSYNERGYPLOTで使用するファイル2つと,SYNERGYPLOTの解析結果を保存するディレクトリが存在する
%【特に注意するパラメータ】
% EMG_type → filtNO5フォルダの命名時に使われる
% add_info → makeEMGNMF_btcOhtaで作成されたファイル((ex.) MATLAB/data/Nibali/20221005/nmf_result/Ni20221005_standard/Ni20221005_standard_NoFold_tim3_pre-300_post-100.mat)
%　の_NoFold_tim3_pre-300_post-100の部分をコピペする
%【課題点】
%パラメータ設定がダルい．UIで使用するデータを選択できるようにする
%【procedure】
%pre: makeEMGNMF_btcOhta(or Oya).m
%post: SYNERGYPLOT.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
%% set param
setting_xpdate = 0; %0:手動でxpdateを設定したとき 1:devide_infoから日付を設定したとき(生成したグラフやディレクトリの名前を決定するときに、devide_infoを使用したことをわかるようにしたい)
xpdate = [20230526, 20230529]; %(setting_xpdateが0の時)手動で設定
monkeyname = 'Ni';
EMG_type = 'task'; %筋シナジー抽出に用いたEMGのタイプ(tim1:タイミング1周り tim2:タイミング2周りtim3:タイミング3周り task:タスク全体)
all_data = 0; %全体データから筋シナジー解析したとき,1にする(EMG_typeがtaskのときのオプション)
% add_info = '_NoFold_tim3_pre-300_post-100'; %筋シナジーのMATファイル名に記述されている処理の詳細(standardの後から),該当箇所を読み込むコードを書くのが手間なのでここで手動で定義する
% key_sentence = 'NoFold_TimeNormalized';  %(ex.)'post_lpHz_20(lp_first)_NoFold_tim3_pre-300_post-100'
EMG_numlist = 9;
%% code section
original_dir = pwd;
if setting_xpdate == 1
    load([pwd '/' 'devide_info' '/' 'all_day_trial.mat'], 'trial_day'); %全ての実験日の日付リストをロードする
    xpdate = GenerateTargetDate(trial_day, 'all', 0, 1000, pwd); %解析する日付をcell配列に格納するための関数．あんまり気にしない
end

% cd([num2str(xpdate) '/nmf_result'])
%フォルダ名の決定
switch EMG_type
    case 'tim1'
        fold_name = ['_standard_filtNO5_tim1'];
    case 'tim2'
        fold_name = ['_standard_filtNO5_tim2'];
    case 'tim3'
        fold_name = ['_standard_filtNO5_tim3'];
    case 'tim4'
        fold_name = ['_standard_filtNO5_tim4'];   
    case 'task'
        if all_data == 1
           fold_name = '_standard_filtNO5_allData_task';
        else
            fold_name = '_standard_filtNO5_TimeNormalized_task';
        end
end
%↓EMG_typeに応じて、筋シナジー解析用のディレクトリを作成
for ii = 1:length(xpdate)
    save_fold = [original_dir '/' num2str(xpdate(ii)) '/' 'nmf_result' '/' monkeyname num2str(xpdate(ii)) fold_name];
    if not(exist(save_fold)) %同名のファイルがある
        mkdir(save_fold)
    end
    nmf_fold = [save_fold '/' monkeyname num2str(xpdate(ii)) '_syn_result_' sprintf('%02d',EMG_numlist)];
    if not(exist(nmf_fold))
        mkdir(nmf_fold)
        mkdir([nmf_fold '/' monkeyname num2str(xpdate(ii)) '_W'])
        mkdir([nmf_fold '/' monkeyname num2str(xpdate(ii)) '_H'])
        mkdir([nmf_fold '/' monkeyname num2str(xpdate(ii)) '_VAF'])
        mkdir([nmf_fold '/' monkeyname num2str(xpdate(ii)) '_r2'])
    end

    if ii == 1
        %一個前の関数(NMF)で得られた2つのファイルを選択※日付ディレクトリはどれでもいい
        disp('【Please select 2 files which is created by pre function!!】')
        disp('(ex.)F:\MATLAB\data\Nibali\20220420\nmf_result\Ni20220420_standard\Ni20220420_standard_NoFold_TimeNormalized & t_Ni20220420_standard_NoFold_TimeNormalized')
        [use_file_list, pathName] = uigetfile(['*.mat'],'Select a file',pwd,'MultiSelect','on');
        temp = regexp(pathName, '\d+', 'match');
        num_part = temp{1};
    end
    pathNameEx= strrep(pathName, num_part, num2str(xpdate(ii)));
    cd(pathNameEx)
    use_file_listEx =  strrep(use_file_list, num_part, num2str(xpdate(ii)));
    
    if strcmp(['t_' use_file_listEx{1}], use_file_listEx{2})
        copyfile(use_file_listEx{1},[monkeyname num2str(xpdate(ii)) '_standard_filtNO5_' sprintf('%02d',EMG_numlist) '.mat'])
        copyfile(use_file_listEx{2},[monkeyname num2str(xpdate(ii)) '_standard_filtNO5_' sprintf('%02d',EMG_numlist) '_nmf.mat'])
    else
        copyfile(use_file_listEx{2},[monkeyname num2str(xpdate(ii)) '_standard_filtNO5_' sprintf('%02d',EMG_numlist) '.mat'])
        copyfile(use_file_listEx{1},[monkeyname num2str(xpdate(ii)) '_standard_filtNO5_' sprintf('%02d',EMG_numlist) '_nmf.mat'])
    end
    movefile([monkeyname num2str(xpdate(ii)) '_standard_filtNO5_' sprintf('%02d',EMG_numlist) '.mat'], '../');
    movefile([monkeyname num2str(xpdate(ii)) '_standard_filtNO5_' sprintf('%02d',EMG_numlist) '_nmf.mat'], '../');
    cd ../
    %複製した2つのデータを指定した下の階層に移す
    movefile([monkeyname num2str(xpdate(ii)) '_standard_filtNO5_' sprintf('%02d',EMG_numlist) '.mat'],[monkeyname num2str(xpdate(ii)) fold_name]);
    movefile([monkeyname num2str(xpdate(ii)) '_standard_filtNO5_' sprintf('%02d',EMG_numlist) '_nmf.mat'],[monkeyname num2str(xpdate(ii)) fold_name]);
end
cd(original_dir)
