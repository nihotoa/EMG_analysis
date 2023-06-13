%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Coded by: Naohito Ohta
% Last modification: 2022/03/30
% 新しいタスクの定義に使用するデータをまとめるための関数
%【caustion!!!!】
% Nibaliの実験タスクの解析には一切関係ないファイルであることに注意
%【procedure】
%pre: Copy_of_sample_data_walkthrough.m 
%post:MakeTaskDefineEMG.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = CombineMatfile2(exp_day,real_name_day)
%% Set Paremeters
monkey_name = 'Ni';
real_name = 'F';%アルファオメガからの.matファイルの接頭語
EMG_num = 16;
downHz = 1375;
CAI_file_num = 1; % CAIのデータ数
exist_EMG = 1; %EMGデータがあるとき1にする
manual_trig = 1; %アルファオメガをmanualで操作している場合(筋電とタイミングずれているから追加の処理をしなきゃいけない)
align_trig = 'CTTL_001'; %筋電とアルファオメガの同期に使う信号
%% code section
% 複数ファイルを連結させて、１日の全筋電データをCEMGに代入するセクション
cd(num2str(exp_day));
%↓接頭文字が'Ni'であるデータ(筋電データ)をカレントディレクトリから読み込む
if exist_EMG == 1
    fileList1 = dir([monkey_name num2str(exp_day) '*.mat']);
end
%↓接頭文字が'F'であるデータ(脳波とタイミングのデータ)をカレントディレクトリから読み込む
fileList2 = dir([real_name num2str(real_name_day) '*.mat']);
if exist_EMG == 1
    for ii = 1:length(fileList1)
        load(fileList1(ii).name)
        for jj= 1:EMG_num
            eval(['sel_CEMG{jj,ii} = CEMG_' sprintf('%03d',jj) ';'])
        end
    end 
    All_CEMG = cell2mat(sel_CEMG);
end


%% resample CAI & combine multi file
if manual_trig==1
    [TimeRange,sel_CAI] = AlignStart(fileList2,downHz,align_trig,All_CEMG,'CAI');
end
%筋電とCAIのタイミングを揃える
%↓alphaomegaからのmatファイルが複数あったときに連結するために一度この変数を仲介する
All_CAI = cell2mat(sel_CAI);

%% resample CTTL & combine multi file(他と違って、複数ファイルに対応していない(後回し))
for ii = 1:length(fileList2)
    clear CTTL_003*
    load(fileList2(ii).name);
    %他の変数と違って、UPとDOWNの2種類の変数がある+ダウンサンプリングじゃなくて、変数の中身の値を1.375/44する
    %↓CTTL_file_numを決定する
    %↓success_signal(CTTL_003)の途切れているデータを除去する作業
    if ii>1
        clear success_signal
        clear judge frame
        clear correct_signal %たぶんこれが更新されていなかったのが原因
    end
    if exist('CTTL_003_Up') %CTTL_003_UPという変数が存在しない場合は、処理を行わない(そのファイルにはタスクのデータが含まれていないってこと)
        count = 1;
        if length(CTTL_003_Up) == length(CTTL_003_Down) %UPとDOWNの回数が同じとき
            success_signal = [CTTL_003_Up;CTTL_003_Down];
        elseif length(CTTL_003_Up) > length(CTTL_003_Down) %UPとDOWNの回数が違う時(UP中にファイルが切り替わってしまった時)
            success_signal = [CTTL_003_Up(1,1:end-1);CTTL_003_Down];
            final_signal_time = CTTL_003_TimeEnd; %次のファイルの操作(下のelseif文)で使う
        elseif length(CTTL_003_Up) < length(CTTL_003_Down) %UPとDOWNの回数が違う時(UP中にファイルが切り替わってしまった時の後ろのファイルのしわ寄せ)
            first_Up_frame = round((final_signal_time - CTTL_003_TimeBegin)*44000);
            CTTL_003_Up = [first_Up_frame CTTL_003_Up];
            success_signal = [CTTL_003_Up;CTTL_003_Down];
        end
        %sel_final_frame(1,ii) = max(success_signal(:)); %次のファイルとの互換のために定義(成功ボタン(CTTL_003))
        for kk = 1:length(success_signal)
            judge_frame = success_signal(2,kk) - success_signal(1,kk);
            if judge_frame > 100
                correct_signal(:,count) = [success_signal(1,kk);success_signal(2,kk)];
                count = count + 1;
            end
        end
        CTTL_003_Up = correct_signal(1,:);
        CTTL_003_Down = correct_signal(2,:);

        CTTL_003_Up = cast(CTTL_003_Up, "double");
        CTTL_003_Down = cast(CTTL_003_Down, "double");
        CTTL_003_Up = round(CTTL_003_Up * (downHz/(CTTL_003_KHz*1000)));
        CTTL_003_Down = round(CTTL_003_Down * (downHz/(CTTL_003_KHz*1000)));
        CTTL_003_KHz = downHz/1000;
        CTTL_003_KHz_Orig = downHz/1000;
        %↓連結のために必要な作業
        sel_CTTL_003_Up{1,ii} = CTTL_003_Up;
        sel_CTTL_003_Down{1,ii} = CTTL_003_Down;
        sel_CTTL_003_TimeBegin(1,ii) = CTTL_003_TimeBegin;
        sel_CTTL_003_TimeEnd(1,ii) = CTTL_003_TimeEnd;
    end
end
%ここにタイミングデータの処理を記述する
for ll = 1:length(sel_CTTL_003_Up)
    error_sampling = round((sel_CTTL_003_TimeBegin(1,ll) - TimeRange(1,1)) * downHz);
    sel_CTTL_003_Down{1,ll} = error_sampling + sel_CTTL_003_Down{1,ll};
    sel_CTTL_003_Up{1,ll} = error_sampling + sel_CTTL_003_Up{1,ll};
end

sel_CTTL_003_Up = cell2mat(sel_CTTL_003_Up);
sel_CTTL_003_Down = cell2mat(sel_CTTL_003_Down);
sel_CTTL_003_TimeBegin = TimeRange(1,1);
sel_CTTL_003_TimeEnd = sel_CTTL_003_TimeEnd(1,ll);
%% consolidate SaveData (セーブデータ(CEMG,CAI,CTTL,CRAW,CLFP)をまとめる(CTTLだけは、他と違う方法で保存する))\
%かなり冗長なコード、関数にまとめるべき

%CAIに関して
for kk = 1:CAI_file_num
        %eval(['CEMG_' sprintf('%03d',kk) ' = All_CEMG(kk,:);'])
        eval(['CAI_' sprintf('%03d',kk) ' = All_CAI(kk,:);'])
        eval(['CAI_' sprintf('%03d',kk) '_KHz = downHz/1000;' ])
        eval(['CAI_' sprintf('%03d',kk) '_KHz_Orig = downHz/1000;' ])
        eval(['CAI_' sprintf('%03d',kk) '_TimeBegin = TimeRange(1,1);' ])
        eval(['CAI_' sprintf('%03d',kk) '_TimeEnd = TimeRange(1,2);' ])
end
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

%CTTL信号に関して

CTTL_003_Up = sel_CTTL_003_Up;
CTTL_003_Down = sel_CTTL_003_Down;
CTTL_003_TimeBegin = TimeRange(1,1); %TimeEndはラストファイルのTimeEndだが、すでに代入済みなので、ここで定義しなくていい
CTTL_003_KHz = (downHz/1000);
CTTL_003_KHz_Orig = (downHz/1000);

%% save data
save(['AllData_' monkey_name num2str(exp_day) '.mat'],'CAI*','CEMG*','TimeRange','CTTL_003*')
cd ../
end




