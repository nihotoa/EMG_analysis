% this code were written for title replacement of .fig file 
function [] = RepTitle(filename,figpath,replace_title)
   cd(figpath);
   openfig(filename);
   title(replace_title);
   filename = strrep(filename,'.fig','');
   SaveFig(gcf,filename,'fig')
end