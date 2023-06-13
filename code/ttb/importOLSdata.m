function importOFSdata
SampleRate  = 30000;

pathname    = getconfig(mfilename,'pathname');
try
    if(~exist(pathname,'dir'))
        pathname    = pwd;
    end
catch
    pathname    = pwd;
end

filename    = getconfig(mfilename,'filename');
try
    if(isempty(filename))
        filename    = '*.txt';
    end
catch
    filename    = '*.txt';
end

fullfilename    = fullfile(pathname,filename);
[filename,pathname] = uigetfile(fullfilename);
if(filename==0)
    disp('User pressed cancel.')
    return;
else
    setconfig(mfilename,'pathname',pathname);
    setconfig(mfilename,'filename',filename);
end

fid = fopen(fullfilename,'r');
C   = textscan(fid,'%f%f','Delimiter',',');
UnitID      = C{1};
TimeStamp   = C{2};

UnitIDs     = unique(UnitID);
nIDs        = length(UnitIDs);
Name        = deext(filename);

for iID=1:nIDs
    S.PlatForm	= 'Plexon OFS';
    S.Name	= [Name,'-',num2str(iID,'%.2d')];
    S.Data    = round(TimeStamp*SampleRate);
    S.SampleRate	= SampleRate;
   S.Class    = 'timestamp channel';
    S.TimeRange= [0 TimeSamp(end)];
    
    fullfilename2   = fullfile(pathname,[S.Name,'.mat']);
    save(fullfilename2,'-struct','S')
    disp(fullfilename2);
end
