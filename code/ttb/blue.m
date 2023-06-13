function h = blue(m)
%BLUE    Black-red-blue-cyan color map
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

if nargin < 1, m = size(get(gcf,'colormap'),1); end
n = fix(3/8*m);

r = [zeros(2*n,1); (1:m-2*n)'/(m-2*n)];
g = [zeros(n,1); (1:n)'/n; ones(m-2*n,1)];
b = [(1:n)'/n; ones(m-n,1)];

h = [r g b];
