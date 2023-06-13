

load('XpdateData');
LPsA = length(YaPostAllDays);
LPsX = length(YaPostXpdays);
LPrA = length(YaPreAllDays);
LPrX = length(YaPreXpdays);

selPsX = cell(LPsA,1);
% selPsA = cell(LPsX,1);
selPrX= cell(LPrA,1);
% selPsA = cell(LPrX,1);

count = ones(2,1);
for ipsa = 1:LPsA
    if YaPostAllDays(ipsa) == YaPostXpdays(count(1))
        selPsX{ipsa,1} = YaPostXpdays(count(1));
        count(1) = count(1) + 1;
    elseif count(1) <= LPsX
        selPsX{ipsa,1} = [];
    end
end

for ipra = 1:LPrA
    if YaPreAllDays(ipra) == YaPreXpdays(count(2))
        selPrX{ipra,1} = YaPreXpdays(count(2));
        count(2) = count(2) + 1;
    elseif count(2) <= LPrX
        selPrX{ipra,1} = [];
    end
end

