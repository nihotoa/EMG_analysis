function uiPWHM(base);
try
    if nargin<1
        base    = 0;
    end

    [pl,xs,ys] = selectdata('sel','Rect','Pointer','crosshair');


    if(~iscell(xs))
        XData   = xs;
        YData   = ys;
    else
        for ii=1:length(xs)
            if(~isempty(xs{ii}))
                XData   = xs{ii};
                YData   = ys{ii};
            end
        end
    end

    baseYData   = YData - base;
    [maxbaseY,maxI] = max(abs(baseYData));

    posiYData   = baseYData*sign(baseYData(maxI));
    halfbaseY       = abs(maxbaseY) / 2;


    Ind         = find(posiYData > halfbaseY);

    PWHM    = XData(Ind(end))-XData(Ind(1));
    PeakY   = YData(maxI);
    PeakX   = XData(maxI);
    halfY   = mean([PeakY base]);

    nextplot    = get(gca,'Nextplot');
    hold on;
    h    = plot([mean([XData(Ind(1)-1),XData(Ind(1))]),mean([XData(Ind(end)),XData(Ind(end)+1)])],[halfY,halfY],'-r','LineWidth',1);
    h    = plot([mean([XData(Ind(1)-1),XData(Ind(1))]),mean([XData(Ind(end)),XData(Ind(end)+1)])],[halfY,halfY],'*r','LineWidth',1);
    hold off;



    msgwin({    'PeakY',    'PeakX',    'halfY',    'PWHM';...
                PeakY,      PeakX,      halfY,  PWHM})

catch
    rethrow(lasterror)
end
