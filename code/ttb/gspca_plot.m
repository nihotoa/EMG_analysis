function gspca_plot
global gsobj

hpca    = gsobj.handles.pca;
score   = gsobj.pca.score;
addflag = gsobj.spike.addflag;
pcx     = gsobj.pca.x;
pcy     = gsobj.pca.y;

hold(hpca,'off')
h1  = plot(hpca,score(:,pcx),score(:,pcy),'o','MarkerSize',2,'MarkerFaceColor',[0.5 0.5 0.5],'MarkerEdgeColor',[0.5 0.5 0.5],'Tag','~addflag');
hold(hpca,'on')
h2  = plot(hpca,score(addflag,pcx)',score(addflag,pcy)','o','MarkerSize',2,'MarkerFaceColor',[1 0 0],'MarkerEdgeColor',[1 0 0],'Tag','addflag');



gsobj.pca.hall  = h1;
gsobj.pca.hadd  = h2;
