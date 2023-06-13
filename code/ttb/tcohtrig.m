function [f,cl]  = tcohtrig(Ref, Tar, trig,  TimeWindows, nfftPoints,maxtrials)
% function [f,cl]  = tcohtrig(chan1file, chan2file, trigfile,  trigWindows, reffile, nfftPoints, movingStep)

if nargin < 6
    maxtrials = [];
end

% Ref   = load(Reffile);
% Tar   = load(Tarfile);
% trig    = load(trigfile);


TimeWindowIndex     = round(TimeWindows * Tar.SampleRate);
WindowLengthIndex	= TimeWindowIndex(2) - TimeWindowIndex(1) + 1;
nseg                = floor(WindowLengthIndex / nfftPoints);

TimeWindow      = TimeWindowIndex / Tar.SampleRate;
timestamp       = round((trig.Data * Tar.SampleRate) / trig.SampleRate);
nstamps         = length(timestamp);
nTarData        = length(Tar.Data);
seg_tot         = nseg * nstamps;

if(isempty(maxtrials))
    maxseg      = seg_tot;
else
    maxseg      = maxtrials * nseg;
end

StartIndices    = reshape(repmat(([1:nseg]'-1)*nfftPoints  + TimeWindowIndex(1) ,1,nstamps),seg_tot,1);
timestamp_tot   = reshape(repmat(timestamp,nseg,1),seg_tot,1);

StartIndices    = timestamp_tot + StartIndices;
StopIndices     = StartIndices + nfftPoints -1;
% StartIndices    = timestamp + TimeWindowIndex(1);
% StopIndices     = StartIndices + WindowLengthIndex -1;


jj      = 0;
data1   = zeros(seg_tot,nfftPoints);
data2   = zeros(seg_tot,nfftPoints);

for ii = 1:seg_tot
%     indicator(ii,nstamps,Tar.Name)
    if(StartIndices(ii)>0 & StopIndices(ii)<=nTarData)
        jj  = jj + 1;
        data1(jj,:) = Ref.Data([StartIndices(ii):StopIndices(ii)]);
        data2(jj,:) = Tar.Data([StartIndices(ii):StopIndices(ii)]);
        if (jj== maxseg)
            break;
        end
    end
end
if jj~=seg_tot
    data1(jj+1:end,:)   = [];
    data2(jj+1:end,:)   = [];
end
seg_tot         = jj;

sample_rate = Tar.SampleRate;
% keyboard
[f,cl]  = tcoh(data1,data2,sample_rate);
