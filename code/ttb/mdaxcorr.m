chanName ={'|AbDM5-1000Hz|','|AbDM5-1000Hz|'};
time    =[1 500]  %sec
xunit   = 'millisecond';

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

rate(1) = get(channels(1), 'SampleRate');
rate(2) = get(channels(2), 'SampleRate');
if (rate(1)~=rate(2))
    disp('Error: Mismach Sampling Rate.');
    return;
end

data    =getdata(currExperiment,chanName,time);

if (length(data{1})~=length(data{2}))
    disp('Error: Mismach Data length.');
    return;
end

coeffcov    =xcorr(double(data{1}),double(data{2}),'coeff');

if xunit=='millisecond'
    dT  = 1000/rate(1);
elseif xunit=='second'
    dT  = 1/rate(1);
end

tscale  = [(-length(data{1})+1):(length(data{1})-1)]*dT;
xlabel(xunit)  

figure('Name','mdaxcorr result');
plot(tscale,coeffcov);