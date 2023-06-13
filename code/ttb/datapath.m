function pathname   = datapath(command)
% 
% pathname   = datapath(command)
% 
% pathname   = datapath
% pathname   = datapath('get')
% pathname   = datapath('set')

if(nargin<1)
    command = 'get';
end

switch command
    case 'get'
        pathname    = getconfig(mfilename,'pathname');
        
        if(isempty(pathname))
            pathname    = uigetdir(pwd,'Select a ''datapath''.');
            setconfig(mfilename,'pathname',pathname);
        end
    case 'set'
        pathname    = uigetdir(pwd,'Select a ''datapath''.');
        setconfig(mfilename,'pathname',pathname);
end