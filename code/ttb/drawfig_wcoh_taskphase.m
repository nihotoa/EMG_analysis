% NB  = load('avewcoh_narrow_071106(-AobaT003).mat');
% BB  = load('avewcoh_broad_071106(-AobaT003).mat');


trest    = [57 :157];   % -0.8 - - 0.4sec
tgrip    = [257:357];   % 0 - 0.4 sec
thold    = [507:607];   % 1.0 - 1.4 sec


FOI     = [4:76];   % 1.25-100 Hz
freq    = NB.freq';
NBnpair   = size(NB.allpcxy,3);
BBnpair   = size(BB.allpcxy,3);
nNB     = size(NB.allpcxy,2);
nBB     = size(BB.allpcxy,2);

sigNBRG = [4:28]; 
sigNBRH1 = [8];
sigNBRH2 = [19:23];
sigBBRG = [4:76];
sigBBRH1 = [11:62];
sigBBRH2 = [65:74];



FLim    = [0 100];
FTick   = [0:20:100];
NBLim   = [0 0.4];
NBTick  = [0:0.1:0.4];
BBLim   = [0 1];
BBTick  = [0:0.25:1];

NBrest    = squeeze(mean(mean(NB.allpcxy(:,trest,:),2),3));      % frequency x LFP-EMG pair ex size(rest)  = [80 43];
NBgrip    = squeeze(mean(mean(NB.allpcxy(:,tgrip,:),2),3));
NBhold    = squeeze(mean(mean(NB.allpcxy(:,thold,:),2),3));

NBrestsd    = squeeze(std(mean(NB.allpcxy(:,trest,:),2),0,3));      % frequency x LFP-EMG pair ex size(rest)  = [80 43];
NBgripsd    = squeeze(std(mean(NB.allpcxy(:,tgrip,:),2),0,3));
NBholdsd    = squeeze(std(mean(NB.allpcxy(:,thold,:),2),0,3));

NBrestse    = NBrestsd / sqrt(nNB);      % frequency x LFP-EMG pair ex size(rest)  = [80 43];
NBgripse    = NBgripsd / sqrt(nNB);
NBholdse    = NBholdsd / sqrt(nNB);


BBrest    = squeeze(mean(mean(BB.allpcxy(:,trest,:),2),3));      % frequency x LFP-EMG pair ex size(rest)  = [80 43];
BBgrip    = squeeze(mean(mean(BB.allpcxy(:,tgrip,:),2),3));
BBhold    = squeeze(mean(mean(BB.allpcxy(:,thold,:),2),3));

BBrestsd    = squeeze(std(mean(BB.allpcxy(:,trest,:),2),0,3));      % frequency x LFP-EMG pair ex size(rest)  = [80 43];
BBgripsd    = squeeze(std(mean(BB.allpcxy(:,tgrip,:),2),0,3));
BBholdsd    = squeeze(std(mean(BB.allpcxy(:,thold,:),2),0,3));

BBrestse    = BBrestsd / sqrt(nBB);      % frequency x LFP-EMG pair ex size(rest)  = [80 43];
BBgripse    = BBgripsd / sqrt(nBB);
BBholdse    = BBholdsd / sqrt(nBB);


figure

h   =subplot(2,2,1);
hold on;

% terrorarea(h,freq,NBrest,NBrestse,'-r','LineWidth',1);
% terrorarea(h,freq,NBgrip,NBgripse,'-b','LineWidth',1);
fill([freq(sigNBRG);freq(sigNBRG(end:-1:1))],[NBrest(sigNBRG);NBgrip(sigNBRG(end:-1:1))],[0.8 0.8 0.8],'Parent',h,'LineStyle','none');

plot(h,freq(FOI),NBrest(FOI),'-r','LineWidth',1);
plot(h,freq(FOI),NBgrip(FOI),'-b','LineWidth',1);

set(h,'Box','off',...
    'TickDir','out',...
    'XLim',FLim,...
    'XTick',FTick,...
    'YLim',NBLim,...
    'YTick',NBTick);

h   =subplot(2,2,2);
hold on;

% terrorarea(h,freq,BBrest,BBrestse,'-r','LineWidth',1);
% terrorarea(h,freq,BBgrip,BBgripse,'-b','LineWidth',1);
fill([freq(sigBBRG);freq(sigBBRG(end:-1:1))],[BBrest(sigBBRG);BBgrip(sigBBRG(end:-1:1))],[0.8 0.8 0.8],'Parent',h,'LineStyle','none');

plot(h,freq(FOI),BBrest(FOI),'-r','LineWidth',1);
plot(h,freq(FOI),BBgrip(FOI),'-b','LineWidth',1);
set(h,'Box','off',...
    'TickDir','out',...
    'XLim',FLim,...
    'XTick',FTick,...
    'YLim',BBLim,...
    'YTick',BBTick);

h   =subplot(2,2,3);
hold on;


% terrorarea(h,freq,NBrest,NBrestse,'-r','LineWidth',1);
% terrorarea(h,freq,NBhold,NBholdse,'-b','LineWidth',1);

fill([freq(sigNBRH1);freq(sigNBRH1(end:-1:1))],[NBrest(sigNBRH1);NBhold(sigNBRH1(end:-1:1))],[0.8 0.8 0.8],'Parent',h,'LineStyle','none');
fill([freq(sigNBRH2);freq(sigNBRH2(end:-1:1))],[NBrest(sigNBRH2);NBhold(sigNBRH2(end:-1:1))],[0.8 0.8 0.8],'Parent',h,'LineStyle','none');

plot(h,freq(FOI),NBrest(FOI),'-r','LineWidth',1);
plot(h,freq(FOI),NBhold(FOI),'-g','LineWidth',1);
set(h,'Box','off',...
    'TickDir','out',...
    'XLim',FLim,...
    'XTick',FTick,...
    'YLim',NBLim,...
    'YTick',NBTick);

h   =subplot(2,2,4);
hold on;

% terrorarea(h,freq,BBrest,BBrestse,'-r','LineWidth',1);
% terrorarea(h,freq,BBhold,BBholdse,'-b','LineWidth',1);
fill([freq(sigBBRH1);freq(sigBBRH1(end:-1:1))],[BBrest(sigBBRH1);BBhold(sigBBRH1(end:-1:1))],[0.8 0.8 0.8],'Parent',h,'LineStyle','none');
fill([freq(sigBBRH2);freq(sigBBRH2(end:-1:1))],[BBrest(sigBBRH2);BBhold(sigBBRH2(end:-1:1))],[0.8 0.8 0.8],'Parent',h,'LineStyle','none');

plot(h,freq(FOI),BBrest(FOI),'-r','LineWidth',1);
plot(h,freq(FOI),BBhold(FOI),'-g','LineWidth',1);
set(h,'Box','off',...
    'TickDir','out',...
    'XLim',FLim,...
    'XTick',FTick,...
    'YLim',BBLim,...
    'YTick',BBTick);


                                                    
% restcol = reshape(rest',[prod(size(rest)),1]);      % 一列のベクトル。ひとつのfrequencyの全LFP-EMGペアのデータが続き、その後に次のfrequencyのデータが続く。
% gripcol = reshape(grip',[prod(size(grip)),1]);
% holdcol = reshape(hold',[prod(size(hold)),1]);
% 
% restFOI = squeeze(mean(allpcxy(FOI,trest,:),2));      % frequency(FOIのみ) x LFP-EMG pair ex size(rest)  = [25 43];
% gripFOI	= squeeze(mean(allpcxy(FOI,tgrip,:),2));
% holdFOI	= squeeze(mean(allpcxy(FOI,thold,:),2));
% 
% restFOIcol = reshape(restFOI,[prod(size(restFOI)),1]);      % 一列のベクトル。ひとつのLFP-EMGペアのFOIfrequencyのデータが続き、その後に次のpairのデータが続く。
% gripFOIcol = reshape(gripFOI,[prod(size(gripFOI)),1]);
% holdFOIcol = reshape(holdFOI,[prod(size(holdFOI)),1]);
% 
% 
% restFOImeancol  = squeeze(mean(restFOI,1))';               % 一列のベクトル。長さはLFP-EMG pair。FOIおよびtrest範囲での平均がされている。ex size  = [43 1];
% gripFOImeancol  = squeeze(mean(gripFOI,1))';
% holdFOImeancol  = squeeze(mean(holdFOI,1))';
% 
% RBF         = [restFOI',gripFOI',holdFOI'];                      % Randmized block factorial (2要因とも対応のある2元配置ANOVA 反復測定)をSPSSで解析する用の変数
% RBF_title{1,1}   = 'pair';                                          % size(RBF) = [43 80*3]
% for ii=1:3
%     for jj=1:nfreqFOI
%         switch ii
%             case 1
%                 str = sprintf('r%.2f',freqFOI(jj));
%                 RBF_title{1,1+jj}   = str;
%             case 2
%                 str = sprintf('g%.2f',freqFOI(jj));
%                 RBF_title{1,1+nfreqFOI+jj}   = str;
%             case 3
%                 str = sprintf('h%.2f',freqFOI(jj));
%                 RBF_title{1,1+nfreqFOI*2+jj}   = str;
%         end
%     end
% end
%     
%                                                     
% RBF_RG_title{1,1}	= {'freq'};
% RBF_RG_title{1,2}	= {'phase'};
% RBF_RG_title{1,3}	= {'pair'};
% RBF_RG_title{1,4}	= {'psig'};
% RBF_RG(:,1) = repmat(freqFOI,size(restFOI,2)*2,1);
% RBF_RG(:,2) = [ones(size(restFOIcol,1),1);2*ones(size(restFOIcol,1),1)];
% RBF_RG(:,3) = repmat(reshape(repmat([1:npair],nfreqFOI,1),npair*nfreqFOI,1),2,1);
% RBF_RG(:,4) = [restFOIcol;gripFOIcol];
% 
% RBF_RH  = [restFOIcol;holdFOIcol];
% 
% 
% 
% keyboard;

% [p,table,stats] = anova2([restcol,gripcol],43);
% [comparison,means,gnames] = multcompare(stats,'ctype','bonferroni','estimate','row');

