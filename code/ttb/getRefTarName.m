function [Ref,Tar]  = getRefTarName(S)

if(ischar(S))
    S   ={S};
    ischar_flag = 1;
else
    ischar_flag = 0;
end

nS  = length(S);

Ref = cell(size(S));
Tar = cell(size(S));

for iS  = 1:nS
    s   = S{iS};

    hajimenokakko   = strfind(s,'(');
    hajimenokakko   = hajimenokakko(1);
    saigonokakko    = strfind(s,')');
    saigonokakko    = saigonokakko(end);
    comma           = strfind(s,', ');

    Ref{iS}         = s(hajimenokakko+1:comma-1);
    Tar{iS}         = s(comma+2:saigonokakko-1);
end

if(ischar_flag)
    Ref = Ref{1};
    Tar = Tar{1};
end

% keyboard