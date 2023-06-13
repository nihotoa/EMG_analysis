function [g,k] = gaussian(sd, npoints)
% g = gaussian(sd, npoints)
% returns a discretegaussian function of npoints length.
%
% g(k) = exp(-k^2 / sd^2) / sqrt(2* pi * sd^2)
%
% sd is the standard deviation of the gaussian given in points.
% if sd = 0, return an impulse fuction if npoints is odd,or split
% the impulse fuction between the central points if npoints is even.
% If npoints is odd, g((npoints + 1) / 2) is the maximal value.
% If npoints is even g(npoints/2) = g(npoints/2 + 1) share the max value.

if sd <= 0
   % Return an impulse fuction
   g = zeros(1, npoints);
   if bitand(npoints, 1)
       % single point impulse fuction if npoints is odd.
       g((npoints + 1) / 2) = 1;
   else
       % split impulse between both central points if npoints is even.
       g(npoints / 2) = 0.5;
       g(npoints / 2 + 1) = 0.5;
   end
   return 
end

% Calculate indexes for odd or even npoints.

if bitand(npoints, 1)
    k = -floor(npoints / 2):floor(npoints/2);
else
    k = [(-npoints/2 + 0.5):0, 0.5:(npoints/2)]; 
end

% Return the gaussian function.
variance = sd * sd;
g = exp(-((k.^2) / variance)/2) / sqrt(2 * pi * variance);
