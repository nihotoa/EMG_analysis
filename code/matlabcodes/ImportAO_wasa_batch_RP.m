clear all
tic
addpath C:\Data
monkeyname = 'Wa' ; 

cd C:\Data\Wasa 
a=dir('Wa*.mat');
b={a.name};

for i=1:length(b)
c{1,i}=b{1,i}(1:8);
end
c = unique(c);

%  c = [c(115:116)];
% 
test=char(b);
testtest=char(c);

for j=1%:length(testtest)
    filenum = find(strncmp(b,testtest(j,1:8),8));
    begin = filenum(1);
    ends = filenum(end);
    
    whichfile = [];
for k=begin:ends
whichfile = [whichfile str2num(test(k,12:13))];
end

start = test(begin,12:13);
stop  = test(ends,12:13);

xpdate = '180928' %testtest(j,3:8) % yymmdd   xpdate='150604' ; %

whichfiles = [2:4];%[str2num(start) : str2num(stop)]; % whichfile; %2:3%2;%
sessionnumber='1' ; % for output file
whichfilt = 'bandpass' ;
snippet =[] ;       % to import only a given period (in second, relative to the beginning of session). to import all, leave empty.
importevents = 1 ;   % import digital events
importEMG = 1 ;      % import EMG
filterEMG= 1 ;       % filter EMG and downsample, either at 5500Hz (whichfilt=='bandpass') or at 1000Hz (whichfilt=='1000Hz')
importSpikes =0;    % import spike TTLs and waveforms. 1== from AO, 2== from Offline Sorter 
importHP=0;         % import high-pass filtered neuronal continuous data
importRAW=0;
shiftwaveform=0 ;   % check the waveform of spikes and shift it a bit if needed
selEMGs=[1:14];%24] ; % which EMG channels will be imported and/or filtered (channels are numbered according to the output file, not the AO original channel ID)

% ImportAO_mata_fun(monkeyname, xpdate,whichfiles, sessionnumber, whichfilt, snippet, importevents, importEMG, filterEMG, importSpikes, importHP,shiftwaveform,selEMGs)
ImportAO_wasa_fun(monkeyname, xpdate,whichfiles, sessionnumber, whichfilt, snippet, importevents, importEMG, filterEMG, importSpikes, importHP,importRAW, shiftwaveform,selEMGs)

clear start stop xpdate whichfiles 
end

toc