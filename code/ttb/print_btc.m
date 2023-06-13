function print_btc(profilename)

warning('off')
% rootpath    = datapath;

eval(['[PSTHpath,STApath,Outpath,files] = ',profilename,';']);

Expnames	= uiselect(dirdir(STApath),1,'ëŒè€Ç∆Ç∑ÇÈExperimentÇëIëÇµÇƒÇ≠ÇæÇ≥Ç¢ÅB');
[nrow,ncol] = size(files);

nExp    = length(Expnames);
% nfiles    = length(files);
nerror  = 0;

for iExp    = 1:nExp
    try
        Expname     = Expnames{iExp};

        %     fig=figure;
        fig = open('A4.fig');
        set(fig,'Name',Expname,...
            'Numbertitle','Off',...
            'FileName',Expname)

        for irow    = 1:nrow
            for icol    = 1:ncol

                file    = files{irow,icol};
                if(isempty(file))
                    break;
                end
                if(strcmp(file(1:3),'STA'))
                    atype       = 'STA';
                elseif(strcmp(file(1:3),'PSE'))
                    atype       = 'PSE';
                elseif(strcmp(file(1:3),'PST'))
                    atype       = 'PSTH';
                else
                    break;
                end
                [Refname,Tarname]   = getRefTarName(file);
                switch atype
                    case 'STA'
                        filename    = fullfile(STApath,Expname,file);
                    case 'PSTH'
                        filename    = fullfile(PSTHpath,Expname,file);
                end



                h   = subplot(nrow,ncol,icol+(irow-1)*ncol,'Parent',fig);
                try
                s   = load(filename);

%                 if(irow==2&&icol==2)     % unit sta ÇÃÇ›
%                     nspikes = s.nTrials;
%                     hh  = subplot(nrow,ncol,2);
%                     title(hh,{'Unit 1',['n= ',num2str(nspikes)]})
%                     set(hh,'YTicklabel',[],...
%                         'YTickl',[])
%                 end
                switch atype
                    case 'PSTH'
                        YData   = s.YData_spp;
                        XData   = s.BinData;
                        nTrials  = s.nTrials;
                        bar(h,XData,YData,1,'k')
                        title(h,{[Expname,' (',Refname,')'];['n= ',num2str(nTrials)],})
                        axis(h,'tight')
                    case 'STA'
                        if(isfield(s,'ISAData'))
                            ISA_flag    = 1;
                        else
                            ISA_flag    = 0;
                        end
                        if(isfield(s,'base'))
                            PSE_flag    = 1;
                        else
                            PSE_flag    = 0;
                        end

                        YData   = s.YData;
                        XData   = s.XData;
                        nTrials = s.nTrials;
                        hL  = plot(h,XData,YData,'k');



                        hold(h,'on')
                        if(ISA_flag && ~PSE_flag)
                            ISAData = s.ISAData;
                            plot(h,XData,ISAData,'Color',[0.75 0 0]);
                        end
                        if(ISA_flag && PSE_flag)
                            ISAData = s.ISAData+mean(s.subYData(s.base.ind));
                            plot(h,XData,ISAData,'Color',[0.75 0 0]);
                            plot(h,XData,ISAData+s.base.nsd*s.base.sd,'--','Color',[0.75 0 0]);
                            plot(h,XData,ISAData-s.base.nsd*s.base.sd,'--','Color',[0.75 0 0]);
                            if(~isempty(s.nsigpeaks))
                               for ipeaks=1:s.nsigpeaks
                                    ind = s.sigpeakind(ipeaks);
                                    xdata   = XData(s.peaks(ind).ind);
                                    ydata   = YData(s.peaks(ind).ind);
                                    isadata = ISAData(s.peaks(ind).ind);
                                    
                                    color   = [0.5 0.5 0.5];
                                    if(isfield(s,'isXtalk'))
                                        if(s.isXtalk==0)
                                            color   = [0 1 1];
                                        else
                                            color   = [1 1 0];
                                        end
                                    end
                                    hA  = fill([xdata, xdata(end:-1:1)],[isadata, ydata(end:-1:1)],color,'Parent',h,'edgecolor',color);
                                    goback(hA)
                                end
                            end
                        end
                        gofront(hL);
                        hold(h,'off')
                        axis(h,'tight')

%                         if(irow==1)
%                             title(h,['nSpikes= ',num2str(nTrials)])
%                         end
%                         ylabel(h,Tarname)
%                         
                        
                        ylabel(h,{Tarname;['n=',num2str(nTrials)]})

                end
                drawnow;
                catch
                    ylabel(h,Tarname)
                end
            end
        end
        %     print(fig)
        if(~exist(fullfile(Outpath,'jpg'),'dir'))
            mkdir(fullfile(Outpath,'jpg'))
        end
        if(~exist(fullfile(Outpath,'pdf'),'dir'))
            mkdir(fullfile(Outpath,'pdf'))
        end
        if(~exist(fullfile(Outpath,'fig'),'dir'))
            mkdir(fullfile(Outpath,'fig'))
        end
        saveas(fig,fullfile(Outpath,'jpg',Expname),'jpg')
        saveas(fig,fullfile(Outpath,'pdf',Expname),'pdf')
        saveas(fig,fullfile(Outpath,'fig',Expname),'fig')
        close(fig)
        disp([Expname,' was printed out.'])
    catch
        Expname     = Expnames{iExp};
        disp(['error occured in',Expname])
        nerror  = nerror+1;
        a(nerror)   = lasterror;
        close(gcf)
    end
end
warning('on')

