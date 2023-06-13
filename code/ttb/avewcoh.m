function S  = avewcoh(fullfilenames,Name)

warning('off','MATLAB:divideByZero')
nfile   = length(fullfilenames);


for ifile   = 1:nfile
    disp(num2str(ifile))
    fullfilename    = fullfilenames{ifile};

    s   = load(fullfilename);
    if(ifile==1)
        %         S       = s;
        S.Name  = Name;
        S.FileNames     = fullfilenames;
        S.TriggerName   = s.TriggerName;
        S.ReferenceName = s.ReferenceName;
        S.TargetName    = s.TargetName;
        S.Class         = s.Class;
        S.AnalysisType  = ['AVE',s.AnalysisType];
        S.TimeRange     = s.TimeRange;
        S.SampleRate    = s.SampleRate;
        S.nTrials       = zeros(1,nfile);
        S.Cxy   = zeros(size(s.Cxy));
        S.Pxx   = zeros(size(s.Pxx));
        S.Pyy   = zeros(size(s.Pyy));
        S.Pxy   = zeros(size(s.Pxy));
        S.Phi   = zeros([nfile,size(s.Pxy)]);
        S.PhiErr    = zeros([nfile,size(s.Pxy)]);
        S.Psig  = zeros(size(s.Cxy));
        S.freqVec   = s.freqVec;
        S.timeVec	= s.timeVec;
        S.sigma     = s.sigma;
        S.c95       = [];
        S.Unit      = s.Unit;

        if(isfield(S,'sigind'))
            S.sigind    = zeros(size(S.sigind));
            S.clssig    = zeros(size(S.clssig));
            S.kkherz    = s.kkherz;
            S.nnherz    = s.nnherz;
            S.FOI       = s.FOI;
            S.HUM       = s.HUM;
        end
    end

    sigind  = s.Cxy > s.c95;

    if(~strcmp(S.TriggerName,s.TriggerName)),S.TriggerName = 'mixed';end
    if(~strcmp(S.ReferenceName,s.ReferenceName)),S.ReferenceName = 'mixed';end
    if(~strcmp(S.TargetName,s.TargetName)),S.TargetName = 'mixed';end
    if(~strcmp(S.Class,s.Class)),S.Class = 'mixed';end
    if(strcmp(S.TimeRange,'mixed') || ~all(S.TimeRange==s.TimeRange)),S.TimeRange = 'mixed';end
    if(strcmp(S.SampleRate,'mixed') || ~all(S.SampleRate==s.SampleRate)),S.SampleRate = 'mixed';end
    S.nTrials(ifile)   = s.nTrials;
    S.Cxy   = S.Cxy + s.Cxy;
    S.Pxx   = S.Pxx + s.Pxx;
    S.Pyy   = S.Pyy + s.Pyy;
    S.Pxy   = S.Pxy + s.Pxy;
    S.Phi(ifile,:,:)    = nanmask(s.Phi,sigind);
    S.PhiErr(ifile,:,:) = nanmask(phasecl(s.nTrials,s.Cxy),sigind);
    S.Psig  = S.Psig + double(sigind);

    if(strcmp(S.freqVec,'mixed') || ~all(S.freqVec==s.freqVec)),S.freqVec = 'mixed';end
    if(strcmp(S.timeVec,'mixed') || ~all(S.timeVec==s.timeVec)),S.timeVec = 'mixed';end
    if(strcmp(S.sigma,'mixed') || ~all(S.sigma==s.sigma)),S.sigma = 'mixed';end

    if(~strcmp(S.Unit,s.Unit)),S.Unit   = 'mixed';end

    if(isfield(S,'sigind'))
        S.sigind    = S.sigind + double(s.sigind);
        S.sigind    = S.clssig + double(s.clssig);
        if(strcmp(S.kkherz,'mixed') || ~all(S.kkherz==s.kkherz)),S.kkherz = 'mixed';end
        if(strcmp(S.nnherz,'mixed') || ~all(S.nnherz==s.nnherz)),S.nnherz = 'mixed';end
        if(strcmp(S.FOI,'mixed') || ~all(S.FOI==s.FOI)),S.FOI = 'mixed';end
        if(strcmp(S.HUM,'mixed') || ~all(S.HUM==s.HUM)),S.HUM= 'mixed';end
    end
end

S.Cxy   = S.Cxy / nfile;
S.Pxx   = S.Pxx / nfile;
S.Pyy   = S.Pyy / nfile;
S.Pxy   = S.Pxy / nfile;

S.Phi   = shiftdim(nancircmean(S.Phi,1),1);
S.PhiErr = sqrt(shiftdim(nansum(S.PhiErr.^2,1),1)) ./ S.Psig;
S.Psig  = S.Psig / nfile;

S.c95   = avecohcl(0.05,S.nTrials);

if(isfield(S,'sigind'))
    S.sigind    = S.sigind / nfile;
    S.clsind    = S.clssig / nfile;
end

warning('on','MATLAB:divideByZero')