function EMGICA_btc(TimeRange)

if nargin<1
    TimeRange   = [0 Inf];
end

warning('off');

ParentDir   = uigetdir(matpath,'親フォルダを選択してください。');
InputDirs   = uiselect(dirdir(ParentDir),1,'対象とするExperimentsを選択してください');

InputDir    = InputDirs{1};
Reffiles    = dirmat(fullfile(ParentDir,InputDir));
Reffiles    = strfilt(Reffiles,'~._');
Tarfiles    = uiselect(sortxls(Reffiles),1,'対象とするfileを選択してください');
Reffiles    = uiselect(sortxls(Reffiles),1,'ICAの極性を決める際に用いるtimestampを選択してください');

OutputDir   = uigetdir(fullfile(datapath,'EMGICA'),'出力フォルダを選択してください。');
% EMGMAXDir   = uigetdir(fullfile(datapath,'EMGMAX'),'EMGMAXファイルの親フォルダを選択してください。');

nDir    = length(InputDirs);
nTar    = length(Tarfiles);

for iDir=1:nDir
    try
        InputDir    = InputDirs{iDir};
        disp([num2str(iDir),'/',num2str(nDir),':  ',InputDir])

        for iTar=1:nTar
            clear('Tar')
            Tarfile     = Tarfiles{iTar};
            Inputfile   = fullfile(ParentDir,InputDir,Tarfile);
%             EMGMAXfile  = fullfile(EMGMAXDir,InputDir,Tarfile);
            
            Tar     = load(Inputfile);
%             Tar     = resamplemat(Tar,fs);
%             EMGMAX  = load(EMGMAXfile,'MAX');
%             if(EMGMAX.MAX~=0)
%                 Tar.Data    = Tar.Data ./ EMGMAX.MAX;
%             end
            
            
            XData   = ([1:length(Tar.Data)]-1)/Tar.SampleRate;
            ind     = (XData >= TimeRange(1) & XData <= TimeRange(2));
            
            if(iTar==1)
                X   = zeros(size(Tar.Data(ind),2),nTar);
                Name = cell(1,nTar);
            end
            X(:,iTar)   = Tar.Data(ind)';
            Name{iTar}   = deext(Tar.Name);

        end
        keyboard
        [X,Score]   = EMGICA(X);
        X.AnalysisType  = 'EMGICA';
        X.Name   = Name;
        X.Unit      = Tar.Unit;
        
        clear('Ref')
        Reffile = fullfile(ParentDir,InputDir,Reffiles{1});
        Ref     = load(Reffile); 

        nICA    = size(Score,2);
        for iICA=1:nICA
            Tar.Name    = ['EMGICA',num2str(iICA,'%02d')];
            Tar.Data    = Score(:,iICA)';
            Tar.Unit    = X.Unit;
            
            % % Reference fileの前後でScoreが増えるようにICAの極性を調整
            % s1  = sta(Tar,Ref,[-0.5 0]);
            % s1  = sum(s1.YData);
            % s2  = sta(Tar,Ref,[0 0.5]);
            % s2  = sum(s2.YData);
            % 
            % if(s2 < s1)
            %     Tar.Data        = - Tar.Data;
            %     X.coeff(:,iICA) = - X.coeff(:,iICA);
            % end


            % Scoreの最大の最大変化がプラスになるようにICAの極性を調整
            [maxval,maxind] = max(abs(Tar.Data));
            maxval  = Tar.Data(maxind);
            if(maxval<0)
                Tar.Data    = - Tar.Data;
                X.coeff(:,iICA) = - X.coeff(:,iICA);
            end
            
            
            Outputfile  = fullfile(ParentDir,InputDir,Tar.Name);
            if(~exist(fileparts(Outputfile),'dir'))
                mkdir(fileparts(Outputfile));
            end
            save(Outputfile,'-struct','Tar');
            disp(Outputfile)
        end

        Outputfile  = fullfile(OutputDir,InputDir);
        if(~exist(fileparts(Outputfile),'dir'))
            mkdir(fileparts(Outputfile));
        end
        save(Outputfile,'-struct','X');
        disp(Outputfile)

    catch
        errormsg    = ['****** Error occured in ',InputDirs{iDir}];
        disp(errormsg)
        errorlog(errormsg);
    end
%     indicator(0,0)
    
end

warning('on');