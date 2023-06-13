function X  = getcomponent(S)
% input a analyses file structure which loaded by topen etc.
% or pick analyses file in this program. In such a case, input a string for
% dialog title.


if nargin < 1
    S	= 'Pick a file';
end
if(ischar(S))
    S   = topen(S);
end


% find a component object
kk  = 0;
for ii = 1:length(S.Objects)
    if(~isempty(strfind(S.Objects(ii).Class,'component')))
        kk  = kk + 1;
        compind(kk) = ii;
    end
end

nComp    = length(compind);
for ii  = 1:nComp
    X(ii)	= cell2struct(S.Objects(compind(ii)).PropertyValues,S.Objects(compind(ii)).PropertyNames,2);
end
