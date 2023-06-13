function export2binary

[S,fullfilenames]    = topen;
if(isempty(S))
    disp('User pressed cancel.')
    return;
end

if(~iscell(S))
    S   = {S};
end
nS  = length(S);

for iS=1:nS
    fullfilename    = fullfilenames{iS};
    SS  = S{iS};
    [pathname,filename,ext] = fileparts(fullfilename);
    
    if(strcmp(SS.Class,'virtual channel'))
        SS   = loaddata(fullfilename);
    end
    
    fullfilename2   = fullfile(pathname,[filename,'.bin']);
    
    Data    = SS.Data;
    fid = fopen(fullfilename2,'w');
    fwrite(fid,Data,'int16');
    fclose(fid);
    disp(fullfilename2)
end