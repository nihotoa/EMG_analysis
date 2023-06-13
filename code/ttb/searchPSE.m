function s  = searchPSE(s,TimeWindow)


if(~isfield(s,'peaks'))
    error('データはPSEが未解析です。pse_btcを行ってください')
end

if(s.npeaks>0)

    addflag = true(1,s.npeaks);
    issig   = false(1,s.npeaks);
    issig_ttest = false(1,s.npeaks);


    for ipeak=1:s.npeaks
        addflag(ipeak) = s.peaks(ipeak).onset>=TimeWindow(1) & s.peaks(ipeak).onset<=TimeWindow(2);
        issig(ipeak)   = s.peaks(ipeak).issig;
        issig_ttest(ipeak) = s.peaks(ipeak).issig_ttest;
    end
    ind = [1:s.npeaks];


    s.search_TimeWindow  = TimeWindow;
    s.npeaksTW     = sum(addflag);
    s.peakindTW = ind(addflag);
    s.nsigpeaksTW  = sum(addflag & issig);
    s.sigpeakindTW = ind(addflag & issig);

    if(~isempty(s.sigpeakindTW))
        [temp,s.maxsigpeakindTW]  = max(abs([s.peaks(s.sigpeakindTW).peakd]));
        s.maxsigpeakindTW = s.sigpeakindTW(s.maxsigpeakindTW);
    else
        s.maxsigpeakindTW = [];
    end

    s.nsigpeaks_ttestTW  = sum(addflag & issig_ttest);
    s.sigpeakind_ttestTW = ind(addflag & issig_ttest);

    if(~isempty(s.sigpeakindTW))
        [temp,s.maxsigpeakind_ttestTW]  = max(abs([s.peaks(s.sigpeakind_ttestTW).peakd]));
        s.maxsigpeakind_ttestTW = s.sigpeakind_ttestTW(s.maxsigpeakind_ttestTW);
    else
        s.maxsigpeakind_ttestTW = [];
    end

else
    s.search_TimeWindow  = TimeWindow;
    s.npeaksTW      = 0;
    s.peakindTW     = [];
    s.nsigpeaksTW       = 0;
    s.sigpeakindTW      = [];
    s.maxsigpeakindTW   = [];
    s.nsigpeaks_ttestTW    = 0;
    s.sigpeakind_ttestTW   = [];
    s.maxsigpeakind_ttestTW= [];
end

%%%% TWのほうがかっこよくてTRから変更、今はもういらないはず。
if(isfield(s,'search_TimeRange'))
    s   = rmfield(s,{'search_TimeRange','npeaksTR','nsigpeaksTR','sigpeakindTR','maxsigpeakindTR','nsigpeaks_ttestTR','sigpeakind_ttestTR','maxsigpeakind_ttestTR','peakindTR'});
end
