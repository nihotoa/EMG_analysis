function [YData,XData,BinEdges,TrialData] = timestamp2psth(TimeStamp,TimeRange,bw)
% [YData,XData,BinEdges,TrialData] = timestamp2psth(TimeStamp,TimeRange,bw)
% convert timestamp data (sec) to psth
%
% example 1
% 
% timestamp=[-1:1:3];
% TimeRange=[-1.5,3]
% bw=0.02
% [YData,XData,BinEdges]=timestamp2psth(timestamp,TimeRange,bw);
% bar(XData,YData,1)
% 
% 
% example 2
% 
% timestamp={[-1:1:3];[-1.5:1:3]}
% TimeRange=[-1.5,3]
% bw=0.02
% [YData,XData,BinEdges,TrialData]=timestamp2psth(timestamp,TimeRange,bw);
% bar(XData,YData,1)
% 
% written by Tomohiko Takei 2011/01/20



FirstBinInd = floor(TimeRange(1)./bw);
LastBinInd  = ceil(TimeRange(2)./bw);

BinInd      = FirstBinInd:LastBinInd;
BinEdges    = BinInd.*bw;
XData       = BinEdges(1:(end-1))+bw/2;
TrialData   = [];

if(~iscell(TimeStamp))
    YData   = histc(TimeStamp,BinEdges);
    if(isempty(YData))
        YData   = zeros(1,length(BinEdges)-1);
    else
        YData   = YData(1:(end-1));
    end
else
    nTrials = length(TimeStamp);
    YData   = zeros(1,length(BinEdges)-1);
    TrialData   = nan(nTrials,length(BinEdges)-1);
    
    for iTrial=1:nTrials
        temp    = histc(TimeStamp{iTrial},BinEdges);
        if(isempty(temp))
            temp   = zeros(1,length(BinEdges)-1);
        else
            temp   = temp(1:(end-1));
        end
        YData   = YData + temp;
        TrialData(iTrial,:) = temp;
    end
end


end