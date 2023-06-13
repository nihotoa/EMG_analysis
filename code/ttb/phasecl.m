function cl = phasecl(L,coh)
% function cl = phasecl(L,coh)
% Calculates 95% confidence limit of coherence phase
%
% L   : # of data segments for FFT
% coh : coherence
% cl  : one-sided 95% confidence limit (phase +- cl)
%
% ex) errorbar(freq,phase,cl)
%
% Reference
% A framework for the analysis of mixed time series/point process data--theory and application to the study of physiological tremor, single motor unit discharges and electromyograms.
% Halliday DM, Rosenberg JR, Amjad AM, Breeze P, Conway BA, Farmer SF
% Prog Biophys Mol Biol  1995-v64-pp237-78


cl  = 1.96 * sqrt(1 / (2*L) * (1./coh-1));    % eq. 6.8