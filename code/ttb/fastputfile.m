function [filename,pathname]    = fastputfile(varargin)


[ST,I] = dbstack;
currfilename    = ST(I).name;
if(length(ST)>1)
    parentfilename    = ST(I+1).name;
else
    parentfilename    = [];
end

keyboard


filename    = getconfig(currfilename,[parentfilename,'filename']);
if(isempty(filename))
    filename    = '*.*';
end

pathname    = getconfig(currfilename,[parentfilename,'pathname']);
if(isempty(pathname))
    pathname    = '*.*';
end

if(nargin>0)
    [filename,pathname] = uiputfile(fullfile(pathname,filename),varargin{:});
else
    [filename,pathname] = uiputfile(fullfile(pathname,filename));
end
    

setconfig(currfilename,[parentfilename,'filename'],filename);
setconfig(currfilename,[parentfilename,'pathname'],pathname);
