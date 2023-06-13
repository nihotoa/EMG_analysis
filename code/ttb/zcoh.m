function Z  = zcoh(Coh,L)
% z  = zCoh(Coh,L)
% Coh     : coherence value
% L       : number of disjoint sections used to calculate the coherence (total segment number)
% Z       : an estimate of Z-transformed coherence. normally distributed with a standard deviation of approximately 1
% Reference   : "A framework for the analysis of mixed time series/point process data--theory and application to the study of physiological tremor, single motor unit discharges and electromyograms."
%             Halliday DM, Rosenberg JR, Amjad AM, Breeze P, Conway BA, Farmer SF 
%             Prog Biophys Mol Biol  1995-v64-pp237-78  

% written by TT 070212

Z   = atanh(sqrt(Coh)) * (sqrt(2*L));
