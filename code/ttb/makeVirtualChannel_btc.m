function makeVirtualChannel_btc



parentpath  = getconfig(mfilename,'parentpath');
try
    if(~exist(parentpath,'dir'))
        parentpath  = pwd;
    end
catch
    parentpath  = pwd;
end
parentpath  = uigetdir(parentpath,'親directoryを選択してください');
if(parentpath==0)
    disp('User pressed cancel.');
    return;
else
    setconfig(mfilename,'parentpath',parentpath);
end

Expnames    = uiselect(dirdir(parentpath),[],'対象となるExpを選択してください');

nExp    = length(Expnames);

for iExp    =1:nExp
    fullExpname     = fullfile(parentpath,Expnames{iExp});
    try
        makeVirtualChannel(fullExpname);
        disp(['(',num2str(iExp),'/',num2str(nExp),')  ',fullExpname]);
    catch
        disp(['***** error occurred in ',fullExpname]);
    end
end