function [sigind,clssig,kkherz,nnherz,FOI,HUM,isclust,maxclust,maxclustpeak,maxclustpeakfreq,maxclustpeakmean]  = sigcluster(freq,Cxy,c95,kkherz,nnherz,FOI,HUM)
% [sigind,clssig,kkherz,nnherz,FOI,HUM,isclust,maxclust]  = sigcluster(freq,Cxy,c95,kkherz,nnherz,FOI,HUM)

dfreq   = freq(2)-freq(1);

nnind   = round(nnherz/dfreq);
kkind   = round(kkherz/dfreq);
nnherz  = nnind*dfreq;
kkherz  = kkind*dfreq;


FOImask = false(size(freq));
FOImask(freq>=FOI(1) & freq<=FOI(2))  = 1;
HUMmask = false(size(freq));
HUMmask(freq>=HUM(1) & freq<=HUM(2))  = 1;

FOIALL  = freq(FOImask);
HUMALL  = freq(HUMmask);
FOI     = [FOIALL(1) FOIALL(end)];
HUM     = [HUMALL(1) HUMALL(end)];

sigind  = (Cxy > c95);

clssig = clustvec(sigind,kkind,nnind,FOImask,HUMmask);

clust = findclust(clssig);
if(~isempty(clust))
    isclust = 1;
    [maxN,maxInd]   = max([clust.last] - [clust.first]);
    mclust          = clust(maxInd);
    maxclust(1)     = freq(mclust.first);
    maxclust(2)     = freq(mclust.last);
    maxclustind     = false(1,length(freq));
    maxclustind(mclust.first:mclust.last)   = true;
    [maxclustpeak,maxclustpeakind]  = max(nanmask(Cxy,maxclustind));
    maxclustpeakfreq    = freq(maxclustpeakind);
    maxclustpeakmean    = nanmean(nanmask(Cxy,maxclustind));
else
    isclust = 0;
    maxclust = [];
    maxclustpeak    = [];
    maxclustpeakfreq    = [];
    maxclustpeakmean    = [];
end
