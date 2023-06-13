%{
how to use this code:
1.Use the current directory as Nibali
2.Fill in monkey_name and exp_day
3.validate 'MATLAB' -> 'Nibali' foloder's path and disconnect 'code' folder path  (codeのパスを切って、Nibali(MATLAB→Nibaliの方)のパスを有効にする
When executed with the above satisfied,  .mat file of EMG data is saved in Nibali→Date.
エラー後にhfile.Entityの中の仕様が変わっていたので、筋電の抽出方法も変更
新しいhfile.Entityの中にサクセスタイミングの信号が入っているからテキトーな変数に代入してEMGとのフレーム誤差の埋め合わせのために使う
hfileの入っているmatlabファイルが保存するファイルと同名だから変更する
【procedure】
pre:nothing(this function is first procedure)
post:CombineMatfile.m
%}
function [] = Copy_of_sample_data_walkthrough(exp_day) 
%% parameter setting
file_name = 'datafile0001'; %コンバートできなかったときの.matファイルの名前

monkey_name='Ni';
%exp_day = 20220831; 
EMG_num = 16;
success_convert = 1; %元のファイル(.nevとか)でコンバートできるか？ 0は業者からもらったmatファイルから筋電を抽出する場合

%% start code
cd(num2str(exp_day));
fileList = dir('datafile*.nev');
data_path = which(fileList(1,1).name); %絶対パスの取得.(次のns_OpenFile関数において、入力引数には絶対パスが必要らしい)

if success_convert == 1
    [ns_RESULT, hFile] = ns_OpenFile(data_path); 
    [ns_RESULT, nsFileInfo] = ns_GetFileInfo(hFile);
else
    load([file_name '.mat']) 
end
%numEnt=length(hFile.Entity)
[start_num,end_num] = get_EMG_file_num(hFile);
%fs_clock = 30000;

for ii = start_num:2:end_num-1

    etype = hFile.Entity(ii).EntityType;

    switch(etype)
        case 'Analog'

            % get entire waveform(全体の波形を取得する) wfがEMGデータ(hfile.Entityの中の仕様が変わっていたので、筋電の抽出方法も変更)
            if success_convert == 1
                [nsres_1, wf_c_1, wf_1] = ns_GetAnalogData(hFile, ii, 1, 1e8);%wf_cは総サンプル数wf_1が筋電データ;
                [nsres_2, wf_c_2, wf_2] = ns_GetAnalogData(hFile, ii+1, 1, 1e8);
                [ns_RESULT_1, nsAnalogInfo_1] = ns_GetAnalogInfo(hFile, ii);
                [ns_RESULT_2, nsAnalogInfo_2] = ns_GetAnalogInfo(hFile, ii+1);
            else
                wf_1 = hFile.Entity(ii).Data;
                wf_2 = hFile.Entity(ii+1).Data;
            end

            %wf_1 = hFile.Entity(ii).Data;どっちか
            %wf_2 = hFile.Entity(ii+1).Data;どっちか
            %奇数チャンネルから偶数チャンネルを引く
            wf = wf_1 - wf_2;
            %↓1375HZにダウンサンプリング(2000*11/16=1375[HZ])
            new_wf = resample(interpft(wf,11*length(wf)),1375,22000);

            % RAWデータから低周波ノイズを除去する(バタワースフィルタでハイパス5HZ)
            %{
            if filt_data == 1
                filt_h = 5;
                SR = 1375;
                [B,A] = butter(6, (filt_h .* 2) ./ SR, 'high');
                new_wf = filtfilt(B,A,new_wf);
            end
            %}

            %データの保存
            %{
            if save_EMG_data == 1
                Name = [EMGs{ii,1} '-hp' num2str(filt_h) 'Hz-rect-lp' num2str(filt_l) 'Hz'];
                save([Name '.mat'],'Class','Data','Name','SampleRate','TimeRange','Unit')
            end
            %}
            %↓得られた各電極からの筋電データをCEMG00?という変数に代入する
                eval(['CEMG_' sprintf('%03d',1+((ii-start_num)/2)) '{1,1} = transpose(new_wf);']);
                eval(['CEMG_' sprintf('%03d',1+((ii-start_num)/2)) '_KHz = (2000*11/16)/1000;']); %2000は元のサンプリングレート
                eval(['CEMG_' sprintf('%03d',1+((ii-start_num)/2)) '_KHz_Org = (2000*11/16)/1000;']);

            %{
            if ii-(start_num-1) < 10
                eval(['CEMG_00' num2str(ii-(start_num-1)) '= transpose(wf)']);
                eval(['CEMG_00' num2str(ii-(start_num-1)) '_KHz = nsAnalogInfo.SampleRate']);
                eval(['CEMG_00' num2str(ii-(start_num-1)) '_KHz_Org = nsAnalogInfo.SampleRate']);
            else
                eval(['CEMG_0' num2str(ii-(start_num-1)) '= transpose(wf)']);
                eval(['CEMG_0' num2str(ii-(start_num-1)) '_KHz = nsAnalogInfo.SampleRate']);
                eval(['CEMG_0' num2str(ii-(start_num-1)) '_KHz_Org = nsAnalogInfo.SampleRate']);
            end 
            %}

            %{
            t_ = (0:(wf_c-1))/nsAnalogInfo.SampleRate;% + nsFileInfo.NIPTime/fs_clock;

            figure; plot(t_,wf); ylabel(hFile.Entity(ii).Units); xlabel('Time (s)');
            title(hFile.Entity(ii).Label,'Interpreter','none');
            %}

        case 'Segment'

            t = (-14:37)/fs_clock; % time, with 0 being time of spike
            t = (0:51)/fs_clock; % time, with timestamp at start of waveform

            % get stim timestamps
            [res, nsInfo] = ns_GetEntityInfo(hFile, ii);

            figure; hold on;
            for jj=1:nsInfo.ItemCount
                [res, ts, seg_data, seg_dsize, unitid] = ...
                    ns_GetSegmentData(hFile, ii, jj);
                plot(t+ts,seg_data); % ssequential
                %plot(t,seg_data); % on top
            end
            hold off;
            ylabel(hFile.Entity(ii).Units); xlabel('Time (s)');
            title(hFile.Entity(ii).Label,'Interpreter','none');

        case 'Event'

            [ns_RESULT, nsEventInfo] = ns_GetEventInfo(hFile, ii);
            N = hFile.Entity(ii).Count;
            ts = zeros(1,N); xs = ts;
            for jj = 1:N
                [ns_RESULT, TimeStamp, Data, DataSize] = ...
                    ns_GetEventData(hFile, ii, jj);
                ts(jj) = TimeStamp;
                xs(jj) = Data;
            end
            figure; stairs(ts,xs,'b.-');
            ylabel(hFile.Entity(ii).Units); xlabel('Time (s)');
            title(hFile.Entity(ii).Reason,'Interpreter','none');

        otherwise
            disp(['not analog, segment, or event, skipping entity ',num2str(ii,'%d')]);
            break
    end




end
    
for jj = 1:EMG_num
    eval(['CEMG_' sprintf('%03d',jj) ' = cell2mat(CEMG_' sprintf('%03d',jj) ');'])
    %CEMG_001 = CEMG_001 * hFile.Entity(ii).Scale
    eval(['CEMG_' sprintf('%03d',jj) ' = CEMG_' sprintf('%03d',jj) ' * hFile.Entity(ii).Scale;'])
end
%save([monkey_name num2str(exp_day) '_' sprintf('%04d',file_num)],'CEMG*'); 
%↓RIPPLEで記録したタイミングデータ(ECOGデータとの時間同期のために使う)
 for ii = 1:2
    eval(['SMA_' num2str(ii) '=round(hFile.Entity(ii).Count*1375/2000)'])%←ダウンサンプルも兼ねていることに注意(元OR後のサンプリングレートに変更があった場合はここも変えなきゃだめ)
 end
 SMA_Hz = 1375;
 save([monkey_name num2str(exp_day)],'CEMG*','SMA*'); 
 
    %{
    if file_num < 10
        save([monkey_name num2str(exp_day) '-000' num2str(file_num)],'CEMG*')     
    else
        save([monkey_name num2str(exp_day) '-00' num2str(file_num)],'CEMG*')
    end    
    %}
    
    %ns_CloseFile(hFile);

cd ../
end