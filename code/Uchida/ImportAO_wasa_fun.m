function ImportAO_wasa_fun(monkeyname, xpdate,whichfiles, sessionnumber, whichfilt, snippet, importevents, importEMG, filterEMG, importSpikes, importHP, importRAW, shiftwaveform,selEMGs)

% function to import the data from AO

year=xpdate(1:2) ;
month=xpdate(3:4) ;
day=xpdate(5:6) ;
parentdirectory='/Users/uchida/Documents/MATLAB/data/Wasa/'; %'N:\document\Roland\MozData\';%'N:\data\Recording_data\Mozuku\EMG Roland\';%'C:\Users\joachim\Documents\MATLAB\test setup\data\' ;
savepath= [parentdirectory monkeyname year month day '_' sessionnumber '\'];

% import only a given period (in second, relative to the beginning of
% session). to import all, leave empty.
% snippet=[];

% digital events
% importevents=1 ;

% EMG data
% importEMG=1 ;
% filterEMG=1 ;
% selEMGs=1:24 ; % which EMG channels to import and filter
% whichfilt='1000Hz' ; % '1000Hz' or 'half'

%raw neuronal signal
% importRAW=0 ;

% spike data
% importSpikes=0 ;
%%

mkdir(parentdirectory, [monkeyname year month day '_' sessionnumber]) ;

if importevents==1
    disp('importing digital events') ;
    ExtractAOevents_Wasa(monkeyname, year, month, day, whichfiles, sessionnumber, savepath, snippet) ;
    disp('done') ;
end

if importEMG==1
    disp(['importing EMG data (channel list: ' int2str(selEMGs) ')']);
    ExtractAOEMG_Wasa(monkeyname, year, month, day, whichfiles, sessionnumber, savepath, selEMGs,snippet) ;
    disp('done')
end

if filterEMG==1
    disp('filtering EMG data')
    if ~iscell(whichfilt)
        whichfilt={whichfilt} ;
    end
    for i=1:length(whichfilt)
        filterEMG_loop(monkeyname, year, month, day, sessionnumber, savepath,selEMGs,whichfilt{i});
    end
    disp('done')
end

if importHP==1 % import HighPass continuous data ?
    try
        ExtractAOHP_fast(monkeyname, year, month, day, whichfiles, sessionnumber, savepath, snippet) ;
        
        % if Matlab runs out of memory because the file is too big, call a version
        % of the program that save, close and reload every channel
        % independantly. very slow but memory-effective
    catch err
        if strcmp(err.identifier,'Out of memory. Type HELP MEMORY for your options.')
            %             ExtractAORAW(monkeyname, year, month, day, whichfiles, sessionnumber, savepath, snippet) ;
        end
    end
end

if importRAW==1
    try
        ExtractAORAW_fast(monkeyname, year, month, day, whichfiles, sessionnumber, savepath, snippet) ;
        
        % if Matlab runs out of memory because the file is too big, call a version
        % of the program that save, close and reload every channel
        % independantly. very slow but memory-effective
    catch err
        if strcmp(err.identifier,'Out of memory. Type HELP MEMORY for your options.')
            ExtractAORAW(monkeyname, year, month, day, whichfiles, sessionnumber, savepath, snippet) ;
        end
    end
end

if importSpikes==1 % if 1, take spikes from AO
    disp('Importing spike data from AlphaOmega')
    ExtractAOSpikes(monkeyname, year, month, day, whichfiles, sessionnumber, savepath, snippet) ;
    disp('done')
elseif importSpikes==2 % if 2, take spikes from Offline Sorter
    disp('Importing spike data from Offline Sorter')
    ExtractOFSSpikes2(monkeyname, xpdate, whichfiles, sessionnumber, savepath, snippet) ;
    disp('done')
end

addpath(savepath)

if shiftwaveform
    ShiftSpikeTim_fun(monkeyname, xpdate,sessionnumber, parentdirectory) ;
elseif importSpikes==2
    SpikesAlignedHighPass_fun(monkeyname, xpdate,sessionnumber) ;
end


