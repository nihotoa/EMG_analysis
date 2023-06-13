function xtalkchk_selection(th)

% th          = 0.2;


ParentDir   = uigetdir(fullfile(datapath,'XTALKCHK'),'親フォルダを選択してください。');

Tarfiles    = sortxls(dirmat(ParentDir));
Tarfiles    = uiselect(Tarfiles,1,'Targetファイルを選択してください。');

nTar        = length(Tarfiles);

for iTar=1:nTar
    Tarfile = Tarfiles{iTar};
    Tar     = load(fullfile(ParentDir,Tarfile));
    
    if(iTar==1)
        All.ChanNames   = Tar.ChanNames;
        All.lRlmaxs     = zeros([size(Tar.lRlmaxs),nTar]);
        addflag         = true(1,size(Tar.lRlmaxs,1));
    end
    
    All.lRlmaxs(:,:,iTar)   = Tar.lRlmaxs;
    indicator(iTar,nTar)
end
    
All.lRlmaxs = nanmean(All.lRlmaxs,3);
All.lRlmaxs(All.lRlmaxs==0) = NaN;
All.isxtalk = All.lRlmaxs > th;
All.th      = th;

Selected    = All;


figure
h   = subplot(1,3,1);
imagesc(All.lRlmaxs,'Parent',h)
axis(h,'square')
set(gca,'XTick',1:size(All.lRlmaxs,2),...
    'XTickLabel',All.ChanNames,...
    'YTick',1:size(All.lRlmaxs,2),...
    'YTickLabel',All.ChanNames)

h   = subplot(1,3,2);
imagesc(All.isxtalk,'Parent',h)
axis(h,'square')
set(gca,'XTick',1:size(All.lRlmaxs,2),...
    'XTickLabel',All.ChanNames,...
    'YTick',1:size(All.lRlmaxs,2),...
    'YTickLabel',All.ChanNames)



h   = subplot(1,3,3);

while(any(any(Selected.isxtalk)))
    xtalkind    = find(sum(Selected.isxtalk,2)==max(sum(Selected.isxtalk,2)));
    nind        = length(xtalkind);
    disp([num2str(max(sum(Selected.isxtalk,2))),'(',num2str(xtalkind'),')']);
    if(nind>1)
        meanR   = nanmean(Selected.lRlmaxs(xtalkind,:),2);
        disp(meanR)
        xtalkind    = xtalkind(maxind(meanR));
    end
    disp([num2str(max(sum(Selected.isxtalk,2))),Selected.ChanNames{xtalkind},'(',num2str(xtalkind),')']);
    Selected.isxtalk(xtalkind,:)= [];
    Selected.isxtalk(:,xtalkind)= [];
    Selected.ChanNames(xtalkind) = [];
    
    
    imagesc(Selected.isxtalk,'Parent',h);
    drawnow;
    axis(h,'square')
    set(gca,'XTick',1:size(Selected.lRlmaxs,2),...
        'XTickLabel',Selected.ChanNames,...
        'YTick',1:size(Selected.lRlmaxs,2),...
        'YTickLabel',Selected.ChanNames)
end

Selected.addflag    = ismember(All.ChanNames,Selected.ChanNames);
disp(num2str(sum(Selected.addflag)));
disp(Selected.ChanNames);

Outputfile  = fullfile(ParentDir,'xtalkchk_selected.mat');
save(Outputfile,'-struct','Selected')

