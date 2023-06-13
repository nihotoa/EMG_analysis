function varargout  = localpeaks
% [F,S,N]   = localpeaks
warning('off');

rootpath    = 'L:\tkitom\data\tcohtrig';
outputfile  = 'L:\tkitom\data\tcohtrig\localpeaks.xls';
parentpath  = uigetdir(rootpath);
temp        = what(parentpath);
filenames   = sort(temp.mat);
triggername = 'GripOff';
roi         = [0 125];  % (Hz)
xlim        = [3 100];  % (Hz)
alpha       = 0.05;

% >> 一つ目のファイルのnfftpoints(1)によって、indexの割り当てを決定する。
temp    = load(fullfile(parentpath,filenames{1}));
temp    = getfield(temp,triggername);
nfftpoints  = getfield(temp,'nfftpoints');

switch nfftpoints(1)
    % FFTpoints = 256
    % 5   6  | 7  11  | 12   57  | 58   59   67  | 68   99  | 103  127 (Index)    
    % 3.9 4.9| 5.8 9.7| 10.7 54.7| 55.7 56.6 64.5| 65.4 95.7| 99.6 123.0 (Hz)

    % FFTpoints = 128
    % 3   | 4   6  | 7    29  | 30   34  | 35   50  | 52   63   (Index)    
    % 3.9 | 5.9 9.8| 11.7 54.7| 56.6 64.5| 66.4 95.7| 99.6 121.1(Hz)

    case 256
        disp('256')
        segind      = {[7:57,68:99];...
            [12:57,68:99]};
        % segind      = [1:127;1:127]';
        chklocalmax     = [61 63];
        chkglobalmax    = [59 67 12 99];
        chkquarter      = [12:57];
        % chkcluster      = [12:57,68:99];
        chkcluster      = [7:57,68:99];
        % FOI             = [12:99];
        FOI             = [7:99];
        HUM             = [58:67];
        
        nn              = 5;
        kk              = 3;

    case 128
        disp('128')
        segind      = {[4:29,35:50];...
            [7:29,35:50]};
        % segind      = [1:127;1:127]';
        chklocalmax     = [30 34];
        chkglobalmax    = [30 34 7 50];
        chkquarter      = [7:29];
        % chkcluster      = [7:29,35:50];
        chkcluster      = [4:29,35:50];
        % FOI             = [12:99];
        FOI             = [4:50];
        HUM             = [30:34];
        
        nn              = 5;
        kk              = 3;

    otherwise
        error('File type is not supported (nfftpoints)')
end
% <<

segxls_flag         = 0;
segreg_flag         = 0;
chklocalmax_flag    = 0;
chkglobalmax_flag   = 0;
quartile_flag       = 0;
maxcluster_flag     = 0;
cluster_flag        = 0;
clusterreg_flag     = 0;
figure_flag         = 1;

flags   = [segxls_flag,segreg_flag,chklocalmax_flag,chkglobalmax_flag,quartile_flag,cluster_flag,clusterreg_flag];
NGword      = 'AbPL';
NGHz        = [];
nNGfile = 0;
disp(parentpath)
if(any(flags))
    fid = fopen(outputfile,'a');
    if(fid==-1)
        disp('Failure to output file.')
        return
    end
    fprintf(fid,'\n%s\nfile',datestr(now));
end
if(segxls_flag==1 && ~isempty(segind))
    for jj=1:length(segind)
        isegind = segind{jj};
        fprintf(fid,'\t%s',[num2str(isegind(1)),num2str(isegind(end))]);
    end
end
if(segreg_flag==1 && ~isempty(segind))
    for jj=1:length(segind)
        isegind = segind{jj};
        fprintf(fid,'\t%s\tnsegsigcl\tisunwrap\tr\tp\tmeanphi\ttau\t',[num2str(isegind(1)),num2str(isegind(end))]);
    end
end

if(chklocalmax_flag==1 && ~isempty(chklocalmax))
    for jj=1:size(chklocalmax,1)
        fprintf(fid,'\tchkLM %s',num2str(chklocalmax(jj,:)));
    end
end
if(chkglobalmax_flag==1 && ~isempty(chkglobalmax))
    for jj=1:size(chkglobalmax,1)
        fprintf(fid,'\tchkGM [%s]/[%s]',num2str(chkglobalmax(jj,1:2)),num2str(chkglobalmax(jj,3:4)));
    end
end
if(quartile_flag==1 & ~isempty(chkquarter))
    fprintf(fid,'\tseg_tot\tMean\tSTD\tMedian\tIQR\tsigcount');
%     fig = figure;
end

if(maxcluster_flag==1 & ~isempty(chkcluster))
    fprintf(fid,'\tWidest(firstF)\tWidest(lastF)\tWidest(FRange)');
%     fig = figure;
end

if(cluster_flag==1 & ~isempty(chkcluster))
    fprintf(fid,'\tfirstF\tlastF\tFRange');
%     fig = figure;
end

if(clusterreg_flag==1 & ~isempty(chkcluster))
    fprintf(fid,'\tfirstF\tlastF\tFRange\tnpts\tisunwrap\tr\tp\tmeanphi\ttau(ms)');
%     fig = figure;
end




for ii=1:length(filenames)
    if(~isempty(strfind(filenames{ii},NGword)))
        nNGfile = nNGfile +1;
    else
        S   = load([parentpath,'\',filenames{ii}]);
        S   = getfield(S,triggername);
        roiInd  = (S.compiled.f(:,1) >= roi(1) & S.compiled.f(:,1) <= roi(2) );
%         if(ii==1)
%             freq    = S.compiled.f(roiInd,1);
%             n       = length(filenames);
%             sigcount    = zeros(size(freq));
%             %             siglocalmaxcount = sigcount;
%             sumP1       = sigcount;
%             
%             sumcoh      = sigcount;
%             sumnormcoh  = sigcount;
%             %             sumsigcoh   = sigcount;
% 
%             %             disp(['[',num2str(freq(3)),':',num2str(freq(5)),' , ',num2str(freq(7)),':',num2str(freq(18)),' , ',num2str(freq(21)),':',num2str(freq(29)),']'])
%         end
        
        % loading each file data
        P1  = S.compiled.f(roiInd,2);
        diffP1  = [0;diff(P1)];
        normP1  = P1/sum(P1);
        normdiffP1  = [0;diff(normP1)];
        freq    = S.compiled.f(roiInd,1);
        dfreq   = freq(2)-freq(1);
        coh = S.compiled.f(roiInd,4);
        phi = S.compiled.f(roiInd,5);
        cl  = S.compiled.cl.ch_c95;
        L(ii)  = S.compiled.cl.seg_tot;
        Ind     = [1:length(freq)]';
%         disp(num2str(L(ii)))
        
        normcoh = zcoh(coh,L(ii));
        localmaxs  = [0;((coh(1:(length(coh)-2)) <= coh(2:(length(coh)-1))) & (coh(2:(length(coh)-1)) >= coh(3:(length(coh)))));0];
        sigInd  = (coh > cl);
        ssigInd	= sigInd(chkcluster);
        sfreq   = freq(chkcluster);
        scoh    = coh(chkcluster);
        sphi    = phi(chkcluster);
         
        siglocalmaxs   = sigInd & localmaxs;
        
        FOImask = zeros(size(freq));
        FOImask(FOI)    = ones(size(FOI));
        HUMmask = zeros(size(freq));
        HUMmask(HUM)    = ones(size(HUM));
        
        
        
        % sum of all file data
        if(ii==1)
            freq    = S.compiled.f(roiInd,1);
            n       = length(filenames);
            sigcount    = zeros(size(freq));
            clssigcount = zeros(size(freq));
            clsMaskedsc = zeros(size(freq));
            maxclscount = zeros(size(freq));
            %             siglocalmaxcount = sigcount;
            sumP1       = [];
            sumdiffP1   = [];
            sumnormP1   = [];
            sumnormdiffP1   = [];
            sumcoh      = sigcount;
            sumnormcoh  = sigcount;
            %             sumsigcoh   = sigcount;

            %             disp(['[',num2str(freq(3)),':',num2str(freq(5)),' , ',num2str(freq(7)),':',num2str(freq(18)),' , ',num2str(freq(21)),':',num2str(freq(29)),']'])
        end
        
        % sig freq std
        sigfreq = freq(chkquarter);
        sigfreq  = sigfreq(sigInd(chkquarter));
        sigfreqmean     = mean(sigfreq);
        sigfreqstd  = std(sigfreq,1);
        Q	= prctile(sigfreq,[25 50 75]);
        sigfreqmed  = Q(2);
        sigfreqqd   = (Q(3)-Q(1));
        
%         clustfreq   = zeros(size(freq));
%         clustfreq(chkcluster)   = ones(size(chkcluster));
        
%         chkclustsigInd   = freq(chkcluster);
        sigcont = findcont(ssigInd,kk,nn);
        clust   = findclust(sigcont);
        [maxN,maxInd]   = max(chkcluster([clust.last])-chkcluster([clust.first]));
        maxclust    = clust(maxInd);
        disp(maxN)
        
        

        
%         sigcdf      = cumsum(sigInd(chkquarter))/sum(sigInd(chkquarter));
%         figure(fig)
%         subplot(2,1,1)
%         bar(freq(chkquarter),sigInd(chkquarter))
%         title(filenames{ii})
%         subplot(2,1,2)
%         plot(freq(chkquarter),sigcdf)
%         
%         keyboard
        

        sigcount    = sigcount + sigInd;
        sumP1       = [sumP1,P1];
        sumdiffP1   = [sumdiffP1,diffP1];
        sumnormP1   = [sumnormP1,normP1];
        sumnormdiffP1   = [sumnormdiffP1,normdiffP1];
        sumcoh      = sumcoh  + coh;
        sumnormcoh  = sumnormcoh + normcoh;
        clssigcount = clssigcount + clustvec(sigInd,kk,nn,FOImask,HUMmask);
        clsMaskedsc = clsMaskedsc + (clustvec(sigInd,kk,nn,FOImask,HUMmask) & sigInd);
        maxclustInd     = (Ind >= chkcluster(maxclust.first)) & (Ind <= chkcluster(maxclust.last));
%         maxclustsigInd  = ssigInd(maxclustInd);
        maxclscount  = maxclscount + maxclustInd;

        
        
        % file output
        if(any(flags))
            fprintf(fid,'\n%s',filenames{ii});
        end
        
        if(segxls_flag==1 & ~isempty(segind))
            for jj=1:length(segind)
                isegind     = segind{jj};
                segcount    = sum(sigInd(isegind));
                fprintf(fid,'\t%d',segcount);
            end
        end
        if(segreg_flag==1 & ~isempty(segind))
            for jj=1:length(segind)
                isegind     = segind{jj};
                segsigInd   = sigInd(isegind);
                
                nsegsig     = sum(segsigInd);
                nseg        = length(isegind) + 1;
                nsegsigcl   = binocl(nseg,0.05,0.05);

                if(nsegsig < 1)
                    fprintf(fid,'\t%d\t%d\t%d\t%f\t%f\t%f\t%f\t%f',0,nsegsigcl,NaN,NaN,NaN,NaN,NaN);
                else
                    segsigX     = freq(isegind);
                    segsigX     = segsigX(segsigInd);
                    segsigY     = phi(isegind);
                    segsigY     = segsigY(segsigInd);

                    uwsegsigY   = unwrap(segsigY);
                    isunwrap= any(segsigY~=uwsegsigY);
                    [A,Sxxx]= polyfit(segsigX,uwsegsigY,1);
                    [r,p]   = corr(segsigX,uwsegsigY);
                    tau     = - (A(1)*1000/2/pi);   % constant delay of channel X from channels Y (ms) degative value indicate chanX precede chanY
                    meanphi = mean(uwsegsigY);

                    fprintf(fid,'\t%d\t%d\t%d\t%f\t%f\t%f\t%f\t%f',nsegsig,nsegsigcl,isunwrap,r,p,meanphi,tau);
                end
            end
        end
        if(chklocalmax_flag==1 & ~isempty(chklocalmax))
            for jj=1:size(chklocalmax,1)
                islocalmax = sum(siglocalmaxs(chklocalmax(jj,1):chklocalmax(jj,2)));
                fprintf(fid,'\t%d',islocalmax);
            end
        end
        if(chkglobalmax_flag==1 & ~isempty(chkglobalmax))
            for jj=1:size(chkglobalmax,1)
                [gmax,igmax]    = max(coh(chkglobalmax(jj,3):chkglobalmax(jj,4)));
                igmax           = igmax + chkglobalmax(jj,3) - 1;
                isglobalmax     = (chkglobalmax(jj,1) <= igmax & igmax <= chkglobalmax(jj,2));
                fprintf(fid,'\t%d',isglobalmax);
            end
        end
        if(quartile_flag==1 & ~isempty(chkquarter))
            fprintf(fid,'\t%d\t%f\t%f\t%f\t%f\t%d',L(ii),sigfreqmean,sigfreqstd,sigfreqmed,sigfreqqd,sum(sigInd(chkquarter)));
        end
        if(maxcluster_flag==1 & ~isempty(clust))

%             maxclustInd    = [maxclust.first:maxclust.last];
%             maxclustsigInd = ssigInd(maxclustInd);

            firstF  = sfreq(maxclust.first);
            lastF   = sfreq(maxclust.last);
            FR      = lastF - firstF;

            fprintf(fid,'\t%f\t%f\%f\t',firstF,lastF,FR);

        end
        
        
        if(cluster_flag==1 & ~isempty(clust))
            for jj=1:length(clust)
                clustInd    = [clust(jj).first:clust(jj).last];
                clustsigInd = ssigInd(clustInd);
                
                firstF  = sfreq(clust(jj).first);
                lastF   = sfreq(clust(jj).last);
                FR      = lastF - firstF;
                
                fprintf(fid,'\t%f\t%f\%f\t',firstF,lastF,FR);
            end
        end
        if(clusterreg_flag==1 & ~isempty(clust))
            for jj=1:length(clust)
                clustInd    = [clust(jj).first:clust(jj).last];
                clustsigInd = ssigInd(clustInd);
                
                firstF  = sfreq(clust(jj).first);
                lastF   = sfreq(clust(jj).last);
                FR      = lastF - firstF;
%                 if(firstF < 55 && lastF > 65)       % hum noise range をはさんだクラスタの場合、クラスタのポイント数をその分（10ポイント）足す。
%                     FR      = (clust(jj).n + 10) * (250/256);
%                 else
%                     FR      = clust(jj).n * (250/256);
%                 end
                
                
                XData   = sfreq(clustInd);
                XData   = XData(clustsigInd);
                YData   = sphi(clustInd);
                YData   = YData(clustsigInd);
                
                uwYData = unwrap(YData);
                isunwrap= any(YData~=uwYData);
                [A,Sxxx]= polyfit(XData,uwYData,1);
                fYData  = polyval(A,XData);
                [r,p]   = corr(XData,uwYData);
                tau     = A(1)*1000/2/pi;   % constant delay of channel X from channels Y (ms) degative value indicate chanX precede chanY
                meanphi = mean(uwYData);
                if(jj>1)
                    fprintf(fid,'\n%s',filenames{ii});
                end
                
                
                fprintf(fid,'\t%f\t%f\%f\t%d\t%d\t%f\t%f\t%f\t%f\t',firstF,lastF,FR,sum(clustsigInd),isunwrap,r,p,meanphi,tau);
            end
        end

    end
%     disp([num2str(ii),'/',num2str(length(filenames))])
    indicator(ii,length(filenames));
end % ii=1:length(filenames)

if(any(flags))
    fclose(fid);
end
% calculate population data
clssigcountpercent  = clssigcount / (n- nNGfile) * 100;
sigpercent          = sigcount / (n- nNGfile) * 100;
clpercent           = (binocl(n- nNGfile,0.05,0.05) - 1) / (n- nNGfile) * 100;
clsMaskedscpercent  = clsMaskedsc / (n- nNGfile) * 100;
maxclscountpercent  = maxclscount / (n- nNGfile) * 100;


% sumP1               = power(sumP1,10);
meanP1              = mean(sumP1,2);
% meanP1              = log10(meanP1);
stdP1               = std(sumP1,0,2);
% stdP1               = log10(stdP1);
meandiffP1              = mean(sumdiffP1,2);
stddiffP1               = std(sumdiffP1,0,2);

meannormP1              = mean(sumnormP1,2);
stdnormP1               = std(sumnormP1,0,2);

meannormdiffP1              = mean(sumnormdiffP1,2);
stdnormdiffP1               = std(sumnormdiffP1,0,2);

meancoh             = sumcoh / (n- nNGfile);
meannormcoh         = sumnormcoh / sqrt(n- nNGfile);

% display on figure
if(figure_flag == 1)
    fig = figure('Name',parentpath,...
        'Numbertitle','off',...
        'PaperUnits' ,'centimeters',...
        'PaperOrientation' , 'portrait',...
        'PaperPosition' , [0.634517 1.28465 19.715 27.1081],...
        'PaperPositionMode' , 'manual',...
        'PaperSize', [20.984 29.6774],...
        'PaperType','a4',...
        'Units' , 'pixels',...
        'Position' , [100   106   322   817],...
        'ToolBar' , 'figure');
    
    h=subplot(5,1,1,'parent',fig);
    stairs(freq,maxclscountpercent,'Color','k','LineWidth',0.75)
    line(xlim,[clpercent clpercent],'Color',[0.5 0.5 0.5],'LineStyle','--','LineWidth',0.75)
    set(h,'xLim',xlim);
    title({parentpath; ['n=',num2str(n- nNGfile)]})
    ylabel('% Significance (widest cluster)')
    % subplot(4,1,2)
    % stairs(freq,siglocalmaxpercent)

    h=subplot(5,1,2,'parent',fig);
    stairs(freq,clssigcountpercent,'Color','k','LineWidth',0.75)
    line(xlim,[clpercent clpercent],'Color',[0.5 0.5 0.5],'LineStyle','--','LineWidth',0.75)
    set(h,'xLim',xlim);
    title({parentpath; ['n=',num2str(n- nNGfile)]})
    ylabel('% Significance (cluster)')
    % subplot(4,1,2)
    % stairs(freq,siglocalmaxpercent)

    h=subplot(5,1,3,'parent',fig);
    stairs(freq,sigpercent,'Color','k','LineWidth',0.75)
    line(xlim,[clpercent clpercent],'Color',[0.5 0.5 0.5],'LineStyle','--','LineWidth',0.75)
    set(h,'xLim',xlim);
    ylabel('% Significance')
%     keyboard
    h=subplot(5,1,4,'parent',fig);
    
%     cl  =cohinv2(1-alpha,L);
%     disp(L)
    cl  =cohmeansignif(L,0.05);
    stairs(freq,meancoh,'Color','k','LineWidth',0.75)
    line(xlim,[cl cl],'Color',[0.5 0.5 0.5],'LineStyle','--','LineWidth',0.75)
    set(h,'xLim',xlim);
    ylabel('Averaged Coherence')
    
%     zerocoh = cohmontecarlo(L);
    h=subplot(5,1,5,'parent',fig);
    hold on
%     keyboard
    stairs(freq,meannormcoh,'Color','k','LineWidth',0.75)
%     stairs(freq,zerocoh,'Color','b','LineWidth',0.75)
%     stairs(freq,zerocoh+1.96,'Color','r','LineWidth',0.75)
    set(h,'xLim',xlim);
    ylabel('Averaged z-Coherence'),xlabel('Frequency (Hz)')
    title(['cl95 = ',num2str(cl)]);
    
%     h=subplot(3,1,1);
%     hold on;
%     fill([freq;freq(end:-1:1)],[meanP1+stdP1;meanP1(end:-1:1)-stdP1(end:-1:1)],[0.8 0.8 0.8]);
%     plot(freq,meanP1,'Color','k','LineWidth',0.75)
%     set(h,'xLim',xlim);
%     ylabel('Averaged Log10(power) P1'),xlabel('Frequency (Hz)')
%     hold off;
    
%     h=subplot(2,2,1);
%     hold on;
%     plot(freq,sumnormP1,'Color','k','LineWidth',0.75)
%     set(h,'xLim',xlim);
%     ylabel('log power'),xlabel('Frequency (Hz)')
%     hold off;
% 
%     h=subplot(2,2,2);
%     hold on;
%     fill([freq;freq(end:-1:1)],[meanP1+stdP1;meanP1(end:-1:1)-stdP1(end:-1:1)],[0.8 0.8 0.8]);
%     plot(freq,meanP1,'Color','k','LineWidth',0.75)
%     set(h,'xLim',xlim);
%     ylabel('Averaged Log power'),xlabel('Frequency (Hz)')
%     hold off;
% 
%     h=subplot(2,2,3);
%     hold on;
%     plot(freq,sumdiffP1,'Color','k','LineWidth',0.75)
%     set(h,'xLim',xlim);
%     ylabel('diff log power'),xlabel('Frequency (Hz)')
%     hold off;
%     
%     h=subplot(2,2,4);
%     hold on;
%     fill([freq;freq(end:-1:1)],[meandiffP1+stddiffP1;meandiffP1(end:-1:1)-stddiffP1(end:-1:1)],[0.8 0.8 0.8]);
%     plot(freq,meandiffP1,'Color','k','LineWidth',0.75)
%     set(h,'xLim',xlim);
%     ylabel('Averaged diff Log power'),xlabel('Frequency (Hz)')
%     hold off;
    

end

% argment out
varargout{1}    = freq;
% varargout{2}    = [clsMaskedscpercent, clssigcountpercent,sigpercent,meancoh,meannormcoh];
% varargout{2}    = meannormcoh;
varargout{2}    = maxclscountpercent;
varargout{3}    = (n- nNGfile);

indicator(0,0);

warning('on');