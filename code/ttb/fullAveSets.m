function fullAveSets

ParentPath  = uigetdir(datapath,'親フォルダを選択してください');
ChildPath   = dirdir(ParentPath);

[AveSets,Avefilename]   = loadAveSets;

nSet    = size(AveSets,1);
for iSet =1:nSet
    