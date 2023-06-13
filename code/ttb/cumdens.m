function [q11,q22,q21,t,cl] = cumdens(f11,f22,f21,nfft,fs,seg_size,seg_tot,filt)
% function [q11,q22,q21,t,cl] = cumdens(f11,f22,f21,nfft,fs,seg_size,seg_tot)

% f11 = f11';
% f22 = f22';
% f21 = f21';

if isempty(filt)
    filt    = ones(size(f11));
else
    filt    = [filt,0,0,0,filt(end:-1:2)];
% %     filt    = ones(size(f11));
%     filt    = ones(size(f11));
%     filt(1)     = 0;
%     filt(1280)  = 0;
end


f11     = f11.*filt;
f22     = f22.*filt;
f21     = f21.*filt;

q11   = real(ifft(f11,nfft));
q11   = fftshift(q11);

q22   = real(ifft(f22,nfft));
q22   = fftshift(q22);

q21   = real(ifft(f21,nfft));
q21   = fftshift(q21);

dt      = 1/fs;
t   = [-nfft/2:nfft/2-1]*dt;

nfft2   = nfft/2;

cl  = 1.96*sqrt(sum(f11.*f22)/seg_size/(seg_tot*seg_size));

% q11 = q11';
% q22 = q22';
% q21 = q21';