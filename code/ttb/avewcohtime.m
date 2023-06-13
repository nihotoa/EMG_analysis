function s  = avewcohtime(S,timerange)
% S  = avetime(s,timerange)
% timerangeは行列にして複数選べる
% ex) [-1.0 -0.6; 0 0.4; 0.6 1.0]


Px  = S.Px;
Py	= S.Py;
Pxy = S.Pxy;

freq    = S.freqVec;
t       = S.timeVec;

ntimerange      = size(timerange,1);




for ii  = 1:ntimerange
    timerangeind    = (t>=timerange(ii,1) & t<=timerange(ii,2));
    tempt           = t(timerangeind);
    timerange(ii,:) = [tempt(1) tempt(end)];
    nbin            = sum(timerangeind);

    Px   = mean(Px(:,timerangeind),2);
    Py   = mean(Py(:,timerangeind),2);
    Pxy  = mean(Pxy(:,timerangeind),2);

    Cxy  = (abs(AvePxy).^2) ./ (AvePx.*AvePy);        % eq.(4)  0<=　wcoh　<=1にノーマライズするため分母のsqrtをはずした。

    Phi     = angle(AvePxy);

    
    s(ii).Name          = S.Name;
    s(ii).TriggerName   = S.TriggerName;
    s(ii).ReferenceName = S.ReferenceName;
    s(ii).TargetName    = S.TargetName;
    s(ii).Class         = S.Class;
    s(ii).AnalysisType  = 'WCOHTIMEAVE';
    s(ii).TimeRange     = timerange(ii,:);
    s(ii).SampleRate    = S.SampleRate;
    s(ii).nTrials       = S.nTrials;
    s(ii).Cxy           = Cxy';
    s(ii).Px            = Px';
    s(ii).Py            = Py';
    s(ii).Pxy           = Pxy';
    s(ii).Phi           = Phi';
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

end