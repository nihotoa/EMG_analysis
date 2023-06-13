function unloadedpdf
[dbtxt,dbdir]    = uigetfile('data.txt');
dbtxt   = fullfile(dbdir,dbtxt);
dbtxt2  = fullfile(dbdir,'unloadeddata.txt');
pdfs    = dir(dbdir);
pdfs    = {pdfs.name};
dblist  = getdblist(dbtxt);

jj  = 0;
for ii  = 1:length(pdfs)
    [ext,body]  = extension(pdfs{ii});
    if  strcmp(ext,'pdf')
        if(~ismember(body,dblist))
            jj  = jj + 1;
            unloadedpdfs{jj}    = body;
        end
    end
end

unloadedpdfs    = sort(unloadedpdfs);

[fid,m] = fopen(dbtxt2,'w');
if(~isempty(m))
    error(m);
    return
end
if(~isempty(unloadedpdfs))
    for ii  =1:length(unloadedpdfs)
        if ii~=1
            fprintf(fid,',');
        end
        fprintf(fid,'%s',unloadedpdfs{ii});
    end
end
fclose(fid);
winopen(dbtxt2);


% --------------------------------------------
function dblist = getdblist(dbtxt)
[fid,m] = fopen(dbtxt);
if(~isempty(m))
    error(m)
    return
end

tline   = fgetl(fid);
fclose(fid);

ii  = 1;
while(any(tline))
    [dblist{ii},tline]  = strtok(tline,',');
    ii  = ii + 1;
end



