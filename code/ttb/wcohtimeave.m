function s  = wcohtimeave(S,timerange)
% S  = avetime(s,timerange)
% timerangeは行列にして複数選べる
% ex) [-1.0 -0.6; 0 0.4; 0.6 1.0]

Pxx = S.Pxx;
Pyy	= S.Pyy;
Pxy = S.Pxy;

freq    = S.freqVec;
t       = S.timeVec;

dt   = t(2) - t(1);

ntimerange      = size(timerange,1);
kkherz  = 6.25;
nnherz  = 10;
FOI     = [5 95];
HUM     = [55 65];


for ii  = 1:ntimerange
    timerangeind    = (t>=(timerange(ii,1)-dt/2) & t<=(timerange(ii,2)+dt/2));
    tempt           = t(timerangeind);
    timerange(ii,:) = [tempt(1) tempt(end)];
    nbin            = sum(timerangeind);
% keyboard
    mPxx = mean(Pxx(:,timerangeind),2);
    mPyy = mean(Pyy(:,timerangeind),2);
    mPxy = mean(Pxy(:,timerangeind),2);

    mCxy = (abs(mPxy).^2) ./ (mPxx.*mPyy);        % eq.(4)  0<=　wcoh　<=1にノーマライズするため分母のsqrtをはずした。

    mPhi = angle(mPxy);

    
    s(ii).Name          = ['WCOHTIMEAVE',S.Name(5:end)];
    s(ii).TriggerName   = S.TriggerName;
    s(ii).ReferenceName = S.ReferenceName;
    s(ii).TargetName    = S.TargetName;
    s(ii).Class         = S.Class;
    s(ii).AnalysisType  = 'WCOHTIMEAVE';
    s(ii).TimeRange     = timerange(ii,:);
    s(ii).SampleRate    = S.SampleRate;
    s(ii).nTrials       = S.nTrials;
    s(ii).Cxy           = mCxy';
    s(ii).Pxx            = mPxx';
    s(ii).Pyy            = mPyy';
    s(ii).Pxy           = mPxy';
    s(ii).Phi           = mPhi';
    s(ii).freqVec       = freq;
    s(ii).timeVec       = tempt;
    s(ii).ntimeVec      = nbin;
    s(ii).sigma         = S.sigma;
    s(ii).c95           = S.c95;
    s(ii).Unit          = 'coh';

    if(isfield(S,'UseExpSet_flag')&&S.UseExpSet_flag==1)
        s(ii).UseExpSet_flag    = 1;
        s(ii).Expset            = S.Expset;
        s(ii).ExpSet_ntrials    = S.ExpSet_ntrials;
    end
    
    
    [s(ii).sigind,s(ii).clssig,s(ii).kkherz,s(ii).nnherz,s(ii).FOI,s(ii).HUM,s(ii).isclust,s(ii).maxclust]  = sigcluster(s(ii).freqVec,s(ii).Cxy,s(ii).c95,kkherz,nnherz,FOI,HUM);

end