function HH  = tsubplot(nrow,ncol,ii,varargin)
% margins = [0.125 0.075 0.075 0.05 0.0 0.015];   % left bottom right top dcol drow 
margins = [0.125 0.075 0.05 0.075 0.075 0.05];   % left bottom right top dcol drow 


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