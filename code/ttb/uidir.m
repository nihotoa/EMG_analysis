function dirs   = uidir(varargin);
if nargin<1
    dname = uigetdir;
else
    dname = uigetdir(varargin);
end

dirs    = dir(dname);