function taskphasecomp_anova_spss(wsfilename)

% trest    = [32 :131];
% trest    = [82 :181];
% tgrip    = [232:331];
% thold    = [607:706];
% 
% trest    = [57 :157];   % -0.8 - - 0.4sec
% tgrip    = [257:357];   % 0 - 0.4 sec
% thold    = [407:507];   % 0.6 - 1.0 sec

trest    = [57 :157];   % -0.8 - - 0.4sec
tgrip    = [257:357];   % 0 - 0.4 sec
thold    = [507:607];   % 1.0 - 1.4 sec
% thold    = [457:557];   % 0.8 - 1.2 sec
% thold    = [482:582];   % 0.9 - 1.3 sec

% load('avewcoh_narrow');
load(wsfilename);

% band1   = [8:12];
% band2   = [13:32];
% band3   = [53:63];
% FOI     = [8:32];   % 10-40 Hz
% FOI     = [8:44,52:76];   % 10-55 65-95 Hz

% 3   |4    7   |8     43   |44    52   |53    76   |77    80  (Index)
% 3.75|5.00 8.75|10.00 53.75|55.00 65.00|66.25 95.00|96.25 100 (Hz)
% FOI     = [4:43,53:76];   % 10-55 65-95 Hz
FOI     = [1:80];   % 1.25-100 Hz
% freqFOI = [5:1.25:53.75,66.25:1.25:95]';
freqFOI = [1.25:1.25:100]';
npair   = size(allpcxy,3);
nfreq   = size(allpcxy,1);
nfreqFOI    = length(FOI);




rest    = squeeze(mean(allpcxy(:,trest,:),2));      % frequency x LFP-EMG pair ex size(rest)  = [80 43];
grip    = squeeze(mean(allpcxy(:,tgrip,:),2));
hold    = squeeze(mean(allpcxy(:,thold,:),2));

                                                    
restcol = reshape(rest',[prod(size(rest)),1]);      % 一列のベクトル。ひとつのfrequencyの全LFP-EMGペアのデータが続き、その後に次のfrequencyのデータが続く。
gripcol = reshape(grip',[prod(size(grip)),1]);
holdcol = reshape(hold',[prod(size(hold)),1]);

restFOI = squeeze(mean(allpcxy(FOI,trest,:),2));      % frequency(FOIのみ) x LFP-EMG pair ex size(rest)  = [25 43];
gripFOI	= squeeze(mean(allpcxy(FOI,tgrip,:),2));
holdFOI	= squeeze(mean(allpcxy(FOI,thold,:),2));

restFOIcol = reshape(restFOI,[prod(size(restFOI)),1]);      % 一列のベクトル。ひとつのLFP-EMGペアのFOIfrequencyのデータが続き、その後に次のpairのデータが続く。
gripFOIcol = reshape(gripFOI,[prod(size(gripFOI)),1]);
holdFOIcol = reshape(holdFOI,[prod(size(holdFOI)),1]);


restFOImeancol  = squeeze(mean(restFOI,1))';               % 一列のベクトル。長さはLFP-EMG pair。FOIおよびtrest範囲での平均がされている。ex size  = [43 1];
gripFOImeancol  = squeeze(mean(gripFOI,1))';
holdFOImeancol  = squeeze(mean(holdFOI,1))';

RBF         = [restFOI',gripFOI',holdFOI'];                      % Randmized block factorial (2要因とも対応のある2元配置ANOVA 反復測定)をSPSSで解析する用の変数
RBF_title{1,1}   = 'pair';                                          % size(RBF) = [43 80*3]
for ii=1:3
    for jj=1:nfreqFOI
        switch ii
            case 1
                str = sprintf('r%.2f',freqFOI(jj));
                RBF_title{1,1+jj}   = str;
            case 2
                str = sprintf('g%.2f',freqFOI(jj));
                RBF_title{1,1+nfreqFOI+jj}   = str;
            case 3
                str = sprintf('h%.2f',freqFOI(jj));
                RBF_title{1,1+nfreqFOI*2+jj}   = str;
        end
    end
end
    
                                                    
RBF_RG_title{1,1}	= {'freq'};
RBF_RG_title{1,2}	= {'phase'};
RBF_RG_title{1,3}	= {'pair'};
RBF_RG_title{1,4}	= {'psig'};
RBF_RG(:,1) = repmat(freqFOI,size(restFOI,2)*2,1);
RBF_RG(:,2) = [ones(size(restFOIcol,1),1);2*ones(size(restFOIcol,1),1)];
RBF_RG(:,3) = repmat(reshape(repmat([1:npair],nfreqFOI,1),npair*nfreqFOI,1),2,1);
RBF_RG(:,4) = [restFOIcol;gripFOIcol];

RBF_RH  = [restFOIcol;holdFOIcol];



keyboard;

% [p,table,stats] = anova2([restcol,gripcol],43);
% [comparison,means,gnames] = multcompare(stats,'ctype','bonferroni','estimate','row');

