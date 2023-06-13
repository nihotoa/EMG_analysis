function h  = terrorbar(H,x,y,err,varargin)

x   = shiftdim(x);
y   = shiftdim(y);
err   = shiftdim(err);

ebwidth = 0.5;

oldNextplot = get(H,'NextPlot');
set(H,'NextPlot','add');

if(length(varargin) < 1)
    hh  = plot(H,x,y);
else
    hh  = plot(H,x,y,varargin{:});
end

lc  = get(hh,'Color');
lw  = get(hh,'LineWidth');

%エラーバーの縦線
X   = repmat(x,[1,2]);
Y   = [y,y+err];
plot(H,X',Y','-','Color',lc,'LineWidth',lw,'Tag','Errorbar');

X   = repmat(x,[1,2]);
Y   = [y,y-err];
plot(H,X',Y','-','Color',lc,'LineWidth',lw,'Tag','Errorbar');

%エラーバーの横線
X   = [x-ebwidth/2,x+ebwidth/2];
Y   = [y+err,y+err];
plot(H,X',Y','-','Color',lc,'LineWidth',lw,'Tag','Errorbar');

X   = [x-ebwidth/2,x+ebwidth/2];
Y   = [y-err,y-err];
plot(H,X',Y','-','Color',lc,'LineWidth',lw,'Tag','Errorbar');

gofront(hh);

if(nargout>0)
    h   =hh;
end


