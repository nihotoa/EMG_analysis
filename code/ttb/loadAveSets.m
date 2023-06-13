function [AveSets,filename]   = loadAveSets(fullfilename)

if(nargin<1)
    [filename,pathname] = uigetfile(fullfile(datapath,'AveSets','*.txt'));
    fullfilename        = fullfile(pathname,filename);
end

fid = fopen(fullfilename,'r');
jj  = 0;
while 1
    jj  = jj+1;
    tlines{jj} = fgetl(fid);
    if ~ischar(tlines{jj})
        tlines(jj)   =[];
        break
    end
end
fclose(fid);

nline   = length(tlines);
AveSets = cell(nline,2); 

for iline  =1:nline
    tline       = tlines{iline};
    
    colonind    = strfind(tline,':');
    AveSets{iline,1}  = deblank(tline(1:colonind-1));
    AveSets{iline,2}  = deblank(tline(colonind+1:end));
    
end

