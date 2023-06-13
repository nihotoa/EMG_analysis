function [files,parentdir]  = uigetallfile(varargin)

if nargin<1
parentdir	= uigetdir;
else
    parentdir	= uigetdir(varargin{:});
end
A   = what(parentdir);

for ii=1:length(A.mat)
    files{ii}   = fullfile(A.path,A.mat{ii});
end
    