function combine_wcoh_wcohclssig_btc


[files,parentpath]	= uigetallfie('L:\tkitom\data\wcohclssig');
nfile   = length(files);

for ii  = nfile
    wcohclssigfile  = files{ii};
    wcohfile        = wcohclssigfile;
    wcohfile(20:25) = [];
    disp(wcohclssigfile)
    disp(wcohfile)
end
    
    

function combine_wcoh_wcohclssig(wcohfile,wcohclssigfile)
wcoh    = load(wcohfile);
wcohclssig  = load(wcohclssigfile);

wcoh.csig   = wcohclssig.cxy;

save(wcohclssigfile,'-struct','wcoh');
