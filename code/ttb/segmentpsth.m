function Y  = segmentpsth(Ref_hdr,Ref_dat,Tar_hdr,Tar_dat,TimeWindow,bw,nshuffle)


Y.Name          = ['SEGPSTH (',Ref_hdr.ReferenceName,', ',Ref_hdr.TargetName,', ',Tar_hdr.TargetName,')'];
Y.ReferenceName = Ref_hdr.Name;
Y.TargetName    = Tar_hdr.Name;
Y.AnalysisType  = 'SEGPSTH';
Y.TimeRange     = TimeWindow;
Y.SampleRate    = Tar_hdr.SampleRate;
Y.nSegments     = [];
Y.nTrials       = [];
Y.XData         = [];
Y.YData         = [];
Y.BinEdges      = [];
Y.BinWidth      = bw;
Y.nShuffle      = nshuffle;
Y.Shuffle.SegmentIndices    = [];
Y.Shuffle.YData = [];
% Y.Shuffle.YData_mean    = [];
% Y.Shuffle.YData_std     = [];
% Y.Shuffle.YData_median  = [];
% Y.Shuffle.YData_uplim   = [];
% Y.Shuffle.YData_lowlim  = [];


RefTrialData    = Ref_dat.TrialData;
TarTrialData    = Tar_dat.TrialData;
[Y.XData,Y.YData,Y.BinEdges,Y.nTrials,Y.nSegments]  = segmentpsth_local(RefTrialData,TarTrialData,TimeWindow,bw);


Y.Shuffle.YData             = nan(nshuffle,size(Y.XData,2));
Y.Shuffle.SegmentIndices    = nan(nshuffle,Y.nSegments);

for ishuffle=1:nshuffle
    indicator(ishuffle,nshuffle);
    tf  = true;
    
    while(tf)
        ind = randperm(Y.nSegments);
        tf  = any((1:Y.nSegments)==ind);
    end
    
    Y.Shuffle.SegmentIndices(ishuffle,:) = ind;
    
    TarTrialData    = Tar_dat.TrialData(Y.Shuffle.SegmentIndices(ishuffle,:),:);
    [XData,Y.Shuffle.YData(ishuffle,:)]  = segmentpsth_local(RefTrialData,TarTrialData,TimeWindow,bw);
    
end
indicator(0,0)



end

function [XData,YData,BinEdges,nTrials,nSeg]  = segmentpsth_local(RefTrialData,TarTrialData,TimeWindow,bw)


nSeg        = length(RefTrialData);
for iSeg =1:nSeg
    
    RefData = RefTrialData{iSeg};
    TarData = TarTrialData{iSeg};
    
    StartTime   = RefData + TimeWindow(1);
    StopTime    = RefData + TimeWindow(2);
    
    nRefData    = length(RefData);
    TrialData   = cell(nRefData,1);
    
    for iRefData=1:nRefData
        TrialData{iRefData} = TarData(TarData>=StartTime(iRefData) & TarData<=StopTime(iRefData)) - RefData(iRefData);
    end
    
    [YData_temp,XData_temp,BinEdges]  = timestamp2psth(TrialData,TimeWindow,bw);
    
    if(iSeg==1)
        nTrials = 0;
        YData   = zeros(size(YData_temp));
        XData   = XData_temp;
    end
    
    nTrials = nTrials + nRefData;
    YData   = YData + YData_temp;
end

end
