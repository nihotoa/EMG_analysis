function combinedata(UseSet_flag)
% combinedata(filenames)
%
% channel fileの結合
% 複数のrecording data(continuous,timestamp,interval)を結合します。
%
%
% 結果は、DisplayDataで確認することができます。
%
% see also, displaydata
%
% Written by Takei 2010/09/29



if(nargin<1)
    UseSet_flag = 0;
end


if(UseSet_flag)
    [Y,Label]   = loadtxt;
    if(length(Label)==1 && strcmp(Label{1},'fullfilename'))
        Sets   = {Y};
    elseif(length(Label)==2 && strcmp(Label{1},'pathname') && strcmp(Label{2},'filename'))
        parentpath  = getconfig(mfilename,'parentpath');
        if(isempty(parentpath)||~ischar(parentpath))
            parentpath  = pwd;
        end
        if(~exist(parentpath,'dir'))
            parentpath  = pwd;
        end
        parentpath  = uigetdir(parentpath);
        if(isequal(parentpah,0))
            disp('User pressed cancel');
            return;
        end
        setconfig(mfilename,'parentpath',parentpath);
        
        nfiles  = size(Y,1);
        Sets    = cell(nfiles,1);
        for ifile=1:nfiles
            Sets{ifile} = fullfile(parentpath,Y{ifile,1},Y{ifile,2});
        end
        Sets    = {Sets};
        
    elseif(length(Label)==1 && strcmp(Label{1},'pathname'))
        parentpath  = getconfig(mfilename,'parentpath');
        if(isempty(parentpath)||~ischar(parentpath))
            parentpath  = pwd;
        end
        if(~exist(parentpath,'dir'))
            parentpath  = pwd;
        end
        parentpath  = uigetdir(parentpath);
        if(isequal(parentpath,0))
            disp('User pressed cancel');
            return;
        end
        setconfig(mfilename,'parentpath',parentpath);
        filenames   = sortxls(dirmat(fullfile(parentpath,Y{1})));
        filenames   = uiselect(filenames);
        if(isempty(filenames))
            disp('User pressed cancel');
            return;
        end
        
        nfiles  = length(filenames);
        ndirs   = length(Y);
        Sets    = cell(nfiles,1);
        
        for ifile=1:nfiles
            fullfilenames    = cell(ndirs,1);
            for idir=1:ndirs
                fullfilenames{idir}  = fullfile(parentpath,Y{idir},filenames{ifile});
            end
            Sets{ifile}  = fullfilenames;
        end
        
    end
else
    Sets    = matexplorer;
    Sets    = {Sets};
end



nSets       = length(Sets);
pathname    = [];

for iSet=1:nSets
    fullfilenames   = Sets{iSet};
    
    
    nfiles  = length(fullfilenames);
    for ifile=1:nfiles
        SS  = loaddata(fullfilenames{ifile});
        % Adjust TimeRange to start with 0
        SS.TimeRange    = [0 diff(SS.TimeRange)];
        if(ifile==1)
            % Prepare default output
            S   = SS;
        else
            % add data
            
            switch SS.Class
                case 'continuous channel'
                    S.Data  = [S.Data,SS.Data];
                case {'timestamp channel','interval channel'}
                    if(isfield(SS,'accessory_data'))
                        nAD =   length(S.accessory_data);
                        for iAD=1:nAD
                            S.accessory_data(iAD).Data  = [S.accessory_data(iAD).Data,SS.accessory_data(iAD).Data];
                        end
                    end
                    if(isfield(SS,'TrialsToUse'))
                        if(~isfield(S,'TrialsToUse'))
                            S.TrialsToUse   = 1:size(S.Data,2);
                        end
                        S.TrialsToUse   = [S.TrialsToUse,SS.TrialsToUse+size(S.Data,2)];
                    elseif(isfield(S,'TrialsToUse'))
                        SS.TrialsToUse  = 1:size(SS.Data,2);
                        S.TrialsToUse   = [S.TrialsToUse,SS.TrialsToUse+size(S.Data,2)];
                    end
                    S.Data  = [S.Data,SS.Data+S.TimeRange(2)*S.SampleRate];
            end
            S.TimeRange(2)  = S.TimeRange(2)+SS.TimeRange(2);
        end
    end
    
    S.CreationMethod    = 'combine';
    S.SourceFiles       = shiftdim(fullfilenames);
    
    
    
    % Output
    [temp,filename,ext] = fileparts(fullfilenames{1});
    filename    = [filename,ext];
    
    if(isempty(pathname))
        
        pathname    = getconfig(mfilename,'pathname');
        if(isempty(pathname)||~ischar(pathname))
            pathname            = pwd;
        end
        if(~exist(pathname,'dir'))
            pathname            = pwd;
        end
        [filename,pathname] = uiputfile(fullfile(pathname,filename));
        if isequal(filename,0) || isequal(pathname,0)
            disp('User pressed cancel')
            return;
        end
        setconfig(mfilename,'pathname',pathname)
    end
    
    Name    = deext(filename);
    S.Name  = Name;
    
    save(fullfile(pathname,[Name,'.mat']),'-struct','S');
    disp(fullfile(pathname,[Name,'.mat']))
end