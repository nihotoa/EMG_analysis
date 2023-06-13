function SaveFig(fig, filename)
drawnow;
temp.figunit = fig.Units;
fig.Units = 'centimeters';
pos = fig.Position;
fig.PaperPositionMode = 'Auto';
temp.figpaperunit = fig.PaperUnits;
fig.PaperUnits = 'centimeters';
temp.figsize = fig.PaperSize;
fig.PaperSize = [pos(3), pos(4)];

% ?????????B
print(fig,'-painters',filename,'-dpdf','-bestfit')
print(fig,filename,'-depsc')
print(fig,filename,'-dpng','-r300')

% ???????????????B
fig.PaperSize = temp.figsize;
fig.Units = temp.figunit;
fig.PaperUnits = temp.figpaperunit;

end