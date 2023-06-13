function uiregress(acceptTag,type)
% uiregress(acceptTag,type)
% type = {'corr'},'phase';

global XLSFILENAME
try
    if nargin < 1
        acceptTag   = [];
    elseif nargin < 2
        acceptTag   = [];
        type        = 'corr';
    end
        
    if(isempty(acceptTag))
        accept  = get(gca,'children');
        ignore  = [];
    else
        allh    = get(gca,'children');
        accept  = findobj(gca,'Tag',acceptTag);
        ignore  = allh(~ismember(allh,accept));
    end
    if isempty(accept)
        msgbox('該当するデータが見つかりませんでした。')
        return;
    end
    sXData   =[];
    sYData   =[];

    nh      = length(accept);

    nextplot    = get(gca,'Nextplot');


    [pl,xs,ys,hChild,hAx] = uiselectdata('sel','lasso','ignore',ignore,'Pointer','crosshair');
    if(iscell(xs))
        for ii=1:nh
            XData   = xs{ii};
            YData   = ys{ii};
            if(~isempty(XData))
                sXData  = [sXData;XData];
                sYData  = [sYData;YData];
            end
        end
    else
        sXData  = xs;
        sYData  = ys;
    end
    
    allXData    = unique(get(accept,'XData'));
    
    nPts    =length(sXData);
    if(nPts < 1)
        return
    end
    [A,S]   = polyfit(sXData,sYData,1);
    fYData  = polyval(A,sXData);
    fYData  = polyval(A,allXData);
    [r,p]   = corr(sXData,sYData);
    tau     = - (A(1)*1000/2/pi);   % constant delay of channel X from channels Y (ms) degative value indicate chanX precede chanY
    a       = A(1);
%     b       = unwrapi(A(2));
    b       = A(2);


    string  = {[' n =',num2str(nPts),' points'];[' y =',num2str(a),'x + ',num2str(b)];[' \itR\rm =',num2str(r),', \itp\rm =',num2str(p)];[' \tau =',num2str(tau),' (ms)']};

    set(hAx,'Nextplot','add');
    %     index   =num2str(floor(cputime));
    %     h  = text(max(sXData),max(sYData),string);
    %     set(h,'BackgroundColor',[1.0000    1.0000    0.7686],...
    %         'EdgeColor',[0 0 0],...
    %         'Tag',['text',index]);


    % hold on
%     h    = plot(sXData,fYData,'-r','LineWidth',1);
    h    = plot([allXData(1) allXData(end)],[fYData(1) fYData(end)],'-r','LineWidth',1);
    %     set(h,'Tag',['regression',index])


    set(gca,'Nextplot',nextplot);
%     msgwin({    'n',    'R',    'p',    'tau(ms)',  'a',	'b',	'eq';...
%         nPts,   r,      p,      tau,    A(1),   A(2),   ['y=',num2str(A(1)),'x+',num2str(A(2))]})
    regressname     = {'n','R','p','tau(ms)','a','b'};
    regressvalue    = [nPts,r,p,tau,a,b];
    assignin('base','regressname',regressname);
    assignin('base','regressvalue',regressvalue);

    
    switch type
        case 'corr'
            %% For usual
            
            text(mean(sXData),mean(sYData),{['y=',num2str(regressvalue(5)),'x+',num2str(regressvalue(6))];['R=',num2str(regressvalue(2))];['p=',num2str(regressvalue(3))]},'Parent',gca,'Color',[0.75 0 0],'FontName','Arial','FontSize',9,'HorizontalAlignment','Left','VerticalAlignment','Bottom');
            
        case 'phase'
            %% For phase
            if(regressvalue(4)<0)
                str     = 'EMG\rightarrowLFP';
            else
                str     = 'LFP\rightarrowEMG';
            end
            
            text(mean(sXData),mean(sYData),{str,['\tau=',num2str(regressvalue(4))]},'Parent',gca,'Color',[0.75 0 0],'FontName','Arial','FontSize',9,'HorizontalAlignment','Left','VerticalAlignment','Bottom');
    end
    
    if(~isempty(XLSFILENAME))
        channel = ddeinit('excel',XLSFILENAME);
        ddeexec(channel,[num2str(regressvalue(1)),'{TAB}',num2str(regressvalue(2)),'{TAB}',num2str(regressvalue(3)),'{TAB}',num2str(regressvalue(4)),'{TAB}',num2str(regressvalue(5)),'{TAB}',num2str(regressvalue(6)),'{ENTER}']);
    end
        
%     clipboard('copy',regressvalue);
catch
    rethrow(lasterror)
end


