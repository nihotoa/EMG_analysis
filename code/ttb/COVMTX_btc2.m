function COVMTX_btc(maxlag,TimeRange,OneToOne_flag,diff3_flag)

if nargin < 2
    TimeRange       = [-inf inf];
    OneToOne_flag   = 0;
    diff3_flag      = 0;
elseif nargin < 3
    OneToOne_flag   = 0;
    diff3_flag      = 0;
elseif nargin < 4
    diff3_flag      = 0;
end

contents    = uiselect({'corr','xcorr','mrA'},1,'解析内容の選択');

alpha   = 0.05;

warning('off');
if(OneToOne_flag~=1)

    ParentDir   = uigetdir(matpath,'親フォルダを選択してください。');
    InputDirs   = uiselect(dirdir(ParentDir),1,'対象とするExperimentsを選択してください');

    InputDir    = InputDirs{1};
    Reffile     = dirmat(fullfile(ParentDir,InputDir));
    Reffile     = strfilt(Reffile,'~._');
    Tarfiles    = uiselect(sortxls(Reffile),1,'対象とするfileを選択してください');
    Tar         = load(fullfile(ParentDir,InputDir,Tarfiles{1}));
    if(~isfield(Tar,'XData')) % MDAdataのとき
        Reffile     = uiselect(sortxls(Reffile),1,'TimeRangeのトリガーとなるTime Stamp channelを選択してください');
        if(iscell(Reffile))
            Reffile     = Reffile{1};
        end
    else
        Reffile      = [];
    end

    OutputDir   = uigetdir(fullfile(datapath,'COVMTX'),'出力フォルダを選択してください。');

    nDir    = length(InputDirs);
    nTar    = length(Tarfiles);

    for iDir=1:nDir
        try
            clear('S');
            S.diff3_flag    = diff3_flag;
            S.OneToOne_flag = OneToOne_flag;
            S.TimeRange     = TimeRange;
            S.maxlag        = maxlag;
            S.AnalysisType  = 'COVMTX';
            S.TargetName    = Tarfiles;
            S.ReferenceName = Reffile;

            InputDir    = InputDirs{iDir};
            disp([num2str(iDir),'/',num2str(nDir),':  ',InputDir])

            if(~isfield(Tar,'XData'))
                Ref         = load(fullfile(ParentDir,InputDir,Reffile));
                StartTime   = Ref.Data(1) ./ Ref.SampleRate;
                TimeRange2  = TimeRange + StartTime;
                S.TimeRange = TimeRange2;
            else                    % sta fileのとき
                TimeRange2  = TimeRange;
            end

            for iTar=1:nTar
                clear('Tar')
                Tarfile     = Tarfiles{iTar};
                Inputfile   = fullfile(ParentDir,InputDir,Tarfile);

                Tar     = load(Inputfile);

                if(isfield(Tar,'XData'))    % sta fileのとき

                    ind     = (Tar.XData >= TimeRange2(1) & Tar.XData <= TimeRange2(2));

                    if(iTar==1)
                        X   = zeros(size(Tar.YData(ind),2),nTar);
                        Name = cell(1,nTar);
                    end
                    X(:,iTar)   = Tar.YData(ind)';
                    Name{iTar}   = deext(Tar.Name);
                else            % continuous fileのとき
                    XData   = ([1:length(Tar.Data)]-1)/Tar.SampleRate;
                    ind     = (XData >= TimeRange2(1) & XData <= TimeRange2(2));

                    if(iTar==1)
                        X   = zeros(size(Tar.Data(ind),2),nTar);
                        Name = cell(1,nTar);
                    end
                    X(:,iTar)   = Tar.Data(ind)';
                    Name{iTar}   = deext(Tar.Name);
                end
            end

            if(diff3_flag)
                X   = filter([1 -3 3 -1],1,X);% Apply 3rd order difference;
            end


            if(any(ismember(contents,'corr')))
                % 共分散および相関係数行列(corr)
                S.cov       = cov(zscore(X));

                [S.corrcoef,S.corrcoefP,S.corrcoefLO,S.corrcoefUP]  = corrcoef(X,'alpha',alpha,'rows','complete');

                S.corrcoefH     = S.corrcoefP < alpha;
                S.corrcoefN     = sum(all(~isnan(X),2));
                S.corrcoefUPLim = t2r(tinv(1-alpha/2,S.corrcoefN-2),S.corrcoefN);
                S.corrcoefLOLim = - S.corrcoefUPLim;

                disp('corr')
            end

            if(any(ismember(contents,'xcorr')))
                
                % 相互相関係数行列
                maxlagind   = round(maxlag * Tar.SampleRate);
                lagind      = (-maxlagind):maxlagind;
                lag         =  lagind / Tar.SampleRate;
                nlag        = length(lag);
                
                S.xcorr         = zeros(nTar,nlag);
                S.xcorrP        = zeros(nTar,nlag);
                S.xcorrH        = false(nTar,nlag);
                S.xcorrLO       = zeros(nTar,nlag);
                S.xcorrUP       = zeros(nTar,nlag);
                S.xcorrN        = zeros(nTar,nlag);
                S.xcorrLOLim    = zeros(nTar,nlag);
                S.xcorrUPLim    = zeros(nTar,nlag);
                S.xcorrRmax     = zeros(nTar,1);
                S.xcorrRmaxlag  = zeros(nTar,1);
                S.xcorrRmaxP    = zeros(nTar,1);
                S.xcorrRmaxH    = false(nTar,1);


                    
                if(isfield(Tar,'XData'))    % sta fileのとき
                    datalength  = size(X,1);

                    for iTar    = 1:nTar
                        Xn0 = [nan(maxlagind,1);X(:,iTar);nan(maxlagind,1)];
                        for ilag = 1:nlag
                            X1  = RefYData;
                            Xn  = Xn0(ilag:(ilag+datalength-1));
                            [temp,tempP,tempLO,tempUP]  = corrcoef(Xn,X1,'alpha',alpha,'rows','complete');
                            S.xcorr(iTar,ilag)      = temp(1,2);
                            S.xcorrP(iTar,ilag)     = tempP(1,2);
                            S.xcorrH(iTar,ilag)     = S.xcorrP(iTar,ilag) < alpha;
                            S.xcorrLO(iTar,ilag)    = tempLO(1,2);
                            S.xcorrUP(iTar,ilag)    = tempUP(1,2);
                            N                       = sum(~isnan(X1) & ~isnan(Xn));
                            S.xcorrN(iTar,ilag)     = N;
                            S.xcorrUPLim(iTar,ilag) = t2r(tinv(1-alpha/2,N-2),N);
                            S.xcorrLOLim(iTar,ilag) = - S.xcorrUPLim(iTar,ilag);
                        end
                    end

                    S.xcorrlag      = lag;  % ch1がlag(i)分遅く起こったときのch2との相関係数がS.xcorr(:,i)に入っている。
                    S.xcorrlaghelp  = 'Target(ex EMG)がlag(ii)分早く起こったときのReference(ex Spike)との相関係数がS.xcorr(1,ii)に入っている。';

                    S.xcorrRmax     = 0;
                    S.xcorrRmaxlag  = 0;
                    S.xcorrRmaxP    = 0;
                    S.xcorrRmaxH    = false;

                    [temp,xcorrRmaxind] = max(abs(S.xcorr));
                    S.xcorrRmax     = S.xcorr(xcorrRmaxind);
                    S.xcorrRmaxlag  = S.xcorrlag(xcorrRmaxind);
                    S.xcorrRmaxP    = S.xcorrP(xcorrRmaxind);
                    S.xcorrRmaxH    = S.xcorrH(xcorrRmaxind);


                else                        % continuous fileのとき

                S.xcorr     = zeros(nTar,nlag);
                datalength  = size(X,1) - maxlagind * 2;
                for iTar = 1:nTar
                    for ilag = 1:nlag
                        %                 S.xcorr(iTar,:) = xcov(X(:,iTar),X(:,1),maxlagind,'coeff')';
                        X1  = X((maxlagind+1):(maxlagind+datalength),1);
                        Xn  = X(ilag:(ilag+datalength-1),iTar);
                        temp    = corrcoef(Xn,X1);
                        S.xcorr(iTar,ilag) = temp(1,2);
                    end
                end
                S.xcorrlag      = lag;  % ch1がlag(i)分遅く起こったときのch2との相関係数がS.xcorr(:,i)に入っている。
                S.xcorrlaghelp  = 'ch1(ex Spike)がlag(ii)分遅く起こったときの他のch(ex EMG)との相関係数がS.xcorr(:,ii)に入っている。';

                S.xcorrPmax     = zeros(nTar,1);
                S.xcorrPmaxlag  = zeros(nTar,1);

                for iTar =1:nTar
                    [temp,xcorrPmaxind] = max(abs(S.xcorr(iTar,:)));
                    S.xcorrPmax(iTar)   = S.xcorr(iTar,xcorrPmaxind);
                    S.xcorrPmaxlag(iTar)= S.xcorrlag(xcorrPmaxind);
                end
                disp('xcorr')
                end



                %
                %     % 相互相関係数行列
                % 両端をNaNで補完する
                maxlagind   = round(maxlag * Tar.SampleRate);
                lagind      = (-maxlagind):maxlagind;
                lag         =  lagind / Tar.SampleRate;
                nlag        = length(lag);
                datalength  = size(RefYData,1);

                S.xcorr      = zeros(1,nlag);
                S.xcorrP     = zeros(1,nlag);
                S.xcorrH     = false(1,nlag);
                S.xcorrLO    = zeros(1,nlag);
                S.xcorrUP    = zeros(1,nlag);
                S.xcorrN     = zeros(1,nlag);
                S.xcorrLOLim = zeros(1,nlag);
                S.xcorrUPLim = zeros(1,nlag);

                X20 = [nan(maxlagind,1);TarYData;nan(maxlagind,1)];
                for ilag = 1:nlag
                    X1  = RefYData;
                    X2  = X20(ilag:(ilag+datalength-1));
                    [temp,tempP,tempLO,tempUP]  = corrcoef(X2,X1,'alpha',alpha,'rows','complete');
                    S.xcorr(ilag)   = temp(1,2);
                    S.xcorrP(ilag)  = tempP(1,2);
                    S.xcorrH(ilag)  = S.xcorrP(ilag) < alpha;
                    S.xcorrLO(ilag) = tempLO(1,2);
                    S.xcorrUP(ilag) = tempUP(1,2);
                    S.xcorrN(ilag)  = sum(~isnan(X2) & ~isnan(X1));
                    S.xcorrUPLim(ilag) = t2r(tinv(1-alpha/2,S.xcorrN(ilag)-2),S.xcorrN(ilag));
                    S.xcorrLOLim(ilag) = - S.xcorrUPLim(ilag);

                end

                S.xcorrlag      = lag;  % ch1がlag(i)分遅く起こったときのch2との相関係数がS.xcorr(:,i)に入っている。
                %     S.xcorrlaghelp  = 'Reference(ex Spike)がlag(ii)分遅く起こったときのTarget(ex EMG)との相関係数がS.xcorr(1,ii)に入っている。';
                S.xcorrlaghelp  = 'Target(ex EMG)がlag(ii)分早く起こったときのReference(ex Spike)との相関係数がS.xcorr(1,ii)に入っている。';

                S.xcorrRmax     = 0;
                S.xcorrRmaxlag  = 0;
                S.xcorrRmaxP    = 0;
                S.xcorrRmaxH    = false;

                [temp,xcorrRmaxind] = max(abs(S.xcorr));
                S.xcorrRmax     = S.xcorr(xcorrRmaxind);
                S.xcorrRmaxlag  = S.xcorrlag(xcorrRmaxind);
                S.xcorrRmaxP    = S.xcorrP(xcorrRmaxind);
                S.xcorrRmaxH    = S.xcorrH(xcorrRmaxind);
                disp('xcorr')



            end


            if(any(ismember(contents,'mrA')))
                % 重回帰分析
                % Vandermonde 行列 XX

                XX  = [ones(size(X,1),1),X(:,2:end)];
                y   = X(:,1);
                [nN,nP] = size(XX);

                %         S.mrA   = XX \ y;
                %
                %         yhat    = XX * S.mrA;
                %         s2      = (y - yhat)' * (y - yhat);
                %         S.mrAse = sqrt(diag(inv(XX'*XX))) .* sqrt(s2);
                %         S.mrAF  = (S.mrA ./ S.mrAse).^2;
                %         S.mrAP  = 1 - fcdf(S.mrAF,1,nN-nP-1);
                %         S.mrAH  = S.mrAP < 0.05;
                [S.mrA,S.mrAint]    = regress(y,XX);

                yhat    = XX * S.mrA;
                S.mrAH  = S.mrAint(:,2)<0 | S.mrAint(:,1)>0;


                S.mrR   = corr(yhat,y);   % 重相関係数
                S.mrRa  = sqrt(1-(nN-1).*(1-S.mrR.^2)./(nN-nP-1));  % 自由度調整済み重相関係数
                S.mrF   = ((S.mrR.^2) .* (nN-nP-1)) ./ ((1 - S.mrR.^2) .* nP);
                S.mrP   = 1-fcdf(S.mrF,nP,nN-nP-1);
                S.mrH   = S.mrP<0.05;
                %         S.mrAse =

                S.mrE   = sum((y - yhat).^2);
                disp('mr')
            end



            %             % 標準化偏回帰係数
            %             XX  = zscore([ones(size(X,1),1),X(:,2:end)]);
            %             y   = zscore(X(:,1));
            %             [nN,nP] = size(XX);
            %
            %             %         S.mrA   = XX \ y;
            %             %
            %             %         yhat    = XX * S.mrA;
            %             %         s2      = (y - yhat)' * (y - yhat);
            %             %         S.mrAse = sqrt(diag(inv(XX'*XX))) .* sqrt(s2);
            %             %         S.mrAF  = (S.mrA ./ S.mrAse).^2;
            %             %         S.mrAP  = 1 - fcdf(S.mrAF,1,nN-nP-1);
            %             %         S.mrAH  = S.mrAP < 0.05;
            %             [S.smrA,S.smrAint]    = regress(y,XX);
            %
            %             yhat    = XX * S.smrA;
            %             S.smrAH  = S.smrAint(:,2)<0 | S.smrAint(:,1)>0;
            %
            %             S.smrR   = corr(yhat,y);   % 重相関係数
            %             S.smrRa  = sqrt(1-(nN-1).*(1-S.smrR.^2)./(nN-nP-1));  % 自由度調整済み重相関係数
            %             S.smrF   = ((S.smrR.^2) .* (nN-nP-1)) ./ ((1 - S.smrR.^2) .* nP);
            %             S.smrP   = 1-fcdf(S.smrF,nP,nN-nP-1);
            %             S.smrH   = S.smrP<0.05;
            %             %         S.smrAse =
            %
            %             S.smrE   = sum((y - yhat).^2);
            %             disp('smr')


            %         % Step-wise method
            %
            %         [S.swA,S.swAse,S.swAp,S.swAinmodel]=stepwisefit(XX,X(:,1));
            %         disp('step wise')


            %         % 時間差つき重回帰分析
            %
            %         S.xmrA  = zeros(length(S.mrA),2*maxlagind+1);
            %
            %         nX  = length(X(:,1));
            %         X   = [zeros(maxlagind,1);X(:,1);zeros(maxlagind,1)];
            %
            %         for lagind = 1:(2*maxlagind+1)
            %             starti = length(X) - nX + 1 - (lagind - 1);
            %             S.xmrA(:,lagind)  = XX\X(starti:(starti+nX-1));
            %             indicator(lagind,(2*maxlagind+1))
            %         end
            % %         indicator(0,0)
            %         disp('xmr')

            S.Name      = Name;
            S.Unit      = Tar.Unit;

            Outputfile  = fullfile(OutputDir,InputDir);
            if(~exist(fileparts(Outputfile),'dir'))
                mkdir(fileparts(Outputfile));
            end
            save(Outputfile,'-struct','S');
            disp(Outputfile)

        catch
            errormsg    = ['****** Error occured in ',InputDirs{iDir}];
            disp(errormsg)
            errorlog(errormsg);
        end
        %     indicator(0,0)

    end
else    % OneToOne_flag == 1


    ParentDir   = uigetdir(matpath,'親フォルダを選択してください。');
    InputDirs   = uiselect(dirdir(ParentDir),1,'対象とするExperimentsを選択してください');

    InputDir    = InputDirs{1};
    Trigfile    = dirmat(fullfile(ParentDir,InputDir));
    Trigfile    = strfilt(Trigfile,'~._');
    Reffiles    = uiselect(sortxls(Trigfile),1,'対象とするReference filesを選択してください');
    Tarfiles    = uiselect(sortxls(Trigfile),1,'対象とするTarget filesを選択してください');

    Tar         = load(fullfile(ParentDir,InputDir,Tarfiles{1}));
    if(~isfield(Tar,'XData')) % MDAdataのとき
        Trigfile     = uiselect(sortxls(Trigfile),1,'TimeRangeのトリガーとなるTime Stamp channelを選択してください');
        if(iscell(Trigfile))
            Trigfile     = Trigfile{1};
        end
    else
        Trigfile      = [];
    end


    OutputDir   = uigetdir(fullfile(datapath,'COVMTX'),'出力フォルダを選択してください。');

    nDir    = length(InputDirs);
    nRef    = length(Reffiles);
    nTar    = length(Tarfiles);
    if(nRef~=nTar)
        error('Reference filesとTarget filesの数が違います.')
    end

    for iDir=1:nDir
        clear('S');
        S.diff3_flag    = diff3_flag;
        S.OneToOne_flag = OneToOne_flag;
        S.TimeRange     = TimeRange;
        S.maxlag        = maxlag;
        S.TargetName    = Tarfiles;
        S.ReferenceName = Reffiles;
        S.AnalysisType  = 'COVMTX';

        try
            InputDir    = InputDirs{iDir};
            disp([num2str(iDir),'/',num2str(nDir),':  ',InputDir])
            clear('Trig')
            if(~isfield(Tar,'XData'))
                Trig         = load(fullfile(ParentDir,InputDir,Trigfile));
                StartTime   = Trig.Data(1) ./ Trig.SampleRate;
                TimeRange2  = TimeRange + StartTime;
                S.TimeRange = TimeRange2;
                %                 disp(TimeRange2)
            else
                TimeRange2  = TimeRange;
                %                 disp(TimeRange2)
            end

            for iTar=1:nTar
                clear('Ref','Tar')
                Reffile     = Reffiles{iTar};
                Tarfile     = Tarfiles{iTar};

                Ref     = load(fullfile(ParentDir,InputDir,Reffile));
                Tar     = load(fullfile(ParentDir,InputDir,Tarfile));

                if(isfield(Tar,'XData'))    % sta fileのとき
                    ind     = (Tar.XData >= TimeRange2(1) & Tar.XData <= TimeRange2(2));
                    %                     X   = [zscore(Ref.YData(ind)') zscore(Tar.YData(ind)')];
                    X   = [Ref.YData(ind)' Tar.YData(ind)'];

                else            % continuous fileのとき

                    XData   = ([1:length(Tar.Data)]-1)/Tar.SampleRate;
                    ind     = (XData >= TimeRange2(1) & XData <= TimeRange2(2));
                    %                     X   = [zscore(Ref.Data(ind)') zscore(Tar.Data(ind)')];
                    X   = [Ref.Data(ind)' Tar.Data(ind)'];
                end


                if(diff3_flag)
                    X   = filter([1 -3 3 -1],1,X);% Apply 3rd order difference;
                end
                X   = zscore(X);

                if(any(ismember(contents,'corr')))
                    % 共分散および相関係数行列
                    if(iTar==1)
                        S.cov       = zeros(nTar,1);
                        S.corrcoef  = zeros(nTar,1);
                    end
                    temp        = cov(X);
                    S.cov(iTar) = temp(1,2);
                    temp            = corrcoef(X);
                    S.corrcoef(iTar)= temp(1,2);
                    disp('corr')
                end

                if(any(ismember(contents,'xcorr')))
                    % 相互相関係数行列
                    maxlagind   = round(maxlag * Tar.SampleRate);
                    lagind      = (-maxlagind):maxlagind;
                    lag         = lagind / Tar.SampleRate;
                    nlag        = length(lag);
                    if(iTar==1)
                        S.xcorr     = zeros(nTar,nlag);
                        S.xcorrlag      = lag;  % ch1がlag(i)分遅く起こったときのch2との相関係数がS.xcorr(:,i)に入っている。
                        S.xcorrlaghelp  = 'ch1(ex Spike)がlag(ii)分遅く起こったときの他のch(ex EMG)との相関係数がS.xcorr(:,ii)に入っている。';
                        S.xcorrPmax     = zeros(nTar,1);
                        S.xcorrPmaxlag  = zeros(nTar,1);
                    end
                    datalength  = size(X,1) - maxlagind * 2;
                    for ilag = 1:nlag
                        %                 S.xcorr(iTar,:) = xcov(X(:,iTar),X(:,1),maxlagind,'coeff')';
                        X1  = X((maxlagind+1):(maxlagind+datalength),1);
                        X2  = X(ilag:(ilag+datalength-1),2);
                        temp    = corrcoef(X2,X1);
                        S.xcorr(iTar,ilag) = temp(1,2);
                    end
                    [temp,xcorrPmaxind] = max(abs(S.xcorr(iTar,:)));
                    S.xcorrPmax(iTar)   = S.xcorr(iTar,xcorrPmaxind);
                    S.xcorrPmaxlag(iTar)= S.xcorrlag(xcorrPmaxind);
                    disp('xcorr')
                end


            end

            S.Unit          = Tar.Unit;

            Outputfile  = fullfile(OutputDir,InputDir);
            if(~exist(fileparts(Outputfile),'dir'))
                mkdir(fileparts(Outputfile));
            end
            save(Outputfile,'-struct','S');
            disp(Outputfile)

        catch
            errormsg    = ['****** Error occured in ',InputDirs{iDir}];
            disp(errormsg)
            errorlog(errormsg);
        end
        %     indicator(0,0)

    end


end
warning('on');
end


