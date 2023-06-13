function cohsum(varargin)
warning off
if(nargin<1)
    command ='selection';
elseif(varargin{1}=='all')
    command ='all';
elseif(varargin{1}=='selection')
    command ='selection';
else
    disp('*****Cohsum error: Bad command.')
    return;
end

xnormLim    = [10 50];
xLim    = [5 100];



configfile  = ['C:\Program Files\MATLAB71\work\','myconfig.mat'];
if(exist(configfile))
    load(configfile,'myconfig');
    if(isfield(myconfig,'cohsum'))
        startpath = myconfig.cohsum.startpath;
        if(~exist(startpath))
            startpath = pwd;
        end
    else
        startpath = pwd;
    end
else
    startpath = pwd;
end

switch command
    case 'all'
        parentdir   = uigetdir(startpath);
        if(parentdir==0)
            disp('*****Cohsum error: Canceled.')
            return;
        end
        add_path    = genpath(parentdir);
        
        myconfig.cohsum.startpath = parentdir;
        save(configfile,'myconfig');
        figTitle    = parentdir;
    case 'selection'
        currdir =pwd;
        cd(startpath)
        [figTitle,startpath]    = uigetfile('*.mat','Select the Cohsum_set file.');
        cd(pwd)
        if(figTitle==0)
            disp('*****Cohsum error: Canceled.')
            return;
        end
        load([startpath,'\',figTitle])
                
        myconfig.cohsum.startpath = startpath;
        save(configfile,'myconfig');
end

localfilename   = {'Non-filtered-subsample__FDI-rect_2048pts_t2s.mat';...
    'Non-filtered-subsample__ADP-rect_2048pts_t2s.mat';...
    'Non-filtered-subsample__AbPB-rect_2048pts_t2s.mat';...
    'Non-filtered-subsample__ED23-rect_2048pts_t2s.mat';...
    'Non-filtered-subsample__ECU-rect_2048pts_t2s.mat';...
    'Non-filtered-subsample__ED45-rect_2048pts_t2s.mat';...
    'Non-filtered-subsample__ECRl-rect_2048pts_t2s.mat';...
    'Non-filtered-subsample__ECRb-rect_2048pts_t2s.mat';...
    'Non-filtered-subsample__EDC-rect_2048pts_t2s.mat';...
    'Non-filtered-subsample__FDPr-rect_2048pts_t2s.mat';...
    'Non-filtered-subsample__FDPu-rect_2048pts_t2s.mat';...
    'Non-filtered-subsample__FCU-rect_2048pts_t2s.mat';...
    'Non-filtered-subsample__AbDM-rect_2048pts_t2s.mat';...
    'Non-filtered-subsample__PL-rect_2048pts_t2s.mat';...
    'Non-filtered-subsample__FDS-rect_2048pts_t2s.mat';...
    'Non-filtered-subsample__FCR-rect_2048pts_t2s.mat';...
    'Non-filtered-subsample__BRD-rect_2048pts_t2s.mat';...
    'Non-filtered-subsample__PT-rect_2048pts_t2s.mat';...
    'Non-filtered-subsample__BB-rect_2048pts_t2s.mat'};
% s=what('C:\data\cohtrig\EMG-EMG')
% localfilename   = s.mat;

%     'Non-filtered-subsample__AbPL-rect.mat';...

listbox = localfilename;
listbox(length(localfilename)+1) ={'ALL'};
path(path,add_path);

fig = figure('Name',['coherence summary (',figTitle,')'],...
    'NumberTitle','off',...
    'PaperUnits', 'centimeters',...
    'PaperOrientation','landscape',...
    'PaperPosition', [0.881189 0.634517 27.9151 19.715],...
    'PaperPositionMode','manual',...
    'Position',[-3 58 1280 904],...
    'Toolbar','figure');
set(0,'CurrentFigure',fig);
h(1)    =subplot(4,1,1);
    ylabel('Percentage of signigicant coherence');
    xlabel('Frequency (Hz)');
    set(h(1),'Nextplot','replacechildren');
h(2)    =subplot(4,1,2);
    ylabel('Averaged Coherence');
    xlabel('Frequency (Hz)');
    set(h(2),'Nextplot','replacechildren');
h(3)    =subplot(4,1,3);
    ylabel('Averaged Phase');
    xlabel('Frequency (Hz)');
    set(h(3),'Nextplot','replacechildren');
h(4)    =subplot(4,1,4);

Callback_command    = ['summary = get(gcf,''UserData'');',...
    'jj=get(gco,''Value'');',...
    'subplot(4,1,1);',...
    'bar(summary(jj).X,summary(jj).psign,1);',...
    'title([summary(jj).name,''   n='',num2str(summary(jj).N)]);',...
    'subplot(4,1,2);',...
    'stairs(summary(jj).X,summary(jj).meancoh);',...
    'subplot(4,1,3);',...
    'plot([summary(jj).X;summary(jj).X;summary(jj).X],[summary(jj).meanpha-2*pi;summary(jj).meanpha;summary(jj).meanpha+2*pi;],''ob'',''MarkerFaceColor'',''b'',''MarkerSize'',3);'];
%             'ylim',[-2*pi 2*pi],...
%             'yTickMode','manual',...
%             'yTick',[-3*pi -2*pi -pi 0 pi 2*pi 3*pi],...
%             'yTickLabel',{'-3pi' '-2pi' '-pi' '0' 'pi' '2pi' '3pi'})
uicontrol('BackgroundColor',[1 1 1],...
    'Callback',Callback_command,...
    'Units',get(h(4),'Units'),...
    'Position',get(h(4),'Position'),...
    'Style','listbox',...
    'String',listbox)
delete(h(4));


for jj=1:length(localfilename)

    fullfilename    = which(localfilename{jj},'-ALL');
    if(length(fullfilename)<1)
%         disp(['Total ',num2str(length(fullfilename)),' files for ''',localfilename{jj},''''])
        continue;
    else
%         disp(['Total ',num2str(length(fullfilename)),' files for ''',localfilename{jj},''''])
    end
    
    for ii=1:length(fullfilename)
        S=open(fullfilename{ii});
            % Output parameters
            %  f column 1  frequency in Hz.
            %  f column 2  Channel 1 log power spectrum.
            %  f column 3  Channel 2 log power spectrum.
            %  f column 4  Coherence.
            %  f column 5  Phase (coherence) ranging from -pi(-3.141592) to pi(3.141592).
            %  Positive value indicates the channel 1 (input) preceds the channel 2 (output).
            %  f column 6  Phase channel 1.
            %  f column 7  Phase channel 2.
            %  f column 8  Z-score for Mann-whitney test of channel1 power vs channel2 power.
            %
            %  cl.seg_size  Segment length.
            %  cl.seg_tot   Number of segments.
            %  cl.samp_tot  Number of samples analysed.
            %  cl.samp_rate Sampling rate of data (samps/sec).
            %  cl.df        FFT frequency spacing between adjacint bins.  
            %  cl.f_c95     95% confidence limit for Log spectral estimates.
            %  cl.ch_c95    95% confidence limit for coherence.
            %  cl.opt_str   Copy of options string.
        if(ii==1)
            X       = S.f(:,1);
            nsign   = zeros(size(X));
            sumcoh  = zeros(size(X));
            sumpha  = zeros(size(X));
            N       = 0;
        end
%         if(S.opt.hum==0 && S.opt.sixtyonehundred==0 && S.opt.typical==0)
%             nsign   = nsign + (S.f(:,4) > S.cl.ch_c95);
%             sumcoh  = sumcoh + S.f(:,4);
%             sumpha  = sumcoh + S.f(:,5).*(S.f(:,4) > S.cl.ch_c95);
%             N   = N + 1;
%         end
        
            nsign   = nsign + (S.f(:,4) > S.cl.ch_c95);
            sumcoh  = sumcoh + S.f(:,3);
            sumpha  = sumcoh + S.f(:,5).*(S.f(:,4) > S.cl.ch_c95);
            N   = N + 1;
        
    end
    
    summary(jj).X       = X;
    summary(jj).psign   = nsign / N * 100;   % (%)
    summary(jj).meancoh = sumcoh / N;
    summary(jj).meanpha = sumpha ./ nsign;
    summary(jj).N       = N;
    summary(jj).name    = localfilename{jj};
    
    if(jj==1)
        ALL_X       = X;
        ALL_nsign   = zeros(size(X));
        ALL_sumcoh  = zeros(size(X));
        ALL_sumpha  = zeros(size(X));
        ALL_N       = 0;
    end
   
    ALL_nsign   = ALL_nsign + nsign;
    ALL_sumcoh  = ALL_sumcoh + sumcoh;
    ALL_sumpha  = ALL_sumpha + sumpha;
    ALL_N       = ALL_N + N;
%     axes(h(1))
% 
%     bar(X,N,1);
% %     set(h(1),'XLim',[0 150]);
% 
%     axes(h(2))
%     stairs(S.f(:,1),mean(allcoh,2));
% %     set(h(2),'XLim',[0 150]);
    disp([num2str(N),' /',num2str(length(fullfilename)),' files for ''',localfilename{jj},''''])

end

summary(jj+1).X         = ALL_X;
summary(jj+1).psign     = ALL_nsign / ALL_N * 100;  % (%)
summary(jj+1).meancoh   = ALL_sumcoh / ALL_N;
summary(jj+1).meanpha   = ALL_sumpha ./ ALL_nsign;
summary(jj+1).N         = ALL_N;
summary(jj+1).name      = 'ALL';

set(fig,'UserData',summary)

f=uicontextmenu;
uimenu(f,'Label','uiregress','callback','uiregress([])')

for ii=1:2
    set(h(ii), 'YLimMode', 'auto',...
        'XLim', xLim,...
        'XLimMode', 'manual',...
        'UIContextMenu',f);

end
set(h(3),'Nextplot','replacechildren',...
    'ylim',[-2*pi 2*pi],...
    'yTickMode','manual',...
    'yTick',[-3*pi -2*pi -pi 0 pi 2*pi 3*pi],...
    'yTickLabel',{'-3pi' '-2pi' '-pi' '0' 'pi' '2pi' '3pi'},...
    'XLim', xLim,...
    'XLimMode', 'manual',...
    'UIContextMenu',f);
rmpath(add_path);
warning OFF

