%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
NMFによる筋シナジー抽出の方法を太田管轄のサルの解析用に作ったもの
makeEMGNMF_btcOyaのマイナーチェンジバージョン
・クロスバリデーションを行わなくても、nmfが行えるようになっている(kf = 1のとき)
【改善点】:
TimeRange2の用途を調べる(用途次第では、中身を変更する必要があるかも)
makeEMGNMF_btcOya.mやUchidaとの相違点を書く
GUI操作の時にどのフォルダを選択すればいいのかわからないので,dispを使ってuigetfileの前に記述しておく(1つ目:day -> nmf_result 2つ目:day -> nmf_result -> ~_standard)
ループで回したい場合にはloopmakeEMGNMF_btcOhta.mを使うこと

※TimeRange2,Y.Info.TimeRangeをコメントアウトしているので、エラーを吐く場合は、元に戻す
【procedure】
pre: untitled.m 
post: makefold.m
【caution!!!】
normalization_methodを適宜変更しましょう
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ParentDir, InputDirs, OutputDir] = makeEMGNMF_btcOhta(looped_dir,referenece_type, date, task, ParentDir, InputDirs, OutputDir) %dateとtaskはloopMakeのdata_type = 'each_trial'用;

% makeEMGNMF_btc(TimeRange,kf,nrep,nshuffle,alg)
% 
% ex
% makeEMGNMF_btc([0 480],4,10,1,'mult')
TimeRange   = [0 Inf];
kf          = 1; %ここで、クロスバリデーションを行うかどうか、行う場合は何分割するかを設定できる
nrep        = 20;
nshuffle    = 1;
warning('off'); %警告メッセージを非表示にする
alg         = 'mult';

ParentDir    = getconfig(mfilename,'ParentDir');
try
    if(~exist(ParentDir,'dir'))
        ParentDir    = pwd;
    end
catch
    ParentDir    = pwd;
end


disp("【Please select 'monkey_name' ->'date' -> 'nmf_result' 】")
if not(exist("ParentDir") == 1)
    ParentDir   = uigetdir(ParentDir,'?e?t?H???_???I???????????????B'); %ダイアログボックスを開いて、選択したディレクトリの絶対パスをParentDirに代入(nmf_resultを選択する)
end

if(ParentDir==0)
    disp('User pressed cancel.')
    return;
else
    setconfig(mfilename,'ParentDir',ParentDir);
end

disp("【Please select '~_standard' fold!】")
if not(exist("InputDirs")==1)
    InputDirs   = uiselect(dirdir(ParentDir),1,'??????????Experiments???I??????????????'); %使用するEMGデータの入っているディレクトリを選択
end
InputDir    = InputDirs{1};
% Tarfiles    = dirmat(fullfile(ParentDir,InputDir));
% Tarfiles    = strfilt(Tarfiles,'~._');
% Tarfiles    = uiselect(sortxls(Tarfiles),1,'??????????file???I??????????????');
Tarfiles = sortxls(dirmat(fullfile(ParentDir,InputDir))); %InputDir内の全てのファイルの名前を代入

disp("【Please select muscle data(.mat) what you want to use】")
Tarfiles    = uiselect(Tarfiles,1,'Target?');
%Tarfiles      = load('D:\MATLABCodes\Toolboxes\force\MuscleList.mat');
% try 
% Tarfiles      = Tarfiles.TargetName;
% catch
% Tarfiles      = Tarfiles.Tarfiles;
% end

%OutputDir    = getconfig(mfilename,'OutputDir');
OutputDir = [ParentDir '/' InputDir];
try
    if(~exist(OutputDir,'dir'))
        OutputDir    = pwd;
    end
catch
    OutputDir    = pwd;
end
disp("【Please select save_fold to save extracted data】")
if not(exist("OutputDir")==1)
    OutputDir   = uigetdir(OutputDir,'?o???t?H???_???I???????????????B'); %結果を保存するディレクトリを選択(選択したディレクトリの絶対パスがOutputDirに代入される)
end
if(OutputDir==0)
    disp('User pressed cancel.')
    return;
else
    setconfig(mfilename,'OutputDir',OutputDir);
end

try %フォルダに日付が含まれている時はtryの中身を使う
    % 文字列を分割してセル配列に格納
    switch referenece_type
        case 'monkey'
            date_str = regexp(InputDirs{1}, '\d+', 'match'); % 正規表現で数字部分を抽出する
            tokens = strsplit(InputDirs{1}, date_str);
        
            % 分割された文字列を変数に代入
            monkey_name = tokens{1}; %Ni
            add_info = tokens{2}; %_standard
        
            for ii = 1:length(looped_dir)
                InputDirs{ii} = [monkey_name num2str(looped_dir(ii)) add_info];
            end
        
            nDir    = length(InputDirs);
            nTar    = length(Tarfiles);
        
            date_str = regexp(ParentDir, '\d+', 'match'); % 正規表現で数字部分(20220420)を抽出する
            tokens = strsplit(ParentDir, date_str);
        
            % 分割された文字列を変数に代入
            ParentDir_factor1 = tokens{1}; %~/Nibali/
            ParentDir_factor2 = tokens{2}; %/nmf_result

        case 'Human'
            if not(exist('date') == 1)
                for ii = 1:length(looped_dir)
                    InputDirs{ii} = InputDir;
                end
    
                nDir    = length(InputDirs);
                nTar    = length(Tarfiles);
    
                tokens = strsplit(ParentDir,looped_dir{1});
                ParentDir_factor1 = tokens{1};
                ParentDir_factor2 = tokens{2};
            else %dateが存在する時(each_trialのとき)
                nDir    = length(InputDirs);
                nTar    = length(Tarfiles);
            end
    end
catch
    nDir    = length(InputDirs);
    nTar    = length(Tarfiles);
end

% 日付ごとに，NMFを行っていく
for iDir=1:nDir
    try
        InputDir    = InputDirs{iDir};
        try
            switch referenece_type
                case 'monkey'
                    disp([num2str(iDir),'/',num2str(nDir),':  ',InputDir])
                    ParentDir = [ParentDir_factor1 num2str(looped_dir(iDir)) ParentDir_factor2];
                case 'Human'
                    path_item = split(OutputDir, '/');
                    day_idx = find(contains(path_item, 'post'));
                    if isempty(day_idx)
                        day_idx = find(contains(path_item, 'pre'));
                    end
                    if not(exist('date')==1)
                        disp([num2str(iDir),'/',num2str(nDir),':  ', path_item{day_idx} '_' looped_dir{iDir}]);
                        ParentDir = [ParentDir_factor1 looped_dir{iDir} ParentDir_factor2];
                    else
                        disp([num2str(iDir),'/',num2str(nDir),':  ', path_item{day_idx} '_' task '_Trial' num2str(iDir)]);
                    end
            end
        catch
        end
        
        for iTar=1:nTar
            clear('Tar')
            Tarfile     = Tarfiles{iTar};
            if iTar == 1 %どのようなフィルタ処理をしたのかの部分だけ抽出する(アルファベット順で最初に来るのがBicepsだからその部分を消した)
                filter_contents = erase(Tarfile,'Biceps(uV)_');
            end
            Inputfile   = fullfile(ParentDir,InputDir,Tarfile); %入力引数を連結させてInputfileに代入
            
            Tar     = load(Inputfile);
            
            XData   = ((1:length(Tar.Data))-1)/Tar.SampleRate; %サンプル数をサンプリングレートで割って、秒に単位変換する
            ind     = (XData >= TimeRange(1) & XData <= TimeRange(2)); %XDataの各要素が、TimeRangeの範囲であるか(logic型で0,1を返す)
            TotalTime = sum(ind)/Tar.SampleRate; %使用する筋電データがトータルで何秒間か？
%             TimeRange2  = [TimeRange(1)+Tar.TimeRange(1),TimeRange(1)+Tar.TimeRange(1)+TotalTime]; %何に使うかわからないが、多分よろしくないデータが入っている
                        
            if(iTar==1) %iTarはfor文よって更新される(1~使用する筋電データの数)　元データXの配列を用意する
                X   = zeros(nTar,size(Tar.Data(ind),2));
                Name = cell(nTar,1);
            end
            X(iTar,:)   = Tar.Data(ind); %元データXに選択した筋電データを代入していく
            Name{iTar}  = deext(Tar.Name);
            
        end

        % Preprocess
        % >>>
        % ????????1?b????filter?????W?????????????????????\?????????????g???????B
        SampleRate  = Tar.SampleRate;
%         X(:,1:SampleRate)   = [];
        
        % offset?????????A??????????????????NMF???R???|?[?l???g????????????????????????????min???????????B
        X   = offset(X,'min'); %筋電の振幅の基準線を変える(min:各筋電の要素からその筋電の最低値を引く mean:各筋電の要素からその筋電の最低値を引く)
        
        % Unit??????????????normalize?????B
        normalization_method    = 'mean';
        X     = normalize(X,normalization_method); %振幅を正規化(振幅の平均値で割る)
        
        % negative???l???S???O???u???????B
        X(X<0)  = 0; %非負行列因子分解なので、非負値をなくす
        
%         % <<<
        
        [Y,Y_dat] = makeEMGNMFOhta(X,kf,nrep,nshuffle,alg,normalization_method); %ここがミソ

        
        % Postprocess
        % >>>
        [mm,nn]   = size(X);    % mm channels x nn data length
        
        
        % NMF???????g????EMG?f?[?^??????????1?b????0???????????B
%         X   = [zeros(size(X,1),SampleRate),X];
%         
%         % NMF???????g?????inormalize???????jEMG??????
%         for iTar=1:nTar
%             Tar.Name    = [Name{iTar},'_NMFraw'];
%             Tar.Data    = X(iTar,:);
%             Tar.Unit    = normalization_method;
%             
%             Outputfile  = fullfile(ParentDir,InputDir,[Tar.Name,'.mat']);
%             
%             save(Outputfile,'-struct','Tar');
%             disp(Outputfile)
%         end
%         
%         clear('X'); % X???N???A
%         nNMF=2;
%         % ?w??????NMFsize????coeff???X?R?A???g????EMG?????\??
%         X   = Y_dat.W{nNMF}*Y_dat.H{nNMF};
%         
%         % NMF???????g????EMG?f?[?^??????????1?b????0???????????B
%         X   = [zeros(size(X,1),SampleRate),X];
%         
%         % ???\????????EMG??????
%         for iTar=1:nTar
%             Tar.Name    = [Name{iTar},'-NMFreconst'];
%             Tar.Data    = X(iTar,:);
%             Tar.Unit    = normalization_method;
%             
%             Outputfile  = fullfile(ParentDir,InputDir,[Tar.Name,'.mat']);
% %             
% %             save(Outputfile,'-struct','Tar');
% %             disp(Outputfile)
% %         end
%         
%         clear('X'); % X???N???A
        
%         % H??Unit??????????????normalize?????B
%         for ii=1:mm
%             A   = mean(Y_dat.test.H{ii},2);
%             Y_dat.test.W{ii} = Y_dat.test.W{ii} .* repmat(A',mm,1);
%             Y_dat.test.H{ii} = Y_dat.test.H{ii} ./ repmat(A ,1,nn);
%         end

        
        % ????????1?b????0???????????B
%         for ii=1:mm
%             Y_dat.test.H{ii} = [zeros(size(Y_dat.test.H{ii},1),SampleRate),Y_dat.test.H{ii}];
%         end
%         
                        
%         % ?w??????NMFsize????coeff???X?R?A???????????B
%         Y.nNMF = nNMF;
%         Y.coeff = Y_dat.test.W{nNMF};
%         Score   = Y_dat.test.H{nNMF};

        % <<<
        
        
        % EMGNMF?t?@?C????EMGNMF_dat?t?@?C????????
        Y.Name          = InputDir;
        Y.AnalysisType  = 'EMGNMF';
        Y.TargetName    = Name;
%         Y.TargetName    = Tarfiles;
%         Y.Unit  = normalization_method;
        Y.TimeRange     = TimeRange;
%         Y.TimeRange2    = TimeRange2;
%         Y.Info.TimeRange    = Tar.TimeRange;
        Y.Info.Class        = Tar.Class;
        Y.Info.SampleRate   = Tar.SampleRate;
        Y.Info.Unit         = Tar.Unit;
        
        %解析結果を保存するセクション(クロスバリデーションをしたのかしていないのか、どこの筋電データなのか(tim2周りなど)を明記すべき
        if kf == 1 %クロスバリデーションをしていないとき
            switch referenece_type
                case 'monkey'
                    try
                        if iDir == 1 %初日の時
                            temp = regexp(OutputDir, '\d+', 'match');
                            num_part = temp{1};
                        end
                        OutputDir_EX = strrep(OutputDir, num_part, num2str(looped_dir(iDir))); %OutputDirを踏襲した最終的なOutputDir
                        Outputfile      = fullfile(OutputDir_EX,[InputDir '_NoFold_' filter_contents]); %filter_contentsには.matまでの文字列が含まれているから.matをつける必要なし
                        Outputfile_dat  = fullfile(OutputDir_EX,['t_',InputDir '_NoFold_' filter_contents]);
        
                        save(Outputfile,'-struct','Y');
                        disp(Outputfile)
        
                        save(Outputfile_dat,'-struct','Y_dat');
                        disp(Outputfile_dat)
                    catch
                        Outputfile      = fullfile(OutputDir,[InputDir,'.mat']);
                        Outputfile_dat  = fullfile(OutputDir,['t_',InputDir,'.mat']);
        
                        save(Outputfile,'-struct','Y');
                        disp(Outputfile)
        
                        save(Outputfile_dat,'-struct','Y_dat');
                        disp(Outputfile_dat)
                    end
                case 'Human'
                    try 
                        if not(exist('date') == 1)
                            % taskのループによるoutputDirの変更
                            OutputDir_EX = strrep(OutputDir, looped_dir{1}, looped_dir{iDir}); %OutputDirを踏襲した最終的なOutputDir
                            Outputfile = fullfile([OutputDir_EX '/' looped_dir{iDir} '_standard_Nofold.mat']); %filter_contentsには.matまでの文字列が含まれているから.matをつける必要なし
                            Outputfile_dat = fullfile([OutputDir_EX '/' 't_' looped_dir{iDir} '_standard_Nofold.mat']); 
                        else %each_trialの時
                            OutputDir_EX = strrep(OutputDir, ['trial' sprintf('%02d', 1)], ['trial' sprintf('%02d', iDir)]);
                            Outputfile = fullfile([OutputDir_EX '/' task '_standard_Nofold.mat']); 
                            Outputfile_dat = fullfile([OutputDir_EX '/' 't_' task '_standard_Nofold.mat']); 
                        end
        
                        save(Outputfile,'-struct','Y');
                        disp(Outputfile)
        
                        save(Outputfile_dat,'-struct','Y_dat');
                        disp(Outputfile_dat)
                    catch
                        error('どこかでエラーを吐いています．やり直してください')
                    end
            end
        else %クロスバリデーションをした時(クロスバリデーションをするときは全体データに対して筋シナジー解析をする)
            Outputfile      = fullfile(OutputDir_EX,[InputDir '_' num2str(kf) 'Fold.mat']);
            Outputfile_dat  = fullfile(OutputDir_EX,['t_',InputDir '_' num2str(kf) 'Fold.mat']);
            
            save(Outputfile,'-struct','Y');
            disp(Outputfile)
            
            save(Outputfile_dat,'-struct','Y_dat');
            disp(Outputfile_dat)
        end
        
        
        
%         % NMF????(SCORE)??????
%         Score=Y_dat.test.H;
%         nNMF    = size(Score,1);
%         for iNMF=1:nNMF
%             Tar.Name    = ['EMGNMF',num2str(iNMF,'%02d')];
%             Tar.Data    = Score(iNMF,:);
%             Tar.Unit    = normalization_method;
%             
%             Outputfile  = fullfile(ParentDir,InputDir,[Tar.Name,'.mat']);
%             
%             save(Outputfile,'-struct','Tar');
%             disp(Outputfile)
%         end
%         
        

    catch
        errormsg    = ['****** Error occured in ',InputDirs{iDir}];
        disp(errormsg)
        errorlog(errormsg);
        % エラー情報を取得して表示
        err = lasterror;
        disp(err.message);

        % エラーが発生したファイル名と行番号を取得して表示
        file = err.stack(1).file;
        line = err.stack(1).line;
        disp(['Error in file: ', file, ' at line ', num2str(line)]);
    end
%     indicator(0,0)
    
end

%MailClient;
%sendmail('toya@ncnp.go.jp',InputDir,'makeEMGNMF_btc Analysis Done!!!');
warning('on');
