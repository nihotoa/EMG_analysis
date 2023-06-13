function wcohpeaks

rootpath    = 'L:\tkitom\data\wcohclssig';
outputfile  = 'L:\tkitom\data\wcohclssig\localpeaks.xls';

maxcluster_flag     = 1;

% TOI     = [7:632];      % -1.0 ~ +1.5 sec
TOI     = [257:632];      % 0 ~ +1.5 sec


[files,parentdir]  = uigetallfile(rootpath);

nfiles  = length(files);

fid = fopen(outputfile,'a');
if(fid==-1)
    disp('Failure to output file.')
    return
end
fprintf(fid,'\n%s',datestr(now));
fprintf(fid,'\nfile\tissig');

if(maxcluster_flag==1)
    fprintf(fid,'\tWidest(firstF)\tWidest(lastF)\tWidest(FRange)');
    %     fig = figure;
end

for ii=1:nfiles
    indicator(ii,nfiles);
    file    = files{ii};
    s   = load(file);
    cxy     = s.cxy(:,TOI);
    t       = s.t(TOI);
    freq    = s.freq;

    issig   = (sum(sum(cxy,1),2) > 0);
    fprintf(fid,'\n%s\t%d',file,issig);


    if(maxcluster_flag==1)
        [nfreq,ntime]   = size(cxy);
        kk   = 0;
        maxclust    = struct('first',[],'last',[],'n',[]);
        for(jj=1:ntime)
            clust   = findclust(cxy(:,jj));      
            if(~isempty(clust))
                kk   = kk + 1;
                [maxN,maxInd]   = max([clust.last] - [clust.first]);
                if kk < 2
                    maxclust    = clust(maxInd);
                else
                    maxclust(kk)    = clust(maxInd);
                end
            end
        end
        
        if(~isempty(maxclust(1).first))
        [maxN,maxInd]   = max([maxclust.last] -  [maxclust.first]);
        maxclust        = maxclust(maxInd);

        firstF  = freq(maxclust.first);
        lastF   = freq(maxclust.last);
        FR      = lastF - firstF;

        fprintf(fid,'\t%f\t%f\%f',firstF,lastF,FR);
        else
            fprintf(fid,'\t%f\t%f\%f',0,0,0);
        end
    end
end
fclose(fid)

indicator(0,0)