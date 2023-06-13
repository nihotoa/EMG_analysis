% written by TT
function [Fs,data]=mdagetdata(timeRange)
Fs  = NaN;
if nargin > 0
   TimeRange = TimeRange;
else
   TimeRange = [0 Inf];
end

currExperiment = gcme;
if isempty(currExperiment)
    disp('mdagetdata error: No experiment selected.');
    return;
elseif (length(currExperiment) > 1)
    disp('mdagetdata error: Too many experiments selected.');
    return;
end

ExpName = get(currExperiment,'FullName');
names   = getchanname;

channels = experiment(currExperiment, 'findchannelobjs', names);
if any(isnull(channels))
    disp('cohanal error: could not find channels');
    return;
end

for ii=1:length(channels)
    switch get(channels(ii),'Class')
        case 'interval channel'
            data = getdata(currExperiment, names{ii}, TimeRange, {{},{},{}});
        otherwise

            Fs   = get(channels(ii),'SampleRate');
            data = getdata(currExperiment, names{ii}, TimeRange, {{},{},{}});
            data = double(data{:});
    end
%     save(['C:\data\',ExpName,'_',names{ii}], 'Fs' ,'data');
    
end
