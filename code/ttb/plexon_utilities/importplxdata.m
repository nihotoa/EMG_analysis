function importplxdata
% IMPORTPLXDATA
% 
% Import plexon data (ad,event)
% 
% To import data, just run this script and follow steps below.    
%  1) select .plx file(s).
%  2) choose 'spike', 'ad' and 'event' channels to be imported.
%  3) select output folder
%  
% After these steps, script automatically save files which organized as 
% "ORIGINALFILENAMES/CHANNELNAME.mat" under the output folder specified in Step3.
% 
% 
% written by Tomohiko Takei 2010/12/02
% modified by Tomomichi Oya 2011/01/18
% modified by Tomomichi Oya 2012/01/26 
% modified by Tomomichi Oya 2012/04/09 --all spike units can be imported
% a new Plexon CDK to be installed for this version, as of 2012/04 


% Find out the data file(s)
InputDir    = getconfig(mfilename,'InputDir');
if(isempty(InputDir))
    InputDir    = pwd;
end
FileName    = getconfig(mfilename,'FileName');
if(isempty(FileName))
    FileName    = '*.plx';
end
[FileNames,InputDir] = uigetfile(fullfile(InputDir,FileName),'Import plx file(s)','MultiSelect','on');
if isequal(FileNames,0) || isequal(InputDir,0)
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

%spike list acquisition
% get some counts
[tscounts, wfcounts, evcounts, slowcounts] = plx_info(FullFileName,1);
%activeSPUnits = nnz(tscounts);

% get the num of active SP chans. first arg can be any num up to size of tscounts (e.g. 1-17)
activeSPChans = length(find(tscounts(2,:)));

% tscounts, wfcounts are indexed by (unit+1,channel+1)
% tscounts(:,ch+1) is the per-unit counts for channel ch
% sum( tscounts(:,ch+1) ) is the total wfs for channel ch (all units)
 [nunits, nchannels] = size( tscounts );
% To get number of nonzero units/channels, use nnz() function

% gives actual number of units (including unsorted) and actual number of
% channels plus 1
%[unitIndex, chanIndex] = find(tscounts);   

% we will read in the timestamps of all units,channels into a two-dim cell
% array named allts, with each cell containing the timestamps for a unit,channel.
% Note that allts second dim is indexed by the 1-based channel number.
% preallocate for speed

% allts = cell(size([nunits nchannels]));
% activeSPList = [];

% for iunit = 0:nunits-1   % starting with unit 0 (unsorted) 
%     for ich = 1:nchannels-1
%         if ( tscounts( iunit+1 , ich+1 ) > 0 )
%             % get the timestamps for this channel and unit 
%         %    [nts, allts{iunit+1,ich}] = plx_ts(FullFileName, ich , iunit );
%         activeSPList= [activeSPList; ich iunit];  % spike list generated 
%         %UnitList= [UnitList; strcat(num2str(ich), (char(96+iunit)))];% '`'- for unsorted, 'a' for unit 1, 'b' for unit 1 and so on. 
%         end
%         
%     end
% end
SPList = [];
UnitList = [];
if (activeSPChans > 0)
    for ich = 1:activeSPChans
        for iunit = 0:3 % from unsorted unit to third (c) unit. if one wants to retrieve more units, change the ceiling num
        SPList= [SPList; ich iunit];  % spike list generated 
        UnitList= [UnitList; strcat(num2str(ich), (char(96+iunit)))];% '`'- for unsorted, 'a' for unit 1, 'b' for unit 1 and so on. 
        end
    end
else
    for ich = 1:1
        for iunit = 0:3 % from unsorted unit to third (c) unit. if one wants to retrieve more units, change the ceiling num
        SPList= [SPList; ich iunit];  % spike list generated 
        UnitList= [UnitList; strcat(num2str(ich), (char(96+iunit)))];% '`'- for unsorted, 'a' for unit 1, 'b' for unit 1 and so on. 
        end
    end
end
% Build catalogue of entities
%[SPChIDs,SPNames]  = plx_chan_names(FullFileName);
SPChIDs = length(SPList); SPNames = UnitList;

[ADChIDs,ADNames]  = plx_adchan_names(FullFileName);
[EVChIDs,EVNames]  = plx_event_names(FullFileName);

SPChIDs = (1:SPChIDs)';
ADChIDs     = (0:ADChIDs-1)'; % to match channel assignment between C-hub and NI ad converter by Oya 26012012 
EVChIDs     = (1:EVChIDs)';
try
SPNames = cellstr(SPNames);
catch
end
ADNames     = cellstr(ADNames);
EVNames     = cellstr(EVNames);
if (~isempty(SPNames))
AllNames = [SPNames;ADNames;EVNames];
else
AllNames = [ADNames;EVNames];
    
end;
%AllNames    = [ADNames;EVNames];

Names    = getconfig(mfilename,'Names');
if(isempty(Names))
    Names    = '';
end
[Names,ChIDs]  = uiselect(AllNames,1,'Select Entities to be imported.',Names);
if(isempty(Names))
    return;
end
setconfig(mfilename,'Names',Names)

SPChInd = ismember(SPNames, Names);
ADChInd     = ismember(ADNames,Names);
EVChInd     = ismember(EVNames,Names);
SPChIDs = SPChIDs(SPChInd);
ADChIDs     = ADChIDs(ADChInd);
EVChIDs     = EVChIDs(EVChInd);
SPNames = SPNames(SPChInd);
ADNames     = ADNames(ADChInd);
EVNames     = EVNames(EVChInd);


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
    FileName        = FileNames{ifile};
    FullFileName    = fullfile(InputDir,FileName);
    disp(FullFileName);
    
%change 8 Load and Save Spike channels
    if(~isempty(SPNames))
        [OpenedFileName, Version, Freq, Comment, Trodalness, NPW, PreTresh, SpikePeakV, SpikeADResBits, SlowPeakV, SlowADResBits, Duration, DateTime] = plx_information(FullFileName);
        nID = length(SPChIDs);
        for iID=1:nID
            ID      = SPChIDs(iID);
            Name    = SPNames{iID};
            
            try
               
                [n, ts] = plx_ts(FullFileName, SPList(ID,1),SPList(ID,2)); % 
               
                data   = round(ts * Freq)';

                S.Name          = Name;
                S.Data          = data;
                S.SampleRate    = Freq;
                S.Class         = 'timestamp channel';
                S.TimeRange     = [0 Duration];
                 
                 
                % Save Data
                OutputDir       = deext(FileName);
                FullOutputDir   = fullfile(OutputParent,OutputDir);
                
                if(~exist(FullOutputDir,'dir'))
                    mkdir(FullOutputDir);
                end
                FullOutputFile  = fullfile(FullOutputDir,[S.Name,'.mat']);
                save(FullOutputFile,'-struct','S');
                disp(FullOutputFile);
            catch
                disp(['***** error occurred in ', FullFileName,': ',Name])
                
            end
            
        end
    end
      
    
    % Load and Save AD channels
    if(~isempty(ADNames))
        nID = length(ADChIDs);
        for iID=1:nID
            ID      = ADChIDs(iID);
            Name    = ADNames{iID};
            
            try
                [adfreq,n,ts,fn,data] = plx_ad(FullFileName, ID);
                
                
                TimeRange   = [0 n/adfreq] + ts;
                
                
                S.Name  = Name;
                S.Data  = data';
                S.SampleRate    = adfreq;
                S.Class = 'continuous channel';
                S.TimeRange = TimeRange;
                S.Unit  = 'mV';
                
                
                % Save Data
                OutputDir       = deext(FileName);
                FullOutputDir   = fullfile(OutputParent,OutputDir);
                
                if(~exist(FullOutputDir,'dir'))
                    mkdir(FullOutputDir);
                end
                FullOutputFile  = fullfile(FullOutputDir,[S.Name,'.mat']);
                save(FullOutputFile,'-struct','S');
                disp(FullOutputFile);
            catch
                disp(['***** error occurred in ', FullFileName,': ',Name])
                
            end
            
        end
    end
    
    % Load and Save EV channels
    if(~isempty(EVNames))
        [OpenedFileName, Version, Freq, Comment, Trodalness, NPW, PreTresh, SpikePeakV, SpikeADResBits, SlowPeakV, SlowADResBits, Duration, DateTime] = plx_information(FullFileName);
        
        nID = length(EVChIDs);
        for iID=1:nID
            ID      = EVChIDs(iID);
            Name    = EVNames{iID};
            
            try
                [n, ts, sv] = plx_event_ts(FullFileName, ID);
                
                data   = round(ts * Freq)';
                
                
                S.Name          = Name;
                S.Data          = data;
                S.SampleRate    = Freq;
                S.Class         = 'timestamp channel';
                S.TimeRange     = [0 Duration];
                
                
                % Save Data
                OutputDir       = deext(FileName);
                FullOutputDir   = fullfile(OutputParent,OutputDir);
                
                if(~exist(FullOutputDir,'dir'))
                    mkdir(FullOutputDir);
                end
                FullOutputFile  = fullfile(FullOutputDir,[S.Name,'.mat']);
                save(FullOutputFile,'-struct','S');
                disp(FullOutputFile);
            catch
                disp(['***** error occurred in ', FullFileName,': ',Name])
                
            end
            
        end
    end
    
    
end



