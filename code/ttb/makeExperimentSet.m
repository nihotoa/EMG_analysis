function makeExperimentSet

Y.Name  = [];
Y.Class = 'experiment set';
Y.Data  = [];

ParentDir   = uigetdir(matpath,'Experiment�̐e�t�H���_��I�����Ă��������B');
Y.Data      = sortxls(dirdir(ParentDir));
Y.Data      = uiselect(Y.Data,1,'ExperimentSet�Ƃ���Experiment��I�����Ă��������B');

OutputDir   = fullfile(datapath,'ExperimentSets');
Outputfile  = 'new experiment set.mat';

[Outputfile, OutputDir] = uiputfile(fullfile(OutputDir,Outputfile),'�o��(ExperimentSets)�t�H���_��I�����Ă��������B');
Y.Name  = deext(Outputfile);

Outputfullfile  = fullfile(OutputDir,Outputfile);
save(Outputfullfile,'-struct','Y');
disp([Outputfullfile,' was created.'])
