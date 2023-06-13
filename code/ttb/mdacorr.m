chanName ={'EMG1','EMG2'};

currExperiment = gcme;
if isempty(currExperiment)
    disp('Error: No experiment selected.');
    return;
end

channels = experiment(currExperiment, 'findchannelobjs', chanName);
if any(isnull(channels))
    disp('Error: could not find channels');
    return;
end