function Data	= aligndata(Tar, Ref, TimeWindow)

TimeWindowIndex = round(TimeWindow * Tar.SampleRate);
WindowLengthIndex   = TimeWindowIndex(2) - TimeWindowIndex(1) + 1;
TimeWindow      = TimeWindowIndex / Tar.SampleRate;
timestamp       = round((Ref.Data * Tar.SampleRate) / Ref.SampleRate);
nstamps         = length(timestamp);
nTarData        = length(Tar.Data);

StartIndices    = timestamp + TimeWindowIndex(1);
StopIndices     = StartIndices + WindowLengthIndex -1;


jj      = 0;
Data   = zeros(nstamps,WindowLengthIndex);
for ii = 1:nstamps
%     indicator(ii,nstamps,Tar.Name)
    if(StartIndices(ii)>0 & StopIndices(ii)<=nTarData)
        jj  = jj + 1;
        Data(jj,:) = Tar.Data([StartIndices(ii):StopIndices(ii)]);
    end
end
if jj~=nstamps
    Data(jj+1:end,:)   = [];
end