function uideL

ParentDir   = uigetdir(matpath,'親フォルダを選択してください。');
InputDirs   = dirdir(ParentDir);
InputDirs   = uiselect(InputDirs,1,'対象となるExperimentを選択してください。');

InputDir    = InputDirs{1};
files       = dirmat(fullfile(ParentDir,InputDir));
files       = uiselect(files,1,'ファイルを選択してください。');

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
                    disp([' コピー失敗:  ',Inputfile])
                end
            catch
                disp([' L-- *** error occured in ',fullfile(ParentDir,InputDir,files{ifile})])
            end
        end
    catch
        disp(['****** Error occured in ',InputDirs{iDirs}])
    end

end