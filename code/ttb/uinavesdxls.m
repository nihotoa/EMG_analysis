function h=uinmeanstdxls

xlsload(-1,'Data');

YN   = length(Data);
Yave    = mean(Data);
Ysd     = std(Data,0);

clipboard('copy',sprintf('%d\t%0.2g\t%0.2g',YN,Yave,Ysd))


fig = figure;
h   = uicontrol(fig,'Max',100,...
    'Min',0,...
    'Style','Edit',...
    'String',[YN,Yave,Ysd]);






