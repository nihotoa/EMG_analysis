function guiindicator(varargin)
% INDICATOR ループの進捗具合をインジケータとして表示
%
% INDICATOR(i,n)
% INDICATOR(i,n,text)
%
% i       分子（何番目のループか）
% n       分母（全ループ回数）(0にするとインジケータfigureを閉じる)
% text    インジケータに付けるタイトル（オプション）
%
% forループに入れ込むと、進捗状況および推定残り時間が表示される。
% インジケータを閉じるにはnに0を入力する（iはどんなものを入力しても構わない）
%
% （例）
% 1から10までの数字を表示させるプログラムを走らせる際に、その進捗状況をインジケータとして表示する。
%
% n   = 10;
% for ii=1:n
%     pause(1)      %　1秒待つ
%     disp(ii)      %　コマンドラインに数字を表示
%     indicator(ii,n,'sample');     %　インジケータに進捗状況を表示
% end
% pause(1)          % "100%"の画面を1秒間表示
% indicator(0,0)    % インジケータを閉じる

% written by TT       2007/12/25

error(nargchk(2,4,nargin,'struct'));
if nargin == 2
    c   = varargin{1};
    N   = varargin{2};
    fig = gcf;
    titlestr    = [];
elseif nargin == 3
    if(~ischar(varargin{3}))
        fig = varargin{1};
        c   = varargin{2};
        N   = varargin{3};
        titlestr    = [];
    else
        fig = gcf;
        c   = varargin{1};
        N   = varargin{2};
        titlestr    = varargin{3};
    end
else
    fig = varargin{1};
    c   = varargin{2};
    N   = varargin{3};
    titlestr    = varargin{4};
end
if(N==0)
    command = 'close';
else
    command = 'update';
end

if(isempty(findobj(fig,'Tag','guiindicator')))
   
    h   = axes('Parent',fig,...
        'Units','Pixel',...
        'Box','on',...
        'Color',get(gcf,'Color'),...
        'Nextplot','replacechildren',...
        'Position',[2,2,98,10],...
        'XColor','k',...
        'XLim',[0 100],...        'XTickMode','manual',...
        'XTick',[],...        'XTickLabelMode','manual',...        'XTickLabel',[],...
        'YColor','k',...
        'YLim',[0.8 0.9],...        'YTickMode','manual',...
        'YTick',[],...        'YTickLabelMode','manual',...        'YTickLabel',[],...
        'Tag','guiindicator_ax');
    
    set(get(h,'Title'),'Units','Normalized',...
        'BackgroundColor',get(gcf,'Color'),...
        'FontName','Arial',...
        'FontSize',8,...
        'HorizontalAlignment','left',...
        'Margin',0.01,...
        'Position',[1,0],...
        'String',[],...
        'VerticalAlignment','Bottom');
    gofront(h)

    barh(h,1,0,1,'k','EdgeColor','k','Tag','guiindicator');
    set(h,'XTick',[],'YTick',[]);
    drawnow;
end

switch command
    case 'update'
        h   = findobj(fig,'Tag','guiindicator');
        cp  = round((c/N)*100);
        set(h,'YData',cp);
        
        h   = get(findobj(fig,'Tag','guiindicator_ax'),'Title');
        if(iscell(h))
            delete(h{2});
            h   = h{1};
        end
        set(h,'String',['  ',titlestr]);
        drawnow;

    case  'close'
        delete(findobj(fig,'Tag','guiindicator'));
%         delete(findobj(fig,'Tag','guiindicator_title'));
        delete(findobj(fig,'Tag','guiindicator_ax'));

        drawnow;
end
end
