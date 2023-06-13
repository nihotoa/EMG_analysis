function [RMS,MAX,MEAN,STD,lMAXl,lMEANl,lSTDl]  = uinoise(XData,YData)

X   = zeros(1,2);
RMS = [];

fig = figure('NumberTitle','off',...
    'Name','uiRMS',...
    'Menubar','figure',...
    'Toolbar','figure');
ax  = axes('Position',[0.13 0.184843 0.775 0.740157],'Parent',fig);

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


plot(ax,XData,YData,'Color',[0 0 0.5]);
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
        
        [temp,Xind(1)] = nearest(XData,X(1));
        [temp,Xind(2)] = nearest(XData,X(2));

        RMS = rms(YData(Xind(1):Xind(2)));
        MAX = max(YData(Xind(1):Xind(2)));
        MEAN    = mean(YData(Xind(1):Xind(2)));
        STD     = std(YData(Xind(1):Xind(2)),1);
        lMAXl   = max(abs(YData(Xind(1):Xind(2))));
        lMEANl  = mean(abs(YData(Xind(1):Xind(2))));
        lSTDl   = std(abs(YData(Xind(1):Xind(2))),1);
        
        set(h1,'String',['Select (',num2str(X(1)),' : ',num2str(X(2)),')'])
        set(h2,'String',['Done (RMS: ',num2str(RMS),')'])
    end
                                                
                                         
                                         

    end