function makeExperimentSet

Y.Name  = [];
Y.Class = 'experiment set';
Y.Data  = [];

ParentDir   = uigetdir(matpath,'Experimentの親フォルダを選択してください。');
Y.Data      = sortxls(dirdir(ParentDir));
Y.Data      = uiselect(Y.Data,1,'ExperimentSetとするExperimentを選択してください。');

OutputDir   = fullfile(datapath,'ExperimentSets');
Outputfile  = 'new experiment set.mat';

[Outputfile, OutputDir] = uiputfile(fullfile(OutputDir,Outputfile),'出力(ExperimentSets)フォルダを選択してください。');
Y.Name  = deext(Outputfile);

Outputfullfile  = fullfile(OutputDir,Outputfile);
save(Outputfullfile,'-struct','Y');
disp([Outputfullfile,' was created.'])
