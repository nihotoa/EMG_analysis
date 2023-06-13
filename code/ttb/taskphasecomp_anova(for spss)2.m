function taskphasecomp_anoba(wsfilename)

% trest    = [32 :131];
% trest    = [82 :181];
% tgrip    = [232:331];
% thold    = [607:706];

% trest    = [57 :157];   % -0.8 - - 0.4sec
% tgrip    = [257:357];   % 0 - 0.4 sec
% thold    = [407:507];   % 0.6 - 1.0 sec

trest    = [7 :107];   % -1.0 - - 0.6sec
tgrip    = [257:357];   % 0 - 0.4 sec
thold    = [507:607];   % 1.0 - 1.4 sec


% band1   = [8:12];
% band2   = [13:32];
% band3   = [53:63];
% FOI     = [8:32];   % 10-40 Hz
% FOI     = [8:44,52:76];   % 10-55 65-95 Hz

% 3   |4    7   |8     43   |44    52   |53    76   |77    80  (Index)
% 3.75|5.00 8.75|10.00 53.75|55.00 65.00|66.25 95.00|96.25 100 (Hz)
FOI     = [4:43,53:76];   % 10-55 65-95 Hz


% load('avewcoh_narrow');
load(wsfilename);

rest    = squeeze(mean(allpcxy(:,trest,:),2));      % frequency x LFP-EMG pair ex size(rest)  = [80 43];
grip    = squeeze(mean(allpcxy(:,tgrip,:),2));
hold    = squeeze(mean(allpcxy(:,thold,:),2));

restcol = reshape(rest',[prod(size(rest)),1]);      % 一列のベクトル。ひとつのfrequencyの全LFP-EMGペアのデータが続き、その後に次のfrequencyのデータが続く。
gripcol = reshape(grip',[prod(size(grip)),1]);
holdcol = reshape(hold',[prod(size(hold)),1]);

restFOI = squeeze(mean(allpcxy(FOI,trest,:),2));      % frequency(FOIのみ) x LFP-EMG pair ex size(rest)  = [25 43];
gripFOI	= squeeze(mean(allpcxy(FOI,tgrip,:),2));
holdFOI	= squeeze(mean(allpcxy(FOI,thold,:),2));

restFOIcol  = squeeze(mean(restFOI,1))';               % 一列のベクトル。長さはLFP-EMG pair。FOIおよびtrest範囲での平均がされている。ex size  = [43 1];
gripFOIcol  = squeeze(mean(gripFOI,1))';
holdFOIcol  = squeeze(mean(holdFOI,1))';

keyboard

% [p,table,stats] = anova2([restcol,gripcol],43);
% [comparison,means,gnames] = multcompare(stats,'ctype','bonferroni','estimate','row');

