function varargout  = uianova1xls(ngroups)
% uianova1xls:  対応のない１元配置のANOVA (ex)uianova1xls(3)

if(nargin<1)
    ngroups = 8;
end


%     Listfilename        = uigetfullfile('*.xls','Experiment Excelファイルを選択してください。');
%     [temp1,temp2,List]  = xlsread(Listfilename,-1);  % Unit-EMG pair Name
variableNames   = cell(1,2*ngroups);
gnames          = cell(1,ngroups);
data            = cell(1,ngroups);
Group           = cell(1,ngroups);
addflag         = false(1,ngroups);
for igroup=1:ngroups
    variableNames{igroup*2-1}   = ['Name',num2str(igroup)];
    variableNames{igroup*2}     = ['Data',num2str(igroup)];
end

xlsload(-1,'VarName',variableNames{:});
keyboard
for igroup=1:ngroups
    eval(['gnames{igroup}   = num2str(Name',num2str(igroup),');']);
    eval(['data{igroup}     = shiftdim(Data',num2str(igroup),');']);
    addflag(igroup) = ~isempty(gnames{igroup}) & ~isempty(data{igroup});
end

gnames  = gnames(addflag);
data    = data(addflag);
ngroups = length(gnames);


means   = zeros(1,ngroups);
stds    = zeros(1,ngroups);

for igroup=1:ngroups
    Group{igroup}   = ones(size(data{igroup}))*igroup;
    means(igroup)   = mean(data{igroup});
    stds(igroup)   = std(data{igroup});
end

X       = cat(1,data{:});
Group   = cat(1,Group{:});


Y.AnalysisType  = 'ANOVA1';
Y.VarName   = VarName;
Y.gnames    = gnames;
Y.Data      = X;
Y.mean      = means;
Y.std       = stds;
Y.Group     = Group;
Y.alpha     = 0.05;
Y.ctype     = 'bonferroni';
% Y.reps  = 1;
dispopt     = 'off';

% kruskalwallis
[Y.kruskalwallis.p,Y.kruskalwallis.table,Y.kruskalwallis.stats]     = kruskalwallis(Y.Data,Y.Group,dispopt);
[Y.kruskalwallis.multcompare.comparison,Y.kruskalwallis.means,Y.kruskalwallis.h,Y.kruskalwallis.gnames] = multcompare(Y.kruskalwallis.stats,...
    'alpha',Y.alpha,...
    'display','off',...
    'ctype',Y.ctype);
ncomp   = size(Y.kruskalwallis.multcompare.comparison,1);
Y.kruskalwallis.multcompare.alpha  = Y.alpha ./ ncomp;  % Bonferroni's correction
Y.kruskalwallis.multcompare.alpha_corrected  = Y.alpha;
Y.kruskalwallis.multcompare.p      = zeros(ncomp,1);
Y.kruskalwallis.multcompare.p_corrected      = zeros(ncomp,1);
Y.kruskalwallis.multcompare.issig  = false(ncomp,1);
for icomp=1:ncomp
    [Y.kruskalwallis.multcompare.p(icomp),Y.kruskalwallis.multcompare.issig(icomp)]   = ranksum(Y.Data(Y.Group==Y.kruskalwallis.multcompare.comparison(icomp,1)),...
        Y.Data(Y.Group==Y.kruskalwallis.multcompare.comparison(icomp,2)),...
        'alpha',Y.kruskalwallis.multcompare.alpha); % ,...'method','exact'
end
Y.kruskalwallis.multcompare.p_corrected = min(Y.kruskalwallis.multcompare.p * ncomp,1);
% Y.kruskalwallis.multcompare.issig2   = (0 < Y.kruskalwallis.multcompare.comparison(:,3) | Y.kruskalwallis.multcompare.comparison(:,5) < 0);
Y.kruskalwallis.gnames  = gnames;

% anova1
[Y.anova1.p,Y.anova1.table,Y.anova1.stats] = anova1(Y.Data,Y.Group,dispopt);
[Y.anova1.multcompare.comparison,Y.anova1.means,Y.anova1.h,Y.anova1.gnames] = multcompare(Y.anova1.stats,...
    'alpha',Y.alpha,...
    'display','off',...
    'ctype',Y.ctype);
ncomp   = size(Y.anova1.multcompare.comparison,1);
Y.anova1.multcompare.alpha  = Y.alpha ./ ncomp;  % Bonferroni's correction
Y.anova1.multcompare.alpha_corrected    = Y.alpha;
Y.anova1.multcompare.p      = zeros(ncomp,1);
Y.anova1.multcompare.p_corrected      = zeros(ncomp,1);
Y.anova1.multcompare.issig  = false(ncomp,1);
for icomp=1:ncomp
    [Y.anova1.multcompare.issig(icomp),Y.anova1.multcompare.p(icomp)]   = ttest2(Y.Data(Y.Group==Y.anova1.multcompare.comparison(icomp,1)),...
        Y.Data(Y.Group==Y.anova1.multcompare.comparison(icomp,2)),...
        Y.anova1.multcompare.alpha,...
        'both','equal');
end
Y.anova1.multcompare.p_corrected = min(Y.anova1.multcompare.p * ncomp,1);
% Y.anova1.multcompare.issig2 = (0 < Y.anova1.multcompare.comparison(:,3) | Y.anova1.multcompare.comparison(:,5) < 0);

if(nargout==1)
    varargout{1}    = Y;
else

OutFileName = ['ANOVA1(',VarName,';'];
for igroup =1:ngroups
    OutFileName = [OutFileName,gnames{igroup},','];
end
OutFileName(end)    = [];
OutFileName         = [OutFileName,')'];



% OutputDir   = uigetdir(fullfile(datapath,'ANOVA1'),'出力先フォルダを選択してください。');
[OutFileName,OutputDir]  = uiputfile(fullfile(datapath,'ANOVA1',[OutFileName,'.mat']),'ファイルの保存');

OutFullfileName     = fullfile(OutputDir,OutFileName);

save(OutFullfileName,'-struct','Y');
disp(OutFullfileName)
end