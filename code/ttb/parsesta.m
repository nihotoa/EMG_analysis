function S = parsesta(S)

if(~isfield(S,'AnalysisType'))
    return;
else
    if(~strcmp(S.AnalysisType,'STA'))
        return;
    end
end


if(isfield(S,'diff'))
    S.Process.diff  = S.diff;
    S   = rmfield(S,'diff');
end

if(isfield(S,'filt'))
    S.Process.filt  = S.filt;
    S   = rmfield(S,'filt');
end



