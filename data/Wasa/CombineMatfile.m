%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Coded by: Naohito Ohta
% Last modification: 2022/03/29
% 筋電データとECoGデータを一つにまとめる&全てのデータをRESAMPLEしてサンプリングレートを揃えるための関数
% データの連結をして１日の全ての筋電データを一つにしてくれる機能もある
% カレントディレクトリをNIBALIにして使う
% 出力結果は 日付フォルダ → AllData_~.mat
% TimeRangeにタスクの始まりと終わりの時間が入っているが、これはCAI_001を参照したものであることに注意
%改善点:
%SFは、それぞれ配列のサイズが違ってコードを書くのが手間なので、複数ファイルを一つにまとめるコードを書いていない(保存対象から除外した)
%resampleした際にTimeBigin,TimeEndの値を修正していないので、そのためのコードを書く必要がある(全てのデータをTimeRange基準に変更した)
%20220414用に変更してある.元データはMACのデスクトップの避難場所フォルダの中に入っている
%【procedure】
%pre: Copy_of_sample_data_walkthrough.m 
%post:untitled.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
%% Set Paremeters
exp_day = 181114;
monkey_name = 'Wa';
EMG_recording_type = 'AlphaOmega'; %'AlphaOmega'/'Ripple'
EMG_num = 16; %number of EMG
downHz = 1375;
CAI_file_num = 0; % CAIのデータ数
CRAW_file_num = 64; %CRAWのデータ数(なぜか、32→80チャンネルになっていた)
CLFP_file_num = 64; %CLFPのデータ数(なぜか、32→80チャンネルになっていた)
exist_EMG = 1; %EMGデータがあるとき1にする
no_CAI = 0; %正しいCAI信号が取れているかどうか
manual_trig = 0; %アルファオメガをmanualで操作している場合(筋電とタイミングずれているから追加の処理をしなきゃいけない)※alphaOmegaで筋電計測の場合は，0にすること
align_trig = 'CTTL_001'; %筋電とアルファオメガの同期に使う信号
%% code section
% 複数ファイルを連結させて、１日の全筋電データをCEMGに代入するセクション
%↓接頭文字が'Ni'であるデータ(筋電データ)をカレントディレクトリから読み込む
fileList1 = dir([monkey_name num2str(exp_day) '*.mat']);
for ii = 1:length(fileList1)
    load(fileList1(ii).name, 'CEMG*')
    for jj= 1:EMG_num
        eval(['CEMG_' sprintf('%03d',jj) '= cast(CEMG_' sprintf('%03d',jj) ',"double");']);
        eval(['CEMG_' sprintf('%03d',jj) '= resample(CEMG_' sprintf('%03d',jj) ',downHz,CEMG_' sprintf('%03d',jj) '_KHz*1000);']);
        eval(['sel_CEMG{jj,ii} = CEMG_' sprintf('%03d',jj) ';'])
    end
end 
All_CEMG = cell2mat(sel_CEMG);


%% search for TimeRange(TimeBegin & TimeEnd)
for ii = 1:length(fileList1) 
    %↓TimeRangeに１日のデータのSTARTとENDの時間を代入(CEMG_001を参照)
    load(fileList1(ii).name, 'CEMG_001_TimeBegin', 'CEMG_001_TimeEnd')
    if ii == 1 
        TimeRange(1,1) = CEMG_001_TimeBegin;
        TimeRange(1,2) = CEMG_001_TimeEnd;
    else
        TimeRange(1,2) = CEMG_001_TimeEnd;
    end
end

%% Combine multi file of CLFP
count=0;
for ii = 1:length(fileList1)
    clear CLFP_001
    load(fileList1(ii).name, 'CLFP*');
    if exist('CLFP_001') %めっちゃ小さいファイルだと、CLFPが存在していない場合がある
        for jj = 1:CLFP_file_num
            if isempty(eval(['CLFP_' sprintf('%03d',jj)]))
                count=count+1;
                break
            end
            eval(['sel_CLFP{jj,ii-count} = CLFP_' sprintf('%03d',jj) ';'])
        end
    else
        count=count+1;
    end
end

for ii = 1:CLFP_file_num
    All_CLFP{ii,1} = cast(cell2mat(sel_CLFP(ii,:)),'double');
end

%% resample CRAW & combine multi file
for ii = 1:length(fileList1)
    load(fileList1(ii).name, 'CRAW*');
    for jj = 1:CRAW_file_num
        eval(['CRAW_' sprintf('%03d',jj) '= cast(CRAW_' sprintf('%03d',jj) ',"double");']);
        eval(['CRAW_' sprintf('%03d',jj) '= resample(CRAW_' sprintf('%03d',jj) ',downHz,CRAW_' sprintf('%03d',jj) '_KHz*1000);']);
        eval(['sel_CRAW{jj,ii} = CRAW_' sprintf('%03d',jj) ';'])
    end
end

for ii = 1:CRAW_file_num
    All_CRAW{ii,1} = cast(cell2mat(sel_CRAW(ii,:)),'double');
end

%% consolidate SaveData (セーブデータ(CEMG,CAI,CTTL,CRAW,CLFP)をまとめる(CTTLだけは、他と違う方法で保存する))\
%CEMGに関して
if exist_EMG == 1
    for kk = 1:EMG_num
        %eval(['CEMG_' sprintf('%03d',kk) ' = All_CEMG(kk,:);'])
        eval(['CEMG_' sprintf('%03d',kk) ' = All_CEMG(kk,:);'])
        eval(['CEMG_' sprintf('%03d',kk) '_KHz = downHz/1000;' ])
        eval(['CEMG_' sprintf('%03d',kk) '_KHz_Orig = downHz/1000;' ])
        eval(['CEMG_' sprintf('%03d',kk) '_TimeBegin = TimeRange(1,1);' ])
        eval(['CEMG_' sprintf('%03d',kk) '_TimeEnd = TimeRange(1,2);' ])
    end
end

%CLFPに関して
 if exist('All_CLFP')
     for kk = 1:CLFP_file_num
            %eval(['CEMG_' sprintf('%03d',kk) ' = All_CEMG(kk,:);'])
            eval(['CLFP_' sprintf('%03d',kk) ' = All_CLFP{kk,1};'])
            eval(['CLFP_' sprintf('%03d',kk) '_KHz = downHz/1000;' ])
            eval(['CLFP_' sprintf('%03d',kk) '_KHz_Orig = downHz/1000;' ])
            eval(['CLFP_' sprintf('%03d',kk) '_TimeBegin = TimeRange(1,1);' ])
            eval(['CLFP_' sprintf('%03d',kk) '_TimeEnd = TimeRange(1,2);' ])
     end
 end
 %CRAWに関して
 for kk = 1:CRAW_file_num
        %eval(['CEMG_' sprintf('%03d',kk) ' = All_CEMG(kk,:);'])
        eval(['CRAW_' sprintf('%03d',kk) ' = All_CRAW{kk,1};'])
        eval(['CRAW_' sprintf('%03d',kk) '_KHz = downHz/1000;' ])
        eval(['CRAW_' sprintf('%03d',kk) '_KHz_Orig = downHz/1000;' ])
        eval(['CRAW_' sprintf('%03d',kk) '_TimeBegin = TimeRange(1,1);' ])
        eval(['CRAW_' sprintf('%03d',kk) '_TimeEnd = TimeRange(1,2);' ])
 end

%% save data
save_fold = fullfile(pwd, [monkey_name num2str(exp_day) '_standard']);
if not(exist(save_fold))
    mkdir(save_fold)
end
save(fullfile(save_fold, ['AllData_' monkey_name num2str(exp_day) '.mat']), 'CEMG*', 'CLFP*', 'CRAW*', 'TimeRange');





