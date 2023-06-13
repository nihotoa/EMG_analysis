function [RMS,MAX,MEAN,STD,lMAXl,lMEANl,lSTDl]  = uinoise(s,ref)


                s.XData   =([1:length(s.Data)]-1)./s.SampleRate;
                s.ind     = (s.XData>=1 & s.XData<=120);
                ref.XData   =([1:length(ref.Data)]-1)./ref.SampleRate;
                ref.ind     = (ref.XData>=1 & ref.XData<=120);

X   = zeros(1,2);
RMS = [];

fig = figure('NumberTitle','off',...
    'Name','uiRMS',...
    'Menubar','figure',...
    'Toolbar','figure');
ax(1)  = axes('Position',[0.13 0.616667 0.775 0.308333],'Parent',fig);
ax(2)  = axes('Position',[0.13 0.247619 0.775 0.308333],'Parent',fig);

h1  = uicontrol(fig,'Unit','normalized',...
    'Callback',@selectarea,...
    'Position',[0.1497 0.0462 0.2931 0.0721],...
    'Style','Pushbutton',...
    'String','Select');

h2  = uicontrol(fig,'Unit','normalized',...
    'Callback','close(gcbf)',...
    'Position',[0.5635 0.0462 0.2931 0.0721],...
    'Style','Pushbutton',...
    'String','Done');

plot(ax(1),ref.XData(ref.ind),ref.Data(ref.ind),'Color',[0 0 0.5]);
plot(ax(2),s.XData(s.ind),s.Data(s.ind),'Color',[0 0 0.5]);

% ylim([min(s.Data)/2 max(s.Data)/2])
linkaxes(ax,'x');
xlim(ax(2),[1 11]);
uiwait(fig);


    function selectarea(varargin)
        k   = waitforbuttonpress;
        point1 = get(gca,'CurrentPoint');    % ボタンダウンの検出
        finalRect = rbbox;                   % figure単位の出力
        point2 = get(gca,'CurrentPoint');    % ボタンアップの検出
        point1 = point1(1,1:2);              % x と y の抽出
        point2 = point2(1,1:2);
        p1   = min(point1,point2);             % 位置と大きさの計算
        offset = abs(point1-point2);         %
        x = [p1(1) p1(1)+offset(1) p1(1)+offset(1) p1(1) p1(1)];
        y = [p1(2) p1(2) p1(2)+offset(2) p1(2)+offset(2) p1(2)];
        hold on
        axis manual
        plot(x,y,'r','linewidth',1)          % ボックスの回りに選択した領域の描画
                                               
        X(1)    = p1(1);
        X(2)    = p1(1)+offset(1);
        
        [temp,Xind(1)] = nearest(s.XData,X(1));
        [temp,Xind(2)] = nearest(s.XData,X(2));

        RMS = rms(s.Data(Xind(1):Xind(2)));
        MAX = max(s.Data(Xind(1):Xind(2)));
        MEAN    = mean(s.Data(Xind(1):Xind(2)));
        STD     = std(s.Data(Xind(1):Xind(2)),1);
        lMAXl   = max(abs(s.Data(Xind(1):Xind(2))));
        lMEANl  = mean(abs(s.Data(Xind(1):Xind(2))));
        lSTDl   = std(abs(s.Data(Xind(1):Xind(2))),1);
        
        set(h1,'String',['Select (',num2str(X(2)-X(1)),' sec)'])
        set(h2,'String',['Done (RMS: ',num2str(RMS),')'])
    end
                                                
                                         
                                         

    end