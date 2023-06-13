function [NUMERIC,TXT,RAW]  = txls

xlsfile    = 'L:\tkitom\Documents and  Settings\tkitom\My Documents\Research\Experiment\Precision_grip_coherence\LFPEMGcoherence.xls';

[NUMERIC,TXT,RAW]= xlsread(xlsfile,-1);