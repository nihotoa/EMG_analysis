function Y  = fmitvcmp(TW,gnames)

nTW = length(TW);
for iTW =1:nTW
    Data(:,iTW)    = TW{iTW}.TrialData;
end
Y.AnalysisType  = 'FMCMP';
Y.gnames    = gnames;
Y.Data  = Data;
Y.nTrials   = size(Data,1);
Y.mean  = mean(Data,1);
Y.std   = std(Data,1,1);

Y.alpha = 0.05;
Y.ctype = 'bonferroni';
Y.reps  = 1;


% friedman
[Y.friedman.p,Y.friedman.table,Y.friedman.stats] = friedman(Y.Data,Y.reps,'off');
[Y.friedman.comparison,Y.friedman.means,Y.friedman.h,Y.friedman.gnames] = multcompare(Y.friedman.stats,...
    'alpha',Y.alpha,...
    'display','off',...
    'ctype',Y.ctype);
Y.friedman.issig = (0 < Y.friedman.comparison(:,3) | Y.friedman.comparison(:,5) < 0);
Y.friedman.gnames    = gnames;

% anova1
[Y.anova1.p,Y.anova1.table,Y.anova1.stats] = anova1(Data,gnames,'off');
[Y.anova1.comparison,Y.anova1.means,Y.anova1.h,Y.anova1.gnames] = multcompare(Y.anova1.stats,...
    'alpha',Y.alpha,...
    'display','off',...
    'ctype',Y.ctype);
Y.anova1.issig = (0 < Y.anova1.comparison(:,3) | Y.anova1.comparison(:,5) < 0);
