function installttb

% ttbpath
pathname    = mfilename('fullpath');
pathname    = fileparts(pathname);
disp(['ttbpath:    ', pathname]);

% add ttb path



% get datapath
pathname    = datapath;
if(~exist(pathname,'dir'))
    pathname    = datapath(set);
end
disp(['datapath:   ', pathname]);

% get matpath
pathname    = matpath;
if(~exist(pathname,'dir'))
    pathname    = datapath(set);
end
disp(['matpath:    ', pathname]);


% Complete
disp(' ')
disp('TTB was successfully installed.')

