function tcoh_btc


nfftPoints(1)   = 256;  % for compiled analyses
nfftPoints(2)   = 64;  % for time-series analyses
movingStep  = 32;       % for time-series analyses

trigName{1}   = 'Grip Onset (success valid)';
trigWindow{1} = [0 2.048];
VarName{1}  = 'GripOn';
refName       = 'summed smoothed Torque';
opt_str     = 't2';

channames = {'Non-filtered-subsample','FDI-subsample',...
    'Non-filtered-subsample','ADP-subsample',...
    'Non-filtered-subsample','AbPB-subsample',...
    'Non-filtered-subsample','ED23-subsample',...
    'Non-filtered-subsample','AbPL-subsample',...
    'Non-filtered-subsample','ECU-subsample',...
    'Non-filtered-subsample','ED45-subsample',...
    'Non-filtered-subsample','ECRl-subsample',...
    'Non-filtered-subsample','ECRb-subsample',...
    'Non-filtered-subsample','EDC-subsample',...
    'Non-filtered-subsample','FDPr-subsample',...
    'Non-filtered-subsample','FDPu-subsample',...
    'Non-filtered-subsample','FCU-subsample',...
    'Non-filtered-subsample','AbDM-subsample',...
    'Non-filtered-subsample','PL-subsample',...
    'Non-filtered-subsample','FDS-subsample',...
    'Non-filtered-subsample','FCR-subsample',...
    'Non-filtered-subsample','BRD-subsample',...
    'Non-filtered-subsample','PT-subsample',...
    'Non-filtered-subsample','BB-subsample'};

for ii=1:ntrig
    chan1   = aligndata(chan1,trigName{ii},trigWindow{ii});
    chan1   = aligndata(chan1,trigName{ii},trigWindow{ii});
    chan1   = aligndata(chan1,trigName{ii},trigWindow{ii});
end
    
