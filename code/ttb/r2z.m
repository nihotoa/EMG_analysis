function Z  =r2z(R)
% fisher's z-transformation for correlation coefficient 
% 
% Reference:
% http://en.wikipedia.org/wiki/Fisher_transformation

[R,nshift] = shiftdim(R);

% Z   = log((1+R)./(1-R))/2;
Z   = atanh(R);

Z = shiftdim(Z,-nshift);

% EOF