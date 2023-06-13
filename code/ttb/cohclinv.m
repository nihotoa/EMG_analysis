function p = cohclinv(c,L)
% Significance limit of coherence
%     p = cohclinv(c,L)
%     p         cumlative probability of coh > c
%     L       number of disjont sections for calculation of coherence
%     
%     c         coherence value
%     
% written by TT 070318


p  = power(1 - c, L - 1);
