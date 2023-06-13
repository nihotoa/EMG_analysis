function uideL

ParentDir   = uigetdir(matpath,'�e�t�H���_��I�����Ă��������B');
InputDirs   = dirdir(ParentDir);
InputDirs   = uiselect(InputDirs,1,'�ΏۂƂȂ�Experiment��I�����Ă��������B');

InputDir    = InputDirs{1};
files       = dirmat(fullfile(ParentDir,InputDir));
files       = uiselect(files,1,'�t�@�C����I�����Ă��������B');

% Unitfile    = 'Unit 1.mat';
% MSDfiles    = {'MSD.mat'};

for iDirs=1:length(InputDirs)
    try
        InputDir    = InputDirs{iDirs};

        OutputDir   = fullfile(ParentDir,InputDir);
        disp([num2str(iDirs),'/',num2str(length(InputDirs)),':  ',OutputDir])

        for ifile=1:length(files)
            try
                file    = files{ifile};
                Inputfile  = fullfile(ParentDir,InputDir,file);
                
                ind     = strfind(file,'l');
                if(length(ind)>=2)
                    file(ind(end))  =[];
                    file(ind(1))  =[];
                end
                
                Outputfile  = fullfile(ParentDir,InputDir,file);
                
                yn  = copyfile(Inputfile,Outputfile);
                
                if(yn)
                    
                
                disp([' L-- ',num2str(ifile),'/',num2str(length(files)),':  ',Outputfile])
                else
                    disp([' �R�s�[���s:  ',Inputfile])
                end
            catch
                disp([' L-- *** error occured in ',fullfile(ParentDir,InputDir,files{ifile})])
            end
        end
    catch
        disp(['****** Error occured in ',InputDirs{iDirs}])
    end

end