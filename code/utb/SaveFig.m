function SaveFig(fig, filename,figType)
% update all graphics
drawnow;

% set the preference
temp.figunit = fig.Units;
fig.Units = 'centimeters';
pos = fig.Position;
fig.PaperPositionMode = 'Auto';
temp.figpaperunit = fig.PaperUnits;
fig.PaperUnits = 'centimeters';
temp.figsize = fig.PaperSize;
fig.PaperSize = [pos(3), pos(4)];

% select which type of figure is.good
switch figType
    case 'fig'
        savefig(fig,[filename '.fig'])
    case 'pdf'
        print(fig,'-painters',filename,'-dpdf','-bestfit')
    case 'eps'
        print(fig,filename,'-depsc')
    case 'png'
        print(fig,filename,'-dpng','-r300')
    otherwise
        disp('fail to save figure.')
        disp('please save as ''fig'', ''png'', ''pdf''or ''eps''.')
end

%
fig.PaperSize = temp.figsize;
fig.Units = temp.figunit;
fig.PaperUnits = temp.figpaperunit;

end