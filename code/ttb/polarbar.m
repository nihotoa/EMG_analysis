function H  = polarbar(ax,x,y,varargin)

x   = shiftdim(x);
y   = shiftdim(y);

nx  = length(x);
ny  = length(y);

if(nx~=ny)
    error('X‚ÆY‚Ìƒf[ƒ^”‚ªˆá‚¢‚Ü‚·‚Œ');
end 

dx  = abs(repmat(x,1,nx) - repmat(x',nx,1));

dx(dx==0)     = NaN;
dx  = min(min(dx));

XData   = [x-dx/2, x-dx/2, x+dx/2, x+dx/2];
YData   = [zeros(ny,1),y,y,zeros(ny,1)];

XData   = reshape(XData',1,numel(XData));
YData   = reshape(YData',1,numel(YData));

% if(nargin<1)
%     h   = polar(ax,XData,YData);
% else
%     h   = polar(ax,XData,YData,varargin(:));
% end

    h   = polar(ax,XData,YData);
if(nargin>1)
    set(h,varargin{:});
end


if(nargout>0)
    H   = h;
end