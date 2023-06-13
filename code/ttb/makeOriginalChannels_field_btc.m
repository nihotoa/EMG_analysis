function makeOriginalChannels_field_btc(processID)
% processID=1:10


if(nargin<1)
    processID   = 0;
end

parentpath  = tgetdir('�edirectory��I�����Ă�������');
Expnames    = uiselect(dirdir(parentpath),[],'�ΏۂƂȂ�Exp��I�����Ă�������');

nExp    = length(Expnames);

for iExp    =1:nExp
    fullExpname     = fullfile(parentpath,Expnames{iExp});
    try
        makeOriginalChannels_field(fullExpname,processID);
        disp(['(',num2str(iExp),'/',num2str(nExp),')  ',fullExpname]);
    catch
        disp(['***** error occurred in ',fullExpname]);
    end
end