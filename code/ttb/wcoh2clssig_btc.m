function woh2clssig_btc

[files,parentdir]  = uigetallfile(fullfile(datapath,'wcoh'));
ii  = findstr(parentdir,'wcoh');
targetdir   = [parentdir(1:ii-1),'wcohclssig',parentdir(ii+4:end)];
uiwait(msgbox({['source: ',parentdir];['target: ',targetdir];[num2str(length(files)),' files']},'Šm”F','modal'));
mkdir(targetdir)


for ii  = 1:length(files)
    
    [p,file,ext]    = fileparts(files{ii});
    file            = [file,ext];
    
    s               = load(fullfile(parentdir,file));
    clssig          = wcoh2clssig(s);
    
    outfile         = fullfile(targetdir,file);
    save(outfile,'-struct','clssig');
    disp(outfile)
    indicator(ii,length(files));
end

indicator(0,0);
