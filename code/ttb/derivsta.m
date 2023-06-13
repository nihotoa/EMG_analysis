function [Tar_hdr,Tar_dat]  = derivsta(Tar_hdr,Tar_dat, nderiv)

if(nargin<2)
    nderiv   = 1;
end

Tar_hdr.YData           = deriv(Tar_hdr.YData,nderiv);
Tar_hdr.Name            = [Tar_hdr.Name,'[deriv',num2str(nderiv,'%d'),']'];
Tar_hdr.AnalysisType    = 'STA';
Tar_hdr.data_file       = ['._',Tar_hdr.Name];
Tar_hdr.Process.deriv.nderiv         = nderiv;

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
    Tar_dat.TrialData(iTrial,:) = deriv(Tar_dat.TrialData(iTrial,:),nderiv);
end
Tar_dat.Name            = ['._',Tar_hdr.Name];
Tar_dat.hdr_file        = Tar_hdr.Name;


end