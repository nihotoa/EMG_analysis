function S  = readStimID(ref)

basefreq    = 1000; % Hz
nCh         = 8;


SampleRate  = ref.SampleRate;
% baseisi     = SampleRate./basefreq;  % step
baseisi     = 1./basefreq;  %s


S   = filterTimestampChannel(ref.Name, '~timestamp occurred', ref, ref, [-0.008 -1/SampleRate]);



for iCh=1:nCh
    temp    = filterTimestampChannel(ref.Name, 'timestamp occurred', S, ref, [baseisi*iCh baseisi*(iCh+1)]-baseisi/2);
    
    S.accessory_data(iCh).Name  = ['Relay',num2str(iCh)];
    S.accessory_data(iCh).Data  = double(ismember(S.Data,temp.Data));
    
end
