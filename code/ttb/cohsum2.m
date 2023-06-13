function cohsum(command)
% initializing parameters
counts  = [];
allcoh  = [];
ALL_allcoh  = [];
ALL_counts = [];
xnormLim    = [10 50];
xLim    = [5 150];



switch command
    case 'ALL'
        


localfilename   = {'Non-filtered-subsample__FDI-rect.mat';...
    'Non-filtered-subsample__ADP-rect.mat';...
    'Non-filtered-subsample__AbPB-rect.mat';...
    'Non-filtered-subsample__ED23-rect.mat';...
    'Non-filtered-subsample__ECU-rect.mat';...
    'Non-filtered-subsample__ED45-rect.mat';...
    'Non-filtered-subsample__ECRl-rect.mat';...
    'Non-filtered-subsample__ECRb-rect.mat';...
    'Non-filtered-subsample__EDC-rect.mat';...
    'Non-filtered-subsample__FDPr-rect.mat';...
    'Non-filtered-subsample__FDPu-rect.mat';...
    'Non-filtered-subsample__FCU-rect.mat';...
    'Non-filtered-subsample__AbDM-rect.mat';...
    'Non-filtered-subsample__PL-rect.mat';...
    'Non-filtered-subsample__FDS-rect.mat';...
    'Non-filtered-subsample__FCR-rect.mat';...
    'Non-filtered-subsample__BRD-rect.mat';...
    'Non-filtered-subsample__PT-rect.mat';...
    'Non-filtered-subsample__BB-rect.mat'};

%     'Non-filtered-subsample__AbPL-rect.mat';...

listbox = localfilename;
listbox(length(localfilename)+1) ={'ALL'};

path(path,genpath('C:\data\cohtrig'));

fig = figure('Name','coherence summary',...
    'NumberTitle','off',...
    'PaperUnits', 'centimeters',...
    'PaperOrientation','landscape',...
    'PaperPosition', [0.881189 0.634517 27.9151 19.715],...
    'PaperPositionMode','manual',...
    'Position',[-3 58 1280 904],...
    'Toolbar','figure');
set(0,'CurrentFigure',fig);
h(1)    =subplot(3,1,1);
    ylabel('Counts above confidence limit');
    xlabel('Fs');
    set(h(1),'Nextplot','replacechildren');
h(2)    =subplot(3,1,2);
    ylabel('Averaged Coherence');
    xlabel('Fs');
    set(h(2),'Nextplot','replacechildren');
h(3)    =subplot(3,1,3);

Callback_command    = ['summary = get(gcf,''UserData'');jj=get(gco,''Value'');subplot(3,1,1);bar(summary(jj).X,summary(jj).counts,1);title(summary(jj).listbox);set(gca, ''YLimMode'', ''auto'');set(gca, ''XLim'', [10 50]);yLim=get(gca,''YLim'');set(gca, ''YLimMode'', ''manual'');set(gca, ''XLim'', [5 150]);set(gca, ''YLim'', yLim);subplot(3,1,2);stairs(summary(jj).X,summary(jj).mean);set(gca, ''YLimMode'', ''auto'');set(gca, ''XLim'', [10 50]);yLim=get(gca,''YLim'');set(gca, ''YLimMode'', ''manual'');set(gca, ''XLim'', [5 150]);set(gca, ''YLim'', yLim);'];
uicontrol('BackgroundColor',[1 1 1],...
    'Callback',Callback_command,...
    'Units',get(h(3),'Units'),...
    'Position',get(h(3),'Position'),...
    'Style','listbox',...
    'String',listbox)
delete(h(3));



for jj=1:length(localfilename)

    fullfilename    = which(localfilename{jj},'-ALL');

    for ii=1:length(fullfilename)
        S=open(fullfilename{ii});
        allcoh(:,ii) = S.f(:,4);
        counts = [counts;S.f(S.f(:,4)>S.cl.ch_c95,1)];
    end
    
    [N,X]   = hist(counts,S.f(:,1));
    M   = mean(allcoh,2);
    summary(jj).X   = X;
    summary(jj).counts  = N;
    summary(jj).mean    = M;
    summary(jj).listbox    = localfilename{jj};
    
    ALL_X       = X;
    ALL_allcoh  = [ALL_allcoh,allcoh];
    ALL_counts  = [ALL_counts;counts];
    
%     axes(h(1))
% 
%     bar(X,N,1);
% %     set(h(1),'XLim',[0 150]);
% 
%     axes(h(2))
%     stairs(S.f(:,1),mean(allcoh,2));
% %     set(h(2),'XLim',[0 150]);
    

end

[N,X]   = hist(ALL_counts,S.f(:,1));
M   = mean(ALL_allcoh,2);
summary(length(localfilename)+1).X   = X;
summary(length(localfilename)+1).counts  = N;
summary(length(localfilename)+1).mean    = M;
summary(length(localfilename)+1).listbox    = 'ALL';

set(fig,'UserData',summary)




for ii=1:2
    set(h(ii), 'YLimMode', 'auto');
    set(h(ii), 'XLim', xnormLim);
    yLim    = get(h(ii), 'YLim');
    set(h(ii), 'YLimMode', 'manual');
    set(h(ii), 'XLim', xLim);
    set(h(ii), 'YLim', yLim);
end

% set(gca, ''YLimMode'', ''auto'');set(gca, ''XLim'', [10 50]);yLim=get(gca,''YLim'');set(gca, ''YLimMode'', ''manual'');set(gca, ''XLim'', [5 150]);set(gca, ''YLim'', yLim);end

rmpath(genpath('C:\data\cohtrig'));