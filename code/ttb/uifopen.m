function varargout  = uifopen(varargin)

[filename, parentname]  = uigetfile('*.*');
if nargin > 1
    fid = fopen(fullfile(parentname,filename),varargin);
else
    fid = fopen(fullfile(parentname,filename));
end

if nargout < 2
    varargout{1}    = fid;
else
    varargout{1}    = fid;
    varargout{2}    = filename;
end