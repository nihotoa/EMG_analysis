function printfig_btc(files)

parentdir   = uigetdir(datapath);
if nargin<1
    files   = dir(parentdir);
    files   = {files.name};
end
files   = uiselect(files,1,'ˆóü‚·‚éfigurefile‚ð‘I‚Ô');
nfiles  = length(files);

for ii  = 1:nfiles
    
    file    = fullfile(parentdir,files{ii});
    try
    fig = openfig(file,'new','visible');
    print(fig)
    close(fig)
    disp(file)
    catch
        a=lasterror
        disp(['error in ',file,'   ',a.message])
                
    end
end
