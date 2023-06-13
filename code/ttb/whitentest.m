% function whitentest

asrate  =100;

bpfilt    = [15 25];
% [b,a]   = cheby2(4,20,filt./(asrate/2));
[b,a]   = butter(4,bpfilt./(asrate/2));

v       =randn(1,100);
fv      =filtfilt(b,a,v);
