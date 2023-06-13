function s  = packPSEXtalk(s,fname)
% PSE‚Ìƒf[ƒ^‚ª•Ï”‚Ì’¼‰º‚É‚ ‚éó‘Ô‚©‚ç®—

if(~isfield(s,'AnalysisType'))
    s.AnalysisType  = 'PSEXtalk';
end


items   = {'EMGName',...
    'PSERatio',...
    'xtIndex',...
    'xtFactor',...
    'isXtalkMTX',...
    'isXtalk'};


nitems  = length(items);

for iitem=1:nitems
    item    = items{iitem};
    if(isfield(s,item))
        s.(fname).(item)    = s.(item);
        if(isfield(s,item))
            s   = rmfield(s,item);
        end
    end
end