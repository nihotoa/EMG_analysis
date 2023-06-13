function tau    = phi2tau(phi,F)

[phi,nshift]    = shiftdim(phi);
[F,nshift]      = shiftdim(F);

T   = 1000 ./ F; % ����(ms)
tau = T ./ 2*pi .* phi;  % �x��(ms)

tau = shiftdim(tau,-nshift);