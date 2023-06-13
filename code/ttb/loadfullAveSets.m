function [fullfilenames,Avefilename,ParentPath]  = loadfullAveSets


[AveSets,Avefilename]   = loadAveSets;

ParentPath  = uigetdir(datapath,'データを探す親フォルダを選択してください');
ChildPaths  = dirdir(ParentPath);



nSet    = size(AveSets,1);
fullfilenames   = cell(nSet,1);
for iSet =1:nSet
    
    ExpSetName  = AveSets{iSet,1};
    EMGName     = AveSets{iSet,2};
    
    hypenind    = strfind(ExpSetName,'-');
    prefix      = ExpSetName(1:hypenind-4);
    
    iChildPath  = strmatch(prefix,ChildPaths);
    ChildPath   = ChildPaths{iChildPath};

    FileNames   = dirmat(fullfile(ParentPath,ChildPath,ExpSetName));
    FileName    = strfilt(FileNames,EMGName);
    FileName    = FileName{:};
    
    fullfilenames{iSet} = fullfile(ParentPath,ChildPath,ExpSetName,FileName);
end
    
    