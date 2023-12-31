function h = krymap(m)
%HOT    Black-red-yellow color map
%   HOT(M) returns an M-by-3 matrix containing a "hot" colormap.
%   HOT, by itself, is the same length as the current figure's
%   colormap. If no figure exists, MATLAB creates one.
%
%   For example, to reset the colormap of the current figure:
%
%             colormap(hot)
%
%   See also HSV, GRAY, PINK, COOL, BONE, COPPER, FLAG, 
%   COLORMAP, RGBPLOT.

%   C. Moler, 8-17-88, 5-11-91, 8-19-92.
%   Copyright 1984-2004 The MathWorks, Inc.
%   $Revision: 5.7.4.2 $  $Date: 2005/06/21 19:30:30 $

if nargin < 1, m = size(get(gcf,'colormap'),1); end
n = fix(m/2);

r = [0; (1:n)'/n; ones(m-n-1,1)];
g = [zeros(n+1,1); (1:(m-n-1))'/(m-n-1)];
b = zeros(m,1);

h = [r g b];
