function Y  = fmclass(S,mode)
if(nargin<2)
    mode    = 'all';
end

tic
isG     = S.anova1.issig(1);
isH     = S.anova1.issig(2);
isGH    = S.anova1.issig(3);
dirG    = S.mean(1) < S.mean(2);    % 0 suppression 1 facilitation
dirH    = S.mean(1) < S.mean(3);    % 0 suppression 1 facilitation
dirGH   = S.mean(2) > S.mean(3);    % 0 G<H 1 G>H



if(isG)
    if(dirG)
        G   = 1;
    else
        G   = 2;
    end
else
    G   = 0;
end
        
if(isH)
    if(dirH)
        H   = 1;
    else
        H   = 2;
    end
else
    H   = 0;
end
    
if(isGH)
    if(dirGH)
        GH   = 1;
    else
        GH   = 2;
    end
else
    GH   = 0;
end

Type    = [num2str(G),num2str(H),num2str(GH)];

switch Type
    case '000'
        Y   = 'none';
    case '001'
        Y   = 'none';
    case '002'
        Y   = 'none';
    case '010'
        Y   = 't+';
    case '011'
        Y   = 't+';
    case '012'
        Y   = 't+';
    case '020'
        Y   = 't-';
    case '021'
        Y   = 't-';
    case '022'
        Y   = 't-';
    case '100'
        Y   = 'p+';
    case '101'
        Y   = 'p+';
    case '102'
        Y   = 'p+';
    case '110'
        Y   = 't+';
    case '111'
        Y   = 'p+t+';
    case '112'
        Y   = 't+';
    case '120'
        Y   = 'error';
    case '121'
        Y   = 'p+t-';
    case '122'
        Y   = 'error';
    case '200'
        Y   = 'p-';
    case '201'
        Y   = 'p-';
    case '202'
        Y   = 'p-';
    case '210'
        Y   = 'error';
    case '211'
        Y   = 'error';
    case '212'
        Y   = 'p-t+';
    case '220'
        Y   = 't-';
    case '221'
        Y   = 't-';
    case '222'
        Y   = 'p-t-';

end

switch mode(1)
    case 'p'
        ind = strfind(Y,'p');
        if(~isempty(ind))
            Y   = Y(ind:ind+1);
        else
            Y   = 'none';
        end
    case 't'
        ind = strfind(Y,'t');
        if(~isempty(ind))
            Y   = Y(ind:ind+1);
        else
            Y   = 'none';
        end
end
        
