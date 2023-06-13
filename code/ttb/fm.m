function [s,sdata]  = fm(s,sdata,Basetime,SearchTW,nsd,nn,kk,alpha)

if nargin<1
    %     s   = topen;
    %     Basetime    = [-1.0 -0.5];
    %     nsd         = 2;
    %     nn          = 0.16; %(sec) ‚±‚ê‚æ‚èduration‚ª’·‚¢‚à‚Ì‚¾‚¯sig‚Æ‚Ý‚È‚·
    %     kk          = 0.1; %(sec)
    %     alpha       = 0.05;
    %     SearchTW    = [0 0.3];
    return;
end

nnind       = round(nn/s.BinWidth)+1;
nn          = (nnind-1)*s.BinWidth;

kkind       = round(kk/s.BinWidth)+1;
kk          = (kkind-1)*s.BinWidth;


XData   = s.BinData;
YData   = s.YData_sps;

if(isempty(sdata.psth_TrialData_sps))
    disp('--- *** No Trial Data')
    error('No Trial Data')
end

basetimeind = (XData>=Basetime(1)&XData<=Basetime(2));

BaseMean     = mean(YData(basetimeind));
BaseSD       = std(YData(basetimeind),1);
BaseMean_Trials  = mean(sdata.psth_TrialData_sps(:,basetimeind),2);

s.base.ind      = basetimeind;
s.base.onset    = Basetime(1);
s.base.offset   = Basetime(2);
s.base.mean     = BaseMean;
s.base.sd       = BaseSD;
s.base.mean_trials   = BaseMean_Trials;
s.base.nsd      = nsd;
s.base.nnsec    = nn;
s.base.kksec    = kk;
s.base.alpha    = alpha;

% SearchTW
nTW = size(SearchTW,1);
for iTW =1:nTW
    TW     = SearchTW(iTW,:);
    TWind  = (XData>=TW(1)&XData<=TW(2));
    
    XDataTW       = XData(TWind);
    
    [TWPeak,ind]      = max(YData(TWind));
    TWPeakTime        = XDataTW(ind);
    TWPeakTime        = nearest(XData,TWPeakTime);
    TWPeakd           = TWPeak - BaseMean;
    
    TWMean     = mean(YData(TWind));
    TWSD       = std(YData(TWind),1);
    TWMean_Trials  = mean(sdata.psth_TrialData_sps(:,TWind),2);
    TWMeand           = TWMean - BaseMean;

    s.TW(iTW).ind      = TWind;
    s.TW(iTW).onset    = TW(1);
    s.TW(iTW).offset   = TW(2);
    s.TW(iTW).peaktime  = TWPeakTime;
    s.TW(iTW).peak      = TWPeak;
    s.TW(iTW).mean     = TWMean;
    s.TW(iTW).sd       = TWSD;
    s.TW(iTW).mean_trials   = TWMean_Trials;
    s.TW(iTW).peakd     = TWPeakd;
    s.TW(iTW).meand     = TWMeand;

    [sigp,issig,stats]    = signrank(s.TW(iTW).mean_trials,s.base.mean_trials,'alpha',alpha);
    [issig_ttest,sigp_ttest,CI_ttest,stats_ttest]    = ttest(s.TW(iTW).mean_trials,s.base.mean_trials,alpha,'both');
    s.TW(iTW).p             = sigp;
    s.TW(iTW).issig         = issig;
    s.TW(iTW).stats         = stats;
    s.TW(iTW).p_ttest       = sigp_ttest;
    s.TW(iTW).issig_ttest   = issig_ttest;
    s.TW(iTW).stats_ttest   = stats_ttest;

end

s.sigTWind= find([s.TW(:).issig]==1);
s.sigTWind_ttest= find([s.TW(:).issig_ttest]==1);





% find peaks
Psigind     = YData > (BaseMean+nsd*BaseSD);
Psigind     = clustvec(Psigind,kkind,nnind);
Peaks       = findclust(Psigind);

% find troughs
Tsigind     = YData < (BaseMean-nsd*BaseSD);
Tsigind     = clustvec(Tsigind,kkind,nnind);
Troughs     = findclust(Tsigind);

s.pind          = Psigind; 
s.tind          = Tsigind;

% peaks
peaks   = [];
jj  = 0;
nsigpeaks       = 0;
nsigpeaks_ttest = 0;
if(~isempty(Peaks))
    nPeaks  = length(Peaks);
    for ii  =1:nPeaks
        jj  = jj+1;
        
        sigind          = false(size(XData));
        sigind(Peaks(ii).first:Peaks(ii).last)  = 1;

        XDataPeak       = XData(sigind);

        onset           = XData(Peaks(ii).first);
        offset          = XData(Peaks(ii).last);
        duration        = offset-onset;

        [Peak,ind]      = max(YData(sigind));
        PeakTime        = XDataPeak(ind);
        [PeakTime,Peakind]  = nearest(XData,PeakTime);
        Peakd           = Peak - BaseMean;
        Mean            = mean(YData(sigind));
        Mean_Trials     = mean(sdata.psth_TrialData_sps(:,sigind),2);
        Meand           = Mean - BaseMean;
        
        [sigp,issig,stats]    = signrank(Mean_Trials,s.base.mean_trials,'alpha',alpha);
        [issig_ttest,sigp_ttest,CI_ttest,stats_ttest]    = ttest(Mean_Trials,s.base.mean_trials,alpha,'both');
        
        nsigpeaks       = nsigpeaks + issig;
        nsigpeaks_ttest = nsigpeaks_ttest + issig_ttest;
        
        peaks(jj).ind       = sigind;
        peaks(jj).onset     = onset;        %(sec)
        peaks(jj).offset    = offset;
        peaks(jj).duration  = duration;
        peaks(jj).peaktime  = PeakTime;
        peaks(jj).peak      = Peak;
        peaks(jj).mean      = Mean;
        peaks(jj).mean_trials   = Mean_Trials;
        peaks(jj).peakd     = Peakd;
        peaks(jj).meand     = Meand;
        peaks(jj).p             = sigp;
        peaks(jj).issig         = issig;
        peaks(jj).stats         = stats;
        peaks(jj).p_ttest       = sigp_ttest;
        peaks(jj).issig_ttest   = issig_ttest;
        peaks(jj).stats_ttest   = stats_ttest;
    end
end
if(~isempty(Troughs))
    nPeaks  = length(Troughs);
    for ii  =1:nPeaks
        jj  = jj+1;
        
        sigind          = false(size(XData));
        sigind(Troughs(ii).first:Troughs(ii).last)  = 1;

        XDataPeak       = XData(sigind);

        onset           = XData(Troughs(ii).first);
        offset          = XData(Troughs(ii).last);
        duration        = offset-onset;

        [Peak,ind]      = min(YData(sigind));
        PeakTime        = XDataPeak(ind);
        [PeakTime,Peakind]  = nearest(XData,PeakTime);
        Peakd           = Peak - BaseMean;
        Mean            = mean(YData(sigind));
        Mean_Trials     = mean(sdata.psth_TrialData_sps(:,sigind),2);
        Meand           = Mean - BaseMean;
        
        [sigp,issig,stats]    = signrank(Mean_Trials,s.base.mean_trials,'alpha',alpha);
        [issig_ttest,sigp_ttest,CI_ttest,stats_ttest]    = ttest(Mean_Trials,s.base.mean_trials,alpha,'both');
        
        nsigpeaks       = nsigpeaks + issig;
        nsigpeaks_ttest = nsigpeaks_ttest + issig_ttest;
        
        peaks(jj).ind       = sigind;
        peaks(jj).onset     = onset;        %(sec)
        peaks(jj).offset    = offset;
        peaks(jj).duration  = duration;
        peaks(jj).peaktime  = PeakTime;
        peaks(jj).peak      = Peak;
        peaks(jj).mean      = Mean;
        peaks(jj).mean_trials   = Mean_Trials;
        peaks(jj).peakd     = Peakd;
        peaks(jj).meand     = Meand;
        peaks(jj).p             = sigp;
        peaks(jj).issig         = issig;
        peaks(jj).stats         = stats;
        peaks(jj).p_ttest       = sigp_ttest;
        peaks(jj).issig_ttest   = issig_ttest;
        peaks(jj).stats_ttest   = stats_ttest;
    end
end
s.npeaks    = jj;

s.nsigpeaks = nsigpeaks;
if(isempty(peaks))
    s.sigpeakind= [];
else
    s.sigpeakind= find([peaks(:).issig]==1);
end
if(~isempty(s.sigpeakind))
    [temp,s.maxsigpeakind]  = max(abs([peaks(s.sigpeakind).peakd]));
    s.maxsigpeakind = s.sigpeakind(s.maxsigpeakind);
else
    s.maxsigpeakind = [];
end

s.nsigpeaks_ttest   = nsigpeaks_ttest;
if(isempty(peaks))
    s.sigpeakind_ttest= [];
else
    s.sigpeakind_ttest= find([peaks(:).issig_ttest]==1);
end
if(~isempty(s.sigpeakind_ttest))
    [temp,s.maxsigpeakind_ttest]  = max(abs([peaks(s.sigpeakind_ttest).peakd]));
    s.maxsigpeakind_ttest = s.sigpeakind_ttest(s.maxsigpeakind_ttest);
else
    s.maxsigpeakind_ttest =[];
end

s.peaks     = peaks;
