function y  = tgetdir(varargin)
% [S,fullfilename]  = topen(dlgtitle)
% written by TT


lastdir = getconfig(mfilename,'lastdir');

try
    if(~exist(lastdir,'dir'))
        lastdir = pwd;
    end
catch
    lastdir = pwd;
end

if nargin < 1
    y   = uigetdir(lastdir);
else
    y   = uigetdir(lastdir,varargin{:});
end
if isequal(y,0)
    disp('User pressed cancel')
    y   =[];
    return;
end



setconfig(mfilename,'lastdir',y)
end
