function [ExpSetsName,ExpSets,filename]   = loadExpSets(fullfilename)

if(nargin<1)
    [filename,pathname] = uigetfile(fullfile(datapath,'ExperimentSets','*.txt'));
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

nSets       = length(tlines);
ExpSetsName = cell(nSets,1);
ExpSets     = cell(nSets,1);

for iSet  =1:nSets
    tline       = tlines{iSet};
    
    colonind    = findstr(tline,':');
    commaind    = findstr(tline,',');
    ind         = [colonind,commaind,length(tline)+1];
    
    nfile       = length(ind)-1;
    ExpSetsName{iSet}  = tline(1:colonind-1);
    
    tempExpSets = cell(1,nfile);
    for ifile=1:nfile
        tempExpSets{ifile}  = tline(ind(ifile)+1:ind(ifile+1)-1);
    end
    ExpSets{iSet} = tempExpSets;
end

