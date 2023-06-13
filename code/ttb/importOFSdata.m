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
    elseif(iscell(filename))
        filename    = filename{1};
    end
catch
    filename    = '*.txt';
end

fullfilename    = fullfile(pathname,filename);
[filename,pathname] = uigetfile(fullfilename,'Multiselect','on');

if(~iscell(filename))
    if(filename==0)
        disp('User pressed cancel.')
        return;
    end
    filename    = {filename};
end
setconfig(mfilename,'pathname',pathname);
setconfig(mfilename,'filename',filename);

nfile   = length(filename);

for ifile=1:nfile
    
    fullfilename    = fullfile(pathname,filename{ifile});
    fid = fopen(fullfilename,'r');
    C   = textscan(fid,'%f%f','Delimiter',',');
    UnitID      = C{1};
    TimeStamp   = C{2};
    
    UnitIDs     = unique(UnitID);
    nIDs        = length(UnitIDs);
    Name        = deext(filename{ifile});
    
    for iID=1:nIDs
        S.PlatForm	= 'Plexon OFS';
        S.Name	= [Name,'-ofs',num2str(iID,'%d')];
        S.Data    = round(TimeStamp(UnitID==UnitIDs(iID))*SampleRate)';
        
        S.SampleRate	= SampleRate;
        S.Class    = 'timestamp channel';
        S.TimeRange= [0 TimeStamp(end)];
        
        fullfilename2   = fullfile(pathname,[S.Name,'.mat']);
        save(fullfilename2,'-struct','S')
        disp(fullfilename2);
    end
    
    fclose(fid);
end