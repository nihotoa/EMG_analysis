function [hdr,dat]  = sortsta(hdr,dat,Label)

Groups  = unique(Label);
Groups(Groups==0)   = [];


nGroups = length(Groups);

TrialData   = nan(nGroups,size(hdr.XData,2));
TrialDataStd= nan(nGroups,size(hdr.XData,2));
TimeStamps  = cell(1,nGroups);

for iGroup=1:nGroups
    TrialData(iGroup,:)     = mean(dat.TrialData(Label==Groups(iGroup),:),1);
    TrialDataStd(iGroup,:)  = std(dat.TrialData(Label==Groups(iGroup),:),0,1);
    TimeStamps{iGroup}      = hdr.TimeStamps(Label==Groups(iGroup));
end

hdr.YData       = mean(TrialData,1);
hdr.nTrials     = nGroups;
hdr.TimeStamps  = TimeStamps;
hdr.Process.sort.Sorce  = hdr.Name;
hdr.Process.sort.Data   = Label;


dat.TrialData       = TrialData;
dat.TrialDataStd    = TrialDataStd;
