function uicohsum

rootpath    = 'C:\data\dcohtrig';
% outputfile  = 'C:\data\dcohtrig\localpeaks.xls';
parentpath  =uigetdir(rootpath);
filenames   = what(parentpath);
filenames   = filenames.mat;
triggername = 'EndHold';
XLim        = [10 100];

nfiles      = length(filenames);

sumcoh      = [];
seg_tot     = [];
for ii=1:nfiles
    S       = load(fullfile(parentpath,filenames{ii}));
    coh     = S.EndHold.compiled.coh;
    sumcoh  = cat(4,sumcoh,S.EndHold.compiled.coh);
    seg_tot = [seg_tot S.EndHold.compiled.cl.seg_tot];
    %     disp([num2str(ii),'/',num2str(nfiles)])
    
    freq        = S.EndHold.compiled.freq';
    coh12   = squeeze(S.EndHold.compiled.coh(1,2,:));
    coh21   = squeeze(S.EndHold.compiled.coh(2,1,:));
    f15_50  = S.EndHold.compiled.freq' >= 15 & S.EndHold.compiled.freq' <= 50;
    [Y,I12]   = max(coh12(f15_50));
    [Y,I21]   = max(coh21(f15_50));
    freq15_50   = freq(f15_50);
%     disp(num2str(freq15_50(I12)));
    disp(num2str(freq15_50(I21)));
end

meancoh     = mean(sumcoh,4);
freq        = S.EndHold.compiled.freq';

figure
subplot(1,2,1)
plot(freq,squeeze(meancoh(1,2,:)),'-k');
title(['n = ',num2str(nfiles)]);
set(gca,'XLim',XLim)

subplot(1,2,2)
plot(freq,squeeze(meancoh(2,1,:)),'-k');
set(gca,'XLim',XLim)

ch_cl95 = cohinv(0.95,seg_tot);

subplot(1,2,1)
line([freq(1) freq(end)],[ch_cl95 ch_cl95],'Color',[0.5 0.5 0.5],'LineStyle','-');
subplot(1,2,2)
line([freq(1) freq(end)],[ch_cl95 ch_cl95],'Color',[0.5 0.5 0.5],'LineStyle','-');
title(['ch_cl95 = ',num2str(ch_cl95)]);
