function H  = marginalhist(h1,XData,YData,ZData)

% shrink and add axis
% axis(h1,'normal')
h1xlim  = xlim(h1);
h1ylim  = ylim(h1);
Ph0    = get(h1,'Position');

Ph1    = [Ph0(1)+Ph0(3)*0.35 Ph0(2)+Ph0(4)*0.35 Ph0(3)*0.65 Ph0(4)*0.65];
Ph2    = [Ph0(1)+Ph0(3)*0.35 Ph0(2)             Ph0(3)*0.65 Ph0(4)*0.25];
Ph3    = [Ph0(1)             Ph0(2)+Ph0(4)*0.35 Ph0(3)*0.25 Ph0(4)*0.65];


set(h1,'Position',Ph1);
h2      = axes('position',Ph2);
h3      = axes('position',Ph3);


ZXData  = sum(ZData,1);
ZYData  = sum(ZData,2);


bar(h2,XData,ZXData,1,'Facecolor',[0 0 0.5]);
axis(h2,'off');
set(h2,'YDir','reverse')


barh(h3,YData,ZYData,1,'Facecolor',[0 0 0.5]);
axis(h3,'off');
set(h3,'XDir','reverse')

linkaxes([h2,h1],'x')
linkaxes([h3,h1],'y')
% xlim(h1,h1xlim)
% ylim(h1,h1ylim)

if(nargout>0)
    H   = [h1,h2,h3];
end