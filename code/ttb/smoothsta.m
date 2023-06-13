function [Tar_hdr,Tar_dat]  = smoothsta(Tar_hdr,Tar_dat,ws)

if(nargin<3)
    ws      = 0.1;  %(sec)
end

wsind   = round(ws.*Tar_hdr.SampleRate);
if(mod(wsind,2)==0)
    wsind   = wsind - 1;
end
ws      = wsind./Tar_hdr.SampleRate;

Tar_hdr.YData           = smoothing(Tar_hdr.YData,wsind,'boxcar');
Tar_hdr.Name            = [Tar_hdr.Name,'[smooth,ws',num2str(ws,'%g'),']'];
Tar_hdr.AnalysisType    = 'STA';
Tar_hdr.data_file       = ['._',Tar_hdr.Name];
Tar_hdr.Process.smooth.WindowSize    = ws;   % sec

fnames  = fieldnames(Tar_hdr);
fnames  = strfilt(fnames,'pse');
if(~isempty(fnames))
    nfnames = length(fnames);
    for ifnames=1:nfnames
        Tar_hdr = rmfield(Tar_hdr,fnames{ifnames});
    end
end
if(isfield(Tar_hdr,'TimeLabels'))
    Tar_hdr = rmfield(Tar_hdr,'TimeLabels');
end



nTrial  = size(Tar_dat.TrialData,1);

for iTrial=1:nTrial
    Tar_dat.TrialData(iTrial,:) = smoothing(Tar_dat.TrialData(iTrial,:),wsind,'boxcar');
end
Tar_dat.Name            = ['._',Tar_hdr.Name];
Tar_dat.hdr_file        = Tar_hdr.Name;


end
