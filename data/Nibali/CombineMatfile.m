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
function [] = CombineMatfile(exp_day,real_name_day)
%% Set Paremeters
% exp_day = 20220722;
% real_name_day = 220722;
monkey_name = 'Ni';
real_name = 'F';%アルファオメガからの.matファイルの接頭語
EMG_num = 16;
downHz = 1375;
CAI_file_num = 1; % CAIのデータ数
% CTTL_file_num = 3; %CTTLのデータ数(現状では001がレコード区間(使用しない)002がフォトセル,003が成功)3がデフォ
CRAW_file_num = 80; %CRAWのデータ数(なぜか、32→80チャンネルになっていた)
CLFP_file_num = 80; %CLFPのデータ数(なぜか、32→80チャンネルになっていた)
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
elseif manual_trig==0 %今までのデフォ
    for ii = 1:length(fileList2) 
        load(fileList2(ii).name)
        %↓TimeRangeに１日のデータのSTARTとENDの時間を代入(CAI_001を参照している)
        if ii == 1 
            TimeRange(1,1) = CAI_001_TimeBegin;
            TimeRange(1,2) = CAI_001_TimeEnd;
        else
            TimeRange(1,2) = CAI_001_TimeEnd;
        end

        for jj=1:CAI_file_num
            eval(['CAI_' sprintf('%03d',jj) '= cast(CAI_' sprintf('%03d',jj) ',"double");']);
            eval(['CAI_' sprintf('%03d',jj) '= resample(CAI_' sprintf('%03d',jj) ',downHz,CAI_001_KHz*1000);']);
            eval(['CAI_' sprintf('%03d',jj) '_KHz = downHz/1000;']);
            eval(['CAI_' sprintf('%03d',jj) '_KHz_Orig = downHz/1000;']);
            eval(['sel_CAI{jj,ii} = CAI_' sprintf('%03d',jj) ';'])
        end
    end
end
%筋電とCAIのタイミングを揃える
%↓alphaomegaからのmatファイルが複数あったときに連結するために一度この変数を仲介する
All_CAI = cell2mat(sel_CAI);

%↓ALL_CAIを用いて連結する
%{
for kk = 1:CAI_file_num
    eval(['CAI_' sprintf('%03d',kk) ' = All_CAI(kk,:);'])
end
%}

%% resample CTTL & combine multi file(他と違って、複数ファイルに対応していない(後回し))
for ii = 1:length(fileList2)
    clear CTTL_002*
    clear CTTL_003*
    load(fileList2(ii).name);
    %他の変数と違って、UPとDOWNの2種類の変数がある+ダウンサンプリングじゃなくて、変数の中身の値を1.375/44する
    if exist('CTTL_002_Down') %場合によっては、中身がほとんどないmatファイルもあるので、その対策用
        %↓CTTL_file_numを決定する
        if ii == 1
            if length(CTTL_003_Up) <= 1 %CTTL_003の中身がないとき
                CTTL_file_num = 2;
            elseif length(CTTL_003_Up) > 1%CTTL_003の中身があるとき
                CTTL_file_num = 3;
            end
        end
        
        for jj= 2:CTTL_file_num %CTTL_001は不要なので、2からスタート
            %↓success_signal(CTTL_003)の途切れているデータを除去する作業
            if jj == 3
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
                end
            end
            if CTTL_file_num == 2
                eval(['CTTL_' sprintf('%03d',jj) '_Up = cast(CTTL_' sprintf('%03d',jj) '_Up' ',"double");']);
                eval(['CTTL_' sprintf('%03d',jj) '_Down = cast(CTTL_' sprintf('%03d',jj) '_Down' ',"double");']);
                eval(['CTTL_' sprintf('%03d',jj) '_Up = round(CTTL_' sprintf('%03d',jj) '_Up * (downHz/(CTTL_' sprintf('%03d',jj) '_KHz*1000)));']);
                eval(['CTTL_' sprintf('%03d',jj) '_Down = round(CTTL_' sprintf('%03d',jj) '_Down * (downHz/(CTTL_' sprintf('%03d',jj) '_KHz*1000)));']);
                eval(['CTTL_' sprintf('%03d',jj) '_KHz = downHz/1000;']);
                eval(['CTTL_' sprintf('%03d',jj) '_KHz_Orig = downHz/1000;']);
                %↓連結のために必要な作業
                eval(['sel_CTTL_' sprintf('%03d',jj) '_Up{1,ii} = CTTL_' sprintf('%03d',jj) '_Up;'])
                eval(['sel_CTTL_' sprintf('%03d',jj) '_Down{1,ii} = CTTL_' sprintf('%03d',jj) '_Down;'])
                eval(['sel_CTTL_' sprintf('%03d',jj) '_TimeBegin(1,ii) = CTTL_' sprintf('%03d',jj) '_TimeBegin;'])
                eval(['sel_CTTL_' sprintf('%03d',jj) '_TimeEnd(1,ii) = CTTL_' sprintf('%03d',jj) '_TimeEnd;'])
            elseif CTTL_file_num == 3
                if exist('CTTL_003_Up') 
                    eval(['CTTL_' sprintf('%03d',jj) '_Up = cast(CTTL_' sprintf('%03d',jj) '_Up' ',"double");']);
                    eval(['CTTL_' sprintf('%03d',jj) '_Down = cast(CTTL_' sprintf('%03d',jj) '_Down' ',"double");']);
                    eval(['CTTL_' sprintf('%03d',jj) '_Up = round(CTTL_' sprintf('%03d',jj) '_Up * (downHz/(CTTL_' sprintf('%03d',jj) '_KHz*1000)));']);
                    eval(['CTTL_' sprintf('%03d',jj) '_Down = round(CTTL_' sprintf('%03d',jj) '_Down * (downHz/(CTTL_' sprintf('%03d',jj) '_KHz*1000)));']);
                    eval(['CTTL_' sprintf('%03d',jj) '_KHz = downHz/1000;']);
                    eval(['CTTL_' sprintf('%03d',jj) '_KHz_Orig = downHz/1000;']);
                    %↓連結のために必要な作業
                    eval(['sel_CTTL_' sprintf('%03d',jj) '_Up{1,ii} = CTTL_' sprintf('%03d',jj) '_Up;'])
                    eval(['sel_CTTL_' sprintf('%03d',jj) '_Down{1,ii} = CTTL_' sprintf('%03d',jj) '_Down;'])
                    eval(['sel_CTTL_' sprintf('%03d',jj) '_TimeBegin(1,ii) = CTTL_' sprintf('%03d',jj) '_TimeBegin;'])
                    eval(['sel_CTTL_' sprintf('%03d',jj) '_TimeEnd(1,ii) = CTTL_' sprintf('%03d',jj) '_TimeEnd;'])
                end
            end
        end
    end
end
%ここにタイミングデータの処理を記述する
%sel_final_frame = round(sel_final_frame*(1375/44000));%finalframeをダウンサンプリング
for kk = 2:CTTL_file_num %kk:CTTLの数(002と003)
    if CTTL_file_num == 3
        for ll = 1:length(sel_CTTL_003_Up) %length(fileList2)だとタスクデータの入っていないファイルがあったときに対処できない(sel_CTTLとの配列数の違いでエラー吐く) 
            %error_sampling = (sel_CTTL_00kk_TimeBegin(1,ll)-TimeRange(1,1)) * downHz;
            %sel_CTTL_00kk{ll,1} = error_sampling + sel_CTTL_00kk{ll,1} ;
            error_sampling = round(eval(['(sel_CTTL_' sprintf('%03d',kk) '_TimeBegin(1,ll) - TimeRange(1,1)) * downHz']));
            eval(['sel_CTTL_' sprintf('%03d',kk) '_Down{1,ll} = error_sampling + sel_CTTL_' sprintf('%03d',kk) '_Down{1,ll}'])
            eval(['sel_CTTL_' sprintf('%03d',kk) '_Up{1,ll} = error_sampling + sel_CTTL_' sprintf('%03d',kk) '_Up{1,ll}'])
        end
    elseif CTTL_file_num == 2 %successシグナルがないとき
        for ll = 1:length(sel_CTTL_002_Up) 
            %error_sampling = (sel_CTTL_00kk_TimeBegin(1,ll)-TimeRange(1,1)) * downHz;
            %sel_CTTL_00kk{ll,1} = error_sampling + sel_CTTL_00kk{ll,1} ;
            error_sampling = round(eval(['(sel_CTTL_' sprintf('%03d',kk) '_TimeBegin(1,ll) - TimeRange(1,1)) * downHz']));
            eval(['sel_CTTL_' sprintf('%03d',kk) '_Down{1,ll} = error_sampling + sel_CTTL_' sprintf('%03d',kk) '_Down{1,ll}'])
            eval(['sel_CTTL_' sprintf('%03d',kk) '_Up{1,ll} = error_sampling + sel_CTTL_' sprintf('%03d',kk) '_Up{1,ll}'])
        end
    end
end

if CTTL_file_num == 2
    sel_CTTL_002_Up = cell2mat(sel_CTTL_002_Up);
    sel_CTTL_002_Down = cell2mat(sel_CTTL_002_Down);
    sel_CTTL_002_TimeBegin = TimeRange(1,1);
    sel_CTTL_002_TimeEnd = sel_CTTL_002_TimeEnd(1,ll);
elseif CTTL_file_num == 3
    sel_CTTL_002_Up = cell2mat(sel_CTTL_002_Up);
    sel_CTTL_002_Down = cell2mat(sel_CTTL_002_Down);
    sel_CTTL_002_TimeBegin = TimeRange(1,1);
    sel_CTTL_002_TimeEnd = sel_CTTL_002_TimeEnd(1,ll);
    sel_CTTL_003_Up = cell2mat(sel_CTTL_003_Up);
    sel_CTTL_003_Down = cell2mat(sel_CTTL_003_Down);
    sel_CTTL_003_TimeBegin = TimeRange(1,1);
    sel_CTTL_003_TimeEnd = sel_CTTL_003_TimeEnd(1,ll);
end
%{
for kk = 2:CTTL_file_num %kk:信号の数 ll:ファイルの数
    e1 = round((eval(['sel_CTTL_' sprintf('%03d',kk) '_TimeBegin(1,1)'])-TimeRange(1,1)) * downHz); %各タイミング信号の開始と、レコードの開始とのフレーム誤差
    eval(['sel_CTTL_' sprintf('%03d',kk) '_Up{1,1} = e1 + sel_CTTL_' sprintf('%03d',kk) '_Up{1,1};'])
    eval(['sel_CTTL_' sprintf('%03d',kk) '_Down{1,1} = e1 + sel_CTTL_' sprintf('%03d',kk) '_Down{1,1};'])
    %↑1ファイル目に偏差を適用
    for ll= 1:length(fileList2)
        if ll == 1 %ファイル数が1のときは何の処理もしない

        else
            if kk == 2 %CTTL_002のとき
                e_pre = round((sel_CTTL_002_TimeBegin(ll) - sel_CTTL_002_TimeEnd(ll-1)) * downHz);
                %↓UpとDownの記録回数が異なる場合があるので、条件分岐で対応(フォトセルが反応している時に次のファイルに行くと、記録回数が異なる)
                %pre_fileは、一個前のファイルの最後のフレーム数(pre_final_frame)の抽出に必要
                if length(sel_CTTL_002_Down{1,ll-1}) == length(sel_CTTL_002_Up{1,ll-1})
                    pre_file = [sel_CTTL_002_Down{1,ll-1};sel_CTTL_002_Up{1,ll-1}];
                elseif length(sel_CTTL_002_Down{1,ll-1}) < length(sel_CTTL_002_Up{1,ll-1})
                    e_length = length(sel_CTTL_002_Up{1,ll-1}) - length(sel_CTTL_002_Down{1,ll-1});
                    tent_sel_CTTL_002_Down = [sel_CTTL_002_Down{1,ll-1},NaN(1,e_length)];
                    pre_file = [tent_sel_CTTL_002_Down;sel_CTTL_002_Up{1,ll-1}];
                elseif length(sel_CTTL_002_Down{1,ll-1}) > length(sel_CTTL_002_Up{1,ll-1})
                    e_length = length(sel_CTTL_002_Down{1,ll-1}) - length(sel_CTTL_002_Up{1,ll-1});
                    tent_sel_CTTL_002_Up = [sel_CTTL_002_Up{1,ll-1},NaN(1,e_length)];
                    pre_file = [sel_CTTL_002_Down{1,ll-1};tent_sel_CTTL_002_Up];
                end
                pre_final_frame = max(pre_file(:));
                sel_CTTL_002_Up{1,ll} = (pre_final_frame + e_pre) + sel_CTTL_002_Up{1,ll};
                sel_CTTL_002_Down{1,ll} = (pre_final_frame + e_pre) + sel_CTTL_002_Down{1,ll};
                if ll == length(fileList2)
                    sel_CTTL_002_Up = cell2mat(sel_CTTL_002_Up);
                    sel_CTTL_002_Down = cell2mat(sel_CTTL_002_Down);
                    sel_CTTL_002_TimeBegin = TimeRange(1,1);
                    sel_CTTL_002_TimeEnd = sel_CTTL_002_TimeEnd(1,ll);
                end
                
            elseif kk == 3 %CTTL_003のとき
                sel_final_frame = e1 + sel_final_frame; %sel_final_frameを、CAIの基準に変換
                e_pre = round((sel_CTTL_003_TimeBegin(ll) - sel_CTTL_003_TimeEnd(ll-1)) * downHz);
                sel_CTTL_003_Up{1,ll} = (sel_final_frame(1,ll-1) + e_pre) + sel_CTTL_003_Up{1,ll};
                sel_CTTL_003_Down{1,ll} = (sel_final_frame(1,ll-1) + e_pre) + sel_CTTL_003_Down{1,ll};
                if ll == length(fileList2)
                    sel_CTTL_003_Up = cell2mat(sel_CTTL_003_Up);
                    sel_CTTL_003_Down = cell2mat(sel_CTTL_003_Down);
                    sel_CTTL_003_TimeBegin = TimeRange(1,1);
                    sel_CTTL_003_TimeEnd = sel_CTTL_003_TimeEnd(1,ll);
                end
            end
        end
    end
end
%}
%% Combine multi file of CLFP
if manual_trig==1
    count=0;
  for ii = 1:length(fileList2)
      clear CLFP_001
      load(fileList2(ii).name)
      if exist('CLFP_001')
          if ii == 1 %一番最初のファイル(いらない部分を消す必要あり)
              trash_sec = TimeRange(1) - CAI_001_TimeBegin; %いらない秒数
              trash_sample = round(trash_sec*downHz);
              for jj = 1:CLFP_file_num
                   eval(['sel_CLFP{jj,ii-count} = CLFP_' sprintf('%03d',jj) '(1,trash_sample+1:end);'])
              end
          elseif TimeRange(1)<CAI_001_TimeBegin && TimeRange(2)>CAI_001_TimeEnd
              for jj = 1:CLFP_file_num
                   eval(['sel_CLFP{jj,ii-count} = CLFP_' sprintf('%03d',jj) ';'])
              end
          else %一番最後のファイル
              e_LastSec = CAI_001_TimeEnd - TimeRange(2);
              e_LastFrame = round(e_LastSec * downHz);
              for jj = 1:CLFP_file_num
                   eval(['sel_CLFP{jj,ii-count} = CLFP_' sprintf('%03d',jj) '(1,1:end - e_LastFrame+1);'])
              end
          end
      else
          count=count+1;
      end
  end
elseif manual_trig==0
    count=0;
    for ii = 1:length(fileList2)
        clear CLFP_001
        load(fileList2(ii).name);
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
end


for ii = 1:CLFP_file_num
    All_CLFP{ii,1} = cast(cell2mat(sel_CLFP(ii,:)),'double');
end
%
%All_CLFP = cast(cell2mat(sel_CLFP),'double'); %なぜか同じファイルにおいて、CLFPの配列の数が異なるチャンネルがあるから、cell2matできない(4/26,27の両日)(データ自体の問題は1375/1くらいなのでほとんど問題ないが,cell2matができない)
%{
for kk = 1:CLFP_file_num
    eval(['CLFP_' sprintf('%03d',kk) ' = All_CLFP(kk,:);'])
end
%}
%% resample CRAW & combine multi file
if manual_trig == 1
    for ii=1:length(fileList2)
        load(fileList2(ii).name);
        if ii == 1 %一番最初のファイル(いらない部分を消す必要あり)
            for jj = 1:CRAW_file_num
                 eval(['CRAW_' sprintf('%03d',jj) '= cast(CRAW_' sprintf('%03d',jj) ',"double");']);
                 eval(['CRAW_' sprintf('%03d',jj) '= resample(CRAW_' sprintf('%03d',jj) ',downHz,CRAW_' sprintf('%03d',jj) '_KHz*1000);']);
                 eval(['sel_CRAW{jj,ii} = CRAW_' sprintf('%03d',jj) '(1,trash_sample+1:end);'])
            end
        elseif TimeRange(1)<CAI_001_TimeBegin && TimeRange(2)>CAI_001_TimeEnd
            for jj = 1:CRAW_file_num
                 eval(['CRAW_' sprintf('%03d',jj) '= cast(CRAW_' sprintf('%03d',jj) ',"double");']);
                 eval(['CRAW_' sprintf('%03d',jj) '= resample(CRAW_' sprintf('%03d',jj) ',downHz,CRAW_' sprintf('%03d',jj) '_KHz*1000);']);
                 eval(['sel_CRAW{jj,ii} = CRAW_' sprintf('%03d',jj) '(1,:);'])
            end
        else %一番最後のファイル
            for jj = 1:CRAW_file_num
                 eval(['CRAW_' sprintf('%03d',jj) '= cast(CRAW_' sprintf('%03d',jj) ',"double");']);
                 eval(['CRAW_' sprintf('%03d',jj) '= resample(CRAW_' sprintf('%03d',jj) ',downHz,CRAW_' sprintf('%03d',jj) '_KHz*1000);']);
                 eval(['sel_CRAW{jj,ii} = CRAW_' sprintf('%03d',jj) '(1,1:end - e_LastFrame+1);'])
            end
        end
    end
elseif manual_trig == 0
    for ii = 1:length(fileList2)
        load(fileList2(ii).name);
        for jj = 1:CRAW_file_num
            eval(['CRAW_' sprintf('%03d',jj) '= cast(CRAW_' sprintf('%03d',jj) ',"double");']);
            eval(['CRAW_' sprintf('%03d',jj) '= resample(CRAW_' sprintf('%03d',jj) ',downHz,CRAW_' sprintf('%03d',jj) '_KHz*1000);']);
            eval(['sel_CRAW{jj,ii} = CRAW_' sprintf('%03d',jj) ';'])
        end
    end
end

for ii = 1:CRAW_file_num
    All_CRAW{ii,1} = cast(cell2mat(sel_CRAW(ii,:)),'double');
end
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
%CLFPに関して
 for kk = 1:CLFP_file_num
        %eval(['CEMG_' sprintf('%03d',kk) ' = All_CEMG(kk,:);'])
        eval(['CLFP_' sprintf('%03d',kk) ' = All_CLFP{kk,1};'])
        eval(['CLFP_' sprintf('%03d',kk) '_KHz = downHz/1000;' ])
        eval(['CLFP_' sprintf('%03d',kk) '_KHz_Orig = downHz/1000;' ])
        eval(['CLFP_' sprintf('%03d',kk) '_TimeBegin = TimeRange(1,1);' ])
        eval(['CLFP_' sprintf('%03d',kk) '_TimeEnd = TimeRange(1,2);' ])
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
%CTTL信号に関して
for kk = 2:CTTL_file_num
    eval(['CTTL_' sprintf('%03d',kk) '_Up = sel_CTTL_' sprintf('%03d',kk) '_Up;'])
    eval(['CTTL_' sprintf('%03d',kk) '_Down = sel_CTTL_' sprintf('%03d',kk) '_Down;'])
    eval(['CTTL_' sprintf('%03d',kk) '_TimeBegin = TimeRange(1,1);']) %TimeEndはラストファイルのTimeEndだが、すでに代入済みなので、ここで定義しなくていい
    eval(['CTTL_' sprintf('%03d',kk) '_KHz = (downHz/1000);'])
    eval(['CTTL_' sprintf('%03d',kk) '_KHz_Orig = (downHz/1000);'])
end

%% save data
if exist_EMG == 1
    if CTTL_file_num == 2
        save(['AllData_' monkey_name num2str(exp_day) '.mat'],'CAI*','CEMG*','CLFP*','CRAW*','Channel_ID_Name_Map','Ports_ID_Name_Map','TimeRange','CTTL_002*')
    elseif CTTL_file_num == 3
        save(['AllData_' monkey_name num2str(exp_day) '.mat'],'CAI*','CEMG*','CLFP*','CRAW*','Channel_ID_Name_Map','Ports_ID_Name_Map','TimeRange','CTTL_002*','CTTL_003*')
    end
else
    if CTTL_file_num == 2
        save(['AllData_' monkey_name num2str(exp_day) '.mat'],'CAI*','CLFP*','CRAW*','Channel_ID_Name_Map','Ports_ID_Name_Map','TimeRange','CTTL_002*')
    elseif CTTL_file_num == 3
        save(['AllData_' monkey_name num2str(exp_day) '.mat'],'CAI*','CLFP*','CRAW*','Channel_ID_Name_Map','Ports_ID_Name_Map','TimeRange','CTTL_002*','CTTL_003*')
    end
end
cd ../
end




