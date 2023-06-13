function HH = subaxis(H,nrow,ncol,ii)

irow    = floor((ii-1) / ncol) + 1;
icol    = ii- ncol * (irow-1);

Hxlim  = xlim(H);
Hylim  = ylim(H);
Ph0    = get(h1,'Position');

Ph1    = [Ph0(1)+Ph0(3)*0.35 Ph0(2)+Ph0(4)*0.35 Ph0(3)*0.65 Ph0(4)*0.65];
Ph2    = [Ph0(1)+Ph0(3)*0.35 Ph0(2)             Ph0(3)*0.65 Ph0(4)*0.25];
Ph3    = [Ph0(1)             Ph0(2)+Ph0(4)*0.35 Ph0(3)*0.25 Ph0(4)*0.65];


set(h1,'Position',Ph1);
h2      = axes('position',Ph2);
h3      = axes('position',Ph3);


if((1-margins(1)-margins(3))/ncol<= margins(5))
    margins(5)  = (1-margins(1)-margins(3))/(2*ncol);
end
if((1-margins(2)-margins(4))/nrow<= margins(6))
    margins(6)  = (1-margins(2)-margins(4))/(2*nrow);
end

w       = (1-margins(1)-margins(3)-(ncol-1)*margins(5))/ncol;
h       = (1-margins(2)-margins(4)-(nrow-1)*margins(6))/nrow;

icol    = mod(ii-1,ncol)+1;
irow    = floor((ii-1)/ncol)+1;

p(1)    = margins(1)+(w+margins(5))*(icol-1);
p(2)    = margins(2)+(h+margins(6))*(nrow-irow);
p(3)    = w;
p(4)    = h;

if(isempty(varargin))
    H   = axes('Position',p);
else
    H   = axes('Position',p,varargin{:});
end

if(nargout>0)
    HH  = H;
end