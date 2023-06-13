function S  = sortscatter(S,CompName,SortMethod,N,MinN)

% SortMethod  = 'interval nbin', 'ordinal nbin', 'ordinal npoint', 'manual';


switch lower(SortMethod)
    case 'interval nbin'
        
        nBin        = N;
        XDataMax    = max(S.XData);
        XDataMin    = min(S.XData);
        XDataWidth  = XDataMax-XDataMin;
        
        
        BinWidth    = XDataWidth ./ nBin;
        BinEdges    = ((1:(nBin+1))-1)*BinWidth+XDataMin;
        
        [N,BinInd]  = histc(S.XData,BinEdges);
        BinInd(BinInd==(nBin+1))    = nBin;
        N(nBin)     = sum(N(nBin:(nBin+1)));
        N(nBin+1)   = [];
        
        XData       = nan(nBin,1);
        XDataStd    = nan(nBin,1);
        YData       = nan(nBin,1);
        YDataStd    = nan(nBin,1);
        
        for iBin=1:nBin
            XData(iBin)     = mean(S.XData(BinInd==iBin));
            XDataStd(iBin)  = std(S.XData(BinInd==iBin));
            YData(iBin)     = mean(S.YData(BinInd==iBin));
            YDataStd(iBin)  = std(S.YData(BinInd==iBin));
        end
        IsValid     = N>=MinN;
        
        Y.SortMethod    = SortMethod;
        Y.nBin      = nBin;
        Y.MinN      = MinN;
        Y.BinEdges  = BinEdges;
        Y.BinIndex  = BinInd;
        Y.N         = N;
        Y.XData     = XData;
        Y.XDataStd  = XDataStd;
        Y.YData     = YData;
        Y.YDataStd  = YDataStd;
        Y.IsValid   = IsValid;
        Y.nValid    = sum(Y.IsValid);
        
    case 'ordinal nbin'
        nBin        = N;
        prclimit    = ((0:nBin)./nBin).*100;
        
        BinEdges    = prctile(S.XData,prclimit);
        
        [N,BinInd]  = histc(S.XData,BinEdges);
        BinInd(BinInd==(nBin+1))    = nBin;
        N(nBin)     = sum(N(nBin:(nBin+1)));
        N(nBin+1)   = [];
        
        XData       = nan(nBin,1);
        XDataStd    = nan(nBin,1);
        YData       = nan(nBin,1);
        YDataStd    = nan(nBin,1);
        
        for iBin=1:nBin
            XData(iBin)     = mean(S.XData(BinInd==iBin));
            XDataStd(iBin)  = std(S.XData(BinInd==iBin));
            YData(iBin)     = mean(S.YData(BinInd==iBin));
            YDataStd(iBin)  = std(S.YData(BinInd==iBin));
        end
        IsValid     = N>=MinN;
        
        Y.SortMethod    = SortMethod;
        Y.nBin      = nBin;
        Y.MinN      = MinN;
        Y.BinEdges  = BinEdges;
        Y.BinIndex  = BinInd;
        Y.N         = N;
        Y.XData     = XData;
        Y.XDataStd  = XDataStd;
        Y.YData     = YData;
        Y.YDataStd  = YDataStd;
        Y.IsValid   = IsValid;
        Y.nValid    = sum(Y.IsValid);
        
    case 'ordinal npoint'
        nXData      = length(S.XData);
        nBin        = floor(nXData./ N);
        prclimitd   = (N./nXData)*100;
        prclimit    = (0:nBin).*prclimitd;
        
        BinEdges    = prctile(S.XData,prclimit);
        
        [N,BinInd]  = histc(S.XData,BinEdges);
        BinInd(BinInd==(nBin+1))    = nBin;
        N(nBin)     = sum(N(nBin:(nBin+1)));
        N(nBin+1)   = [];
        
        XData       = nan(nBin,1);
        XDataStd    = nan(nBin,1);
        YData       = nan(nBin,1);
        YDataStd    = nan(nBin,1);
        
        for iBin=1:nBin
            XData(iBin)     = mean(S.XData(BinInd==iBin));
            XDataStd(iBin)  = std(S.XData(BinInd==iBin));
            YData(iBin)     = mean(S.YData(BinInd==iBin));
            YDataStd(iBin)  = std(S.YData(BinInd==iBin));
        end
        IsValid     = N>=MinN;
        
        Y.SortMethod    = SortMethod;
        Y.nBin      = nBin;
        Y.MinN      = MinN;
        Y.BinEdges  = BinEdges;
        Y.BinIndex  = BinInd;
        Y.N         = N;
        Y.XData     = XData;
        Y.XDataStd  = XDataStd;
        Y.YData     = YData;
        Y.YDataStd  = YDataStd;
        Y.IsValid   = IsValid;
        Y.nValid    = sum(Y.IsValid);
        
        
    case 'manual'
        
        
        BinInd      = N;
        Group       = unique(BinInd);
        Group(Group==0) = [];
        nBin        = length(Group);
        N           = nan(1,nBin);
        
        
        XData       = nan(nBin,1);
        XDataStd    = nan(nBin,1);
        YData       = nan(nBin,1);
        YDataStd    = nan(nBin,1);
        
        for iBin=1:nBin
            XData(iBin)     = mean(S.XData(BinInd==Group(iBin)));
            XDataStd(iBin)  = std(S.XData(BinInd==Group(iBin)));
            YData(iBin)     = mean(S.YData(BinInd==Group(iBin)));
            YDataStd(iBin)  = std(S.YData(BinInd==Group(iBin)));
            
            N(iBin) = sum(BinInd==Group(iBin));
        end
        IsValid     = N>=MinN;
        
        Y.SortMethod    = SortMethod;
        Y.nBin      = nBin;
        Y.MinN      = MinN;
%         Y.BinEdges  = BinEdges;
        Y.BinIndex  = BinInd;
        Y.N         = N;
        Y.XData     = XData;
        Y.XDataStd  = XDataStd;
        Y.YData     = YData;
        Y.YDataStd  = YDataStd;
        Y.IsValid   = IsValid;
        Y.nValid    = sum(Y.IsValid);

end

% pearson& spearman

% 相関係数
if(Y.nValid<2)
    Y.Pearson.R = 0;
    Y.Pearson.P = 1;
    Y.Spearman.R    = 0;
    Y.Spearman.P    = 1;
    % 線形回帰
    Y.a   = nan(1,2);
    Y.ahelp = '回帰直線：Y=a(1)*X+a(2)';
else
    [Y.Pearson.R,Y.Pearson.P]   = corr(XData(IsValid),YData(IsValid),'type','Pearson');
    [Y.Spearman.R,Y.Spearman.P] = corr(XData(IsValid),YData(IsValid),'type','Spearman');
    % 線形回帰
    Y.a   = polyfit(XData(IsValid),YData(IsValid),1);
    Y.ahelp = '回帰直線：Y=a(1)*X+a(2)';
end




% anova1
Data        = S.YData;
Group       = BinInd;


ValidInd    = 1:nBin;
ValidInd    = ValidInd(N>=MinN);
nValidInd   = length(ValidInd);

if(nValidInd>=2)
    ValidFlag   = ismember(BinInd,ValidInd);
    
    Group   = Group(ValidFlag);
    Data    = Data(ValidFlag);
    
    ii  = 0;
    for iBin=1:nBin
        if(ismember(iBin,ValidInd))
            ii=ii+1;
            Group(Group==iBin) = ii;
        end 
    end
    
    Y.anova1.gnames = XData(ValidInd);
    Y.anova1.Data   = Data;
    Y.anova1.mean   = YData(ValidInd);
    Y.anova1.std    = YDataStd(ValidInd);
    Y.anova1.Group  = Group;
    Y.anova1.alpha  = 0.05;
    Y.anova1.ctype  = 'bonferroni';

    [Y.anova1.p,Y.anova1.table,Y.anova1.stats] = anova1(Y.anova1.Data,Y.anova1.Group,'off');
    [Y.anova1.multcompare.comparison,Y.anova1.means,Y.anova1.h,Y.anova1.gnames] = multcompare(Y.anova1.stats,...
        'alpha',Y.anova1.alpha,...
        'display','off',...
        'ctype',Y.anova1.ctype);
    ncomp   = size(Y.anova1.multcompare.comparison,1);
    Y.anova1.multcompare.alpha  = Y.anova1.alpha ./ ncomp;  % Bonferroni's correction
    Y.anova1.multcompare.alpha_corrected    = Y.anova1.alpha;
    Y.anova1.multcompare.p      = zeros(ncomp,1);
    Y.anova1.multcompare.p_corrected      = zeros(ncomp,1);
    Y.anova1.multcompare.issig  = false(ncomp,1);
    for icomp=1:ncomp
        [Y.anova1.multcompare.issig(icomp),Y.anova1.multcompare.p(icomp)]   = ttest2(Y.anova1.Data(Y.anova1.Group==Y.anova1.multcompare.comparison(icomp,1)),...
            Y.anova1.Data(Y.anova1.Group==Y.anova1.multcompare.comparison(icomp,2)),...
            Y.anova1.multcompare.alpha,...
            'both','equal');
    end
    Y.anova1.multcompare.p_corrected = min(Y.anova1.multcompare.p * ncomp,1);
    
end



S.sort.(CompName)  = Y;