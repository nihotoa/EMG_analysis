function h = bluered(m)
%BLUERED   Cyan-blue-black-red-yellow color map
%   BLUE(M) returns an M-by-3 matrix containing a "blue" colormap.
%   BLUE, by itself, is the same length as the current figure's
%   colormap. If no figure exists, MATLAB creates one.
%
%   For example, to reset the colormap of the current figure:
%
%             colormap(blue)
%
%   See also HSV, GRAY, PINK, COOL, BONE, COPPER, FLAG, 
%   COLORMAP, RGBPLOT.

%   T. Takei, 3-19-2010.

if nargin < 1, m = size(get(gcf,'colormap'),1);end

if(rem(m,2)==0)
    m2= m/2 + 1;
    n = fix(m2/2);
    
    r1 = zeros(m2,1);
    g1 = [zeros(n,1); (1:m2-n)'/(m2-n)];
    b1 = [(1:n)'/n; ones(m2-n,1)];
    
    r2 = [(1:n)'/n; ones(m2-n,1)];
    g2 = [zeros(n,1); (1:(m2-n))'/(m2-n)];
    b2 = zeros(m2,1);
    
    r   = [r1(end-1:-1:1);r2(1:end-1)];
    g   = [g1(end-1:-1:1);g2(1:end-1)];
    b   = [b1(end-1:-1:1);b2(1:end-1)];
else
    m2  = (m-1)/2;
    n = fix(m2/2);

    r1 = zeros(m2,1);
    g1 = [zeros(n,1); (1:m2-n)'/(m2-n)];
    b1 = [(1:n)'/n; ones(m2-n,1)];
    
    r2 = [(1:n)'/n; ones(m2-n,1)];
    g2 = [zeros(n,1); (1:(m2-n))'/(m2-n)];
    b2 = zeros(m2,1);
    
    r   = [r1(end-1:-1:1);0;r2(1:end-1)];
    g   = [g1(end-1:-1:1);0;g2(1:end-1)];
    b   = [b1(end-1:-1:1);0;b2(1:end-1)];
    
end
h = [r g b];
