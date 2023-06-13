function [x,B]=deriv(x,N)
% [x,B]=deriv(x,N)
% Nth order differentiation
%
% see also integ
%
% written by Tomohiko Takei 20101230


B   = 1;

for ii=1:N
    B   = filter([1 -1],1,[B 0]);
end

A   = 1;

x   = filter(B,A,x);
