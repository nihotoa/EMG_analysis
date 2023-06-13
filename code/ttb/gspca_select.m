function gspca_select
global gsobj
hpca    = gsobj.handles.pca;

addflag     = gsobj.spike.addflag;  
hadd        = gsobj.pca.hadd;
list        = selectdata('Axes',hpca,'Ignore',hadd);

addflag     = logical(zeros(size(addflag)));
addflag(list)   = logical(1);
gsobj.spike.addflag = addflag;
% keyboard

deltawindow
gspca_plot
gsscope_plot