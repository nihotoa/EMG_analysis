function [Tar_hdr,Tar_dat]  = diffsta(Tar_hdr,Tar_dat, ws, ndiff)

if(nargin<2)
    ws      = 0.1;  %(sec)
    ndiff   = 2;
elseif(nargin<3)
    ndiff   = 2;
end

wsind   = round(ws.*Tar_hdr.SampleRate);
ws      = wsind./Tar_hdr.SampleRate;

Tar_hdr.YData           = smoothdiff(Tar_hdr.YData,wsind,ndiff);
Tar_hdr.Name            = [Tar_hdr.Name,'[diff',num2str(ndiff,'%d'),',ws',num2str(ws,'%g'),']'];
Tar_hdr.AnalysisType    = 'STA';
Tar_hdr.data_file       = ['._',Tar_hdr.Name];
Tar_hdr.Process.diff.WindowSize    = ws;   % sec
Tar_hdr.Process.diff.ndiff         = ndiff;

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
    Tar_dat.TrialData(iTrial,:) = smoothdiff(Tar_dat.TrialData(iTrial,:),wsind,ndiff);
end
Tar_dat.Name            = ['._',Tar_hdr.Name];
Tar_dat.hdr_file        = Tar_hdr.Name;


end

function Data  = smoothdiff(Data,wsind,ndiff)
for idiff=1:ndiff
    nData   = length(Data);
    pre     = zeros(1,nData);
    post    = pre;
    
    for iData=1:nData
        preind  = max(iData-wsind,1):max(iData-1,1);
        postind = min(iData,nData):min(iData+(wsind-1),nData);
        
        pre(iData)  = mean(Data(preind));
        post(iData) = mean(Data(postind));
    end
    
    Data    = post-pre;
end
end