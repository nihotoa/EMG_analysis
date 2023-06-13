function baseball
warning('off')
config_mouse(10);  
config_display(0);

h(1)    = figure
h(2)    = subplot(3,3,[1:6]);
h(3)    = subplot(3,3,7);
h(4)    = subplot(3,3,7);
h(5)    = subplot(3,3,7);
h(3)    = uicontrol('Style','text',...
    'Position',get(h(3),'Position'));
h(4)    = uicontrol('Style','text',...
    'Position',get(h(4),'Position'));
h(5)    = uicontrol('Style','text',...
    'Position',get(h(5),'Position'));

x   = [40:-1:21];
set(h(2),'Color',[0 0.5 0],...
    'NextPlot','ReplaceChildren',...
    'XLim',[1 100]);


start_cogent;

map = getmousemap;


t0  =0;
t1  =0;
t2  =0;

t0  = time;
for ii =1:20
    
    plot(h(2),x(ii),1,'o','Color','w','MarkerFaceColor','w','MarkerSize',3)
    drawnow;
    readmouse;
    if ~isempty(getmouse(map.Button1)) & any(getmouse(map.Button1) == 128 )
        t1    = time-t0;
    end
    

    pause(0.02)

end
t2  = time - t0;
while(t1==0|time<10000)

    readmouse;
    if ~isempty(getmouse(map.Button1)) & any(getmouse(map.Button1) == 128 )
        t1    = time-t0;
        break;
    end
end

disp(t1)
disp(t2)

warning('on')

