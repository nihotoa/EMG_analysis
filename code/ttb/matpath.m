function pathname   = matpath(command)
% 
% pathname   = matpath(command)
% 
% pathname   = matpath
% pathname   = matpath('get')
% pathname   = matpath('set')

if(nargin<1)
    command = 'get';
end

switch command
    case 'get'
        pathname    = getconfig(mfilename,'pathname');
        
        if(isempty(pathname))
            pathname    = uigetdir(pwd,'Select a ''matpath''.');
            setconfig(mfilename,'pathname',pathname);
        end
    case 'set'
        pathname    = uigetdir(pwd,'Select a ''matpath''.');
        setconfig(mfilename,'pathname',pathname);
end