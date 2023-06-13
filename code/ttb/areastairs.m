function h  = areastairs(H,x,y,varargin)
% function h  = areastairs(H,x,y,varargin)

x   = shiftdim(x);
y   = shiftdim(y);

if length(x)<3
    if(length(varargin) < 1)

        hh   = area(H,x,y);
    else
        hh   = area(H,x,y,varargin{:});
    end

else

    X   = repmat(x(2:end),[1,2])';
    X   = reshape(X,[prod(size(X)),1]);
    Y   = repmat(y(1:end-1),[1,2])';
    Y   = reshape(Y,[prod(size(Y)),1]);
    X   = [x(1);X];
    Y   = [Y;y(end)];

    if(length(varargin) < 1)

        hh   = area(H,X,Y);
    else
        hh   = area(H,X,Y,varargin{:});
    end

end

if(nargout>0)
    h   =hh;
end