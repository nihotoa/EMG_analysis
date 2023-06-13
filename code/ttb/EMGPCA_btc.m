function EMGPCA_btc(TimeRange)

if nargin<2
    TimeRange   = [0 Inf];
end

warning('off');

ParentDir   = uigetdir(matpath,'�e�t�H���_��I�����Ă��������B');
InputDirs   = uiselect(dirdir(ParentDir),1,'�ΏۂƂ���Experiments��I�����Ă�������');

InputDir    = InputDirs{1};
Reffiles    = dirmat(fullfile(ParentDir,InputDir));
Reffiles    = strfilt(Reffiles,'~._');
Tarfiles    = uiselect(sortxls(Reffiles),1,'�ΏۂƂ���file��I�����Ă�������');
Reffiles    = uiselect(sortxls(Reffiles),1,'PCA�̋ɐ������߂�ۂɗp����timestamp��I�����Ă�������');

OutputDir   = uigetdir(fullfile(datapath,'EMGPCA'),'�o�̓t�H���_��I�����Ă��������B');
% EMGMAXDir   = uigetdir(fullfile(datapath,'EMGMAX'),'EMGMAX�t�@�C���̐e�t�H���_��I�����Ă��������B');

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
        [X,Score]   = EMGPCA(X);
        X.AnalysisType  = 'EMGPCA';
        X.Name   = Name;
        X.Unit      = Tar.Unit;
        
        clear('Ref')
        Reffile = fullfile(ParentDir,InputDir,Reffiles{1});
        Ref     = load(Reffile); 

        nPCA    = size(Score,2);
        for iPCA=1:nPCA
            Tar.Name    = ['EMGPCA',num2str(iPCA,'%02d')];
            Tar.Data    = Score(:,iPCA)';
            Tar.Unit    = X.Unit;
            
            % Reference file�̑O���Score��������悤��PCA�̋ɐ��𒲐�
            s1  = sta(Tar,Ref,[-0.5 0]);
            s1  = sum(s1.YData);
            s2  = sta(Tar,Ref,[0 0.5]);
            s2  = sum(s2.YData);
            
            if(s2 < s1)
                Tar.Data        = - Tar.Data;
                X.coeff(:,iPCA) = - X.coeff(:,iPCA);
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