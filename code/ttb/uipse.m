function PSEs   = uipse
% Check Parameters

BaseRange   = [-40, -10]; %(ms)
LValue      = 2;        % # times of Basestd
nn          = 0.5;        %(ms) if Peaks/Troughs sustain nn(ms), they are accepted as PSeffects
a           = 0.05;
% YConversionFactor   = 10/(2^16);

[sta,stafile]   = topen('Pick a STA analysis file');
[isa,isafile]   = topen('Pick a ISA analysis file');
sta = getcomponent(sta);
isa = getcomponent(isa);

isa=sta;
% Extract necessary data
ISAData     = isa.YData;
XData       = sta.XData;
TrialData   = sta.TrialData;
TrialsToUse = TrialsToUsedlg(sta.TrialsToUse,[1:size(TrialData,1)]);
if(~isempty(TrialsToUse))
    TrialData   = TrialData(TrialsToUse,:);
end
nTrials     = size(TrialData,1);
YData       = mean(TrialData,1);

% Remove ISA baseline
iTrialData  = removeISA(TrialData,ISAData);

% Find PSE components
PSEs        = findpeaks(iTrialData, XData, BaseRange, LValue, nn, a);

%plot
figure('Name',stafile,...
    'NumberTitle','off');
subplot(2,1,1)
plot(XData,YData,'Color',[0 0 0],'LineStyle','-','LineWidth',0.5)

hold on;
plot(XData,ISAData+PSEs.Base.mean,'Color',[0.5 0.5 0.5],'LineStyle','-','LineWidth',0.5)
plot(XData,ISAData+PSEs.Base.mean+LValue*PSEs.Base.std,'Color',[0.5 0.5 0.5],'LineStyle','--','LineWidth',0.5)
plot(XData,ISAData+PSEs.Base.mean-LValue*PSEs.Base.std,'Color',[0.5 0.5 0.5],'LineStyle','--','LineWidth',0.5)
hold off;

title(['n = ',num2str(nTrials)])

subplot(2,1,2)
plot(XData,mean(iTrialData),'Color',[0 0 0],'LineStyle','-','LineWidth',0.5)
hold on;
plot([XData(1) XData(end)],[PSEs.Base.mean PSEs.Base.mean],'Color',[0.5 0.5 0.5],'LineStyle','-','LineWidth',0.5)
plot([XData(1) XData(end)],[PSEs.Base.mean+LValue*PSEs.Base.std PSEs.Base.mean+LValue*PSEs.Base.std],'Color',[0.5 0.5 0.5],'LineStyle','--','LineWidth',0.5)
plot([XData(1) XData(end)],[PSEs.Base.mean-LValue*PSEs.Base.std PSEs.Base.mean-LValue*PSEs.Base.std],'Color',[0.5 0.5 0.5],'LineStyle','--','LineWidth',0.5)
hold off;


%-------------------------------------------
function TrialData  = removeISA (TrialData,ISAData)
nTrials     = size(TrialData,1);

ISAData     = repmat(ISAData,nTrials,1);
TrialData   = TrialData - ISAData;

%-------------------------------------------
function S  = findpeaks(TrialData, XData, BaseRange, LValue, nn, a)
YData       = mean(TrialData,1);

% Convert time units to vector index
dX          = XData(2) - XData(1);
iBaseRange  = ms2ind(BaseRange,XData);
inn         = round(nn ./ dX);


S.Base.mean = mean(YData(iBaseRange(1):iBaseRange(2)));
S.Base.std  = std(YData(iBaseRange(1):iBaseRange(2)),0);


%-------------------------------------------
function ind    = ms2ind(t,XData)
% if ms value is on the center of two time index, it will be floored.
[XData,nshift]  = shiftdim(XData);
[t,nshift]      = shiftdim(t);
tdim            = length(size(t));
tsize           = size(t);

t       = repmat(t,[ones(1,tdim),length(XData)]);
XData   = repmat(shiftdim(XData,-tdim),[tsize,1]);
[y,ind]         = min(abs(XData-t),[],tdim+1);

ind = shiftdim(ind,-nshift);

% ---------------------------------------------
function newvalue = TrialsToUsedlg(exvalue,acceptvalues)
prompt = {'If no restriction, input [] .'};
dlg_title = 'TrialsToUse';
num_lines = 1;
if(isempty(exvalue))
    def = {'[]'};
else
    def = {num2str(exvalue)};
end

ii  = 1;
while(ii)
    newvalue    = inputdlg(prompt,dlg_title,num_lines,def);
    newvalue    = eval(newvalue{:});
    if(isempty(newvalue))
        ii  = 0;
    else
        if(any(~ismember(newvalue,acceptvalues)));
            disp('TrialsToUse must be ranging from ',num2str(acceptvalues(1)),' - ', num2str(acceptvalues(end)),'.');
            ii=1;
        else
            ii=0;
        end
    end
end
% 
% AnalysisObjects = gsma;
% nAnalyses = length(AnalysisObjects);
% if nAnalyses < 1
%    disp('PeakAreas: No selected analysis -- nothing to do')
%    return;
% end
% fprintf(fid,'FileName\tSpike\tEMGname\tComponents\tnTrials\tBaseStart(ms)\tBaseEnd(ms)\tBaseMean(V)\tBaseSTD(V)\tStart(ms)\tStartValue(V)\tEnd(ms)\tEndValue(V)\tPeakTime(ms)\tPeak(V)\tMean(V)\tMPI(%)\tPPI(%)\tHalfMaximum(V)\tPWHMStart(ms)\tPWHMEnd(ms)\tPWHM(ms)\tp\t(<0.05)\n');


% for ana = 1:nAnalyses
%    analysisName = get(AnalysisObjects(ana), 'Name');
%    FullName = get(AnalysisObjects(ana), 'FullName');
%    AnalysesComponents = analyses(AnalysisObjects(ana), 'componentobjs');
%    nAnalysesComponents = length(AnalysesComponents);
%    if nAnalysesComponents == 0
%       disp(['PeakAreas: No components to do: ' analysisName]);
%       break;
%    end
%    fig  =figure('Name',FullName,...
%        'NumberTitle','off',...
%         'PaperUnits', 'centimeters',...
%         'PaperOrientation','landscape',...
%         'PaperPosition', [0.881189 0.634517 27.9151 19.715],...
%         'PaperPositionMode','manual',... %        'PaperOrientation','portrait',...'PaperPosition',[-2 4.91751 26.4382 19.8287],...%[-2.72314 4.91751 26.4382 19.8287]%        'PaperPositionMode','auto',...
%        'PaperType','A4',...
%        'Pointer','fullcrosshair',...
%        'Position',[1         188        1272         770]);
% 
%    uicontrol('BackgroundColor',[1 1 1],...
%        'Style','text',...
%        'HorizontalAlignment','left',...
%        'Position',[10 10 800 30],...
%        'String',FullName);
% %    htext    = uicontrol('BackgroundColor',[1,1,1],...
% %        'Style','text',...
% %        'HorizontalAlignment','left',...
% %        'Position',[500 100 400 600],...
% %        'String',FullName);
%   message=[];
%    disp('----------------------');
%    disp(FullName)
%    
%    % Caculate statistics
%    
%    maxTrials = 0;
%    for jj = 1:nAnalysesComponents
% %    for jj = 1:2
%       analysisType = get(AnalysesComponents(jj), 'SubClass');
%       spikeName = get(AnalysesComponents(jj), 'Reference');
%       TimeUnits = get(AnalysesComponents(jj), 'TimeUnits');
%       YDataUnits = get(AnalysesComponents(jj), 'YUnits');
%       ConversionFactor = units('conversionfactor', 'time', TimeUnits, 'milliseconds');     
%       WindowStart = get(AnalysesComponents(jj), 'WindowStart') * ConversionFactor;
%       WindowStop = get(AnalysesComponents(jj), 'WindowStop') * ConversionFactor;             
%       trialData = get(AnalysesComponents(jj), 'TrialData');
%       trialData	= trialData*YConversionFactor;
%       trialTimes = get(AnalysesComponents(jj), 'TrialTriggerTime');
%       TrialsToUse   = get(AnalysesComponents(jj), 'TrialsToUse');
%       nTotalTrials = get(AnalysesComponents(jj), 'TrialCount');
%       nTrials = size(trialData, 1);
%       name = get(AnalysesComponents(jj), 'Name'); 
%       disp(name)
% %       fprintf(fid,'%s\n',name);
%       if (nTrials < min_nTrials)
%            disp(['Warning: Too few stored trials in ' analysisName ' : ' name]);
%            if(gcf==fig)
%                close(fig);
%            end
%            break;
%       end
% %       if (nTrials < nTotalTrials)
% %           disp(['Warning: There are fewer stored trials than averaged trials in ' analysisName ' : ' name]);
% %       end
%       xData = get(AnalysesComponents(jj), 'XData') * ConversionFactor;
%       yData = get(AnalysesComponents(jj), 'YData');
%       nPoints = length(yData);
%       dt    =   xData(2)-xData(1); 
%       kk    =   round(nn/dt);
%       PSF   = logical(zeros(1,nPoints));
%       PSS   = logical(zeros(1,nPoints));
%       PSFSE = [];
%       PSSSE = [];
%       [y,BaseSE(1)]    = find(xData>=BaseRange(1),1,'first');
%       [y,BaseSE(2)]    = find(xData<=BaseRange(2),1,'last');
% 
% %       plot(xData,yData,'b:');hold on;
%       
%       % You can chose Detrend method
%       switch DetrendMethod
%           case 1            %1.Simple linear detrending from all data length       
%               ymean  = mean(yData);
%               
%               coef  =polyfit(xData,yData,1);
%               yreg  =polyval(coef,xData);
%               yData = yData-yreg+ymean;
%               trialData = trialData-repmat(yreg,[size(trialData,1),1])+ymean;
%               
%           case 2            %2.Remove base ramp
%               BaseData  = yData([BaseSE(1):BaseSE(2)]);
%               Basemean  = mean(BaseData);
%               
%               coef  =polyfit(xData([BaseSE(1):BaseSE(2)]),BaseData,1);
%               Basereg  =polyval(coef,xData);
%               
%               yData = yData-Basereg+Basemean;
%               plot(xData,mean(trialData,1),'r');hold on;
%               plot(xData,Basereg,'c');hold on;
%               trialData = trialData-repmat(Basereg,[size(trialData,1),1])+Basemean;
% %               plot(xData,mean(trialData,1),'g');hold on;
%               
%           otherwise
%               yData =yData;
%       end
%       
%       BaseData  = yData([BaseSE(1):BaseSE(2)]);
%       Basemean  = mean(BaseData);
%       Basestd   = std(BaseData);
%       
%       Limit  = [Basemean-LValue*Basestd , Basemean+LValue*Basestd];
% 
%       
%       Bigger   = yData>Limit(2);
%       Smaller   = yData<Limit(1);
%       ConvBigger   =conv(Bigger,ones(1,kk));
%       ConvSmaller   =conv(Smaller,ones(1,kk));
%       if(sum(ConvBigger>=kk)~=0)
%           [y,PSFSE(:,1)]   = find(((ConvBigger(kk:nPoints+kk-1)>=kk)-(ConvBigger(kk-1:nPoints+kk-2)>=kk))==1);
%           [y,PSFSE(:,2)]   = find(((ConvBigger(1:nPoints)>=kk)-(ConvBigger(2:nPoints+1)>=kk))==1);
%       end
%       if(sum(ConvSmaller>=kk)~=0)
%           [y,PSSSE(:,1)]   = find(((ConvSmaller(kk:nPoints+kk-1)>=kk)-(ConvSmaller(kk-1:nPoints+kk-2)>=kk))==1);
%           [y,PSSSE(:,2)]   = find(((ConvSmaller(1:nPoints)>=kk)-(ConvSmaller(2:nPoints+1)>=kk))==1);
%       end
%           
%       
%       BasemeanTrials = mean(trialData(:,[BaseSE(1):BaseSE(2)]),2);
%       
%       if(~isempty(PSFSE))
%           yPeak = [];
%           xPeak = [];
%           for ii=1:size(PSFSE,1)
%               DatameanTrials  =  mean(trialData(:,[PSFSE(ii,1):PSFSE(ii,2)]),2);
%               [PSFh(ii),PSFp(ii)] = ttest(BasemeanTrials,DatameanTrials,a);
%               
%               yPeak         = yData(PSFSE(ii,1):PSFSE(ii,2));
%               xPeak         = xData(PSFSE(ii,1):PSFSE(ii,2));
%               [PSFMAX(ii),ind]  = max(yPeak);
%               PSFMAXTIME(ii)    = xPeak(ind);
%               PSFMAXTIMEind(ii) = PSFSE(ii,1)+ind-1;
%               PSFmean(ii)   = mean(yPeak);
%               PSFMPI(ii)    = (PSFmean(ii)-Basemean)/Basemean*100;
%               PSFPPI(ii)    = (PSFMAX(ii)-Basemean)/Basemean*100;
%               PSFHM(ii)     = (PSFMAX(ii)+Basemean)/2;
%               if ~isempty(find(yData(1:PSFMAXTIMEind(ii))<PSFHM(ii),1,'last'))
%                   PSFPWHMSE(ii,1)   = find(yData(1:PSFMAXTIMEind(ii))<PSFHM(ii),1,'last')+1;
%               else
%                   PSFPWHMSE(ii,1)   = 1;
%               end
%               if ~isempty(find(yData(PSFMAXTIMEind(ii):length(yData))<PSFHM(ii),1,'first'))
%                   PSFPWHMSE(ii,2)   = find(yData(PSFMAXTIMEind(ii):length(yData))<PSFHM(ii),1,'first')+PSFMAXTIMEind(ii)-2;
%               else
%                   PSFPWHMSE(ii,2)   = length(yData);
%               end
%               PSFPWHM(ii)   = xData(PSFPWHMSE(ii,2))-xData(PSFPWHMSE(ii,1));
%           end
%       end
%       if(~isempty(PSSSE))
%           yTrough = [];
%           xTrough = [];
%           for ii=1:size(PSSSE,1)
%               DatameanTrials  =  mean(trialData(:,[PSSSE(ii,1):PSSSE(ii,2)]),2);
%               [PSSh(ii),PSSp(ii)] = ttest(BasemeanTrials,DatameanTrials,a);
%               
%               yTrough         = yData(PSSSE(ii,1):PSSSE(ii,2));
%               xTrough         = xData(PSSSE(ii,1):PSSSE(ii,2));
%               [PSSMIN(ii),ind]  = min(yTrough);
%               PSSMINTIME(ii)    = xTrough(ind);
%               PSSMINTIMEind(ii)     = PSSSE(ii,1)+ind-1;
%               PSSmean(ii)   = mean(yTrough);
%               PSSMPI(ii)    = (PSSmean(ii)-Basemean)/Basemean*100;
%               PSSPPI(ii)    = (PSSMIN(ii)-Basemean)/Basemean*100;
%               PSSHM(ii)     = (PSSMIN(ii)+Basemean)/2;
%               if ~isempty(find(yData(1:PSSMINTIMEind(ii))>PSSHM(ii),1,'last'))
%                   PSSPWHMSE(ii,1)   = find(yData(1:PSSMINTIMEind(ii))>PSSHM(ii),1,'last')+1;
%               else
%                   PSSPWHMSE(ii,1)   = 1;
%               end
%               if ~isempty(find(yData(PSSMINTIMEind(ii):length(yData))>PSSHM(ii),1,'first'))
%                   PSSPWHMSE(ii,2)   = find(yData(PSSMINTIMEind(ii):length(yData))>PSSHM(ii),1,'first')+PSSMINTIMEind(ii)-2;
%               else
%                   PSSPWHMSE(ii,2)   = length(yData);
%               end
%               PSSPWHM(ii)   = xData(PSSPWHMSE(ii,2))-xData(PSSPWHMSE(ii,1));
%           end
%       end        
% %       nc    = fix(nAnalysesComponents/6)+1;
% %       nr    = min([nAnalysesComponents,6]);
%         nc  = floor((nAnalysesComponents-1)/ceil(sqrt(nAnalysesComponents)))+1;
%         nr  = ceil(sqrt(nAnalysesComponents));
% %       nc    = 5;
% %       nr    = 4;
% %       
%       set(0,'CurrentFigure',fig);
%       subplot(nc,nr,jj); hold on; title([name,'; ',num2str(nTrials),' trials']);
% %       plot(xData,yData,'k');
%       if(~isempty(PSFSE))
%           for ii=1:size(PSFSE,1)
%               if(PSFh(ii)==1)
%                   plot(PSFMAXTIME(ii),PSFMAX(ii),'r*')
%                   fill([xData(PSFSE(ii,1)),xData(PSFSE(ii,1):PSFSE(ii,2)),xData(PSFSE(ii,2))],[Basemean,yData(PSFSE(ii,1):PSFSE(ii,2)),Basemean],'b','LineStyle','none');
%                   plot(ones(1,2)*xData(PSFPWHMSE(ii,1)),[yData(PSFPWHMSE(ii,1)),2*PSFHM(ii)-yData(PSFPWHMSE(ii,1))],'r-');
%                   plot(ones(1,2)*xData(PSFPWHMSE(ii,2)),[yData(PSFPWHMSE(ii,2)),2*PSFHM(ii)-yData(PSFPWHMSE(ii,2))],'r-');
%                   plot(xData(PSFPWHMSE(ii,:)),[PSFHM(ii),PSFHM(ii)],'r-');
%               else
%                   fill([xData(PSFSE(ii,1)),xData(PSFSE(ii,1):PSFSE(ii,2)),xData(PSFSE(ii,2))],[Basemean,yData(PSFSE(ii,1):PSFSE(ii,2)),Basemean],'y','LineStyle','none');
%               end
%               
%               fprintf(fid,'%s\t%s\t%s\tPSF%d\t%d\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%c\n',...
%                   FullName,spikeName,name,ii,nTotalTrials,xData(BaseSE(1)),xData(BaseSE(2)),Basemean,Basestd,xData(PSFSE(ii,1)),yData(PSFSE(ii,1)),xData(PSFSE(ii,2)),yData(PSFSE(ii,1)),PSFMAXTIME(ii),PSFMAX(ii),PSFmean(ii),PSFMPI(ii),PSFPPI(ii),PSFHM(ii),xData(PSFPWHMSE(ii,1)),xData(PSFPWHMSE(ii,2)),PSFPWHM(ii),PSFp(ii),('*'*PSFh(ii)));
%           end
%       end
%       if(~isempty(PSSSE))
%           for ii=1:size(PSSSE,1)
%               if(PSSh(ii)==1)
%                   plot(PSSMINTIME(ii),PSSMIN(ii),'r*')
% %                   fill([xData(PSSSE(ii,1)),xData(PSSSE(ii,1):PSSSE(ii,2)),xData(PSSSE(ii,2))],[Limit(1),yData(PSSSE(ii,1):PSSSE(ii,2)),Limit(1)],'g');
%                   fill([xData(PSSSE(ii,1)),xData(PSSSE(ii,1):PSSSE(ii,2)),xData(PSSSE(ii,2))],[Basemean,yData(PSSSE(ii,1):PSSSE(ii,2)),Basemean],'g','LineStyle','none');
%                   plot(ones(1,2)*xData(PSSPWHMSE(ii,1)),[yData(PSSPWHMSE(ii,1)),2*PSSHM(ii)-yData(PSSPWHMSE(ii,1))],'r-');
%                   plot(ones(1,2)*xData(PSSPWHMSE(ii,2)),[yData(PSSPWHMSE(ii,2)),2*PSSHM(ii)-yData(PSSPWHMSE(ii,1))],'r-');
%                   plot(xData(PSSPWHMSE(ii,:)),[PSSHM(ii),PSSHM(ii)],'r-');
% % keyboard
%               else
%                   fill([xData(PSSSE(ii,1)),xData(PSSSE(ii,1):PSSSE(ii,2)),xData(PSSSE(ii,2))],[Basemean,yData(PSSSE(ii,1):PSSSE(ii,2)),Basemean],'y','LineStyle','none');
%               end
% %               keyboard
%               fprintf(fid,'%s\t%s\t%s\tPSS%d\t%d\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%c\n',...
%                   FullName,spikeName,name,ii,nTotalTrials,xData(BaseSE(1)),xData(BaseSE(2)),Basemean,Basestd,xData(PSSSE(ii,1)),yData(PSSSE(ii,1)),xData(PSSSE(ii,2)),yData(PSSSE(ii,1)),PSSMINTIME(ii),PSSMIN(ii),PSSmean(ii),PSSMPI(ii),PSSPPI(ii),PSSHM(ii),xData(PSSPWHMSE(ii,1)),xData(PSSPWHMSE(ii,2)),PSSPWHM(ii),PSSp(ii),('*'*PSSh(ii)));
% 
%           end
%       end
%       plot(xData,yData,'k');
%       plot(xData,Basemean*ones(size(xData)),'r-',xData,Limit(1)*ones(size(xData)),'r:',xData,Limit(2)*ones(size(xData)),'r:')
%       xlabel('time (ms)');
%       ylabel(['amplitude (',YDataUnits,')']);
%       set(gca,'XGrid','off');
%       
%       yLim(1)   =min(yData(find((xData< -2) + (xData > 2))));
%       yLim(2)   =max(yData(find((xData< -2) + (xData > 2))));
%       
%       set(gca,'XLim',[-40 60]);
%       set(gca,'YLim',yLim);
% %       keyboard
%    end  %for jj = 1:nAnalysesComponents
%    if(gcf==fig)
% %        haxes    = findobj(gcf,'Type','axes');
% %        haxes(length(haxes)-UnitAna+1)   = [];
% %        YLims    = get(haxes,'YLim');
% %        set(haxes,'YLim',[min([YLims{:}]),max([YLims{:}])])
% 
%         print(gcf)
%         close(gcf)
%    end
%     
%    
% end     %for ana = 1:nAnalyses
% fclose(fid);
