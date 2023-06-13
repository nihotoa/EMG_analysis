function importnevdata
% IMPORTNEVDATA
%
% nsNEVLibrary.dll support only 32bit PC, but not 64bit PC

% Prompt for the correct DLL
DLLName = 'nsNEVLibrary.dll';

% Load the appropriate DLL
[nsresult] = ns_SetLibrary(which(DLLName));
if (nsresult ~= 0)
    disp('DLL was not found!');
    return
end



% Find out the data file(s)
InputDir    = getconfig(mfilename,'InputDir');
try
    if(~exist(InputDir,'dir'))
        InputDir    = pwd;
    end
catch
    InputDir    = pwd;
end
FileName    = getconfig(mfilename,'FileName');
try
    if(~ischar(FileName))
        FileName    = '*.nev';
    end
catch
    FileName    = '*.nev';
end

[FileNames,InputDir] = uigetfile(fullfile(InputDir,FileName),'Import NEV files','MultiSelect','on');
if isequal(FileNames,0) || isequal(InputDir,0)
    disp('User pressed cancel.');
    return;
else
    setconfig(mfilename,'InputDir',InputDir);
    if(~iscell(FileNames))
        FileNames   = {FileNames};
    end
    setconfig(mfilename,'FileName',FileNames{1});
end


% Select 1st File to set parameters
FileName    = FileNames{1};
FullFileName    = fullfile(InputDir,FileName);

% Load data file and display some info about the file
% Open data file
[nsresult, hFile] = ns_OpenFile(FullFileName);
if (nsresult ~= 0)
    disp('Data file did not open!');
    return
end
% % % % clear FileName;

% Get file information
[nsresult, FileInfo] = ns_GetFileInfo(hFile);
if (nsresult ~= 0)
    disp('Data file information did not load!');
    return
end

% Build catalogue of entities
[nsresult, EntityInfo] = ns_GetEntityInfo(hFile, 1:FileInfo.EntityCount);
Names    = getconfig(mfilename,'Names');
if(isempty(Names))
    Names    = '';
end

EntityLabels    = parseEntityLabel(EntityInfo,hFile,[1,2,4]);
[Names,EntityIDs]  = uiselect(EntityLabels,1,'Select Entities to be imported.',Names);
if(isempty(Names))
    disp('User pressed cancel.');
    return;
else
    setconfig(mfilename,'Names',Names)
end


% Locate output directory
OutputParent    = getconfig(mfilename,'OutputParent');
try
    if(~exist(OutputParent,'dir'))
        OutputParent    = pwd;
    end
catch
    OutputParent    = pwd;
end
OutputParent    = uigetdir(OutputParent,'Pick a Output Directory');
if(OutputParent==0)
    disp('User pressed cancel.');
    return;
else
    setconfig(mfilename,'OutputParent',OutputParent);
end




nfile   = length(FileNames);

for ifile=1:nfile
    FileName    = FileNames{ifile};
    FullFileName    = fullfile(InputDir,FileName);
    disp(FullFileName);
    
    % Load data file and display some info about the file
    % Open data file
    [nsresult, hFile] = ns_OpenFile(FullFileName);
    if (nsresult ~= 0)
        disp('Data file did not open!');
        return
    end
    % % % % clear FileName;
    
    % Get file information
    [nsresult, FileInfo] = ns_GetFileInfo(hFile);
    % Gives you EntityCount, TimeStampResolution and TimeSpan
    if (nsresult ~= 0)
        disp('Data file information did not load!');
        return
    end
    
    % Build catalogue of entities
    [nsresult, EntityInfo] = ns_GetEntityInfo(hFile, 1:FileInfo.EntityCount);
    EntityLabels    = parseEntityLabel(EntityInfo,hFile);
    
    % Recording parameters
    TimeRange   = [0 FileInfo.TimeSpan];    % seconds
    SampleRate  = 1/FileInfo.TimeStampResolution;
    
    
    
    nID = length(Names);
    for iID=1:nID
        ID      = strmatch(Names{iID},EntityLabels,'exact');
        if(~isempty(ID))
            Name    = EntityLabels{ID};
            S       = [];
            S.PlatForm  = 'cerebus';
            try
                if(EntityInfo(ID).EntityType==1)
                    disp([Name ': Event Entity'])
                    
                    [ns_RESULT, nsEventInfo] = ns_GetEventInfo(hFile, ID);
                    switch(nsEventInfo.EventType)
                        case 'ns_EVENT_WORD'
                            nCh     = 16;
                            nData   = EntityInfo(ID).ItemCount;
                            [ns_RESULT, TimeStamp, Data, DataSize] = ns_GetEventData(hFile, ID, 1:nData);
                            binData = false(nCh,nData);
                            for iData=1:nData
                                binData(:,iData)    = logical(dec2binvec(Data(iData),16));
                            end
                            
                            nXData      = (TimeRange(2)-TimeRange(1))*SampleRate;
                            XData        = (0:nXData)./SampleRate;
                            
                            diffbinData = [false(size(binData,1),1),binData];       % Assuming all DI channel started with low state (0V).
                            diffbinData = diff(diffbinData,[],2);
                            
                            for iCh=1:nCh
                                
                                S.Name          = [Name,num2str(iCh-1,'%.2d'),'-high'];
                                S.Data  = round(TimeStamp(diffbinData(iCh,:)==1)'*SampleRate);
                                
                                
                                S.SampleRate    = SampleRate;
                                S.Class         = 'timestamp channel';
                                S.TimeRange     = TimeRange;
                                
                                % Save Data
                                OutputDir       = deext(FileName);
                                FullOutputDir   = fullfile(OutputParent,OutputDir);
                                
                                if(~exist(FullOutputDir,'dir'))
                                    mkdir(FullOutputDir);
                                end
                                FullOutputFile  = fullfile(FullOutputDir,[S.Name,'.mat']);
                                save(FullOutputFile,'-struct','S');
                                disp(FullOutputFile);
                                
                                S.Name          = [Name,num2str(iCh-1,'%.2d'),'-low'];
                                S.Data  = round(TimeStamp(diffbinData(iCh,:)==-1)'*SampleRate);
                                
                                
                                S.SampleRate    = SampleRate;
                                S.Class         = 'timestamp channel';
                                S.TimeRange     = TimeRange;
                                
                                % Save Data
                                OutputDir       = deext(FileName);
                                FullOutputDir   = fullfile(OutputParent,OutputDir);
                                
                                if(~exist(FullOutputDir,'dir'))
                                    mkdir(FullOutputDir);
                                end
                                FullOutputFile  = fullfile(FullOutputDir,[S.Name,'.mat']);
                                save(FullOutputFile,'-struct','S');
                                disp(FullOutputFile);
                            end
                            
                    end
                    
                elseif(EntityInfo(ID).EntityType==2)
                    disp([Name ': Analog Entity'])
                    [ns_RESULT,Info] = ns_GetAnalogInfo(hFile,ID);
                    
                    S.Name          = Name;
                    S.Data          = [];
                    S.SampleRate    = Info.SampleRate;
                    S.Class         = 'continuous channel';
                    S.TimeRange     = TimeRange;        % seconds;
                    S.Unit          = Info.Units;
                    
                    
                    [ns_RESULT, ConCount, S.Data] = ns_GetAnalogData(hFile, ID, 1, EntityInfo(ID).ItemCount);
                    %         'Name','Data','SampleRate','Class','TimeRange')
                    if(ConCount~=EntityInfo(ID).ItemCount)
                        disp([Name, ': Some data may be missed!'])
                    end
                    S.Data  = S.Data';
                    
                    
                    % Save Data
                    OutputDir       = deext(FileName);
                    FullOutputDir   = fullfile(OutputParent,OutputDir);
                    
                    if(~exist(FullOutputDir,'dir'))
                        mkdir(FullOutputDir);
                    end
                    FullOutputFile  = fullfile(FullOutputDir,[S.Name,'.mat']);
                    save(FullOutputFile,'-struct','S');
                    disp(FullOutputFile);
                    
                elseif(EntityInfo(ID).EntityType==3)
                    disp([Name ': Segment Entity Under construction'])
                    keyboard
                elseif(EntityInfo(ID).EntityType==4)
                    disp([Name ': Neural Entity'])
                    [ns_RESULT, Data] = ns_GetNeuralData(hFile, ID, 1, EntityInfo(ID).ItemCount); % Data in time
                    S.Name          = Name;
                    S.Data          = round(Data*SampleRate)';
                    S.SampleRate    = SampleRate;
                    S.Class         = 'timestamp channel';
                    S.TimeRange     = TimeRange;        % seconds;
                    
                    % Save Data
                    OutputDir       = deext(FileName);
                    FullOutputDir   = fullfile(OutputParent,OutputDir);
                    
                    if(~exist(FullOutputDir,'dir'))
                        mkdir(FullOutputDir);
                    end
                    FullOutputFile  = fullfile(FullOutputDir,[S.Name,'.mat']);
                    save(FullOutputFile,'-struct','S');
                    disp(FullOutputFile);
                end
            catch
                disp(['***** error occurred in ', FullFileName,': ',Name])
                
            end
        end
    end
    
    
end
end


function Names  = parseEntityLabel(EntityInfo,hFile,UseTypes)

if(nargin<3)
    UseTypes    = [1,2,3,4];
end

Names   = strtok({EntityInfo.EntityLabel});
Types   = [EntityInfo.EntityType];
IDs     = 1:length(Names);
Names   = Names(ismember(Types,UseTypes));
IDs     = IDs(ismember(Types,UseTypes));
Types   = Types(ismember(Types,UseTypes));
nn      = length(Names);

for ii=1:nn
    if(Types(ii)==2)
        Names{ii}   = ['elec',Names{ii},'-cont'];
        %         Names{ii}   = ['elec',Names{ii}];
    elseif(Types(ii)==3)
        Names{ii}   = [Names{ii},'-segment'];
    elseif(Types(ii)==4)
        [ns_RESULT, nsNeuralInfo] = ns_GetNeuralInfo(hFile, IDs(ii));
        Names{ii}   = [Names{ii},'-unit',num2str(nsNeuralInfo.SourceUnitID)];
    end
end


end