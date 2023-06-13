function cohtrig_btc
% function cohtrig(timeRange, nfftPoints, chanName1, chanName2, trigName, trigWindow, varargin)

timeRange   = [700 1000];
nfftPoints  = 128;
chanNames1  = getchanname('Select Reference Channels');
chanNames2  = getchanname('Select Target Channels');
% trigName    = 'Grip Onset (success)';
trigName    = getchanname('Select a Trigger Channel');
trigName    = trigName{1};
trigWindow  = [-2 4];
filename    = 'cohtrig20120720.txt';

nch1    = length(chanNames1);
nch2    = length(chanNames2);

for ich1 =1:nch1
    for ich2    = 1:nch2
        chanName1   = chanNames1{ich1};
        chanName2   = chanNames2{ich2};
        
        cohtrig(timeRange, nfftPoints, chanName1, chanName2, trigName, trigWindow, filename)
        
    end
end
