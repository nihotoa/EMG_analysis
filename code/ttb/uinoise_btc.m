function uinoise_btc


ParentDir   = uigetdir(matpath,'�e�t�H���_��I�����Ă��������B');
InputDirs   = dirdir(ParentDir);
InputDirs   = uiselect(InputDirs,1,'�ΏۂƂȂ�Experiment��I�����Ă��������B');

InputDir    = InputDirs{1};
files    = dirmat(fullfile(ParentDir,InputDir));
EMGfiles    = uiselect(files,1,'�ΏۂƂ���t�@�C��(EMG�Ȃ�)��I�����Ă��������B');
reffile = uiselect(files,1,'�Q�ƂƂ��Ďg���t�@�C����I�����Ă��������B');
reffile = reffile{1};


OutputParentDir = uigetdir(matpath,'�o�̓t�H���_��I�����Ă��������B');

for iDirs=1:length(InputDirs)
    try
        InputDir    = InputDirs{iDirs};
        
        OutputDir   = fullfile(OutputParentDir,InputDir(1:end-2));
        mkdir(OutputDir);
        
        ref     = load(fullfile(ParentDir,InputDir,reffile));
        
        disp([num2str(iDirs),'/',num2str(length(InputDirs)),': ',OutputDir])

        for ifile=1:length(EMGfiles)

            file    = EMGfiles{ifile};
            try
                s       = load(fullfile(ParentDir,InputDir,file));
                
%                 XData   =([1:length(s.Data)]-1)./s.SampleRate;
%                 ind     = (XData>=1 & XData<=30);
                
                ind     = strfind(file,'l');    % ��Βl�L��������
                if(length(ind)>=2)
                    file(ind(end))  =[];
                    file(ind(1))  =[];
                end
                
                
                fulloutputfile  = fullfile(OutputDir,file);
                
                [RMS,MAX,MEAN,STD,lMAXl,lMEANl,lSTDl]   = uinoise(s,ref);

                if(exist(fulloutputfile,'file'))
%                     disp('add')
                    S       = load(fulloutputfile);
                    S.RMS  = RMS;
                    S.MAX  = MAX;
                    S.MEAN = MEAN;
                    S.STD  = STD;
                    S.lMAXl    = lMAXl;
                    S.lMEANl   = lMEANl;
                    S.lSTDl    = lSTDl;
                    
                else
%                     disp('new')
                    S.RMS  = RMS;
                    S.MAX  = MAX;
                    S.MEAN = MEAN;
                    S.STD  = STD;
                    S.lMAXl    = lMAXl;
                    S.lMEANl   = lMEANl;
                    S.lSTDl    = lSTDl;
                    
                end
                
                
                save(fulloutputfile,'-struct','S')

                disp([' L-- ',num2str(ifile),'/',num2str(length(EMGfiles)),':  ',fulloutputfile])
            catch
                disp([' L-- *** error occured in ',fullfile(OutputDir,file)])
            end
        end
    catch
        disp(['****** Error occured in ',InputDirs{iDirs}])
    end

end