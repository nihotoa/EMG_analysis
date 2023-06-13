function h  = terrorarea(H,x,y,err,varargin)

x   = shiftdim(x);
y   = shiftdim(y);
err = shiftdim(err);

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

%エラーバー
X   = [x;x(end:-1:1)];
Y   = [y+err;y(end:-1:1)-err(end:-1:1)];
fill(X',Y',[0.8 0.8 0.8],'LineStyle','none','Tag','Errorbar','Parent',H);


gofront(hh);

set(H,'NextPlot',oldNextplot)

if(nargout>0)
    h   =hh;
end




