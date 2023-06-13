function sl = cohcl(alpha,L)
% Significance limit of coherence
%     sl = cohcl(alpha,L)
%     alpha   significant level ex 0.05
%     L       number of disjont sections for calculation of coherence
%     
%     sl      significant limit   i.e. coherece > sl is significant
%     
% written by TT 070318


sl  = 1 - power(alpha,1/(L-1));
