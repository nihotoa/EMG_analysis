function makeEMGNMF_btc(TimeRange,kf,nrep,nshuffle,alg)

% makeEMGNMF_btc(TimeRange,kf,nrep,nshuffle,alg)
% 
% ex
% makeEMGNMF_btc([0 480],4,10,1,'mult')

if nargin<1
    TimeRange   = [0 Inf];
    kf          = 4;
    nrep        = 20;
    nshuffle    = 1;
    alg         = 'mult';
elseif nargin<2
    kf          = 4;
    nrep        = 20;
    nshuffle    = 1;
    alg         = 'mult';
elseif nargin<3
    nrep        = 20;
    nshuffle    = 1;
    alg         = 'mult';
elseif nargin<4
    nshuffle    = 1;
    alg         = 'mult';
elseif nargin<4
    alg         = 'mult';
end

warning('off');


ParentDir    = getconfig(mfilename,'ParentDir');
try
    if(~exist(ParentDir,'dir'))
        ParentDir    = pwd;
    end
catch
    ParentDir    = pwd;
end
ParentDir   = uigetdir(ParentDir,'?e?t?H???_???I???????????????B');
if(ParentDir==0)
    disp('User pressed cancel.')
    return;
else
    setconfig(mfilename,'ParentDir',ParentDir);
end

InputDirs   = uiselect(dirdir(ParentDir),1,'??????????Experiments???I??????????????');

InputDir    = InputDirs{1};
% Tarfiles    = dirmat(fullfile(ParentDir,InputDir));
% Tarfiles    = strfilt(Tarfiles,'~._');
% Tarfiles    = uiselect(sortxls(Tarfiles),1,'??????????file???I??????????????');
Tarfiles = sortxls(dirmat(fullfile(ParentDir,InputDir)));
Tarfiles    = uiselect(Tarfiles,1,'Target?');
%Tarfiles      = load('D:\MATLABCodes\Toolboxes\force\MuscleList.mat');
% try 
% Tarfiles      = Tarfiles.TargetName;
% catch
% Tarfiles      = Tarfiles.Tarfiles;
% end

OutputDir    = getconfig(mfilename,'OutputDir');
try
    if(~exist(OutputDir,'dir'))
        OutputDir    = pwd;
    end
catch
    OutputDir    = pwd;
end
OutputDir   = uigetdir(OutputDir,'?o???t?H???_???I???????????????B');
if(OutputDir==0)
    disp('User pressed cancel.')
    return;
else
    setconfig(mfilename,'OutputDir',OutputDir);
end


nDir    = length(InputDirs);
nTar    = length(Tarfiles);

for iDir=1:nDir
%     try
        InputDir    = InputDirs{iDir};
        disp([num2str(iDir),'/',num2str(nDir),':  ',InputDir])

        for iTar=1:nTar
            clear('Tar')
            Tarfile     = Tarfiles{iTar};
            Inputfile   = fullfile(ParentDir,InputDir,Tarfile);
            
            Tar     = load(Inputfile);
            
            XData   = ((1:length(Tar.Data))-1)/Tar.SampleRate;
            ind     = (XData >= TimeRange(1) & XData <= TimeRange(2));
            TotalTime=sum(ind)/Tar.SampleRate;
            TimeRange2  = [TimeRange(1)+Tar.TimeRange(1),TimeRange(1)+Tar.TimeRange(1)+TotalTime];
                        
            if(iTar==1)
                X   = zeros(nTar,size(Tar.Data(ind),2));
                Name = cell(nTar,1);
            end
            X(iTar,:)   = Tar.Data(ind);
            Name{iTar}  = deext(Tar.Name);
            
        end

        % Preprocess
        % >>>
        % ????????1?b????filter?????W?????????????????????\?????????????g???????B
        SampleRate  = Tar.SampleRate;
%         X(:,1:SampleRate)   = [];
        
        % offset?????????A??????????????????NMF???R???|?[?l???g????????????????????????????min???????????B
        X   = offset(X,'min');
        
        % Unit??????????????normalize?????B
        if iDir == 1
           normalization_method    = 'mean';
           PreX   = mean(X,2);
           X     = normalize(X,normalization_method);
        else
           X = X ./ repmat(PreX,1,length(X(1,:)));
        end
        
        % negative???l???S???O???u???????B
        X(X<0)  = 0;
        
%         % <<<
        if iDir == 1
           [Y,Y_dat] = makeEMGNMFOya(X,kf,nrep,nshuffle,alg);
        else
           [Y,Y_dat] = makeEMGNMFUchida(X,kf,nrep,nshuffle,alg);
        end
        
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
        Y.TimeRange2    = TimeRange2;
        Y.Info.TimeRange    = Tar.TimeRange;
        Y.Info.Class        = Tar.Class;
        Y.Info.SampleRate   = Tar.SampleRate;
        Y.Info.Unit         = Tar.Unit;
        
        
        Outputfile      = fullfile(OutputDir,[InputDir,'.mat']);
        Outputfile_dat  = fullfile(OutputDir,['t_',InputDir,'.mat']);
        
        save(Outputfile,'-struct','Y');
        disp(Outputfile)
        
        save(Outputfile_dat,'-struct','Y_dat');
        disp(Outputfile_dat)
        
        
        
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
        

%     catch
%         errormsg    = ['****** Error occured in ',InputDirs{iDir}];
%         disp(errormsg)
%         errorlog(errormsg);
%     end
%     indicator(0,0)
    
end

%MailClient;
%sendmail('toya@ncnp.go.jp',InputDir,'makeEMGNMF_btc Analysis Done!!!');
warning('on');
end