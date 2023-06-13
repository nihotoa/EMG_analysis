function makeInvalidIntervalChannel

pathname    = getconfig(mfilename,'pathname');
filename    = getconfig(mfilename,'filename');

if(any([isempty(pathname),isempty(filename)]))
    [s,f]   = topen('Select original interval channel');
    [pathname,filename,ext] = fileparts(f);
    filename    = [filename,ext];
else
    fullfilename        = fullfile(pathname,filename);
    [filename,pathname] = uigetfile(fullfilename);
    fullfilename        = fullfile(pathname,filename);
    s   = load(fullfilename);
end
setconfig(mfilename,'pathname',pathname);
setconfig(mfilename,'filename',filename);


nint    = size(s.Data,2);
allint  = cell(1,nint);

for iint=1:nint
    allint{iint}    = [num2str(iint),': [',num2str(s.Data(1,iint)),',',num2str(s.Data(2,iint)),']'];
end

[sint,ind]  = uiselect(allint,1,'Select Invalid Intervals');
if(isempty(sint))
        disp('User Pressed Cancel')
        return;
end

s.Data  = s.Data(:,ind);
YN  = questdlg(sint, ...
    'TimeWindows',...
    'OK','Cancel','OK');

switch YN
    case 'OK'
        fullfilename    = fullfile(pathname,'Invalid Interval.mat');
        if(exist(fullfilename,'file')) % append previous file
            ss  = load(fullfilename);
            s.Data= union(ss.Data',s.Data','rows')';
        end
        save(fullfilename,'-struct','s');
        disp(fullfilename)
    otherwise
        disp('User Pressed Cancel')
        return;
end
end
