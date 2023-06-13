function combine_wcoh_wcohclssig_btc


[files,parentpath]	= uigetallfile('L:\tkitom\data\wcohclssig');
nfile   = length(files);

for ii  = 1:nfile
    indicator(ii,nfile)
    wcohclssigfile  = files{ii};
    wcohfile        = wcohclssigfile;
    wcohfile(20:25) = [];
    disp(wcohclssigfile)
    disp(wcohfile)
    combine_wcoh_wcohclssig(wcohfile,wcohclssigfile)
end
    
    

function combine_wcoh_wcohclssig(wcohfile,wcohclssigfile)
wcoh    = load(wcohfile);
wcohclssig  = load(wcohclssigfile);

wcoh.csig   = wcohclssig.cxy;

save(wcohclssigfile,'-struct','wcoh');
