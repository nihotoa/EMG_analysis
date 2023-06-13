function makeOriginalChannels_btc(processID)
% processID=1:10


if(nargin<1)
    processID   = 0;
end

parentpath  = getconfig(mfilename,'parentpath');
try
    if(~exist(parentpath,'dir'))
        parentpath  = pwd;
    end
catch
    parentpath  = pwd;
end
parentpath  = uigetdir(parentpath,'edirectory‚ð‘I‘ð‚µ‚Ä‚­‚¾‚³‚¢');
if(parentpath==0)
    disp('User pressed cancel.');
    return;
else
    setconfig(mfilename,'parentpath',parentpath);
end

Expnames    = uiselect(dirdir(parentpath),[],'‘ÎÛ‚Æ‚È‚éExp‚ð‘I‘ð‚µ‚Ä‚­‚¾‚³‚¢');

nExp    = length(Expnames);

for iExp    =1:nExp
    fullExpname     = fullfile(parentpath,Expnames{iExp});
    try
        makeOriginalChannels(fullExpname,processID);
        disp(['(',num2str(iExp),'/',num2str(nExp),')  ',fullExpname]);
    catch
        disp(['***** error occurred in ',fullExpname]);
    end
end