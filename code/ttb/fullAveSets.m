function fullAveSets

ParentPath  = uigetdir(datapath,'�e�t�H���_��I�����Ă�������');
ChildPath   = dirdir(ParentPath);

[AveSets,Avefilename]   = loadAveSets;

nSet    = size(AveSets,1);
for iSet =1:nSet
    