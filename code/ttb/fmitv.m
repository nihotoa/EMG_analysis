function [Y_hdr,Y_dat]  = fmitv(Tar,Ref)
% [Y_hdr,Y_dat]  fmitv(Tar(timestamp), Ref(interval))
%

nRef    = size(Ref.Data,2);
Tar.Data    = Tar.Data ./ Tar.SampleRate;

if(nRef<0)
    TrialData   = [];
    Data        = [];
else
    TrialData   = zeros(nRef,1);
    for iRef=1:nRef
        TrialData(iRef) = sum(Tar.Data >= Ref.Data(1,iRef) & Tar.Data <= Ref.Data(2,iRef)) ./ (Ref.Data(2,iRef) - Ref.Data(1,iRef));    % sps
    end
    Data        = mean(TrialData);
end
Y_hdr.Name          = ['FMITV (',Ref.Name,', ',Tar.Name,')'];
Y_hdr.data_file     = ['._FMITV (',Ref.Name,', ',Tar.Name,')'];
Y_hdr.TargetName    = Tar.Name;
Y_hdr.ReferenceName = Ref.Name;
Y_hdr.Class         = 'scalar channel';
Y_hdr.AnalysisType  = 'FMITV';
Y_hdr.TimeRange     = Tar.TimeRange;
Y_hdr.nTrials       = nRef;
Y_hdr.Data          = Data;
Y_hdr.Unit          = 'sps';

Y_dat.Name          = ['._FMITV (',Ref.Name,', ',Tar.Name,')'];
Y_dat.hdr_file      = ['FMITV (',Ref.Name,', ',Tar.Name,')'];
Y_dat.TrialData     = TrialData;