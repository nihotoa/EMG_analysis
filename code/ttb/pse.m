function s  = pse(s,sdata,Basetime,SearchTW,nsd,nn,kk,alpha,nSPF,psename,method,SearchObj,sBL)

% BaseLineとは,ISADataのbasetimeの平均値をYDataのoriginalbasemeanにあわせたもの。
% すなわち、描画の時などは、YData-BaseLine+BaseMeanをすれば、ISA-adjusted YDataとなる。ISA≠BaseLine
%
% ---------------------------
% Method
%     'sdr'
% BaseLine adjustment
%     nothing
% Peak Detection
%     Basetimeの平均±nsdを、kk/nn(sec)超えている物をpeakとみなす。
%     さらに、Onset LatencyがSearchTWの範囲に入っているものを、peakTWとして選んでいる。
% Significance test of Peak
%     Peakとしてみなされた範囲のデータbasetimeのデータに対して対応のない（poolされたデータ）t検定を行う。
%
% Reference
%     None
% Example
%     pse_btc([-1.5 -1.0], [-1.5 3.0], 2, [0.1 0.1], 0.05, 1, 'pseSD1','sdr','any')
%
% ---------------------------
% Method
%     'normal'
% BaseLine adjustment
%     nothing
% Peak Detection
%     Basetimeの平均±nsdを、kk/nn(sec)超えている物をpeakとみなす。
%     さらに、Onset LatencyがSearchTWの範囲に入っているものを、peakTWとして選んでいる。
% Significance test of Peak
%     Multiple fragment method (MF method, Polyakov 1998). Peakとしてみなされた期間のデータについて、TrialをnSPF(number of spikes per fragment)に分けて各々の平均を取る。
%     同様にBasemeanの平均もfragmentに分けて平均を取り、両者のpaired-ttestを行う。
%     nSPF=1とすると、MFmethodを使わずに全Trial対に対してpaired ttestを行う。
% Reference
%     None
% Example
%     pse_btc([-0.03 -0.01],[-0.01 -0.02],3,[0.001 0.002],0.01/20,1,'pseN1','normal','any');
%
% ---------------------------
% Method
%     'ttest'
% BaseLine adjustment
%     nothing
% Peak Detection
%     Basetimeの平均と各時間データをMultiple fragment methodによってfragmentに分けてpaired ttestを行う。
%     このttestで有意な点が、kk/nn(sec)以上続いているものをpeakとみなす。
%     さらに、Onset LatencyがSearchTWの範囲に入っているものを、peakTWとして選んでいる。
% Significance test of Peak
%     Multiple fragment method (MF method, Polyakov 1998). Peakとしてみなされた期間のデータについて、TrialをnSPF(number of spikes per fragment)に分けて各々の平均を取る。
%     同様にBasemeanの平均もfragmentに分けて平均を取り、両者のpaired-ttestを行う。
%     nSPF=1とすると、MFmethodを使わずに全Trial対に対してpaired ttestを行う。
% Reference
%     None
% Example
%     pse_btc([-0.03 -0.01],[-0.01 -0.02],[],[0.001 0.002],0.01/20,1,'pseT1','ttest','any');
%
% ---------------------------
% Method
%     'schieber'
% BaseLine adjustment
%     nothing (STA作成時にISA_flagを1にしていた場合は、ISAを使ってベースラインを補正)
% Peak Detection
%     Davidson et al 2007を参照
% Significance test of Peak
%     Multiple fragment method (MF method, Polyakov 1998). Peakとしてみなされた期間のデータについて、TrialをnSPF(number of spikes per fragment)に分けて各々の平均を取る。
%     同様にBasemeanの平均もfragmentに分けて平均を取り、両者のpaired-ttestを行う。
%     nSPF=1とすると、MFmethodを使わずに全Trial対に対してpaired ttestを行う。
% Reference
%     Davidson et al, 2007
% Example
%     pse_btc([-0.03 -0.01],[0.003 0.015],2,[0 0],0.05/20,100,'pseS1','schieber',[]);
%
% ---------------------------
% Method
%     'baker'
% BaseLine adjustment
%     referenceからは不明だったので、次のLemonと一緒にしている。
% Peak Detection
%     Basetimeの平均±nsd(1)を、kk/nn(sec)超えている物をpeakとみなす。
%     さらに、Onset LatencyがSearchTWの範囲に入っているものを、peakTWとして選んでいる。
% Significance test of Peak
%     Peakのアンプリチュードがnsd(2)を超えるものを有意とみなす。
% Reference
%     Baker and Lemon 1998
% Example
%     sta_btc([-0.04 0.06],[2000 Inf],5,0,0,0,0,0)
%     pse_btc([-0.04 -0.01;-0.04 -0.015;0.045 0.06], [-0.01 0.02], [2 3.6],[0.0002 0.0002] , [], [], 'pseB1','baker','any')
%
% ---------------------------
% Method
%     'lemon'
% BaseLine adjustment
%     linear(Basetime(2,1)からBasetime(2,2)までとBasetime(3,1)からBasetime(3,2)までのデータ（一般的に波形の一番最初と一番最後）を使って線形のフィッティングをしこれを補正する)
% Peak Detection
%     Basetimeの平均±nsdを、kk/nn(sec)超えている物をpeakとみなす。
%     さらに、Onset LatencyがSearchTWの範囲に入っているものを、peakTWとして選んでいる。
% Significance test of Peak
%     Multiple fragment method (MF method, Polyakov 1998). Peakとしてみなされた期間のデータについて、TrialをnSPF(number of spikes per fragment)に分けて各々の平均を取る。
%     同様にBasemeanの平均もfragmentに分けて平均を取り、両者のpaired-ttestを行う。
%     nSPF=1とすると、MFmethodを使わずに全Trial対に対してpaired ttestを行う。
% Reference
%
% Example
%     sta_btc([-0.04 0.06],[2000 Inf],5,0,0,0,0,0)
%     pse_btc([-0.04 -0.01;-0.04 -0.015;0.035 0.06], [-0.01 0.02], 2,[0.0002 0.0002] , 0.05, 500, 'pseL1','lemon','any')
% ---------------------------




if nargin<1
    s           = topen;
    Basetime    = [-0.03 -0.01];
    nsd         = 2;
    nn          = 0.003; %(sec) これよりdurationが長いものだけsigとみなす
    kk          = 0.002; %(sec)
    alpha       = 0.01;
    nSPF        = 1;    % number of spikes per fragment
    SearchTW    = [-0.01 0.02];
    SearchObj   = 'any';   % 'onset' 'peak' 'any'
    method      = 'normal';
    sBL         = [];
elseif nargin<13
    sBL         = [];
end
% SearchTW(1)     = max(SearchTW(1),s.TimeRange(1));
% SearchTW(2)     = min(SearchTW(2),s.TimeRange(2));



switch lower(method)
    case 'sdr'            %% sdr
        if(isempty(sBL))
            YData   = s.YData;
            XData   = s.XData;
            BLYData  = s.YData;
            BLXData  = s.XData;
        else
            YData   = s.YData;
            XData   = s.XData;
            BLYData = sBL.YData;
            BLXData = sBL.XData;
        end
        
        SampleRate  = 1 / (XData(2)-XData(1));

        basetimeind = (BLXData>=Basetime(1)&BLXData<=Basetime(2));
        BaseMean    = mean(BLYData(basetimeind));
        BaseSD      = std(BLYData(basetimeind),1);

        BaseLine    = ones(size(XData))*BaseMean;

        nnind       = round(nn*SampleRate);
        nn          = nnind / SampleRate;

        kkind       = round(kk*SampleRate);
        kk          = kkind / SampleRate;


        % find peaks
        Psigind     = YData > (BaseMean+nsd*BaseSD);
        Psigind     = clustvec(Psigind,kkind,nnind);
        Peaks       = findclust(Psigind);

        % find troughs
        Tsigind     = YData < (BaseMean-nsd*BaseSD);
        Tsigind     = clustvec(Tsigind,kkind,nnind);
        Troughs     = findclust(Tsigind);

        s.method        = 'sdr';
        s.pind          = Psigind;
        s.tind          = Tsigind;
        if(~isempty(sBL))
            s.base.ReferenceName    = sBL.Name;
        end
        s.BaseLine = BaseLine;
        s.base.ind      = basetimeind;
        s.base.onset    = Basetime(1);
        s.base.offset   = Basetime(2);
        s.base.mean     = BaseMean;
        s.base.sd       = BaseSD;
        s.base.nsd      = nsd;
        s.base.nnsec    = nn;
        s.base.kksec    = kk;
        s.base.alpha    = alpha;


        peaks   = [];
        jj  = 0;
        nsigpeaks       = 0;

        if(~isempty(Peaks))
            nPeaks  = length(Peaks);
            for ii  =1:nPeaks
                jj  = jj+1;

                sigind          = false(size(s.XData));
                sigind(Peaks(ii).first:Peaks(ii).last)  = 1;

                onset           = s.XData(Peaks(ii).first);
                offset          = s.XData(Peaks(ii).last);
                duration        = offset-onset;

                XDataPeak       = s.XData(sigind);
                [Peak,ind]      = max(YData(sigind));
                PeakTime        = XDataPeak(ind);
                [PeakTime,Peakind]  = nearest(s.XData,PeakTime);
                Peakd           = Peak - BaseMean;

                Mean            = mean(YData(sigind));
                Meand           = Mean - BaseMean;

                PPI             = (Peak - BaseMean) / BaseMean * 100;
                MPI             = (Mean - BaseMean) / BaseMean * 100;
                API             = MPI*duration; % (% * sec)

                [ind,HM]        = pwhm(YData-BaseMean,1,sigind);
                PWHM_onset      = s.XData(ind(1));
                PWHM_offset     = s.XData(ind(2));
                PWHM_duration   = PWHM_offset - PWHM_onset;
                PWHM_halfmax    = HM + BaseMean;


                [issig,sigp,CI,stats]    = ttest2(YData(sigind),YData(basetimeind),alpha,'both');
                nsigpeaks       = nsigpeaks + issig;

                peaks(jj).ind       = sigind;
                peaks(jj).onset     = onset;        %(sec)
                peaks(jj).offset    = offset;
                peaks(jj).duration  = duration;
                peaks(jj).peaktime  = PeakTime;
                peaks(jj).peak      = Peak;
                peaks(jj).mean      = Mean;
                peaks(jj).peakd     = Peakd;
                peaks(jj).meand     = Meand;
                peaks(jj).PPI       = PPI;
                peaks(jj).MPI       = MPI;
                peaks(jj).API       = API;
                peaks(jj).PWHM_onset    = PWHM_onset;
                peaks(jj).PWHM_offset   = PWHM_offset;
                peaks(jj).PWHM_duration = PWHM_duration;
                peaks(jj).PWHM_halfmax  = PWHM_halfmax;
                peaks(jj).p             = sigp;
                peaks(jj).issig         = issig;
                peaks(jj).stats         = stats;
            end
        end
        if(~isempty(Troughs))
            nPeaks  = length(Troughs);
            for ii  =1:nPeaks
                jj  = jj+1;

                sigind          = false(size(s.XData));
                sigind(Troughs(ii).first:Troughs(ii).last)  = 1;

                onset           = s.XData(Troughs(ii).first);
                offset          = s.XData(Troughs(ii).last);
                duration        = offset-onset;

                XDataPeak       = s.XData(sigind);
                [Peak,ind]      = min(YData(sigind));
                PeakTime        = XDataPeak(ind);
                [PeakTime,Peakind]  = nearest(s.XData,PeakTime);
                Peakd           = Peak - BaseMean;

                Mean            = mean(YData(sigind));
                Meand           = Mean - BaseMean;

                PPI             = (Peak - BaseMean) / BaseMean * 100;
                MPI             = (Mean - BaseMean) / BaseMean * 100;
                API             = MPI*duration; % (% * sec)

                [ind,HM]        = pwhm(YData-BaseMean,0,sigind);
                PWHM_onset      = s.XData(ind(1));
                PWHM_offset     = s.XData(ind(2));
                PWHM_duration   = PWHM_offset - PWHM_onset;
                PWHM_halfmax    = HM + BaseMean;


                [issig,sigp,CI,stats]    = ttest2(YData(sigind),YData(basetimeind),alpha,'both');
                nsigpeaks       = nsigpeaks + issig;

                peaks(jj).ind       = sigind;
                peaks(jj).onset     = onset;        %(sec)
                peaks(jj).offset    = offset;
                peaks(jj).duration  = duration;
                peaks(jj).peaktime  = PeakTime;
                peaks(jj).peak      = Peak;
                peaks(jj).mean      = Mean;
                peaks(jj).peakd     = Peakd;
                peaks(jj).meand     = Meand;
                peaks(jj).PPI       = PPI;
                peaks(jj).MPI       = MPI;
                peaks(jj).API       = API;
                peaks(jj).PWHM_onset    = PWHM_onset;
                peaks(jj).PWHM_offset   = PWHM_offset;
                peaks(jj).PWHM_duration = PWHM_duration;
                peaks(jj).PWHM_halfmax  = PWHM_halfmax;
                peaks(jj).p             = sigp;
                peaks(jj).issig         = issig;
                peaks(jj).stats         = stats;
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

        s.peaks     = peaks;

        s   = searchPSE(s,SearchTW,SearchObj);
        s   = packPSE(s,psename);


    case 'normal'            %% normal

        YData   = s.YData;
        XData   = s.XData;
        
        SampleRate  = 1 / (XData(2)-XData(1));


        if(s.nTrials<nSPF)
            nMF     = 1;
            nSPF    = s.nTrials;
            disp('nTrialsはnSPFより小さいです。')
        else
            nMF     = floor(s.nTrials./nSPF);
        end


        basetimeind = (XData>=Basetime(1)&XData<=Basetime(2));
        BaseMean    = mean(YData(basetimeind));
        BaseSD      = std(YData(basetimeind),1);
        BaseMean_Trials  = mean(sdata.TrialData(:,basetimeind),2);

        BaseLine    = ones(size(XData))*BaseMean;

        nnind       = round(nn*SampleRate);
        nn          = nnind / SampleRate;

        kkind       = round(kk*SampleRate);
        kk          = kkind / SampleRate;

        if(isempty(sdata.TrialData))
            s.(psename).method  = 'normal';
            s.(psename).nsd     = nsd;
            s.(psename).nnsec   = nn;
            s.(psename).kksec   = kk;
            s.(psename).alpha   = alpha;
            s.(psename).nSPF    = nSPF;
            s.(psename).nMF     = nMF;
            s.(psename).pind    = false(size(s.XData));
            s.(psename).tind    = false(size(s.XData));


            s.(psename).BaseLine   = BaseLine;
            s.(psename).base.ind    = basetimeind;
            s.(psename).base.onset  = Basetime(1);
            s.(psename).base.offset = Basetime(2);
            s.(psename).base.mean   = 0;
            s.(psename).base.sd     = 0;
            s.(psename).base.mean_trials= 0;
            s.(psename).base.mean_MF= 0;

            s.(psename).npeaks      = 0;
            s.(psename).nsigpeaks   = 0;
            s.(psename).sigpeakind  = [];
            s.(psename).peaks           = [];
            s.(psename).maxsigpeakind   = [];
            s.(psename).search_TimeWindow   = SearchTW;
            s.(psename).npeaksTW        = 0;
            s.(psename).peakindTW       = [];
            s.(psename).nsigpeaksTW     = 0;
            s.(psename).sigpeakindTW    = [];
            s.(psename).maxsigpeakindTW = [];

            return;
        end
        % find peaks
        Psigind     = YData > (BaseMean+nsd*BaseSD);
        Psigind     = clustvec(Psigind,kkind,nnind);
        Peaks       = findclust(Psigind);

        % find troughs
        Tsigind     = YData < (BaseMean-nsd*BaseSD);
        Tsigind     = clustvec(Tsigind,kkind,nnind);
        Troughs     = findclust(Tsigind);

        s.method        = 'normal';
        s.pind          = Psigind;
        s.tind          = Tsigind;
        s.BaseLine = BaseLine;
        s.base.ind      = basetimeind;
        s.base.onset    = Basetime(1);
        s.base.offset   = Basetime(2);
        s.base.mean     = BaseMean;
        s.base.sd       = BaseSD;
        s.base.mean_trials  = BaseMean_Trials;
        s.base.mean_MF      = mean(reshape(BaseMean_Trials(1:nSPF*nMF),nSPF,nMF),1);
        s.base.nsd      = nsd;
        s.base.nnsec    = nn;
        s.base.kksec    = kk;
        s.base.alpha    = alpha;
        s.base.nSPF     = nSPF;
        s.base.nMF      = nMF;

        peaks   = [];
        jj  = 0;
        nsigpeaks       = 0;
        %         nsigpeaks_ttest = 0;

        if(~isempty(Peaks))
            nPeaks  = length(Peaks);
            for ii  =1:nPeaks
                jj  = jj+1;

                sigind          = false(size(s.XData));
                sigind(Peaks(ii).first:Peaks(ii).last)  = 1;

                onset           = s.XData(Peaks(ii).first);
                offset          = s.XData(Peaks(ii).last);
                duration        = offset-onset;

                XDataPeak       = s.XData(sigind);
                [Peak,ind]      = max(YData(sigind));
                PeakTime        = XDataPeak(ind);
                [PeakTime,Peakind]  = nearest(s.XData,PeakTime);
                Peakd           = Peak - BaseMean;

                Mean            = mean(YData(sigind));
                Mean_Trials     = mean(sdata.TrialData(:,sigind),2);
                Meand           = Mean - BaseMean;

                PPI             = (Peak - BaseMean) / BaseMean * 100;
                MPI             = (Mean - BaseMean) / BaseMean * 100;
                API             = MPI*duration; % (% * sec)

                [ind,HM]        = pwhm(YData-BaseMean,1,sigind);
                PWHM_onset      = s.XData(ind(1));
                PWHM_offset     = s.XData(ind(2));
                PWHM_duration   = PWHM_offset - PWHM_onset;
                PWHM_halfmax    = HM + BaseMean;


                Mean_MF         = mean(reshape(Mean_Trials(1:nSPF*nMF),nSPF,nMF),1);

                [issig,sigp,CI,stats]    = ttest(Mean_MF,s.base.mean_MF,alpha,'both');
                nsigpeaks       = nsigpeaks + issig;

                peaks(jj).ind       = sigind;
                peaks(jj).onset     = onset;        %(sec)
                peaks(jj).offset    = offset;
                peaks(jj).duration  = duration;
                peaks(jj).peaktime  = PeakTime;
                peaks(jj).peak      = Peak;
                peaks(jj).mean      = Mean;
                peaks(jj).mean_trials   = Mean_Trials;
                peaks(jj).mean_MF   = Mean_MF;
                peaks(jj).peakd     = Peakd;
                peaks(jj).meand     = Meand;
                peaks(jj).PPI       = PPI;
                peaks(jj).MPI       = MPI;
                peaks(jj).API       = API;
                peaks(jj).PWHM_onset    = PWHM_onset;
                peaks(jj).PWHM_offset   = PWHM_offset;
                peaks(jj).PWHM_duration = PWHM_duration;
                peaks(jj).PWHM_halfmax  = PWHM_halfmax;
                peaks(jj).p             = sigp;
                peaks(jj).issig         = issig;
                peaks(jj).stats         = stats;
            end
        end
        if(~isempty(Troughs))
            nPeaks  = length(Troughs);
            for ii  =1:nPeaks
                jj  = jj+1;

                sigind          = false(size(s.XData));
                sigind(Troughs(ii).first:Troughs(ii).last)  = 1;

                onset           = s.XData(Troughs(ii).first);
                offset          = s.XData(Troughs(ii).last);
                duration        = offset-onset;

                XDataPeak       = s.XData(sigind);
                [Peak,ind]      = min(YData(sigind));
                PeakTime        = XDataPeak(ind);
                [PeakTime,Peakind]  = nearest(s.XData,PeakTime);
                Peakd           = Peak - BaseMean;

                Mean            = mean(YData(sigind));
                Mean_Trials     = mean(sdata.TrialData(:,sigind),2);
                Meand           = Mean - BaseMean;

                PPI             = (Peak - BaseMean) / BaseMean * 100;
                MPI             = (Mean - BaseMean) / BaseMean * 100;
                API             = MPI*duration; % (% * sec)

                [ind,HM]        = pwhm(YData-BaseMean,0,sigind);
                PWHM_onset      = s.XData(ind(1));
                PWHM_offset     = s.XData(ind(2));
                PWHM_duration   = PWHM_offset - PWHM_onset;
                PWHM_halfmax    = HM + BaseMean;


                Mean_MF         = mean(reshape(Mean_Trials(1:nSPF*nMF),nSPF,nMF),1);

                [issig,sigp,CI,stats]    = ttest(Mean_MF,s.base.mean_MF,alpha,'both');
                nsigpeaks       = nsigpeaks + issig;

                peaks(jj).ind       = sigind;
                peaks(jj).onset     = onset;        %(sec)
                peaks(jj).offset    = offset;
                peaks(jj).duration  = duration;
                peaks(jj).peaktime  = PeakTime;
                peaks(jj).peak      = Peak;
                peaks(jj).mean      = Mean;
                peaks(jj).mean_trials   = Mean_Trials;
                peaks(jj).mean_MF   = Mean_MF;
                peaks(jj).peakd     = Peakd;
                peaks(jj).meand     = Meand;
                peaks(jj).PPI       = PPI;
                peaks(jj).MPI       = MPI;
                peaks(jj).API       = API;
                peaks(jj).PWHM_onset    = PWHM_onset;
                peaks(jj).PWHM_offset   = PWHM_offset;
                peaks(jj).PWHM_duration = PWHM_duration;
                peaks(jj).PWHM_halfmax  = PWHM_halfmax;
                peaks(jj).p             = sigp;
                peaks(jj).issig         = issig;
                peaks(jj).stats         = stats;
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

        s.peaks     = peaks;

        s   = searchPSE(s,SearchTW,SearchObj);
        s   = packPSE(s,psename);

    case 'ttest'            %% ttest

        YData   = s.YData;
        XData   = s.XData;
        
        SampleRate  = 1 / (XData(2)-XData(1));


        if(s.nTrials<nSPF)
            nMF     = 1;
            nSPF    = s.nTrials;
            disp('nTrialsはnSPFより小さいです。')
        else
            nMF     = floor(s.nTrials./nSPF);
        end


        basetimeind = (XData>=Basetime(1)&XData<=Basetime(2));
        BaseMean    = mean(YData(basetimeind));
        BaseSD      = std(YData(basetimeind),1);
        BaseMean_Trials  = mean(sdata.TrialData(:,basetimeind),2);

        BaseLine    = ones(size(XData))*BaseMean;

        nnind       = round(nn*SampleRate)+1;
        nn          = (nnind-1)/SampleRate;

        kkind       = round(kk*SampleRate)+1;
        kk          = (kkind-1)/SampleRate;

        if(isempty(sdata.TrialData))
            %             disp('--- *** No Trial Data')
            %             error('No Trial Data')
            s.(psename).method  = 'ttest';
            s.(psename).nsd     = nsd;
            s.(psename).nnsec   = nn;
            s.(psename).kksec   = kk;
            s.(psename).alpha   = alpha;
            s.(psename).nSPF    = nSPF;
            s.(psename).nMF     = nMF;
            s.(psename).pind    = false(size(s.XData));
            s.(psename).tind    = false(size(s.XData));


            s.(psename).BaseLine   = BaseLine;
            s.(psename).base.ind    = basetimeind;
            s.(psename).base.onset  = Basetime(1);
            s.(psename).base.offset = Basetime(2);
            s.(psename).base.mean   = 0;
            s.(psename).base.sd     = 0;
            s.(psename).base.mean_trials= 0;
            s.(psename).base.mean_MF= 0;

            s.(psename).npeaks      = 0;
            s.(psename).nsigpeaks   = 0;
            s.(psename).sigpeakind  = [];
            s.(psename).peaks           = [];
            s.(psename).maxsigpeakind   = [];
            s.(psename).search_TimeWindow   = SearchTW;
            s.(psename).npeaksTW        = 0;
            s.(psename).peakindTW       = [];
            s.(psename).nsigpeaksTW     = 0;
            s.(psename).sigpeakindTW    = [];
            s.(psename).maxsigpeakindTW = [];

            return;
        end
        % find peaks
        nData   = length(YData);
        Psigind = false(size(YData));
        Tsigind = Psigind;


        s.method        = 'ttest';
        s.pind          = Psigind;
        s.tind          = Tsigind;
        s.BaseLine = BaseLine;
        s.base.ind      = basetimeind;
        s.base.onset    = Basetime(1);
        s.base.offset   = Basetime(2);
        s.base.mean     = BaseMean;
        s.base.sd       = BaseSD;
        s.base.mean_trials  = BaseMean_Trials;
        s.base.mean_MF      = mean(reshape(BaseMean_Trials(1:nSPF*nMF),nSPF,nMF),1);
        s.base.nsd      = nsd;
        s.base.nnsec    = nn;
        s.base.kksec    = kk;
        s.base.alpha    = alpha;
        s.base.nSPF     = nSPF;
        s.base.nMF      = nMF;


        for iData   =1:nData
            Mean_MF    = mean(reshape(sdata.TrialData(1:nSPF*nMF,iData),nSPF,nMF),1);
            if(ttest(s.base.mean_MF,Mean_MF,alpha/2,'left')==1)
                Psigind(iData)  = true;
            end
            if(ttest(s.base.mean_MF,Mean_MF,alpha/2,'right')==1)
                Tsigind(iData)  = true;
            end
        end

        %         Psigind     = YData > (BaseMean+nsd*BaseSD);
        Psigind     = clustvec(Psigind,kkind,nnind);
        Peaks       = findclust(Psigind);

        % find troughs
        %         Tsigind     = YData < (BaseMean-nsd*BaseSD);
        Tsigind     = clustvec(Tsigind,kkind,nnind);
        Troughs     = findclust(Tsigind);

        peaks   = [];
        jj  = 0;
        nsigpeaks       = 0;

        if(~isempty(Peaks))
            nPeaks  = length(Peaks);
            for ii  =1:nPeaks
                jj  = jj+1;

                sigind          = false(size(s.XData));
                sigind(Peaks(ii).first:Peaks(ii).last)  = 1;

                onset           = s.XData(Peaks(ii).first);
                offset          = s.XData(Peaks(ii).last);
                duration        = offset-onset;

                XDataPeak       = s.XData(sigind);
                [Peak,ind]      = max(YData(sigind));
                PeakTime        = XDataPeak(ind);
                [PeakTime,Peakind]  = nearest(s.XData,PeakTime);
                Peakd           = Peak - BaseMean;

                Mean            = mean(YData(sigind));
                Mean_Trials     = mean(sdata.TrialData(:,sigind),2);
                Meand           = Mean - BaseMean;

                PPI             = (Peak - BaseMean) / BaseMean * 100;
                MPI             = (Mean - BaseMean) / BaseMean * 100;
                API             = MPI*duration; % (% * sec)

                [ind,HM]        = pwhm(YData-BaseMean,1,sigind);
                PWHM_onset      = s.XData(ind(1));
                PWHM_offset     = s.XData(ind(2));
                PWHM_duration   = PWHM_offset - PWHM_onset;
                PWHM_halfmax    = HM + BaseMean;


                Mean_MF         = mean(reshape(Mean_Trials(1:nSPF*nMF),nSPF,nMF),1);

                [issig,sigp,CI,stats]    = ttest(Mean_MF,s.base.mean_MF,alpha,'both');
                nsigpeaks       = nsigpeaks + issig;


                peaks(jj).ind       = sigind;
                peaks(jj).onset     = onset;        %(sec)
                peaks(jj).offset    = offset;
                peaks(jj).duration  = duration;
                peaks(jj).peaktime  = PeakTime;
                peaks(jj).peak      = Peak;
                peaks(jj).mean      = Mean;
                peaks(jj).mean_trials   = Mean_Trials;
                peaks(jj).mean_MF   = Mean_MF;
                peaks(jj).peakd     = Peakd;
                peaks(jj).meand     = Meand;
                peaks(jj).PPI       = PPI;
                peaks(jj).MPI       = MPI;
                peaks(jj).API       = API;
                peaks(jj).PWHM_onset    = PWHM_onset;
                peaks(jj).PWHM_offset   = PWHM_offset;
                peaks(jj).PWHM_duration = PWHM_duration;
                peaks(jj).PWHM_halfmax  = PWHM_halfmax;
                peaks(jj).p             = sigp;
                peaks(jj).issig         = issig;
                peaks(jj).stats         = stats;
            end
        end
        if(~isempty(Troughs))
            nPeaks  = length(Troughs);
            for ii  =1:nPeaks
                jj  = jj+1;

                sigind          = false(size(s.XData));
                sigind(Troughs(ii).first:Troughs(ii).last)  = 1;

                onset           = s.XData(Troughs(ii).first);
                offset          = s.XData(Troughs(ii).last);
                duration        = offset-onset;

                XDataPeak       = s.XData(sigind);
                [Peak,ind]      = min(YData(sigind));
                PeakTime        = XDataPeak(ind);
                [PeakTime,Peakind]  = nearest(s.XData,PeakTime);
                Peakd           = Peak - BaseMean;

                Mean            = mean(YData(sigind));
                Mean_Trials     = mean(sdata.TrialData(:,sigind),2);
                Meand           = Mean - BaseMean;

                PPI             = (Peak - BaseMean) / BaseMean * 100;
                MPI             = (Mean - BaseMean) / BaseMean * 100;
                API             = MPI*duration; % (% * sec)

                [ind,HM]        = pwhm(YData-BaseMean,0,sigind);
                PWHM_onset      = s.XData(ind(1));
                PWHM_offset     = s.XData(ind(2));
                PWHM_duration   = PWHM_offset - PWHM_onset;
                PWHM_halfmax    = HM + BaseMean;


                Mean_MF         = mean(reshape(Mean_Trials(1:nSPF*nMF),nSPF,nMF),1);

                [issig,sigp,CI,stats]    = ttest(Mean_MF,s.base.mean_MF,alpha,'both');
                nsigpeaks       = nsigpeaks + issig;

                peaks(jj).ind       = sigind;
                peaks(jj).onset     = onset;        %(sec)
                peaks(jj).offset    = offset;
                peaks(jj).duration  = duration;
                peaks(jj).peaktime  = PeakTime;
                peaks(jj).peak      = Peak;
                peaks(jj).mean      = Mean;
                peaks(jj).mean_trials   = Mean_Trials;
                peaks(jj).mean_MF   = Mean_MF;
                peaks(jj).peakd     = Peakd;
                peaks(jj).meand     = Meand;
                peaks(jj).PPI       = PPI;
                peaks(jj).MPI       = MPI;
                peaks(jj).API       = API;
                peaks(jj).PWHM_onset    = PWHM_onset;
                peaks(jj).PWHM_offset   = PWHM_offset;
                peaks(jj).PWHM_duration = PWHM_duration;
                peaks(jj).PWHM_halfmax  = PWHM_halfmax;
                peaks(jj).p             = sigp;
                peaks(jj).issig         = issig;
                peaks(jj).stats         = stats;
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

        s.peaks     = peaks;

        s   = searchPSE(s,SearchTW,SearchObj);
        s   = packPSE(s,psename);


    case 'schieber'        % schieber method
        %% schieber

        YData   = s.YData;
        XData   = s.XData;

        SampleRate  = 1 / (XData(2)-XData(1));


        basetimeind = (XData>=Basetime(1)&XData<=Basetime(2));
        oBaseMean   = mean(YData(basetimeind));

        if(~isfield(s,'ISAData'))   % ISAなしで解析した場合は、YDataのbasemean(constant)をbaselineとする
            BaseLine    = ones(size(YData))*oBaseMean;
        else
            BaseLine    = s.ISAData;
        end

        if(~isfield(sdata,'ISATrialData'))
            BaseLineTrialData   = repmat(BaseLine,s.nTrials,1);
        else
            BaseLineTrialData   = sdata.ISATrialData;
        end

        if(s.nTrials<nSPF)
            nMF     = 1;
            nSPF    = s.nTrials;
        else
            nMF     = floor(s.nTrials./nSPF);
        end

        if(size(SearchTW,1)==1)
            testind = (s.XData>=SearchTW(1)&s.XData<=SearchTW(2));
            contind  = (s.XData>=(SearchTW(1)-0.01) & s.XData<(SearchTW(1))) | (s.XData>(SearchTW(2)) & s.XData<=(SearchTW(2) + 0.01));
        elseif(size(SearchTW,1)==2)
            testind = (s.XData>=SearchTW(1,1)&s.XData<=SearchTW(1,2));
            contind  = (s.XData>=SearchTW(2,1) & s.XData<(SearchTW(2,2)));
        elseif(size(SearchTW,1)==3)
            testind = (s.XData>=SearchTW(1,1)&s.XData<=SearchTW(1,2));
            contind  = (s.XData>=SearchTW(2,1) & s.XData<(SearchTW(2,2))) | (s.XData>SearchTW(3,1) & s.XData<=(SearchTW(3,2)));
        end
            
            



        nnind       = round(nn*SampleRate)+1;
        nn          = (nnind-1)/SampleRate;

        kkind       = round(kk*SampleRate)+1;
        kk          = (kkind-1)/SampleRate;


        if(isempty(sdata.TrialData))
            %             disp('--- *** No Trial Data')
            %             error('No Trial Data')

            s.(psename).method   = 'schieber';
            s.(psename).nsd      = nsd;
            s.(psename).nnsec    = nn;
            s.(psename).kksec    = kk;
            s.(psename).alpha    = alpha;
            s.(psename).nSPF     = nSPF;
            s.(psename).nMF      = nMF;

            s.(psename).p        = 1.0;
            s.(psename).npeaks      = 0;
            s.(psename).nsigpeaks   = 0;
            s.(psename).sigpeakind	= [];
            s.(psename).maxsigpeakind   = [];
            s.(psename).search_TimeWindow   = SearchTW;
            s.(psename).npeaksTW    = 0;
            s.(psename).peakindTW   = [];
            s.(psename).nsigpeaksTW = 0;
            s.(psename).sigpeakindTW= [];
            s.(psename).maxsigpeakindTW = [];

            s.(psename).BaseLine = BaseLine-mean(BaseLine(basetimeind))+oBaseMean;
            % BaseLineとはISADataのbasetimeの平均値をYDataのoriginalbasemeanにあわせたもの。
            % すなわち、描画の時などは、YData-BaseLine+BaseMeanをすれば、ISA-adjusted YDataとなる。;
            s.(psename).base.ind      = basetimeind;
            s.(psename).base.onset    = Basetime(1);
            s.(psename).base.offset   = Basetime(2);
            s.(psename).base.mean     = 0;
            s.(psename).base.sd       = 0;

            s.(psename).peaks.ind       = [];
            s.(psename).peaks.onset     = [];        %(sec)
            s.(psename).peaks.offset    = [];
            s.(psename).peaks.duration  = [];
            s.(psename).peaks.peaktime  = [];
            s.(psename).peaks.peak      = [];
            s.(psename).peaks.mean      = [];
            s.(psename).peaks.peakd     = [];
            s.(psename).peaks.meand     = [];
            s.(psename).peaks.PPI       = [];
            s.(psename).peaks.MPI       = [];
            s.(psename).peaks.API       = [];
            s.(psename).peaks.PWHM_onset    = [];
            s.(psename).peaks.PWHM_offset   = [];
            s.(psename).peaks.PWHM_duration = [];
            s.(psename).peaks.PWHM_halfmax  = [];
            s.(psename).peaks.p             = [];
            s.(psename).peaks.issig         = [];
            s.(psename).peaks.stats         = [];

            return;
        end



        YData               = YData - BaseLine + oBaseMean;
        sdata.TrialData     = sdata.TrialData - BaseLineTrialData + repmat(mean(sdata.TrialData(:,basetimeind),2),size(YData));

        ContMean_Trials     = mean(sdata.TrialData(:,contind),2);
        TestMean_Trials     = mean(sdata.TrialData(:,testind),2);

        ContMean_MF         = mean(reshape(ContMean_Trials(1:nSPF*nMF),nSPF,nMF),1);
        TestMean_MF         = mean(reshape(TestMean_Trials(1:nSPF*nMF),nSPF,nMF),1);
        
        sigtest = 'ttest';
        switch sigtest
            case 'signrank'
                [sigp,issig,stats]  = signrank(TestMean_MF,ContMean_MF,'alpha',alpha);
            case 'ttest'
                [issig,sigp,ci,stats]  = ttest(TestMean_MF,ContMean_MF,alpha,'both');
        end
         

        s.(psename).method   = 'schieber';
        s.(psename).nsd      = nsd;
        s.(psename).nnsec    = nn;
        s.(psename).kksec    = kk;
        s.(psename).alpha    = alpha;
        s.(psename).nSPF     = nSPF;
        s.(psename).nMF      = nMF;
        s.(psename).p        = sigp;
        s.(psename).sigtest  = sigtest;

        BaseMean= mean(YData(basetimeind));
        BaseSD  = std(YData(basetimeind),1);

        Mean    = mean(YData(testind));
        ContMean= mean(YData(contind));

        if(Mean>=ContMean)  % facilitation
            abovesd_flag   = max(nanmask(YData,testind)) > (BaseMean + nsd*BaseSD);
        else
            abovesd_flag   = min(nanmask(YData,testind)) < (BaseMean - nsd*BaseSD);
        end

        if(issig && abovesd_flag)

            s.(psename).npeaks      = 1;
            s.(psename).nsigpeaks   = 1;
            s.(psename).sigpeakind	= 1;
            s.(psename).maxsigpeakind   = 1;
            s.(psename).search_TimeWindow   = SearchTW;
            s.(psename).npeaksTW    = 1;
            s.(psename).peakindTW   = 1;
            s.(psename).nsigpeaksTW = 1;
            s.(psename).sigpeakindTW= 1;
            s.(psename).maxsigpeakindTW = 1;

            s.(psename).BaseLine = BaseLine-mean(BaseLine(basetimeind))+oBaseMean;
            % BaseLineとはISADataのbasetimeの平均値をYDataのoriginalbasemeanにあわせたもの。
            % すなわち、描画の時などは、YData-BaseLine+BaseMeanをすれば、ISA-adjusted YDataとなる。;
            s.(psename).base.ind      = basetimeind;
            s.(psename).base.onset    = Basetime(1);
            s.(psename).base.offset   = Basetime(2);
            s.(psename).base.mean     = BaseMean;
            s.(psename).base.sd       = BaseSD;

            if(Mean>=ContMean)  % facilitation
                [Peak,Peakind]  = max(nanmask(YData,testind));
                PeakTime        = s.XData(Peakind);
                Peakd           = Peak - BaseMean;

                onsetind        = find(s.XData<=PeakTime & YData <= (BaseMean+nsd*BaseSD),1,'last')+1;
                onset           = s.XData(onsetind);
                offsetind       = find(s.XData>=PeakTime & YData <= (BaseMean+nsd*BaseSD),1,'first')-1;
                offset          = s.XData(offsetind);
                duration        = offset-onset;

                sigind             = s.XData >= onset & s.XData <= offset;

                Mean            = mean(YData(sigind));
                Meand           = Mean - BaseMean;

                PPI             = (Peak - BaseMean) / BaseMean * 100;
                MPI             = (Mean - BaseMean) / BaseMean * 100;
                API             = MPI*duration; % (% * sec)

                [ind,HM]        = pwhm(YData-BaseMean,1,sigind,'exact');
                PWHM_onset      = s.XData(ind(1));
                PWHM_offset     = s.XData(ind(2));
                PWHM_duration   = PWHM_offset - PWHM_onset;
                PWHM_halfmax    = HM + BaseMean;

                s.(psename).peaks.ind       = sigind;
                s.(psename).peaks.onset     = onset;        %(sec)
                s.(psename).peaks.offset    = offset;
                s.(psename).peaks.duration  = duration;
                s.(psename).peaks.peaktime  = PeakTime;
                s.(psename).peaks.peak      = Peak;
                s.(psename).peaks.mean      = Mean;
                s.(psename).peaks.peakd     = Peakd;
                s.(psename).peaks.meand     = Meand;
                s.(psename).peaks.PPI       = PPI;
                s.(psename).peaks.MPI       = MPI;
                s.(psename).peaks.API       = API;
                s.(psename).peaks.PWHM_onset    = PWHM_onset;
                s.(psename).peaks.PWHM_offset   = PWHM_offset;
                s.(psename).peaks.PWHM_duration = PWHM_duration;
                s.(psename).peaks.PWHM_halfmax  = PWHM_halfmax;
                s.(psename).peaks.p             = sigp;
                s.(psename).peaks.issig         = issig;
                s.(psename).peaks.stats         = stats;


            else

                [Peak,Peakind]  = min(nanmask(YData,testind));
                PeakTime        = s.XData(Peakind);
                Peakd           = Peak - BaseMean;

                onsetind        = find(s.XData<=PeakTime & YData >= (BaseMean-nsd*BaseSD),1,'last')+1;
                onset           = s.XData(onsetind);
                offsetind       = find(s.XData>=PeakTime & YData >= (BaseMean-nsd*BaseSD),1,'first')-1;
                offset          = s.XData(offsetind);
                duration        = offset-onset;

                sigind             = s.XData >= onset & s.XData <= offset;

                Mean            = mean(YData(sigind));
                Meand           = Mean - BaseMean;

                PPI             = (Peak - BaseMean) / BaseMean * 100;
                MPI             = (Mean - BaseMean) / BaseMean * 100;
                API             = MPI*duration; % (% * sec)

                [ind,HM]        = pwhm(YData-BaseMean,0,sigind,'exact');
                PWHM_onset      = s.XData(ind(1));
                PWHM_offset     = s.XData(ind(2));
                PWHM_duration   = PWHM_offset - PWHM_onset;
                PWHM_halfmax    = HM + BaseMean;

                s.(psename).peaks.ind       = sigind;
                s.(psename).peaks.onset     = onset;        %(sec)
                s.(psename).peaks.offset    = offset;
                s.(psename).peaks.duration  = duration;
                s.(psename).peaks.peaktime  = PeakTime;
                s.(psename).peaks.peak      = Peak;
                s.(psename).peaks.mean      = Mean;
                s.(psename).peaks.peakd     = Peakd;
                s.(psename).peaks.meand     = Meand;
                s.(psename).peaks.PPI       = PPI;
                s.(psename).peaks.MPI       = MPI;
                s.(psename).peaks.API       = API;
                s.(psename).peaks.PWHM_onset    = PWHM_onset;
                s.(psename).peaks.PWHM_offset   = PWHM_offset;
                s.(psename).peaks.PWHM_duration = PWHM_duration;
                s.(psename).peaks.PWHM_halfmax  = PWHM_halfmax;
                s.(psename).peaks.p             = sigp;
                s.(psename).peaks.issig         = issig;
                s.(psename).peaks.stats         = stats;

            end
            if(issig && nn > 0 && kk > 0)
                if(duration < kk)
                    s.(psename).npeaks      = 0;
                    s.(psename).nsigpeaks   = 0;
                    s.(psename).sigpeakind	= [];
                    s.(psename).maxsigpeakind   = [];
                    s.(psename).search_TimeWindow   = SearchTW;
                    s.(psename).npeaksTW    = 0;
                    s.(psename).peakindTW   = [];
                    s.(psename).nsigpeaksTW = 0;
                    s.(psename).sigpeakindTW= [];
                    s.(psename).maxsigpeakindTW = [];

                    s.(psename).BaseLine = BaseLine-mean(BaseLine(basetimeind))+oBaseMean;
                    % BaseLineとはISADataのbasetimeの平均値をYDataのoriginalbasemeanにあわせたもの。
                    % すなわち、描画の時などは、YData-BaseLine+BaseMeanをすれば、ISA-adjusted YDataとなる。;
                    s.(psename).base.onset    = Basetime(1);
                    s.(psename).base.offset   = Basetime(2);
                    s.(psename).base.mean     = BaseMean;
                    s.(psename).base.sd       = BaseSD;

                    s.(psename).peaks.ind       = [];
                    s.(psename).peaks.onset     = [];        %(sec)
                    s.(psename).peaks.offset    = [];
                    s.(psename).peaks.duration  = [];
                    s.(psename).peaks.peaktime  = [];
                    s.(psename).peaks.peak      = [];
                    s.(psename).peaks.mean      = [];
                    s.(psename).peaks.peakd     = [];
                    s.(psename).peaks.meand     = [];
                    s.(psename).peaks.PPI       = [];
                    s.(psename).peaks.MPI       = [];
                    s.(psename).peaks.API       = [];
                    s.(psename).peaks.PWHM_onset    = [];
                    s.(psename).peaks.PWHM_offset   = [];
                    s.(psename).peaks.PWHM_duration = [];
                    s.(psename).peaks.PWHM_halfmax  = [];
                    s.(psename).peaks.p             = [];
                    s.(psename).peaks.issig         = [];
                    s.(psename).peaks.stats         = [];

                end

            end

        else
            s.(psename).npeaks      = 0;
            s.(psename).nsigpeaks   = 0;
            s.(psename).sigpeakind	= [];
            s.(psename).maxsigpeakind   = [];
            s.(psename).search_TimeWindow   = SearchTW;
            s.(psename).npeaksTW    = 0;
            s.(psename).peakindTW   = [];
            s.(psename).nsigpeaksTW = 0;
            s.(psename).sigpeakindTW= [];
            s.(psename).maxsigpeakindTW = [];

            s.(psename).BaseLine = BaseLine-mean(BaseLine(basetimeind))+oBaseMean;
            % BaseLineとはISADataのbasetimeの平均値をYDataのoriginalbasemeanにあわせたもの。
            % すなわち、描画の時などは、YData-BaseLine+BaseMeanをすれば、ISA-adjusted YDataとなる。;
            s.(psename).base.onset    = Basetime(1);
            s.(psename).base.offset   = Basetime(2);
            s.(psename).base.mean     = BaseMean;
            s.(psename).base.sd       = BaseSD;

            s.(psename).peaks.ind       = [];
            s.(psename).peaks.onset     = [];        %(sec)
            s.(psename).peaks.offset    = [];
            s.(psename).peaks.duration  = [];
            s.(psename).peaks.peaktime  = [];
            s.(psename).peaks.peak      = [];
            s.(psename).peaks.mean      = [];
            s.(psename).peaks.peakd     = [];
            s.(psename).peaks.meand     = [];
            s.(psename).peaks.PPI       = [];
            s.(psename).peaks.MPI       = [];
            s.(psename).peaks.API       = [];
            s.(psename).peaks.PWHM_onset    = [];
            s.(psename).peaks.PWHM_offset   = [];
            s.(psename).peaks.PWHM_duration = [];
            s.(psename).peaks.PWHM_halfmax  = [];
            s.(psename).peaks.p             = [];
            s.(psename).peaks.issig         = [];
            s.(psename).peaks.stats         = [];

        end




    case 'baker'            %% baker
        %%
        %         signsd    = 5.7;
        %         signsd    = 3.6;    % norminv(1-(0.05/150/2),0,1)
        %         signsd    = 4.3;    % norminv(1-(0.05/150/20/2),0,1)
        signsd      = nsd(2);
        nsd         = nsd(1);

        YData       = s.YData;
        XData       = s.XData;
        
        SampleRate  = 1 / (XData(2)-XData(1));

        
        BaseLineind = (XData >= Basetime(2,1) & XData <= Basetime(2,2)) | (XData >= Basetime(3,1) & XData <= Basetime(3,2));
        basetimeind = (XData >= Basetime(1,1) & XData <= Basetime(1,2));
        P           = polyfit(XData(BaseLineind),YData(BaseLineind),1);
        BaseLine  = polyval(P,XData);

        oBaseMean   = mean(YData(basetimeind));     % とりあえずベース

        YData       = YData - BaseLine + oBaseMean;

        BaseMean    = mean(YData(basetimeind));     % あらためてベース
        BaseSD      = std(YData(basetimeind),1);

        nnind       = round(nn*SampleRate)+1;
        nn          = (nnind-1)/SampleRate;

        kkind       = round(kk*SampleRate)+1;
        kk          = (kkind-1)/SampleRate;

        if(isempty(sdata.TrialData))
            %             disp('--- *** No Trial Data')
            %             error('No Trial Data')
            s.(psename).method  = 'baker';
            s.(psename).nsd     = [nsd signsd];
            s.(psename).nnsec   = nn;
            s.(psename).kksec   = kk;
            s.(psename).alpha   = alpha;

            s.(psename).BaseLine = BaseLine-mean(BaseLine(basetimeind))+oBaseMean;
            % BaseLineとはBLDataのbasetimeの平均値をYDataのoriginalbasemeanにあわせたもの。
            % すなわち、描画の時などは、YData-BaseLine+BaseMeanをすれば、BL-adjusted YDataとなる。;
            s.(psename).base.ind    = basetimeind;
            s.(psename).base.onset  = Basetime(1);
            s.(psename).base.offset = Basetime(2);
            s.(psename).base.mean   = 0;
            s.(psename).base.sd     = 0;

            s.(psename).peaks           = [];

            s.(psename).npeaks      = 0;
            s.(psename).nsigpeaks   = 0;
            s.(psename).sigpeakind  = [];
            s.(psename).maxsigpeakind   = [];
            s.(psename).search_TimeWindow   = SearchTW;
            s.(psename).npeaksTW        = 0;
            s.(psename).peakindTW       = [];
            s.(psename).nsigpeaksTW     = 0;
            s.(psename).sigpeakindTW    = [];
            s.(psename).maxsigpeakindTW = [];
            return;
        end


        % find peaks
        Psigind     = YData > (BaseMean+nsd*BaseSD);
        Psigind     = clustvec(Psigind,kkind,nnind);
        Peaks       = findclust(Psigind);

        % find troughs
        Tsigind     = YData < (BaseMean-nsd*BaseSD);
        Tsigind     = clustvec(Tsigind,kkind,nnind);
        Troughs     = findclust(Tsigind);


        s.(psename).method  = 'baker';
        s.(psename).nsd     = [nsd signsd];
        s.(psename).nnsec   = nn;
        s.(psename).kksec   = kk;
        s.(psename).alpha   = alpha;

        s.(psename).BaseLine = BaseLine-mean(BaseLine(basetimeind))+oBaseMean;
        % BaseLineとはBLDataのbasetimeの平均値をYDataのoriginalbasemeanにあわせたもの。
        % すなわち、描画の時などは、YData-BaseLine+BaseMeanをすれば、BL-adjusted YDataとなる。;
        s.(psename).base.ind      = basetimeind;
        s.(psename).base.onset    = Basetime(1);
        s.(psename).base.offset   = Basetime(2);
        s.(psename).base.mean     = BaseMean;
        s.(psename).base.sd       = BaseSD;



        peaks   = [];
        jj  = 0;
        nsigpeaks       = 0;

        if(~isempty(Peaks))
            nPeaks  = length(Peaks);
            for ii  =1:nPeaks
                jj  = jj+1;

                sigind          = false(size(s.XData));
                sigind(Peaks(ii).first:Peaks(ii).last)  = 1;

                onset           = s.XData(Peaks(ii).first);
                offset          = s.XData(Peaks(ii).last);
                duration        = offset-onset;

                XDataPeak       = s.XData(sigind);
                [Peak,ind]      = max(YData(sigind));
                PeakTime        = XDataPeak(ind);
                [PeakTime,Peakind]  = nearest(s.XData,PeakTime);
                Peakd           = Peak - BaseMean;

                Mean            = mean(YData(sigind));
                Meand           = Mean - BaseMean;

                PPI             = (Peak - BaseMean) / BaseMean * 100;
                MPI             = (Mean - BaseMean) / BaseMean * 100;
                API             = MPI*duration; % (% * sec)

                [ind,HM]        = pwhm(YData-BaseMean,1,sigind);
                PWHM_onset      = s.XData(ind(1));
                PWHM_offset     = s.XData(ind(2));
                PWHM_duration   = PWHM_offset - PWHM_onset;
                PWHM_halfmax    = HM + BaseMean;


                if(Peak > (BaseMean + signsd * BaseSD))
                    issig   = true;
                else
                    issig   = false;
                end
                sigp        = normcdf(-Peak,BaseMean,BaseSD)*2;

                nsigpeaks       = nsigpeaks + double(issig);

                peaks(jj).ind       = sigind;
                peaks(jj).onset     = onset;        %(sec)
                peaks(jj).offset    = offset;
                peaks(jj).duration  = duration;
                peaks(jj).peaktime  = PeakTime;
                peaks(jj).peak      = Peak;
                peaks(jj).mean      = Mean;
                peaks(jj).peakd     = Peakd;
                peaks(jj).meand     = Meand;
                peaks(jj).PPI       = PPI;
                peaks(jj).MPI       = MPI;
                peaks(jj).API       = API;
                peaks(jj).PWHM_onset    = PWHM_onset;
                peaks(jj).PWHM_offset   = PWHM_offset;
                peaks(jj).PWHM_duration = PWHM_duration;
                peaks(jj).PWHM_halfmax  = PWHM_halfmax;
                peaks(jj).p             = sigp;
                peaks(jj).issig         = issig;
            end
        end
        if(~isempty(Troughs))
            nPeaks  = length(Troughs);
            for ii  =1:nPeaks
                jj  = jj+1;

                sigind          = false(size(s.XData));
                sigind(Troughs(ii).first:Troughs(ii).last)  = 1;

                onset           = s.XData(Troughs(ii).first);
                offset          = s.XData(Troughs(ii).last);
                duration        = offset-onset;

                XDataPeak       = s.XData(sigind);
                [Peak,ind]      = min(YData(sigind));
                PeakTime        = XDataPeak(ind);
                [PeakTime,Peakind]  = nearest(s.XData,PeakTime);
                Peakd           = Peak - BaseMean;

                Mean            = mean(YData(sigind));
                Meand           = Mean - BaseMean;

                PPI             = (Peak - BaseMean) / BaseMean * 100;
                MPI             = (Mean - BaseMean) / BaseMean * 100;
                API             = MPI*duration; % (% * sec)

                [ind,HM]        = pwhm(YData-BaseMean,0,sigind);
                PWHM_onset      = s.XData(ind(1));
                PWHM_offset     = s.XData(ind(2));
                PWHM_duration   = PWHM_offset - PWHM_onset;
                PWHM_halfmax    = HM + BaseMean;


                if(Peak < (BaseMean - signsd * BaseSD))
                    issig   = true;
                else
                    issig   = false;
                end
                sigp        = normcdf(Peak,BaseMean,BaseSD)*2;

                nsigpeaks       = nsigpeaks + double(issig);

                peaks(jj).ind       = sigind;
                peaks(jj).onset     = onset;        %(sec)
                peaks(jj).offset    = offset;
                peaks(jj).duration  = duration;
                peaks(jj).peaktime  = PeakTime;
                peaks(jj).peak      = Peak;
                peaks(jj).mean      = Mean;
                peaks(jj).peakd     = Peakd;
                peaks(jj).meand     = Meand;
                peaks(jj).PPI       = PPI;
                peaks(jj).MPI       = MPI;
                peaks(jj).API       = API;
                peaks(jj).PWHM_onset    = PWHM_onset;
                peaks(jj).PWHM_offset   = PWHM_offset;
                peaks(jj).PWHM_duration = PWHM_duration;
                peaks(jj).PWHM_halfmax  = PWHM_halfmax;
                peaks(jj).p             = sigp;
                peaks(jj).issig         = issig;
            end
        end
        s.(psename).peaks     = peaks;

        s.(psename).npeaks    = jj;

        s.(psename).nsigpeaks = nsigpeaks;
        if(isempty(peaks))
            s.(psename).sigpeakind= [];
        else
            s.(psename).sigpeakind= find([peaks(:).issig]==1);
        end
        if(~isempty(s.(psename).sigpeakind))
            [temp,s.(psename).maxsigpeakind]  = max(abs([peaks(s.(psename).sigpeakind).peakd]));
            s.(psename).maxsigpeakind = s.(psename).sigpeakind(s.(psename).maxsigpeakind);
        else
            s.(psename).maxsigpeakind = [];
        end



        s.(psename) = searchPSE(s.(psename),SearchTW,SearchObj);


    case 'lemon'            %% Lemon
        if(isempty(sdata.TrialData))
            disp('--- *** No Trial Data')
            error('No Trial Data')
        end

        if(s.nTrials<nSPF)
            nMF     = 1;
            nSPF    = s.nTrials;
            disp('nTrialsはnSPFより小さいです。')
        else
            nMF     = floor(s.nTrials./nSPF);
        end
        YData       = s.YData;
        XData       = s.XData;
        
        BaseLineind = (XData >= Basetime(2,1) & XData <= Basetime(2,2)) | (XData >= Basetime(3,1) & XData <= Basetime(3,2));
        basetimeind = (XData >= Basetime(1,1) & XData <= Basetime(1,2));
        P           = polyfit(XData(BaseLineind),YData(BaseLineind),1);
        BaseLine  = polyval(P,XData);

        oBaseMean   = mean(YData(basetimeind));

        nnind       = round(nn*SampleRate)+1;
        nn          = (nnind-1)/SampleRate;

        kkind       = round(kk*SampleRate)+1;
        kk          = (kkind-1)/SampleRate;

        if(isempty(sdata.TrialData))
            %             disp('--- *** No Trial Data')
            %             error('No Trial Data')
            s.(psename).method  = 'lemon';
            s.(psename).nsd     = nsd;
            s.(psename).nnsec   = nn;
            s.(psename).kksec   = kk;
            s.(psename).nSPF     = nSPF;
            s.(psename).nMF      = nMF;
            s.(psename).alpha   = alpha;

            s.(psename).BaseLine = BaseLine-mean(BaseLine(basetimeind))+oBaseMean;
            % BaseLineとはBLDataのbasetimeの平均値をYDataのoriginalbasemeanにあわせたもの。
            % すなわち、描画の時などは、YData-BaseLine+BaseMeanをすれば、BL-adjusted YDataとなる。;
            s.(psename).base.ind    = basetimeind;
            s.(psename).base.ind    = basetimeind;
            s.(psename).base.onset  = Basetime(1);
            s.(psename).base.offset = Basetime(2);
            s.(psename).base.mean   = 0;
            s.(psename).base.sd     = 0;

            s.(psename).peaks           = [];

            s.(psename).npeaks      = 0;
            s.(psename).nsigpeaks   = 0;
            s.(psename).sigpeakind  = [];
            s.(psename).maxsigpeakind   = [];
            s.(psename).search_TimeWindow   = SearchTW;
            s.(psename).npeaksTW        = 0;
            s.(psename).peakindTW       = [];
            s.(psename).nsigpeaksTW     = 0;
            s.(psename).sigpeakindTW    = [];
            s.(psename).maxsigpeakindTW = [];
            return;
        end
        
        s.(psename).method  = 'lemon';
        s.(psename).nsd     = nsd;
        s.(psename).nnsec   = nn;
        s.(psename).kksec   = kk;
        s.(psename).alpha   = alpha;
        s.(psename).nSPF     = nSPF;
        s.(psename).nMF      = nMF;
        
        
        YData       = YData - BaseLine + oBaseMean;
        sdata.TrialData = sdata.TrialData - repmat(BaseLine,s.nTrials,1) + oBaseMean;

        BaseMean    = mean(YData(basetimeind));     % あらためてベース
        BaseSD      = std(YData(basetimeind),1);

        ContMean_Trials     = mean(sdata.TrialData(:,basetimeind),2);
        ContMean_MF         = mean(reshape(ContMean_Trials(1:nSPF*nMF),nSPF,nMF),1);


        % find peaks
        Psigind     = YData > (BaseMean+nsd*BaseSD);
        Psigind     = clustvec(Psigind,kkind,nnind);
        Peaks       = findclust(Psigind);

        % find troughs
        Tsigind     = YData < (BaseMean-nsd*BaseSD);
        Tsigind     = clustvec(Tsigind,kkind,nnind);
        Troughs     = findclust(Tsigind);


        s.(psename).BaseLine = BaseLine-mean(BaseLine(basetimeind))+oBaseMean;
        % BaseLineとはBLDataのbasetimeの平均値をYDataのoriginalbasemeanにあわせたもの。
        % すなわち、描画の時などは、YData-BaseLine+BaseMeanをすれば、BL-adjusted YDataとなる。;
        s.(psename).base.ind      = basetimeind;
        s.(psename).base.onset    = Basetime(1);
        s.(psename).base.offset   = Basetime(2);
        s.(psename).base.mean     = BaseMean;
        s.(psename).base.sd       = BaseSD;



        peaks   = [];
        jj  = 0;
        nsigpeaks       = 0;

        if(~isempty(Peaks))
            nPeaks  = length(Peaks);
            for ii  =1:nPeaks
                jj  = jj+1;

                sigind          = false(size(s.XData));
                sigind(Peaks(ii).first:Peaks(ii).last)  = 1;

                onset           = s.XData(Peaks(ii).first);
                offset          = s.XData(Peaks(ii).last);
                duration        = offset-onset;

                XDataPeak       = s.XData(sigind);
                [Peak,ind]      = max(YData(sigind));
                PeakTime        = XDataPeak(ind);
                [PeakTime,Peakind]  = nearest(s.XData,PeakTime);
                Peakd           = Peak - BaseMean;

                Mean            = mean(YData(sigind));
                Meand           = Mean - BaseMean;

                PPI             = (Peak - BaseMean) / BaseMean * 100;
                MPI             = (Mean - BaseMean) / BaseMean * 100;
                API             = MPI*duration; % (% * sec)

                [ind,HM]        = pwhm(YData-BaseMean,1,sigind);
                PWHM_onset      = s.XData(ind(1));
                PWHM_offset     = s.XData(ind(2));
                PWHM_duration   = PWHM_offset - PWHM_onset;
                PWHM_halfmax    = HM + BaseMean;

                TestMean_Trials     = mean(sdata.TrialData(:,sigind),2);
                TestMean_MF         = mean(reshape(TestMean_Trials(1:nSPF*nMF),nSPF,nMF),1);

                [issig,sigp,CI,stats]    = ttest(TestMean_MF,ContMean_MF,alpha,'both');
                nsigpeaks       = nsigpeaks + double(issig);

                peaks(jj).ind       = sigind;
                peaks(jj).onset     = onset;        %(sec)
                peaks(jj).offset    = offset;
                peaks(jj).duration  = duration;
                peaks(jj).peaktime  = PeakTime;
                peaks(jj).peak      = Peak;
                peaks(jj).mean      = Mean;
                peaks(jj).peakd     = Peakd;
                peaks(jj).meand     = Meand;
                peaks(jj).PPI       = PPI;
                peaks(jj).MPI       = MPI;
                peaks(jj).API       = API;
                peaks(jj).PWHM_onset    = PWHM_onset;
                peaks(jj).PWHM_offset   = PWHM_offset;
                peaks(jj).PWHM_duration = PWHM_duration;
                peaks(jj).PWHM_halfmax  = PWHM_halfmax;
                peaks(jj).p             = sigp;
                peaks(jj).issig         = issig;
                peaks(jj).stats         = stats;
            end
        end
        if(~isempty(Troughs))
            nPeaks  = length(Troughs);
            for ii  =1:nPeaks
                jj  = jj+1;

                sigind          = false(size(s.XData));
                sigind(Troughs(ii).first:Troughs(ii).last)  = 1;

                onset           = s.XData(Troughs(ii).first);
                offset          = s.XData(Troughs(ii).last);
                duration        = offset-onset;

                XDataPeak       = s.XData(sigind);
                [Peak,ind]      = min(YData(sigind));
                PeakTime        = XDataPeak(ind);
                [PeakTime,Peakind]  = nearest(s.XData,PeakTime);
                Peakd           = Peak - BaseMean;

                Mean            = mean(YData(sigind));
                Meand           = Mean - BaseMean;

                PPI             = (Peak - BaseMean) / BaseMean * 100;
                MPI             = (Mean - BaseMean) / BaseMean * 100;
                API             = MPI*duration; % (% * sec)

                [ind,HM]        = pwhm(YData-BaseMean,0,sigind);
                PWHM_onset      = s.XData(ind(1));
                PWHM_offset     = s.XData(ind(2));
                PWHM_duration   = PWHM_offset - PWHM_onset;
                PWHM_halfmax    = HM + BaseMean;

                TestMean_Trials     = mean(sdata.TrialData(:,sigind),2);
                TestMean_MF         = mean(reshape(TestMean_Trials(1:nSPF*nMF),nSPF,nMF),1);
                %                 [sigp,issig,stats]  = signrank(TestMean_MF,ContMean_MF,'alpha',alpha);
                [issig,sigp,CI,stats]    = ttest(TestMean_MF,ContMean_MF,alpha,'both');

                nsigpeaks       = nsigpeaks + double(issig);

                peaks(jj).ind       = sigind;
                peaks(jj).onset     = onset;        %(sec)
                peaks(jj).offset    = offset;
                peaks(jj).duration  = duration;
                peaks(jj).peaktime  = PeakTime;
                peaks(jj).peak      = Peak;
                peaks(jj).mean      = Mean;
                peaks(jj).peakd     = Peakd;
                peaks(jj).meand     = Meand;
                peaks(jj).PPI       = PPI;
                peaks(jj).MPI       = MPI;
                peaks(jj).API       = API;
                peaks(jj).PWHM_onset    = PWHM_onset;
                peaks(jj).PWHM_offset   = PWHM_offset;
                peaks(jj).PWHM_duration = PWHM_duration;
                peaks(jj).PWHM_halfmax  = PWHM_halfmax;
                peaks(jj).p             = sigp;
                peaks(jj).issig         = issig;
                peaks(jj).stats         = stats;
            end
        end
        s.(psename).peaks     = peaks;

        s.(psename).npeaks    = jj;

        s.(psename).nsigpeaks = nsigpeaks;
        if(isempty(peaks))
            s.(psename).sigpeakind= [];
        else
            s.(psename).sigpeakind= find([peaks(:).issig]==1);
        end
        if(~isempty(s.(psename).sigpeakind))
            [temp,s.(psename).maxsigpeakind]  = max(abs([peaks(s.(psename).sigpeakind).peakd]));
            s.(psename).maxsigpeakind = s.(psename).sigpeakind(s.(psename).maxsigpeakind);
        else
            s.(psename).maxsigpeakind = [];
        end


        s.(psename) = searchPSE(s.(psename),SearchTW,SearchObj);


        %         % searchTW
        %         if(s.(psename).npeaks>0)
        %
        %             addflag = true(1,s.(psename).npeaks);
        %             issig   = false(1,s.(psename).npeaks);
        %
        %
        %             for ipeak=1:s.(psename).npeaks
        %                 addflag(ipeak) = s.(psename).peaks(ipeak).onset>=SearchTW(1) & s.(psename).peaks(ipeak).onset<=SearchTW(2);
        %                 issig(ipeak)   = s.(psename).peaks(ipeak).issig;
        %             end
        %             ind = [1:s.(psename).npeaks];
        %
        %
        %             s.(psename).search_TimeWindow   = SearchTW;
        %             s.(psename).npeaksTW            = sum(addflag);
        %             s.(psename).peakindTW           = ind(addflag);
        %             s.(psename).nsigpeaksTW         = sum(addflag & issig);
        %             s.(psename).sigpeakindTW        = ind(addflag & issig);
        %
        %             if(~isempty(s.(psename).sigpeakindTW))
        %                 [temp,s.(psename).maxsigpeakindTW]  = max(abs([s.(psename).peaks(s.(psename).sigpeakindTW).meand]));
        %                 s.(psename).maxsigpeakindTW         = s.(psename).sigpeakindTW(s.(psename).maxsigpeakindTW);
        %             else
        %                 s.(psename).maxsigpeakindTW = [];
        %             end
        %
        %
        %
        %         else
        %             s.(psename).search_TimeWindow   = SearchTW;
        %             s.(psename).npeaksTW            = 0;
        %             s.(psename).peakindTW           = [];
        %             s.(psename).nsigpeaksTW         = 0;
        %             s.(psename).sigpeakindTW        = [];
        %             s.(psename).maxsigpeakindTW     = [];
        %
        %         end
        %


end
end


function s  = searchPSE(s,TimeWindow,SearchObj)


if(~isfield(s,'peaks'))
    error('データはPSEが未解析です。pse_btcを行ってください')
end

if(s.npeaks>0)

    addflag = true(1,s.npeaks);
    issig   = false(1,s.npeaks);
    %     issig_ttest = false(1,s.npeaks);

    switch lower(SearchObj)
        case 'onset'
            for ipeak=1:s.npeaks
                addflag(ipeak) = s.peaks(ipeak).onset>=TimeWindow(1) & s.peaks(ipeak).onset<=TimeWindow(2);
                issig(ipeak)   = s.peaks(ipeak).issig;
                %                 issig_ttest(ipeak) = s.peaks(ipeak).issig_ttest;
            end
        case 'offset'
            for ipeak=1:s.npeaks
                addflag(ipeak) = s.peaks(ipeak).offset>=TimeWindow(1) & s.peaks(ipeak).offset<=TimeWindow(2);
                issig(ipeak)   = s.peaks(ipeak).issig;
                %                 issig_ttest(ipeak) = s.peaks(ipeak).issig_ttest;
            end
        case 'peak'
            for ipeak=1:s.npeaks
                addflag(ipeak) = s.peaks(ipeak).peaktime>=TimeWindow(1) & s.peaks(ipeak).peaktime<=TimeWindow(2);
                issig(ipeak)   = s.peaks(ipeak).issig;
                %                 issig_ttest(ipeak) = s.peaks(ipeak).issig_ttest;
            end
        case 'any'
            for ipeak=1:s.npeaks
                addflag(ipeak) = ~((s.peaks(ipeak).onset<TimeWindow(1) & s.peaks(ipeak).offset<TimeWindow(1))|(s.peaks(ipeak).onset>TimeWindow(2) & s.peaks(ipeak).offset>TimeWindow(2)));
                issig(ipeak)   = s.peaks(ipeak).issig;
                %                 issig_ttest(ipeak) = s.peaks(ipeak).issig_ttest;
            end
    end

    ind = 1:s.npeaks;

    s.search_TimeWindow = TimeWindow;
    s.search_Object     = SearchObj;
    s.npeaksTW          = sum(addflag);
    s.peakindTW         = ind(addflag);
    s.nsigpeaksTW       = sum(addflag & issig);
    s.sigpeakindTW      = ind(addflag & issig);

    if(~isempty(s.sigpeakindTW))
        [temp,s.maxsigpeakindTW]  = max(abs([s.peaks(s.sigpeakindTW).peakd]));
        s.maxsigpeakindTW = s.sigpeakindTW(s.maxsigpeakindTW);
    else
        s.maxsigpeakindTW = [];
    end

    %     s.nsigpeaks_ttestTW  = sum(addflag & issig_ttest);
    %     s.sigpeakind_ttestTW = ind(addflag & issig_ttest);
    %
    %     if(~isempty(s.sigpeakindTW))
    %         [temp,s.maxsigpeakind_ttestTW]  = max(abs([s.peaks(s.sigpeakind_ttestTW).peakd]));
    %         s.maxsigpeakind_ttestTW = s.sigpeakind_ttestTW(s.maxsigpeakind_ttestTW);
    %     else
    %         s.maxsigpeakind_ttestTW = [];
    %     end

else
    s.search_TimeWindow = TimeWindow;
    s.search_Object     = SearchObj;
    s.npeaksTW      = 0;
    s.peakindTW     = [];
    s.nsigpeaksTW       = 0;
    s.sigpeakindTW      = [];
    s.maxsigpeakindTW   = [];
    %     s.nsigpeaks_ttestTW    = 0;
    %     s.sigpeakind_ttestTW   = [];
    %     s.maxsigpeakind_ttestTW= [];
end

%%%% TWのほうがかっこよくてTRから変更、今はもういらないはず。
if(isfield(s,'search_TimeRange'))
    s   = rmfield(s,{'search_TimeRange','npeaksTR','nsigpeaksTR','sigpeakindTR','maxsigpeakindTR','nsigpeaks_ttestTR','sigpeakind_ttestTR','maxsigpeakind_ttestTR','peakindTR'});
end
end

function s  = packPSE(s,psename)
% PSEのデータが変数の直下にある状態から整理

if(isfield(s,'base'))
    items   = {'nsd',...
        'nnsec',...
        'kksec',...
        'alpha',...
        'nSPF',...
        'nMF'};

    nitems  = length(items);

    for iitem=1:nitems
        item    = items{iitem};
        if(isfield(s.base,item))
            s.(psename).(item)    = s.base.(item);
            if(isfield(s.(psename),item))
                s.base  = rmfield(s.base,item);
            end
        end
    end
end

items   = {'method',...
    'baseline',...
    'BaseLine',...
    'pind',...
    'tind',...
    'base',...
    'npeaks',...
    'nsigpeaks',...
    'sigpeakind',...
    'nsigpeaks_ttest',...
    'sigpeakind_ttest',...
    'peaks',...
    'maxsigpeakind',...
    'maxsigpeakind_ttest',...
    'isXtalk',...
    'search_TimeWindow',...
    'search_Object',...
    'npeaksTW',...
    'peakindTW',...
    'nsigpeaksTW',...
    'sigpeakindTW',...
    'maxsigpeakindTW',...
    'nsigpeaks_ttestTW',...
    'sigpeakind_ttestTW',...
    'maxsigpeakind_ttestTW'};

nitems  = length(items);

for iitem=1:nitems
    item    = items{iitem};
    if(isfield(s,item))
        s.(psename).(item)    = s.(item);
        if(isfield(s,item))
            s   = rmfield(s,item);
        end
    end
end
end