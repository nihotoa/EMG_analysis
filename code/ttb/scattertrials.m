function S  = scattertrials(X_hdr,X_dat,Y_hdr,Y_dat,method,TimeWindow,Z_hdr,Z_dat,test_limits)

if(nargin<7)
    test_flag  = 0;
else
    test_flag  = 1;
end

if(test_flag==1)
    Z_ind   = Z_hdr.XData>=TimeWindow(1) & Z_hdr.XData<=TimeWindow(2);
end

switch lower(method)
    case 'mean'
        
        switch X_hdr.AnalysisType
            case 'STA'
                X_ind   = X_hdr.XData>=TimeWindow(1) & X_hdr.XData<=TimeWindow(2);
                XData   = mean(X_dat.TrialData(:,X_ind),2);
            case 'PSTH'
                nTrials = length(X_dat.TrialData);
                XData   = zeros(nTrials,1);
                for iTrial=1:nTrials
                    XData(iTrial)   = sum(X_dat.TrialData{iTrial}>=TimeWindow(1) & X_dat.TrialData{iTrial}<=TimeWindow(2));
                end
                XData   = XData./(TimeWindow(2)-TimeWindow(1)); % convert to sps
        end
        
        switch Y_hdr.AnalysisType
            case 'STA'
                Y_ind   = Y_hdr.XData>=TimeWindow(1) & Y_hdr.XData<=TimeWindow(2);
                YData   = mean(Y_dat.TrialData(:,Y_ind),2);
            case 'PSTH'
                nTrials = length(Y_dat.TrialData);
                YData   = zeros(nTrials,1);
                for iTrial=1:nTrials
                    YData(iTrial)   = sum(Y_dat.TrialData{iTrial}>=TimeWindow(1) & Y_dat.TrialData{iTrial}<=TimeWindow(2));
                end
                YData   = YData./(TimeWindow(2)-TimeWindow(1)); % convert to sps
        end
        
        
        
        XName   = X_hdr.TargetName;
        if(isfield(X_hdr,'Process'))
            suffix  = fieldnames(X_hdr.Process);
            XName   = [XName,'[',suffix{1},']'];
        end
        YName   = Y_hdr.TargetName;
        if(isfield(Y_hdr,'Process'))
            suffix  = fieldnames(Y_hdr.Process);
            YName   = [YName,'[',suffix{1},']'];
        end
        
        if(test_flag==1)
            ZData   = mean(Z_dat.TrialData(:,Z_ind),2);
            ZName   = Z_hdr.TargetName;
        end
        
    case 'max'
        X_ind   = X_hdr.XData>=TimeWindow(1) & X_hdr.XData<=TimeWindow(2);
        Y_ind   = Y_hdr.XData>=TimeWindow(1) & Y_hdr.XData<=TimeWindow(2);
        
        [XData,XDataInd]    = max(X_dat.TrialData(:,X_ind),[],2);
        [YData,YDataInd]    = max(Y_dat.TrialData(:,Y_ind),[],2);
        
        XName   = X_hdr.TargetName;
        if(isfield(X_hdr,'Process'))
            suffix  = fieldnames(X_hdr.Process);
            XName   = [XName,'[',suffix{1},']'];
        end
        YName   = Y_hdr.TargetName;
        if(isfield(Y_hdr,'Process'))
            suffix  = fieldnames(Y_hdr.Process);
            YName   = [YName,'[',suffix{1},']'];
        end
        
        XDataInd    = XDataInd+find(X_ind,1,'first')-1;
        YDataInd    = YDataInd+find(Y_ind,1,'first')-1;
        S.XDataTime   = X_hdr.XData(XDataInd);
        S.YDataTime   = Y_hdr.XData(YDataInd);
        if(test_flag==1)
            [ZData,ZDataInd]    = max(Z_dat.TrialData(:,Z_ind),[],2);
            ZName               = Z_hdr.TargetName;
            ZDataInd    = ZDataInd+find(Z_ind,1,'first')-1;
            S.ZDataTime   = Z_hdr.XData(ZDataInd);
        end
        
end

S.Name          = ['SCAT (',XName,', ',YName,',[',method,',',num2str(TimeWindow(1)),',',num2str(TimeWindow(2)),'])'];
S.AnalysisType  = 'SCAT';
S.method        = ['scattertrials_',method];
S.TimeWindow    = TimeWindow;
S.ReferenceName = X_hdr.Name;
S.TargetName    = Y_hdr.Name;
S.XData         = XData;
S.XName         = XName;
S.YData         = YData;
S.YName         = YName;
if(test_flag==1)
    S.OrderingName  = Z_hdr.Name;
    S.ZData     = ZData;
    S.ZName     = ZName;
end
S.N             = size(XData,1);
S.Xmean         = mean(XData);
S.Xstd          = std(XData);
S.Xmedian       = median(XData);
S.Ymean         = mean(YData);
S.Ystd          = std(YData);
S.Ymedian       = median(YData);


% 相関係数
if(S.N<2)
    S.Pearson.R = 0;
    S.Pearson.P = 1;
    S.Spearman.R    = 0;
    S.Spearman.P    = 1;
    % 線形回帰
    S.a   = nan(1,2);
    S.ahelp = '回帰直線：Y=a(1)*X+a(2)';
else
    [S.Pearson.R,S.Pearson.P]   = corr(S.XData,S.YData,'type','Pearson');
    [S.Spearman.R,S.Spearman.P]   = corr(S.XData,S.YData,'type','Spearman');
    % 線形回帰
    S.a   = polyfit(XData,YData,1);
    S.ahelp = '回帰直線：Y=a(1)*X+a(2)';
end




if(test_flag==1)
%     minZData= min(ZData);
%     maxZData= max(ZData);
%     limit1  = (maxZData - minZData)*test_limits(1)/100+minZData;
%     limit2  = (maxZData - minZData)*test_limits(2)/100+minZData;
    limit1  = prctile(ZData,test_limits(1));
    limit2  = prctile(ZData,test_limits(2));
    ind1    = ZData<= limit1;
    ind2    = ZData>= limit2;
    
    XData1  = XData(ind1);
    XData2  = XData(ind2);
    YData1  = YData(ind1);
    YData2  = YData(ind2);
    
    S.test.XData1   = XData1;
    S.test.XData2   = XData2;
    S.test.YData1   = YData1;
    S.test.YData2   = YData2;
    S.test.prclimits= test_limits;
    S.test.limits   = [limit1,limit2];
    S.test.alpha    = 0.05;
    S.test.tail     = 'both';
    S.test.vartype  = 'unequal';
    S.test.Xmean    = [mean(XData1),mean(XData2)];
    S.test.Xstd     = [std(XData1),std(XData2)];
    S.test.Xmedian  = [median(XData1),median(XData2)];
    S.test.Ymean    = [mean(YData1),mean(YData2)];
    S.test.Ystd     = [std(YData1),std(YData2)];
    S.test.Ymedian  = [median(YData1),median(YData2)];
    if(length(YData1)<2 || length(YData2)<2)
        S.test.ttest.h   = 0;
        S.test.ttest.p   = nan;
        S.test.ttest.a   = nan(1,2);
        S.test.ranksum.h = 0;
        S.test.ranksum.p = nan;
        S.test.ranksum.a = nan(1,2);
    else
        [S.test.ttest.h,S.test.ttest.p]       = ttest2(YData1,YData2,S.test.alpha,S.test.tail,S.test.vartype);
        S.test.ttest.a      = nan(1,2);
        S.test.ttest.a(1)   = (S.test.Ymean(2) - S.test.Ymean(1))/(S.test.Xmean(2) - S.test.Xmean(1));
        S.test.ttest.a(2)   = S.test.Ymean(1) - S.test.ttest.a(1)*S.test.Xmean(1);
        
        [S.test.ranksum.p,S.test.ranksum.h]   = ranksum(YData1,YData2,'alpha',S.test.alpha);
        S.test.ranksum.a    = nan(1,2);
        S.test.ranksum.a(1) = (S.test.Ymedian(2) - S.test.Ymedian(1))/(S.test.Xmedian(2) - S.test.Xmedian(1));
        S.test.ranksum.a(2) = S.test.Ymedian(1) - S.test.ranksum.a(1)*S.test.Xmedian(1);
    end
end


% % scat2hist
% [S.hist.XData,S.hist.YData,S.hist.ZData]   = scat2hist(S.XData,S.YData,dx,dy);