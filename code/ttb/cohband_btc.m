function cohband_btc(command,comment)
tic;
if nargin < 1
    command = 'matrix'
    comment = [];
end

switch command
    case 'matrix'
        list=getchanname('Select Continuous Channels');
    case 'control'
        control = getchanname('Control Channel');
        list    = getchanname('Select Continuous Channels');
end

SelectedExp  = gsme;
if isempty(SelectedExp)
    disp('**** Cohband_btc error: No experiment is selected.')
    return
end

nExp    = length(SelectedExp);

for kk=1:nExp
    try
        currExp  = SelectedExp(kk);

        % initializing parameters
%         TimeRange   = [0 get(currExp,'TotalTime')]
        TimeRange   = [0 1800]
        ExperimentName  = [get(currExp,'Name')];
        AnalysisType   = 'Cohband';
        nfftPoints   = 2048
        opt_str     = 't2 s'
        xnormLim    = [10 50];
        xLim    = [5 100];
        maxaxes = 5;
        
        if(isempty(comment))
            string =[num2str(nfftPoints),'pts_',opt_str(opt_str~=' ')];
        else
            string =[comment,'_',num2str(nfftPoints),'pts_',opt_str(opt_str~=' ')];
        end
        
        disp(['Cohband_btc: ',ExperimentName,' (',num2str(kk),'/',num2str(nExp),') start at ',datestr(now)]);


        % initializing output directory and file
        if(~exist('c:\data'))
            mkdir('c:\', 'data')
        end
        if(~exist('c:\data\cohband'))
            mkdir('c:\data\', 'cohband')
        end
        if(~exist(['c:\data\cohband\',ExperimentName]))
            status  = mkdir('c:\data\Cohband\',ExperimentName);
        else
            status  = 1;
        end
        if(status==0)
            disp('**** Cohband_btc error: Failure to make output directory.')
            return
        end
        Outputpath  = ['c:\data\cohband\',ExperimentName,'\'];


        switch command
            case 'matrix'
        %         list=getchanname('Select Continuous Channels');

                % TimeRange   = [0 100];
                nCh = length(list);
        %         maxaxes = 5;

                % axes arrengement
                if nCh < 1
                    disp('**** cohband_btc error: No channels selected.')
                    return
                elseif nCh < maxaxes
                    fig = figure('Name',[AnalysisType,'_',ExperimentName,'_',string,'_','1-1'],...
                                'NumberTitle','off',...
                                'PaperUnits', 'centimeters',...
                                'PaperOrientation','landscape',...
                                'PaperPosition', [0.881189 0.634517 27.9151 19.715],...
                                'PaperPositionMode','manual',...
                                'Position',[-3 58 1280 904],...
                                'Toolbar','figure');
                    for ii=1:nCh
                        for jj=ii+1:nCh
                            axesh(ii,jj)    =    subplot((nCh-1),(nCh-1),((ii-1)*(nCh-1)+(jj-1)),'align');
                        end
                    end
                else
                    for ii=1:(floor((nCh-2)/maxaxes)+1)
                        for jj=ii:(floor((nCh-2)/maxaxes)+1)
                            fig(ii,jj) =figure('Name',[AnalysisType,'_',ExperimentName,'_',string,'_',num2str(ii),'-',num2str(jj)],...
                                'NumberTitle','off',...
                                'PaperUnits', 'centimeters',...
                                'PaperOrientation','landscape',...
                                'PaperPosition', [0.881189 0.634517 27.9151 19.715],...
                                'PaperPositionMode','manual',...
                                'Position',[-3 58 1280 904],...
                                'Toolbar','figure');
                        end
                    end
                    for ii=1:nCh
                        for jj=ii+1:nCh
                            interfigy   = floor((ii-1)/maxaxes)+1;
                            interfigx   = floor((jj-2)/maxaxes)+1;
                            intrafigy   = mod(ii-1,maxaxes)+1;
                            intrafigx   = mod(jj-2,maxaxes)+1;

                            set(0,'CurrentFigure',fig(interfigy,interfigx));
                            axesh(ii,jj)    = subplot(maxaxes,maxaxes,(intrafigy-1)*maxaxes+intrafigx,'align');
                        end
                    end
                end

                for ii=1:nCh
                    for jj=ii+1:nCh
                        [f, cl]=tcohall(currExp, TimeRange, nfftPoints,list{ii},list{jj},opt_str);
                        saveas(gcf,[Outputpath,list{ii},'__',list{jj},'_',string,'.fig'])
                        close(gcf)

                        save([Outputpath,list{ii},'__',list{jj},'_',string,'.mat'],'f','cl');

                        axes(axesh(ii,jj))
                            stairs(f(:, 1), f(:, 4));
                            h = line([0 150], [cl.ch_c95 cl.ch_c95]);
                            set(h, 'Color', [0.5 0.5 0.5]);

                            set(axesh(ii,jj), 'YLimMode', 'auto');
                            set(axesh(ii,jj), 'XLim', xnormLim);
                            yLim    = get(axesh(ii,jj), 'YLim');
                            set(axesh(ii,jj), 'YLimMode', 'manual');
                            set(axesh(ii,jj), 'XLim', xLim);
                            set(axesh(ii,jj), 'YLim', yLim);

                            title([list{ii},' -> ',list{jj}])
                            if(jj==ii+1)
                                ylabel('Coherence'); 
                                xlabel('Hz')
                            end
                    end
                end

                for ii=1:size(fig,1)
                    for jj=1:size(fig,2)
                        if(fig(ii,jj)~=0)
                            set(fig(ii,jj),'FileName',[Outputpath,get(fig(ii,jj),'Name')]);
                            uicontrol(fig(ii,jj),'Backgroundcolor',[1 1 1],'Style','text','Position',[10 10 800 30],'String',[get(fig(ii,jj),'Name'),' ( [',num2str(TimeRange(1)),'-',num2str(TimeRange(2)),'] seconds, ', num2str(cl.df) ,' Hz resolution, ', num2str(cl.seg_tot), ' segments, ', num2str(cl.seg_size), ' points, ''', opt_str,''')' ]);
                            saveas(fig(ii,jj),[Outputpath,get(fig(ii,jj),'Name')],'fig');
%                             print(fig(ii,jj))
%                         close(fig(ii,jj))
                        end
                    end
                end

            case 'control'

    %             control = getchanname('Select Control Channel');
    %             list    = getchanname('Select Channels of Interest');
                % TimeRange   = [0 100];
                nCh = length(list);
    %             maxaxes = 5;

                % axes arrengement
                if nCh < 1
                    disp('**** Cohband_btc error: No channels selected.')
                    return
                elseif nCh < maxaxes^2
                    figcol  = floor((nCh-1)/ceil(sqrt(nCh)))+1;
                    figrow  = ceil(sqrt(nCh));

                    fig = figure('Name',[AnalysisType,'_',ExperimentName,'_',string,'_','1'],...
                        'NumberTitle','off',...
                        'PaperUnits', 'centimeters',...
                        'PaperOrientation','landscape',...
                        'PaperPosition', [0.881189 0.634517 27.9151 19.715],...
                        'PaperPositionMode','manual',...
                        'Position',[-3 58 1280 904],...
                        'Toolbar','figure');
                    for ii=1:nCh
                        axesh(ii)    =    subplot(figcol,figrow,ii,'align');
                        if((mod(ii-1,figrow)+1)==1)
                            ylabel('Coherence'); 
                        end
                        if((floor((ii-1)/figrow)+1)==figcol)
                            xlabel('Hz')
                        end
                    end
                else
                    figcol  = ceil(sqrt(maxaxes));
                    figrow  = ceil(sqrt(maxaxes));

                    for ii=1:(floor((nCh-1)/(maxaxes^2))+1)
                        fig(ii) =figure('Name',[AnalysisType,'_',ExperimentName,'_',string,'_',num2str(ii)],...
                            'NumberTitle','off',...
                            'PaperUnits', 'centimeters',...
                            'PaperOrientation','landscape',...
                            'PaperPosition', [0.881189 0.634517 27.9151 19.715],...
                            'PaperPositionMode','manual',...
                            'Position',[-3 58 1280 904],...
                            'Toolbar','figure');
                    end
                    for ii=1:nCh
                        interfig   = floor((ii-1)/(maxaxes^2))+1;
                        intrafig   = mod(ii-1,(maxaxes^2))+1;
                        set(0,'CurrentFigure',fig(interfig));
                        axesh(ii)    = subplot(figcol,figrow,intrafig,'align');
                        if((mod(intrafig-1,figrow)+1)==1)
                            ylabel('Coherence'); 
                        end
                        if((floor((intrafig-1)/figrow)+1)==figcol)
                            xlabel('Hz')
                        end
                    end
                end

                for ii=1:nCh
                    [f, cl]=tcohall(currExp, TimeRange, nfftPoints,control{1},list{ii},opt_str);
                    saveas(gcf,[Outputpath,control{1},'__',list{ii},'_',string,'.fig'])
                    close(gcf)

                    save([Outputpath,control{1},'__',list{ii},'_',string,'.mat'],'f','cl');

                    axes(axesh(ii))
                    stairs(f(:, 1), f(:, 4));
                        h = line([0 150], [cl.ch_c95 cl.ch_c95]);
                        set(h, 'Color', [0.5 0.5 0.5]);

                        set(axesh(ii), 'YLimMode', 'auto');
                        set(axesh(ii), 'XLim', xnormLim);
                        yLim    = get(axesh(ii), 'YLim');
                        set(axesh(ii), 'YLimMode', 'manual');
                        set(axesh(ii), 'XLim', xLim);
                        set(axesh(ii), 'YLim', yLim);

                        title([control{1},' -> ',list{ii}])
                end

                for ii=1:length(fig)
                    if(fig(ii)~=0)
                        set(fig(ii),'FileName',[Outputpath,get(fig(ii),'Name')]);
                        uicontrol(fig(ii),'Backgroundcolor',[1 1 1],'Style','text','Position',[10 10 800 30],'String',[get(fig(ii),'Name'),' ( [',num2str(TimeRange(1)),'-',num2str(TimeRange(2)),'] seconds, ', num2str(cl.df) ,' Hz resolution, ', num2str(cl.seg_tot), ' segments, ', num2str(cl.seg_size), ' points, ''', opt_str,''')' ]);
                        saveas(fig(ii),[Outputpath,get(fig(ii),'Name')],'fig');
                        print(fig(ii))
                        close(fig(ii))
                    end
                end
        end     % switch command
    catch
        currExp  = SelectedExp(kk);
        ExperimentName  = get(currExp,'Name');
        disp(['**** Cohband_btc error: error occurred in ',ExperimentName])
    end
end         % for kk=1:nExp