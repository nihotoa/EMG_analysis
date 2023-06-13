function sortsta_btc(label,suffix)

% label �g���C�A����sort���邽�߂̃X�J���[�z��

if(nargin<2)
    suffix='sorted';
end



ParentDir   = getconfig(mfilename,'ParentDir');
try
    if(~exist(ParentDir,'dir'))
        ParentDir   = pwd;
    end
catch
    ParentDir   = pwd;
end

ParentDir   = uigetdir(ParentDir,'�e�t�H���_��I�����Ă��������B');
if(ParentDir==0)
    disp('User pressed cancel.')
    return;
end
setconfig(mfilename,'ParentDir',ParentDir)

InputDirs   = uiselect(dirdir(ParentDir),1,'�ΏۂƂ���Experiments��I�����Ă�������');
if(isempty(InputDirs))
    disp('User pressed cancel.')
    return;
end
InputDir    = InputDirs{1};
InputFiles    = dirmat(fullfile(ParentDir,InputDir));
InputFiles    = sortxls(strfilt(InputFiles,'~._'));
InputFiles    = uiselect(InputFiles,1,'�ΏۂƂ���file��I�����Ă�������');
if(isempty(InputFiles))
    disp('User pressed cancel.')
    return;
end




% LabelParentDir   = getconfig(mfilename,'LabelParentDir');
% try
%     if(~exist(LabelParentDir,'dir'))
%         LabelParentDir   = pwd;
%     end
% catch
%     LabelParentDir   = pwd;
% end
% 
% LabelParentDir   = uigetdir(LabelParentDir,'Label�p�̐e�t�H���_��I�����Ă��������B');
% if(LabelParentDir==0)
%     disp('User pressed cancel.')
%     return;
% end
% setconfig(mfilename,'LabelParentDir',LabelParentDir)
% 
% LabelFiles    = dirmat(fullfile(LabelParentDir,InputDir));
% LabelFiles    = sortxls(strfilt(LabelFiles,'~._'));
% LabelFiles    = uiselect(LabelFiles,1,'Label�Ƃ���file��I�����Ă�������');
% if(isempty(LabelInputFiles))
%     disp('User pressed cancel.')
%     return;
% end


% 
OutputParentDir   = getconfig(mfilename,'OutputParentDir');
try
    if(~exist(OutputParentDir,'dir'))
        OutputParentDir   = pwd;
    end
catch
    OutputParentDir   = pwd;
end

OutputParentDir   = uigetdir(OutputParentDir,'�o�̓t�H���_��I�����Ă��������B');
if(OutputParentDir==0)
    disp('User pressed cancel.')
    return;
end
setconfig(mfilename,'OutputParentDir',OutputParentDir)






nDir    = length(InputDirs);
nFile   = length(InputFiles);


for iDir=1:nDir
    try
        InputDir    = InputDirs{iDir};

        disp([num2str(iDir),'/',num2str(length(InputDirs)),':  ',InputDir])

        for iFile=1:nFile
            try
                InputFile   = InputFiles{iFile};
%                 LabelFile   = LabelFiles{iFile};
                                
                FullInputFile    = fullfile(ParentDir,InputDir,InputFile);

                hdr = load(FullInputFile);
                dat = load(fullfile(ParentDir,InputDir,['._',InputFile]));
%                 label   = load(fullfile(LabelParentDir,InputDir,LabelFile));
%                 label   = eval(['label.',LabelName]);
                
                [hdr,dat]   = sortsta(hdr,dat,label);
                
                if(~exist(fullfile(OutputParentDir,InputDir),'dir'))
                    mkdir(fullfile(OutputParentDir,InputDir));
                end
                Outputhdr   = fullfile(OutputParentDir,InputDir,[deext(InputFile),'[sorted,',suffix,'].mat']);
                Outputdat   = fullfile(OutputParentDir,InputDir,['._',deext(InputFile),'[sorted,',suffix,'].mat']);

                save(Outputhdr,'-struct','hdr');
                save(Outputdat,'-struct','dat');
                clear('hdr','dat')

                disp([' L-- ',num2str(iFile),'/',num2str(nFile),':  ',Outputhdr])
            catch
                errormsg    = [' L-- *** error occured in ',fullfile(ParentDir,InputDir,InputFiles{iFile})];
                disp(errormsg)
                errorlog(errormsg);
            end
            %                 indicator(ii,length(InputFiles))
        end
    catch
        errormsg    = ['****** Error occured in ',InputDirs{iDir}];
        disp(errormsg)
        errorlog(errormsg);
    end
    %     indicator(0,0)

end

warning('on');