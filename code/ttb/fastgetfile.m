function [filename,pathname]    = fastgetfile(varargin)


[ST,I] = dbstack;
currfilename    = ST(I).name;
if(length(ST)>1)
    parentfilename    = ST(I+1).name;
else
    parentfilename    = [];
end


filename    = getconfig(currfilename,[parentfilename,'filename']);
if(isempty(filename))
    filename    = '*.*';
end

pathname    = getconfig(currfilename,[parentfilename,'pathname']);
if(isempty(pathname))
    pathname    = '*.*';
end

if(nargin>0)
    [filename,pathname] = uigetfile(fullfile(pathname,filename),varargin{:});
else
    [filename,pathname] = uigetfile(fullfile(pathname,filename));
end

setconfig(currfilename,[parentfilename,'filename'],filename);
setconfig(currfilename,[parentfilename,'pathname'],pathname);

