function [N,X]  = uihist(varargin)
% [N,X]  = uihist(varargin)

f   = uigetfullfile;
NUMERIC = xlsread(f,-1);
% NUMERIC = xlsread('L:\tkitom\Documents and  Settings\tkitom\My Documents\Research\Experiment\Precision_grip_coherence\phase regression 071119.xls',-1);

if(nargin<1)
    if(nargout>1)
        [N,X]	=hist(NUMERIC);
    elseif(nargout>0)
        N       =hist(NUMERIC);
    else
        fig = figure;
        hist(gca,NUMERIC);
    end
else
    if(nargout>1)
        [N,X]	=hist(NUMERIC,varargin{:});
    elseif(nargout>0)
        N       =hist(NUMERIC,varargin{:});
    else
        fig = figure;
        hist(gca,NUMERIC,varargin{:});
    end
end