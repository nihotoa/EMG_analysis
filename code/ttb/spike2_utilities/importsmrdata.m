function importsmrdata(PrefixInDir_flag)
% IMPORTSMRDATA
%
% 

if(nargin<1)
    PrefixInDir_flag    = false;
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
        FileName    = '*.smr';
    end
catch
    FileName    = '*.smr';
end

[FileNames,InputDir] = uigetfile(fullfile(InputDir,FileName),'Import SMR files','MultiSelect','on');
if isequal(FileNames,0) || isequal(InputDir,0)
    disp('User pressed cancel.')
    return;
else
    setconfig(mfilename,'InputDir',InputDir);
    if(~iscell(FileNames))
        FileNames   = {FileNames};
    end
    setconfig(mfilename,'FileName',FileNames{1});
end


% Select 1st File to set parameters
FileName        = FileNames{1};
FullFileName    = fullfile(InputDir,FileName);

% Load data file and display some info about the file
% Open data file
hFile   = fopen(FullFileName);
if (hFile < 1)
    disp('Data file did not open!');
    return
end

% Get channel list
ChanList    = SONChanList(hFile);

fclose(hFile);

Names    = getconfig(mfilename,'Names');
if(isempty(Names))
    Names    = '';
end
[Names,ChanIDs]  = uiselect({ChanList.title},1,'Select channels to be imported.',Names);
if(isempty(Names))
    disp('User pressed cancel.')
    return;
else
    setconfig(mfilename,'Names',Names)
end

% Locate output directory
OutputParent    = getconfig(mfilename,'OutputParent');
if(isempty(OutputParent))
    OutputParent    = matpath;
elseif(~ischar(OutputParent))
    OutputParent    = matpath;
elseif(~exist(OutputParent,'dir'))
    OutputParent    = matpath;
end
OutputParent    = uigetdir(OutputParent,'Pick a Output Directory');
setconfig(mfilename,'OutputParent',OutputParent);





nfile   = length(FileNames);

for ifile=1:nfile
    FileName    = FileNames{ifile};
    FullFileName    = fullfile(InputDir,FileName);
    disp(FullFileName);
    
    % Load data file and display some info about the file
    % Open data file
    hFile   = fopen(FullFileName);
    if (hFile < 0)
        disp('Data file did not open!');
        return
    end
    % % % % clear FileName;
    
    % Get channel list
    ChanList    = SONChanList(hFile);
    
    
    nID = length(ChanIDs);
    for iID=1:nID
        ID      = ChanIDs(iID);
        Name    = ChanList(ID).title;
        S       = [];
        S.PlatForm  = 'spike2';
        try
            if(ChanList(ID).kind==0)
                
            elseif(ChanList(ID).kind==1)
                disp([Name ': ADC Channel'])
                                
                [data,header]=SONGetChannel(hFile, ChanList(ID).number,  'seconds', 'scale', 'progress');
                
                
                S.Name          = ChanList(ID).title;
                S.Data          = data';
                S.SampleRate    = (10^6)./header.sampleinterval;
                S.Class         = 'continuous channel';
                S.TimeRange     = [header.start, header.stop];        % seconds;
                S.Unit          = strtrim(header.units);
                
                
                % Save Data
                if(PrefixInDir_flag)
                    [temp,InDirName]   = fileparts(fileparts(InputDir));
                    OutputDir       = [InDirName,'_',deext(FileName)];
                else
                    OutputDir       = deext(FileName);
                end
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
    
    fclose(hFile);
    
    
end
end