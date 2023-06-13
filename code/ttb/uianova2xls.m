function uianova2xls
% uianova2xls:  対応のない2元配置のANOVA (ex)uianova2xls

% if(nargin<1)
%     ngroups = 8;
% end


%     Listfilename        = uigetfullfile('*.xls','Experiment Excelファイルを選択してください。');
%     [temp1,temp2,List]  = xlsread(Listfilename,-1);  % Unit-EMG pair Name

xlsload(-1,'VarName','VarData','CondName1','CondData1','CondName2','CondData2');

CondLabel1  = sortxls(unique(CondData1));
CondLabel2  = sortxls(unique(CondData2));

temp1  = '{';
for iLabel=1:length(CondLabel1)
    temp1  = [temp1,' ''',CondLabel1{iLabel},''''];
end
temp1  = [temp1,' }'];

temp2  = '{';
for iLabel=1:length(CondLabel2)
    temp2  = [temp2,' ''',CondLabel2{iLabel},''''];
end
temp2  = [temp2,' }'];


temp    = inputdlg({'CondLabel1:','CondLabel2'},'ラベル',1,{temp1,temp2});
CondLabel1  = eval([temp{1},';']);
CondLabel2  = eval([temp{2},';']);

nLabel1 = length(CondLabel1);
nLabel2 = length(CondLabel2);

CondDataInd1   = zeros(size(CondData1));
CondDataInd2   = zeros(size(CondData2));

for iLabel=1:nLabel1
    CondDataInd1(strcmp(CondData1,CondLabel1{iLabel}))   = iLabel;
end
for iLabel=1:nLabel2
    CondDataInd2(strcmp(CondData2,CondLabel2{iLabel}))   = iLabel;
end


[p,atab,stats]    = anovan(VarData,{CondDataInd1 CondDataInd2},'model','full','sstype',2,'varnames',{CondName1,CondName2},'display','off');

Y.AnalysisType  = 'ANOVA2';
Y.VarName   = VarName;
Y.condnames = {CondName1, CondName2};
Y.gnames1   = CondLabel1;
Y.gnames2   = CondLabel2;

Y.Data      = VarData;
Y.mean      = [];
Y.std       = [];
Y.Group1    = CondData1;
Y.Group2    = CondData2;
Y.GroupInd1 = CondDataInd1;
Y.GroupInd2 = CondDataInd2;
Y.alpha     = 0.05;
Y.ctype     = 'bonferroni';
Y.anova2.p      = p;
Y.anova2.table  = atab;
Y.anova2.stats  = stats;


ncond1  = length(Y.gnames1);
ncond2  = length(Y.gnames2);

Y.mean  = zeros(ncond1,ncond2);
Y.std   = zeros(ncond1,ncond2);


for icond1=1:ncond1
    for icond2=1:ncond2
        ind = strcmp(CondData1,Y.gnames1{icond1}) & strcmp(CondData2,Y.gnames2{icond2});
        Y.mean(icond1,icond2)   = mean(VarData(ind));
        Y.std(icond1,icond2)    = std(VarData(ind));
    end
end

% Y.reps  = 1;
% dispopt     = 'off';

% % kruskalwallis
% [Y.kruskalwallis.p,Y.kruskalwallis.table,Y.kruskalwallis.stats]     = kruskalwallis(Y.Data,Y.Group,dispopt);
% [Y.kruskalwallis.multcompare.comparison,Y.kruskalwallis.means,Y.kruskalwallis.h,Y.kruskalwallis.gnames] = multcompare(Y.kruskalwallis.stats,...
%     'alpha',Y.alpha,...
%     'display','off',...
%     'ctype',Y.ctype);
% ncomp   = size(Y.kruskalwallis.multcompare.comparison,1);
% Y.kruskalwallis.multcompare.alpha  = Y.alpha ./ ncomp;  % Bonferroni's correction
% Y.kruskalwallis.multcompare.alpha_corrected  = Y.alpha;
% Y.kruskalwallis.multcompare.p      = zeros(ncomp,1);
% Y.kruskalwallis.multcompare.p_corrected      = zeros(ncomp,1);
% Y.kruskalwallis.multcompare.issig  = false(ncomp,1);
% for icomp=1:ncomp
%     [Y.kruskalwallis.multcompare.p(icomp),Y.kruskalwallis.multcompare.issig(icomp)]   = ranksum(Y.Data(Y.Group==Y.kruskalwallis.multcompare.comparison(icomp,1)),...
%         Y.Data(Y.Group==Y.kruskalwallis.multcompare.comparison(icomp,2)),...
%         'alpha',Y.kruskalwallis.multcompare.alpha); % ,...'method','exact'
% end
% Y.kruskalwallis.multcompare.p_corrected = min(Y.kruskalwallis.multcompare.p * ncomp,1);
% % Y.kruskalwallis.multcompare.issig2   = (0 < Y.kruskalwallis.multcompare.comparison(:,3) | Y.kruskalwallis.multcompare.comparison(:,5) < 0);
% Y.kruskalwallis.gnames  = gnames;
% 
% % anova1
% [Y.anova1.p,Y.anova1.table,Y.anova1.stats] = anova1(Y.Data,Y.Group,dispopt);
% [Y.anova1.multcompare.comparison,Y.anova1.means,Y.anova1.h,Y.anova1.gnames] = multcompare(Y.anova1.stats,...
%     'alpha',Y.alpha,...
%     'display','off',...
%     'ctype',Y.ctype);
% ncomp   = size(Y.anova1.multcompare.comparison,1);
% Y.anova1.multcompare.alpha  = Y.alpha ./ ncomp;  % Bonferroni's correction
% Y.anova1.multcompare.alpha_corrected    = Y.alpha;
% Y.anova1.multcompare.p      = zeros(ncomp,1);
% Y.anova1.multcompare.p_corrected      = zeros(ncomp,1);
% Y.anova1.multcompare.issig  = false(ncomp,1);
% for icomp=1:ncomp
%     [Y.anova1.multcompare.issig(icomp),Y.anova1.multcompare.p(icomp)]   = ttest2(Y.Data(Y.Group==Y.anova1.multcompare.comparison(icomp,1)),...
%         Y.Data(Y.Group==Y.anova1.multcompare.comparison(icomp,2)),...
%         Y.anova1.multcompare.alpha,...
%         'both','equal');
% end
% Y.anova1.multcompare.p_corrected = min(Y.anova1.multcompare.p * ncomp,1);
% % Y.anova1.multcompare.issig2 = (0 < Y.anova1.multcompare.comparison(:,3) | Y.anova1.multcompare.comparison(:,5) < 0);
% 
% 
OutFileName = ['ANOVA2(',VarName,';'];
for ii =1:2
    OutFileName = [OutFileName,Y.condnames{ii},','];
end
OutFileName(end)    = [];
OutFileName         = [OutFileName,')'];



% OutputDir   = uigetdir(fullfile(datapath,'ANOVA1'),'出力先フォルダを選択してください。');
[OutFileName,OutputDir]  = uiputfile(fullfile(datapath,'ANOVA2',[OutFileName,'.mat']),'ファイルの保存');

OutFullfileName     = fullfile(OutputDir,OutFileName);

save(OutFullfileName,'-struct','Y');
disp(OutFullfileName)
